function analyse_CheckSNR(date)
%23/5/17
%Written by Xing. Extracts MUA data from raw .NS6 file, during presentation
%of fullscreen flashing checkerboard stimuli to analyse signals for
%visually evoked responses.
% date='240717_B2';
switch(date)
    case '040717_B2'
        whichDir=2;
    case '050717_B3'
        whichDir=2;
    case '060717_B2'
        whichDir=2;
    case '110717_B3'
        whichDir=2;
    case '180717_B1'
        whichDir=1;
    case '200717_B7'
        whichDir=1;
    case '210717_B4'
        whichDir=1;
    case '240717_B2'
        whichDir=1;
    case '250717_B2'
        whichDir=1;
    case '260717_B3'
        whichDir=1;
    case '080817_B7'
        whichDir=1;
    case '090817_B8'
        whichDir=1;
    case '100817_B2'
        whichDir=1;
    case '180817_B10'
        whichDir=1;
    case '230817_B20'
        whichDir=1;
end
if whichDir==2
    topDir='D:\data\';
elseif whichDir==2
    topDir='X:\other\';
end
stimDur=400/1000;%in seconds
allInstanceInd=5:8;
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
    NEV=openNEV(instanceNEVFileName);
    instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
    NS=openNSx(instanceNS6FileName);
    sampFreq=NS.MetaTags.SamplingFreq;
    codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
    %dasbit sends a change in the bit (either high or low) on one of the 8 ports
    indStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^codeStimOn);%starts at 2^0, till 2^7
    timeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(indStimOns);%time stamps corresponding to stimulus onset
    trialData={};
    preStimDur=300/1000;%length of pre-stimulus-onset period, in s
    postStimDur=300/1000;%length of post-stimulus-offset period, in s
    for trialInd=1:length(timeStimOns)
        trialData{trialInd}=NS.Data(:,timeStimOns(trialInd)-sampFreq*preStimDur:timeStimOns(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
    end
    channelData={};
    for channelInd=1:NS.MetaTags.ChannelCount
        for trialInd=1:length(trialData)
            channelData{channelInd}(trialInd,:)=trialData{trialInd}(channelInd,:);
        end
    end
    
    %extract MUA for each channel and trial:
    channelDataMUA=[];
    for channelInd=1:NS.MetaTags.ChannelCount
        for trialInd=1:length(trialData)
            S=double(channelData{channelInd}(trialInd,:)');
            %MAKE MUAe
            %Bandpassed, rectified and low-passed data
            %================================================
            Fs=30000;%sampling frequency
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
            downsampleFreq=30;
            muafilt = downsample(muafilt,downsampleFreq); % apply filter to the data and downsample
            
            %Kill the first sample to get rid of artifact
            muafilt = muafilt(2:end);
            
            %50Hz removal
            FsD = Fs/downsampleFreq;
            Fn = FsD/2; % Downsampled Nyquist frequency
            for v = [50 100 150];
                Fbp = [v-2,v+2];
                [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
                muafilt = filtfilt(Blp, Alp, muafilt);
            end
            
            %remove outlying samples of MUA
            %         dumz = abs((muafilt-mean(muafilt))./std(muafilt));
            %         muafilt(dumz>4) = NaN;
            
            %Baseline correct and store
            %Find background MUAe activity
            MUA = muafilt;
            
            %Assign to vargpout
            channelDataMUA{channelInd}(trialInd,:)=MUA;
        end
    end
    fileName=fullfile('D:\data',date,['MUA_',instanceName,'.mat']);
    save(fileName,'channelDataMUA');
    
    %Average across trials and plot activity:
    % load(fileName);
    % figure(1)
    % hold on
    meanChannelMUA=[];
    for channelInd=1:NS.MetaTags.ChannelCount
        meanChannelMUA(channelInd,:)=mean(channelDataMUA{channelInd}(:,:),1);
        %     plot(meanChannelMUA(channelInd,:))
            
        MUAm=meanChannelMUA(channelInd,:);%each value corresponds to 1 ms
        %Get noise levels before smoothing
        BaseT = 1:sampFreq*preStimDur/downsampleFreq;
        Base = nanmean(MUAm(BaseT));
        BaseS = nanstd(MUAm(BaseT));
        
        %Smooth it to get a maximum...
        sm = smooth(MUAm,20);
        [mx,mi] = max(sm);
        Scale = mx-Base;
        
        %calculate SNR
        SNR=Scale/BaseS;
        channelSNR(channelInd)=SNR;
    end
    fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'.mat']);
    save(fileName,'meanChannelMUA','channelSNR');
    fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'.mat']);
    save(fileName,'meanChannelMUA','channelSNR');
    
    for channelInd=1:NS.MetaTags.ChannelCount
        figInd=ceil(channelInd/36);
        figure(figInd);hold on
        subplotInd=channelInd-((figInd-1)*36);
        subplot(6,6,subplotInd);
        plot(meanChannelMUA(channelInd,:))
        ax=gca;
        ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
        ax.XTickLabel={'-300','0','400'};
            set(gca,'ylim',[min(meanChannelMUA(channelInd,:)) max(meanChannelMUA(channelInd,:))]);
        title(num2str(channelInd));
    end
    for figInd=1:4
        figure(figInd)
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd),'_visual_response']);
        print(pathname,'-dtiff');
    end
    close all
end
pause=1;