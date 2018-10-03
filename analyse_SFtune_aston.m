function analyse_SFtune_aston
%3/10/18
%Written by Xing, modified from Lick's analyse_SFtune.m. Extracts MUA data from raw .NS6 file, during presentation
%of SF tuning stimuli (5 SFs, at 4 orientations) in runstim_SFtune.m. For
%channels with good orientation tuning, identify SF at which highest level of
%activity observed. For channels with no clear orientation tuning, average
%activity across all orientations, and then identify SF at which highest
%level of activity was observed. 
date='031018_B2_aston';
orientations=[0 45 90 135];
SFs=[0.5 1 2 4 8];
load(['X:\aston\031018_data\CheckSNR_',date,'.mat'])
switch(date)
    case '031018_B2_aston'
        whichDir=1;
end
if whichDir==1%local copy available
    topDir='D:\aston_data';
elseif whichDir==2%local copy deleted; use server copy
    topDir='X:\aston';
end
copyRemotely=0;%make a copy to the remote directory?
if copyRemotely==1
    copyDir=topDir;
end
stimDur=600/1000;%in seconds
allInstanceInd=1:4;
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;
allSNR=[];
generateAct=1;
if generateAct==1
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
            condLogGoodTrials(goodTrials,1:4)=condLog(goodTrials,1:4);%keep condition information for 'good' trials, and replace with zeros in 'bad' trials
            %column 1: orientation; column 2: size; column 3: position
            numOriConds=max(condLogGoodTrials(:,1));
            numSizeConds=max(condLogGoodTrials(:,2));
            numPosConds=max(condLogGoodTrials(:,3));
            numSFConds=max(condLogGoodTrials(:,4));
            for oriInd=1:numOriConds
                oriRowInds{oriInd}=find(condLogGoodTrials(:,1)==oriInd);%find indices of all trials that correspond to this orientation condition
            end
            for SFInd=1:numSFConds
                SFRowInds{SFInd}=find(condLogGoodTrials(:,4)==SFInd);%find indices of all trials that correspond to this SF condition
            end
            %no need to do this for RF position, as only 1 position was used
            %during the experiment
            
            meanChannelMUAOri=[];
            meanActCondOri=[];
            allCondsMeanChannelMUAOri=cell(NS.MetaTags.ChannelCount,1);
            for channelInd=1:NS.MetaTags.ChannelCount
                figure;hold on
                for oriInd=1:numOriConds
                    for SFInd=1:numSFConds
                        SFori=intersect(oriRowInds{oriInd},SFRowInds{SFInd});%find trials with that particular combination of SF and orientation
                        SForiInd=SFInd+(oriInd-1)*numSFConds;
                        condMUA=channelDataMUA{channelInd}(SFori,:);
                        meanChannelMUAOri(channelInd,:)=mean(condMUA,1);
                        allCondsMeanChannelMUAOri{channelInd}=[allCondsMeanChannelMUAOri{channelInd};mean(condMUA,1)];%compile mean activity across trials for all 24 orientation conditions
                        baseline=mean(meanChannelMUAOri(channelInd,1:0.3*1000));
                        meanActCondOri(channelInd,SForiInd)=mean(meanChannelMUAOri(channelInd,0.35*1000:0.5*1000));%-baseline;
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
                        channelSNR(channelInd,SForiInd)=SNR;
                        subplot(4,5,SForiInd);
                        plot(allCondsMeanChannelMUAOri{channelInd}(SForiInd,:))
                        ax=gca;
                        ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
                        ax.XTickLabel={'-300','0','600'};
                        set(gca,'ylim',[min(allCondsMeanChannelMUAOri{channelInd}(SForiInd,2:end)) max(allCondsMeanChannelMUAOri{channelInd}(SForiInd,:))]);
                        if oriInd==1
                            title(num2str(channelInd));
                        end
                    end
                end
            end
            if copyRemotely==1
                fileName=fullfile(copyDir,date,['mean_MUA_',instanceName,'.mat']);
                save(fileName,'allCondsMeanChannelMUAOri','channelSNR','meanActCondOri');
            end
            close all
            for channelInd=1:128
                subplotInd=mod(channelInd,24);
                if subplotInd==0
                    subplotInd=24;
                end
                if subplotInd==1
                    figure;
                end
                subplot(4,6,subplotInd);hold on
                for oriInd=1:numOriConds
                    oriAct=meanActCondOri(channelInd,length(SFs)*(oriInd-1)+1:length(SFs)+(oriInd-1)*length(SFs));
                    STD=ones(1,length(oriAct))*0.1;
                    plot(1:5,oriAct);
                    if subplotInd==1
                        legend('0','45','90','135');
                    end
                    %                 [Tuning_Amplitude,Width,Perc_Var_acc, Prefered_SF, Bandwidth, Baseline_FR, pFit]=Wrapped_Gaus_SF(oriAct,STD,channelInd);
                    %                 allPerc_Var_acc(channelInd,oriInd)=Perc_Var_acc;
                    %                 allPrefered_SF(channelInd,oriInd)=Prefered_SF;
                    %                 allWidth(channelInd,oriInd)=Width;
                    %                 allTuning_Amplitude(channelInd,oriInd)=Tuning_Amplitude;
                end
                ax=gca;
                ax.XTick=1:5;
                ax.XTickLabel={'0.5' '1' '2' '4' '8'};
                xlabel('SF');
                ylabel('MUA');
            end
            for figInd=1:ceil(128/24)
                figure(figInd)
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                pathname=fullfile(topDir,date,[instanceName,'_fig',num2str(figInd),'_SF_tuning']);
                print(pathname,'-dtiff');
            end
            %         goodVarAcc=find(allPerc_Var_acc>60);
            %         goodWidth=find(allWidth>5);
            %         goodTuningChs=intersect(goodVarAcc,goodWidth);
            %         instanceName
            %         length(goodTuningChs)
            %         for figInd=1:6
            %             figure(figInd)
            %             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            %             pathname=fullfile(topDir,date,[instanceName,'_fig',num2str(figInd),'_orientation_tuning']);
            %             print(pathname,'-dtiff');
            %         end
            fileName=fullfile(topDir,date,['mean_MUA_',instanceName,'.mat']);
            save(fileName,'allCondsMeanChannelMUAOri','channelSNR','meanActCondOri');
            close all
            %         save(fileName,'allCondsMeanChannelMUAOri','channelSNR','meanActCondOri','goodTuningChs','allPerc_Var_acc','allPrefered_Ori','allWidth','allTuning_Amplitude');
        end
        %     fileName=fullfile(topDir,date,['mean_MUA_',instanceName,'.mat']);
        %     load(fileName,'allCondsMeanChannelMUAOri','channelSNR','meanActCondOri','goodTuningChs','allPerc_Var_acc','allPrefered_Ori','allWidth','allTuning_Amplitude');
        %     for goodCh=1:length(goodTuningChs)
        %         channelInd=goodTuningChs(goodCh);
        %         oriActGoodChs=meanActCondOri(channelInd,1:12);
        %         STDGoodChs=ones(1,length(oriActGoodChs))*0.1;
        %         [Tuning_Amplitude,Width,Perc_Var_acc, Prefered_Ori, Bandwidth, Baseline_FR, pFit]=Wrapped_Gaus_SF(oriActGoodChs,STDGoodChs,goodCh);
        %     end
        %     for figInd=1:ceil(length(goodTuningChs)/20)
        %         figure(figInd)
        %         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        %         pathname=fullfile(topDir,date,[instanceName,'_fig',num2str(figInd),'_orientation_tuned_chs_only']);
        %         print(pathname,'-dtiff');
        %     end
        
    end
end
pause=1;