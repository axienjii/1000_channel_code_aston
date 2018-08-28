function [TD,vargout] = extracttrial(FileName,D,stimon,strt,lngt,anaflag,inputTD,powerT,baseT)

%anaflag: Extract vec vector whether to extract PSTH, MUA/LFP, Power
%e.g. [1,1,1] = extract everything

%The order of the variables in vargout is:
%1 = MUA
%2 = LFP
%3 = POWER;
%4 = BASEPOWER;
%5 = anafreq;
%6 = basefreq;
%7 = PSTH (of all spikes, or cluster #1)
%8 = RASTER (of all spikes, or cluster #1)
%9 and above: any PSTH and RASTERS from extra clusters

%The timebase is either calculated or given to the function
%Leave argument out or assign to empty to make timebase
if nargin<7
    makeTD = 1;
else
    if isempty(inputTD)
        makeTD = 1;
    else
        makeTD = 0;
    end
end


%Get timestamps of this event
%tbuf is addedso that the extracted data definately includes
%the requested time-period
tbuf = 0.1;
TON = stimon+(strt*1e6)-(tbuf*1e6);
TOFF = stimon+(strt*1e6)+(lngt*1e6)+(2.*tbuf*1e6);
ModeArray     = [ceil(TON),ceil(TOFF)];

%REad in the CSC data for making MUA and LFP
FieldSelection=[1 1 1 1 1]; % 1. Timestamps 2. Channel Numbers 3. Sample Frequency 4. Number of Valid Samples 5. Samples
ExtractHeader = 1;
ExtractMode   = 4; % 4. Extract Timestamp Range = This will extract every Record whos timestamp is within a range specified by Paramter 5. param5=[0,1e6]
[Timestamp, ChanNum, SampleFrequency, NumValSamples,Samples,NlxHeader] = Nlx2MatCSC(FileName,FieldSelection,ExtractHeader,ExtractMode,ModeArray); % edit Nlx2MatCSC

%GEt scale factor to ocnvert to uV, used to be 43rd line, now 41st
header=textread(FileName,'%s',43);
sfline = strmatch('-ADBitVolts',header)+1;
scale_factor = str2num(header{sfline});
Samples = Samples.*scale_factor.*1e6;

%The Neuralynx extract does not always start from the time of
%the strt variable and can be ~20ms   So it is best to
%correct the time variable using the time of the first sample
%returned rather than the ON variable.
%FTR = first time returned
FTR = Timestamp(1);
%Difference betwen the asked for time and the actual time
Tdiff = FTR-ModeArray(1);
%Add this to strt, to make the real start time
RealStart = (strt-tbuf)+(Tdiff.*1e-6);

%Remake the time index
%The time index just stores the time of the first block of
%data, the individual sample timestamps have to be made from the
%Sample Frequency
Fs=SampleFrequency(1);
nsmp=size(Samples,1);
nrec=size(Samples,2);
TIM=repmat(Timestamp,[nsmp,1])+repmat([0:nsmp-1]',[1,nrec])*1/Fs*1e6;

%Reshape the time and samples records into vectors
%Convert to seconds and add the RealStart time
T = reshape(TIM,[nsmp*nrec,1]);
T = (T-FTR).*1e-6+RealStart;
S = reshape(Samples,[nsmp*nrec,1]);

%Now trim the dataset so it runs for the requested time from
%the requested moment
f = find(T>=strt,1,'first');
%It is safer to request a certain number of samples as then
%every trial will have the same number of data points
smp=round(Fs*lngt);
T=T(f:f+smp);
S=S(f:f+smp);

if makeTD
    %Now we have the data an dtimestamps correctlt arranged
    %We can already downsample the time by the same amount as the
    %MUA and LFP will be downsampled later
    %TD = downsampled time
    %THe timebase does not need to be stored, any will do, as it is
    %accurate +/-3 microseconds
    TD = downsample(T,35);
    TD = TD(2:end);
else
    TD = inputTD;
end

%What is the downsampled sample-rate
FsD = Fs/35;

if anaflag(2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MAKE LFP: do filtering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Theoretically we could downsample first to 1000Hz-ish then
    %filter as we're losign teh high-frequency stuff anyway
    %Make sthe filter design a little better on the low end
    downraw = downsample(S,35);

    %Filter between 1 and 200.
    Fbp=[1,200]; %the lower limit here is somewhat arbitrary
    N  = 2;    % filter order
    Fn = FsD/2; % Nyquist frequency
    [Bd, Ad] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn]); % compute filter coefficients
    lpraw = filtfilt(Bd, Ad, downraw);

    %Kill the first sample to get rid of artifact
    lpraw = lpraw(2:end);

    if 1
        %Now add a 50,100,150 notch filt
        lfpfilt = lpraw;
        for v = [50 100 150];
            Fbp = [v-2,v+2];
            [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
            lfpfilt = filtfilt(Blp, Alp, lfpfilt);
        end
    else
        [Ahat,Theta,RMS,Model]=sinefit2(lpraw',2*pi*50,TD(1),1/FsD,0);
        lfpfilt = lpraw-Model';
    end

    %remove outlying samples of LFP, z > 4
    dumz = abs((lfpfilt-mean(lfpfilt))./std(lfpfilt));
    lfpfilt(dumz>4) = NaN;

    %Store in look-up table addressed matrix
    LFP = lfpfilt;

    if anaflag(3)
        %Measure power during the stationary period via FFT
        anaT = find(TD>powerT(1) & TD<powerT(2));
        [anafreq,POWER] = ez_powermeasure(lfpfilt(anaT),FsD,1);
        baseT = find(TD>=baseT(1) & TD<=baseT(2));
        [basefreq,BASEPOWER] = ez_powermeasure(lfpfilt(baseT),FsD,1);
        vargout{3} = POWER;
        vargout{4} = BASEPOWER;
        vargout{5} = anafreq;
        vargout{6} = basefreq;
    else
        vargout{3} = NaN;
        vargout{4} = NaN;
        vargout{5} = NaN;
        vargout{6} = NaN;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %MAKE MUAe
    %BAndpassed, rectified and low-passed data
    %================================================

    %BANDPASS
    Fbp=[500,9000];
    N  = 2;    % filter order
    Fn = Fs/2; % Nyquist frequency
    [B, A] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn]); % compute filter coefficients
    dum1 = filtfilt(B, A, S); % apply filter to the data
    %RECTIFY
    dum2 = abs(dum1);

    %LOW-PASS
    Fl=200;
    N  = 2;    % filter order
    Fn = Fs/2; % Nyquist frequency
    [B, A] = butter(N,Fl/Fn,'low'); % compute filter coefficients
    muafilt = filtfilt(B, A, dum2);
    %Downsample
    muafilt = downsample(muafilt,35); % apply filter to the data and downsample

    %Kill the first sample to get rid of artifact
    muafilt = muafilt(2:end);

    %50Hz removal
    Fn = FsD/2; % Downsampled Nyquist frequency
    for v = [50 100 150];
        Fbp = [v-2,v+2];
        [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
        muafilt = filtfilt(Blp, Alp, muafilt);
    end

    %remove outlying samples of MUA
    dumz = abs((muafilt-mean(muafilt))./std(muafilt));
    muafilt(dumz>4) = NaN;

    %BAsleine correct and store
    %Find background MUAe activity
    MUA = muafilt;

    %Assign to vargpout
    vargout{1} = MUA;
    vargout{2} = LFP;
else
    vargout{1} = NaN;
    vargout{2} = NaN;
    vargout{3} = NaN;
    vargout{4} = NaN;
    vargout{5} = NaN;
    vargout{6} = NaN;
end

if anaflag(1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %THRESHOLDED MUA (MUAs)
    %==========================================

    %GAussian window for spikes, normalised to have an area of one, which
    %should produce the correct spike-rates in Hz
    %Winsz is in downsampled samples
    winsz = 21; %Should be odd numbered (i.e. 2.1ms)
    winstd = 3; %In down-sampled samples(i.e. 0.3ms)
    halfwin = (winsz-1)./2;
    gwin = normpdf(linspace(-halfwin,halfwin,winsz),0,winstd);
    gwin = gwin./sum(gwin);

    %Are there multiple clusters?
    if isfield(D,'cluster_class')
        %How many clusters are there? (Exclude cluster zero)
        nclus = length(unique(D.cluster_class(:,1)))-1;
        cluster = 1;
    else
        nclus = 1;
        cluster = 0;
    end

    for n = 1:nclus
        
        PSTH = zeros(length(TD),1);
        RASTER = zeros(length(TD),1);
    
        %Read in the spiking data for this trial
        if cluster
            spiketimes = D.cluster_class(D.cluster_class(:,1) == n & D.cluster_class(:,2)>ModeArray(1)&D.cluster_class(:,2)<ModeArray(2),2);
        else
            spiketimes = D.index(D.index>ModeArray(1)&D.index<ModeArray(2));
        end

        %If there is at least one spike
        if ~isempty(spiketimes)
            %Convert the spiketimes to times relative to stimulus onset
            %and convert to seconds
            spiketimes = (spiketimes-stimon).*1e-6;
            %MAke stick function and convolve with a Gaussian
            %USe TD for the time bin so the MUAs and MUAe are diretcly
            %compatible.
            %Given the way histc works we have to include one extra sample
            %at the end to capture spikes that fall in the last bin, then
            %trim this.
            stick = histc(spiketimes,[TD;TD(end)+(1/FsD)]);
            stick(end) = [];
            %Save the stick function out as the Raster
            RASTER(:,1) = stick;
            %Convolve with a Gaussian window to make PSTH
            buf = conv(stick,gwin);
            %Trim the convolved data
            buf = buf(halfwin+1:(length(TD)+halfwin));
            %Convert to Hz and store
            PSTH(:,1) = buf'.*FsD;
            
            %Save out to vargout
            vargout{7+(n-1).*2} = PSTH;
            vargout{8+(n-1).*2} = RASTER;
        else
            vargout{7+(n-1).*2} = PSTH;
            vargout{8+(n-1).*2} = RASTER;
        end   
    end
end

a = 1;

return