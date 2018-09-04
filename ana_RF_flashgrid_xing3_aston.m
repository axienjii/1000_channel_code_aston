function ana_RF_flashgrid_xing3
%Modified by Xing on 20/6/17 from ana_RF_flashgrid.

%Analyses data from runstim_RF_GridMap
%Normally used for mapping V4
%Matt, May 2015
tic
analysedata = 1;        %If data already analysed you can skip straight to the graphs
saveout = 0;            %Save out the data  at the end?
savename = 'FlashMap_20170620';   %Name of data file to save
fileName = 'RF_GridMap_20170619_B1.mat';

datadir = 'D:\data\190617_B1\';
date='190617_B1';
date='280617_B2';

%Directory of stimulus logfile
logdir = 'D:\data\190617_B1\';
% To plot dots on top of data:
%USeful for testing potential positions for stimuli

%Details of mapping: read in from logfile, just read first block
load([logdir,fileName])
gridx = LOG.Grid_x;
gridy = LOG.Grid_y;
pixperdeg = LOG.Par.PixPerDeg;

%dasbit sends a change in the bit (either high or low) on one of the 8 ports
codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
codeCorrB=7;%CorrB is 7
codeRew=3;%RewardB is 3
startTrialCode=5;%sent by tracker software early during the trial, not sure exactly what this codes for

stimDur=LOG.BART*nsquares+LOG.INTBAR*(nsquares-1);

for instanceInd=5:5
    instanceName=['instance',num2str(instanceInd)];
    instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
    NEV=openNEV(instanceNEVFileName,'overwrite');
    oldIndStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^startTrialCode);%starts at 2^0, till 2^7
    oldTimeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(oldIndStimOns);%time stamps corresponding to stimulus onset
    correctTrialCodes=2.^[codeCorrB codeRew];%identify trials where fixation was maintained throughout
    indStimOns=[];
    timeStimOns=[];
    trialStimConds=[];
    for i=1:length(oldIndStimOns)
        if oldIndStimOns(i)+10<length(NEV.Data.SerialDigitalIO.UnparsedData)
            trialCodes(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i):oldIndStimOns(i)+10);
            if trialCodes(i,10:11)==correctTrialCodes%identify completed trials
                if sum(trialCodes(i,[3 5 7 9])==2)==4
                    indStimOns=[indStimOns oldIndStimOns(i)];
                    timeStimOns=[timeStimOns oldTimeStimOns(i)];
                    trialStimConds(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i)+[1 3 5 7]);%read out stimulus condition
                end
            end
        end
    end
    preStimDur=300/1000;%length of pre-stimulus-onset period, in s
    postStimDur=300/1000;%length of post-stimulus-offset period, in s
    
    instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
    switch(instanceInd)
        case(1)
            goodChannels=[2 3 6:11 16 19:23 28 29 31:33 36 42:50 56 58 60:65 75:81 89 93:96 98:112 114:128];
            goodChannels=[11 16 19:23 28 29 31:33 36 42:50 56 58 60:65 75:81 89 93:96 98:112 114:128];
        case(2)
            goodChannels=[1:5 18 20:23 34 35 37:42 56:57 59:60 69 72 74:78 90:98 107:110 113:116 125 128];
        case(8)
            goodChannels=[1:1];
        case(5)
            goodChannels=[];
    end
    
    sampFreq=30000;%hard coded
    downsampleFreq=30;
    
    readRawData=1;
    if readRawData==1
        numMin=1;%duration of each segment to be read in, in minutes
        errorMessages=[];%keep a list of any errors
        for channelCount=1:length(goodChannels)
            channelInd=goodChannels(channelCount);
            readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
            NSch=openNSx(instanceNS6FileName,'read',readChannel);
            fileName=fullfile('D:\data',date,[instanceName,'_ch',num2str(channelInd),'_rawdata.mat']);
            save(fileName,'NSch');            
            data=double(NSch.Data);%for MUA extraction, process data for that channel at one shot, across entire session            
        end
    end
    
    STIMx = [];
    STIMy = [];
    for channelCount=1:length(goodChannels)
        channelInd=goodChannels(channelCount);
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'.mat']);
        load(fileName);
        trialStimCondsDecode=trialStimConds;%convert from binary code to identify original dasbit pin
        trialStimCondsDecode(trialStimCondsDecode==1)=0;
        trialStimCondsDecode(trialStimCondsDecode==4)=2;
        trialStimCondsDecode(trialStimCondsDecode==8)=3;
        trialStimCondsDecode(trialStimCondsDecode==64)=6;
        trialStimCondsDecode(trialStimCondsDecode==128)=7;
        
        RFx=sort(unique(STMMAT(:,5)));
        RFy=sort(unique(STMMAT(:,6)));
        
        goodTrials=[];
        trialStimCondsGood=[];
        for trialStimCondsDecodeCounter=1:size(trialStimConds,1)
            if sum(trialStimConds(trialStimCondsDecodeCounter,:))>0%check whether this is a complete trial
                goodTrials=[goodTrials trialStimCondsDecodeCounter];
                trialStimCondsGood=[trialStimCondsGood trialStimCondsDecode(trialStimCondsDecodeCounter,:)'];
            end
        end
        
        TRLMATcounter=1;
        goodTrialsInd=[];
        indStimOnsMatch=[];
        timeStimOnsMatch=[];
        for colInd=1:size(trialStimCondsGood,2)
            if sum(TRLMAT(:,3,TRLMATcounter)==trialStimCondsGood(:,colInd))==4%if matlab codes match NEV codes
                goodTrialsInd=[goodTrialsInd colInd];
                indStimOnsMatch=[indStimOnsMatch indStimOns(colInd)];
                timeStimOnsMatch=[timeStimOnsMatch timeStimOns(colInd)];
                stimX(:,colInd)=TRLMAT(:,1,TRLMATcounter);
                stimY(:,colInd)=TRLMAT(:,2,TRLMATcounter);
                TRLMATcounter=TRLMATcounter+1;
            else%if the trials do not align at first, search through subsequent trials in TRLMAT to find matching one. If none match, then that trial (although present in NEV data) will be excluded
                matchFlag=0;
                while matchFlag==0
                    if sum(TRLMAT(:,3,TRLMATcounter+1)==trialStimCondsGood(:,colInd))==4
                        TRLMATcounter=TRLMATcounter+1;
                        goodTrialsInd=[goodTrialsInd colInd];
                        indStimOnsMatch=[indStimOnsMatch indStimOns(colInd)];
                        timeStimOnsMatch=[timeStimOnsMatch timeStimOns(colInd)];
                        stimX(:,colInd)=TRLMAT(:,1,TRLMATcounter);%store the X- and Y- positions for that stimulus presentation
                        stimY(:,colInd)=TRLMAT(:,2,TRLMATcounter);
                        matchFlag=1;
                    else
                        TRLMATcounter=TRLMATcounter+1;
                    end
                end
            end
        end        
        stimXY=(stimX-1)*17.+stimY;
        
        stimActBaselineSub=[];%spontaneous activity subtracted from stimulus responses
        for goodTrialInd=1:length(timeStimOnsMatch)
            %extract MUA for each channel and trial:
            S=data(timeStimOnsMatch(goodTrialInd)-preStimDur*sampFreq:timeStimOnsMatch(goodTrialInd)+(4*BART+3*INTBAR)/1000*sampFreq);
            %MAKE MUAe
            %Bandpassed, rectified and low-passed data
            %================================================
            Fs=sampFreq;%sampling frequency
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
            muafilt = downsample(muafilt,downsampleFreq); % apply filter to the data and downsample
                        
            %50Hz removal
            FsD = Fs/downsampleFreq;
            Fn = FsD/2; % Downsampled Nyquist frequency
            for v = [50 100 150];
                Fbp = [v-2,v+2];
                [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
                muafilt = filtfilt(Blp, Alp, muafilt);
            end
            MUA = muafilt;
            
            %Assign to vargpout
            channelDataMUA=MUA;
            %         channelDataMUA(trialInd,:)=MUA;
            %     end
%             fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_new.mat']);
%             save(fileName,'channelDataMUA','trialStimConds');
            
            timeStimOnDownsample=ceil(double(timeStimOnsMatch(goodTrialInd))/downsampleFreq);%make an adjustment to the sample number, due to downsampling of raw data when generating MUA
            %DOWNSAMPLE(X,N) downsamples input signal X by keeping every N-th sample starting with the first.
            spontanAct=channelDataMUA(1:preStimDur*sampFreq/downsampleFreq-1);
            stimAct=[];
            for stimInd=1:nsquares
                stimAct(stimInd,:)=channelDataMUA(preStimDur*sampFreq/downsampleFreq+(stimInd-1)*(BART+INTBAR)/1000*sampFreq/downsampleFreq:preStimDur*sampFreq/downsampleFreq+(stimInd-1)*(BART+INTBAR)/1000*sampFreq/downsampleFreq+BART/1000*sampFreq/downsampleFreq-1);
%             stimAct(stimInd,:)=smooth(stimAct(stimInd,:),20);
%             stimAct(stimInd,:)=max(stimAct(stimInd,:));
            end
            stimAct=stimAct-mean(spontanAct);
            stimActBaselineSub=[stimActBaselineSub;stimAct];%compile responses for each stimulus presentation, subtracting the spontaneous act for a given trial
        end
        
        condsMUAm=[];
        for locInd=1:length(Grid_x)*length(Grid_y)%go through each stimulus location condition
            locMatchInd=find(stimXY==locInd);
            if ~isempty(locMatchInd)
                MUAm=mean(stimActBaselineSub(locMatchInd,:),2);%calculate mean MUA across trials for that condition
                condsMUAm(locInd)=mean(MUAm);%calculate mean across the stimulus presentation period
            end
        end
        gridMUA=reshape(condsMUAm,[length(Grid_x),length(Grid_y)]);
        figure;hold on
        imagesc(Grid_x,Grid_y,gridMUA)
        scatter(0,0,'r','o','filled');%fix spot
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        axis equal
        titleText=['MUAconds ',instanceName,' ch',num2str(channelInd)];
        title(titleText);
        imageText=['MUAconds_',instanceName,'_ch',num2str(channelInd)];
        pathname=fullfile('D:\data',date,imageText);
        print(pathname,'-dtiff');
        
        fileName=fullfile('D:\data',date,['MUAconds_',instanceName,'_ch',num2str(channelInd),'.mat']);
        save(fileName,'condsMUAm','gridMUA','stimActBaselineSub','stimXY');
        close all
    end
end
toc

%SKIP TO HERE if not analysing
if 1
    %Basic plots,One figure per array
    %Not needed if plotting Gauss/Contour centers below
    ch = 0;
    for a = 1:8
        figure
        for z = 1:24
            ch = ch+1;
            subplot(5,5,z)
            imagesc(gridx,gridy,MUAm(:,:,ch))
            axis xy
        end
    end
end

%Fit Gaussians
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following code is very sensitive to incorrect guesses for the
%starting positions
%Best to estimate the peak point beforehand using the maximum response
ch = 0;
for a = 1:8
    for z = 1:24
        ch = ch+1;
        MM = MUAm(:,:,ch);
        v = reshape(MM,size(MM,1)*size(MM,2),1);
        [mx,my] = meshgrid(Grid_x,Grid_y);
        vx = reshape(mx,size(MM,1)*size(MM,2),1);
        vy = reshape(my,size(MM,1)*size(MM,2),1);
        [crap,ij] = max(v);
        mxx = vx(ij);
        mxy = vy(ij);
        Starting=[mxx,mxy,Par.PixPerDeg,Par.PixPerDeg,0];
        [y,params(ch,:)] =Gauss2D_RFfit4_MUA(MM,Grid_x,Grid_y,0,Starting);
        buf = corrcoef(reshape(MM,size(MM,1)*size(MM,2),1),reshape(y,size(MM,1)*size(MM,2),1));
        rs(ch) = buf(1,2);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Contour fits
%Useful for judging hotspots of V4 RFs

%2d smoothing filter
%Currently defined in grid spacing, could be improved
win = gausswin(4);
win = win*win';
win = win./sum(sum(win));
ch = 0;
h1 = figure; %Dummy figure for contour plots
for a = 1:8
    for z = 1:24
        ch = ch+1;
        MM = MUAm(:,:,ch);
        %Smooth with Gaussian filter
        MMS = filter2(win,MM);
        %Trim the egdes
        MMSc = MMS(2:end-1,2:end-1);
        
        [ct,f] = contourf(Grid_x(2:end-1),Grid_y(2:end-1),MMSc,10);
        
        %Go through and get levels
        lvi = 1;
        k = 1;
        clear lvs,clear lvv,clear lvn
        while lvi<length(ct)
            %The value
            lvv(k) = ct(1,lvi);
            %The number of contour segments
            lvn(k) = ct(2,lvi);
            %The index
            lvs(k) = lvi;
            lvi = lvi+lvn(k)+1;
            k = k+1;
        end
        %Unique levels (11)
        lev = unique(lvv);
        %FInd the highest level
        m2 = lev(end);
        f = find(lvv==m2);
        %If there are more than one, take the largest
        if length(f) > 1
            v = lvn(f);
            [i,j] = max(v);
            f = f(j);
        end
        %Get contours
        cth = ct(:,lvs(f)+1:1:lvs(f)+lvn(f));
        ctx(ch) = mean(cth(1,:));
        cty(ch) = mean(cth(2,:));
    end
end
close(h1)


%Plot out everything and calculate array centers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ch = 0;
for a = 1:8
    %rs below 0.25 is generally rubbish
    ach = find(array == a & rs>0.25);
    nchans(a) = length(ach)
    xc(a) = mean(params(ach,1));
    yc(a) = mean(params(ach,2));
    cxc(a) = mean(ctx(ach));
    cyc(a) = mean(cty(ach));
    figure
    for z = 1:24
        ch = ch+1;
        subplot(5,5,z)
        imagesc(Grid_x,Grid_y,MUAm(:,:,ch)),axis xy
        axis square
        %2d Gauss centers (white)
        hold on,scatter(params(ch,1),params(ch,2),[],'w','filled')
        %Stimulus chouices (m)
        for s = 1:length(STIMx)
            hold on,scatter(STIMx(s),STIMy(s),[],'m','filled')
        end
        %Array centers (black = Gauss, yellow = Contour)
        hold on,scatter(xc(a),yc(a),[],'k','filled')
        hold on,scatter(cxc(a),cyc(a),[],'y','filled')
        colormap jet
    end
end

a = 1;


