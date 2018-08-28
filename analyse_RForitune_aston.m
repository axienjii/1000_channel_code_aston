function analyse_RForitune
%15/8/18
%Written by Xing, modified from analyse_CheckSNR.m. Extracts MUA data from raw .NS6 file, during presentation
%of orientation tuning stimuli in runstim_RForitune.m. Fits wrapped
%Gaussian to data, using function modified from bj_Wrapped_Gauss_strf.m.
%Write preferred orientations to separate file for each instance, and then
%call combine_orientation_tuning.m to combine values across instances, for
%further plotting of orientation-coded RF maps in plot_all_RFs.m.
date='080618_B3';
load('X:\best\080618_B3\080618_data\CheckSNR_080618_B3.mat')
best=1;
switch(date)
    case '080618_B3'
        whichDir=2;
        best=1;
end
if whichDir==1%local copy available
    topDir='D:\data';
elseif whichDir==2%local copy deleted; use server copy
    if best==1
        topDir='X:\best';
    elseif best==0
        topDir='X:\other';
    end
end
copyRemotely=0;%make a copy to the remote directory?
if copyRemotely==1
    if best==1
        copyDir='X:\best';
    elseif best==0
        copyDir='X:\other';
    end
end
stimDur=600/1000;%in seconds
allInstanceInd=4:8;
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;
allSNR=[];
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    readRaw=1;
    if readRaw==1
        instanceNEVFileName=fullfile(topDir,date,[instanceName,'.nev']);
        NEV=openNEV(instanceNEVFileName);
        instanceNS6FileName=fullfile(topDir,date,[instanceName,'.ns6']);
        NS=openNSx(instanceNS6FileName);
        sampFreq=NS.MetaTags.SamplingFreq;

        trialNo=1;
        timeStimOns=[];
        indStimOns=[];
        breakHere=0;
        while breakHere==0
            encode=double(num2str(trialNo));%serial port encodes. e.g. 0 is encoded as 48, 1 as 49, 10 as [49 48], 12 as [49 50]
            tempInd=strfind(NEV.Data.SerialDigitalIO.UnparsedData',encode);
            if isempty(tempInd)
                breakHere=1;
            else
                timeInd(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(tempInd(1));
                encodeInd(trialNo)=tempInd(1);
                if trialNo>1
                    trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(encodeInd(trialNo-1):encodeInd(trialNo));
                else
                    trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo));
                end
                CorrectB=Par.CorrectB;
                StimB=Par.StimB;
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                    if find(trialEncodes==2^StimB)
                        trialIndStimOn=find(trialEncodes==2^StimB);
                        indStimOns(trialNo)=encodeInd(trialNo-1)+trialIndStimOn-1;%index of times at which stimulus was presented
                        timeStimOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(indStimOns(trialNo));%time stamps for stimulus presentation
                    else
                        indStimOns(trialNo)=NaN;
                        timeStimOns(trialNo)=NaN;
                    end
                else
                    perfNEV(trialNo)=-1;
                    indStimOns(trialNo)=NaN;
                    timeStimOns(trialNo)=NaN;
                end
                trialNo=trialNo+1;
            end
        end        
        
        trialData={};
        for trialInd=1:length(timeStimOns)
            if timeStimOns(trialInd)>0
                if strcmp(class(NS.Data),'cell')
                    if size(NS.Data{end},2)>=timeStimOns(trialInd)+sampFreq*(stimDur+postStimDur)-1
                        trialData{trialInd}=NS.Data{end}(:,timeStimOns(trialInd)-sampFreq*preStimDur:timeStimOns(trialInd)+sampFreq*(stimDur+postStimDur)-1);%raw data in uV, read in data during stimulus presentation
                    end
                elseif strcmp(class(NS.Data),'double')
                    if size(NS.Data,2)>=timeStimOns(trialInd)+sampFreq*(stimDur+postStimDur)-1
                        trialData{trialInd}=NS.Data(:,timeStimOns(trialInd)-sampFreq*preStimDur:timeStimOns(trialInd)+sampFreq*(stimDur+postStimDur)-1);%raw data in uV, read in data during stimulus presentation
                    end
                elseif strcmp(class(NS.Data),'int16')
                    if size(NS.Data,2)>=timeStimOns(trialInd)+sampFreq*(stimDur+postStimDur)-1%stim bit is sent at the beginning of stimulus presentation
                        trialData{trialInd}=NS.Data(:,timeStimOns(trialInd)-sampFreq*preStimDur:timeStimOns(trialInd)+sampFreq*(stimDur+postStimDur)-1);%raw data in uV, read in data during stimulus presentation
                    end
                end
                
            end
        end        
        
        %extract MUA for each channel and trial:
        channelDataMUA=[];
        for channelInd=1:NS.MetaTags.ChannelCount
            for trialInd=1:length(trialData)
                if ~isempty(trialData{trialInd})
                    S=double(trialData{trialInd}(channelInd,:)');
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
        end
        fileName=fullfile(topDir,date,['MUA_',instanceName,'.mat']);
        save(fileName,'channelDataMUA');
        if copyRemotely==1
            fileName=fullfile(copyDir,date,['MUA_',instanceName,'.mat']);
            save(fileName,'channelDataMUA');
        end
        
        %Average across trials and plot activity:
        % load(fileName);
        % figure(1)
        % hold on
        goodTrials=find(perfNEV==1);
        condLogGoodTrials=condLog*0;
        condLogGoodTrials(goodTrials,1:3)=condLog(goodTrials,1:3);%keep condition information for 'good' trials, and replace with zeros in 'bad' trials
        %column 1: orientation; column 2: size; column 3: position
        numOriConds=max(condLogGoodTrials(:,1));
        numSizeConds=max(condLogGoodTrials(:,2));
        numPosConds=max(condLogGoodTrials(:,3));
        for oriInd=1:numOriConds
            oriRowInds{oriInd}=find(condLogGoodTrials(:,1)==oriInd);%find indices of all trials that correspond to this orientation condition
        end
        for sizeInd=1:numSizeConds
            sizeRowInds{sizeInd}=find(condLogGoodTrials(:,2)==sizeInd);%find indices of all trials that correspond to this size condition
        end
        %no need to do this for RF position, as only 1 position was used
        %during the experiment
        
        meanChannelMUAOri=[];
        meanActCondOri=[];
        allCondsMeanChannelMUAOri=cell(NS.MetaTags.ChannelCount,1);
        for channelInd=1:NS.MetaTags.ChannelCount
            figure;hold on
            for oriInd=1:numOriConds
                condMUA=channelDataMUA{channelInd}(oriRowInds{oriInd},:);
                meanChannelMUAOri(channelInd,:)=mean(condMUA,1);
                allCondsMeanChannelMUAOri{channelInd}=[allCondsMeanChannelMUAOri{channelInd};mean(condMUA,1)];%compile mean activity across trials for all 24 orientation conditions
                baseline=mean(meanChannelMUAOri(channelInd,1:0.3*1000));
                meanActCondOri(channelInd,oriInd)=mean(meanChannelMUAOri(channelInd,0.35*1000:0.5*1000));%-baseline;
%                 for sizeInd=1:numSizeConds
%                     condMUA=channelDataMUA{channelInd}(sizeRowInds{sizeInd},:);
%                     meanChannelMUASize(channelInd,:)=mean(condMUA,1);
%                     meanActCondSize(channelInd,oriInd)=mean(meanChannelMUASize(channelInd,0.3*1000:(0.3+0.6)*1000));
%                 end
                %     plot(meanChannelMUAOri(channelInd,:))
                
                MUAm=meanChannelMUAOri(channelInd,:);%each value corresponds to 1 ms
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
                channelSNR(channelInd,oriInd)=SNR;
                subplot(4,6,oriInd);
                plot(allCondsMeanChannelMUAOri{channelInd}(oriInd,:))
                ax=gca;
                ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
                ax.XTickLabel={'-300','0','600'};
                set(gca,'ylim',[min(allCondsMeanChannelMUAOri{channelInd}(oriInd,2:end)) max(allCondsMeanChannelMUAOri{channelInd}(oriInd,:))]);
                if oriInd==1
                    title(num2str(channelInd));
                end
            end
        end
        if copyRemotely==1
            fileName=fullfile(copyDir,date,['mean_MUA_',instanceName,'.mat']);
            save(fileName,'allCondsMeanChannelMUAOri','channelSNR','meanActCondOri');
        end
        close all
        for channelInd=1:128
            oriAct=meanActCondOri(channelInd,1:12);
            STD=ones(1,length(oriAct))*0.1;
            [Tuning_Amplitude,Width,Perc_Var_acc, Prefered_Ori, Bandwidth, Baseline_FR, pFit]=Wrapped_Gaus_strf(oriAct,STD,channelInd);
            allPerc_Var_acc(channelInd)=Perc_Var_acc;
            allPrefered_Ori(channelInd)=Prefered_Ori;
            allWidth(channelInd)=Width;
            allTuning_Amplitude(channelInd)=Tuning_Amplitude;
        end
        goodVarAcc=find(allPerc_Var_acc>60);
        goodWidth=find(allWidth>5);
        goodTuningChs=intersect(goodVarAcc,goodWidth);
        instanceName
        length(goodTuningChs)
        for figInd=1:6
            figure(figInd)
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile(topDir,date,[instanceName,'_fig',num2str(figInd),'_orientation_tuning']);
            print(pathname,'-dtiff');            
        end
        fileName=fullfile(topDir,date,['mean_MUA_',instanceName,'.mat']);
        save(fileName,'allCondsMeanChannelMUAOri','channelSNR','meanActCondOri','goodTuningChs','allPerc_Var_acc','allPrefered_Ori','allWidth','allTuning_Amplitude');
    end    
    fileName=fullfile(topDir,date,['mean_MUA_',instanceName,'.mat']);
    load(fileName,'allCondsMeanChannelMUAOri','channelSNR','meanActCondOri','goodTuningChs','allPerc_Var_acc','allPrefered_Ori','allWidth','allTuning_Amplitude');
    close all
    for goodCh=1:length(goodTuningChs)   
        channelInd=goodTuningChs(goodCh);
        oriActGoodChs=meanActCondOri(channelInd,1:12);
        STDGoodChs=ones(1,length(oriActGoodChs))*0.1;
        [Tuning_Amplitude,Width,Perc_Var_acc, Prefered_Ori, Bandwidth, Baseline_FR, pFit]=Wrapped_Gaus_strf(oriActGoodChs,STDGoodChs,goodCh);
    end
    for figInd=1:ceil(length(goodTuningChs)/24)
        figure(figInd)
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(topDir,date,[instanceName,'_fig',num2str(figInd),'_orientation_tuned_chs_only']);
        print(pathname,'-dtiff');
    end
    close all
    clear NS channelDataMUA
    
end
pause=1;