function analyse_RF_barsweep
%29/5/17
%Written by Xing. Extracts MUA data from raw .NS6 file, during presentation
%of sweeping white bar stimuli for RF mapping.
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
date='280617_B1';
processRaw=1;
if processRaw==1
    for instanceInd=1:2
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
        NS=openNSx(instanceNS6FileName);%200 s
        % NS=openNSx('t:1:6000000');%200 s
        sampFreq=NS.MetaTags.SamplingFreq;
        codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
        %dasbit sends a change in the bit (either high or low) on one of the 8 ports
        oldIndStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^codeStimOn);%starts at 2^0, till 2^7
        oldTimeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(oldIndStimOns);%time stamps corresponding to stimulus onset
        correctTrialCodes=[2 4];%identify trials where fixation was maintained throughout
        indStimOns=[];
        timeStimOns=[];
        trialStimConds=[];
        for i=1:length(oldIndStimOns)
            if oldIndStimOns(i)+2<length(NEV.Data.SerialDigitalIO.UnparsedData)
                trialCodes(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i):oldIndStimOns(i)+2);
                if trialCodes(i,1:2)==correctTrialCodes
                    indStimOns=[indStimOns oldIndStimOns(i)];
                    timeStimOns=[timeStimOns oldTimeStimOns(i)];
                    trialStimConds=[trialStimConds NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i)+2)];%read out stimulus condition
                end
            end
        end
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
        save(fileName,'channelDataMUA','trialStimConds');
        
        %Average across trials and plot activity:
        % load(fileName);
        % figure(1)
        % hold on
        
        %Sort trials according to stimulus condition:
        stimCondCol='rgbk';
        for stimCond=3:6
            meanChannelMUA=[];
            for channelInd=1:NS.MetaTags.ChannelCount
                stimCondInd=find(trialStimConds==2^stimCond);
                stimCondChannelDataMUA=channelDataMUA{channelInd}(stimCondInd,:);
                meanChannelMUA(channelInd,:)=mean(stimCondChannelDataMUA,1);
                %         allStimCondChannelDataMUA{stimCond-2}=stimCondChannelDataMUA;
                %     plot(meanChannelMUA(channelInd,:))
            end
            fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'cond',num2str(stimCond-2)','.mat']);
            save(fileName,'meanChannelMUA');
            
            for channelInd=1:NS.MetaTags.ChannelCount
                figInd=ceil(channelInd/36);
                figure(figInd);hold on
                subplotInd=channelInd-((figInd-1)*36);
                subplot(6,6,subplotInd);
                plot(meanChannelMUA(channelInd,:),stimCondCol(stimCond-2))
                ax=gca;
                ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
                ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
                %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
                title(num2str(channelInd));
            end
        end
        clearvars -except stimDurms stimDur date instanceInd
        close all
    end
end

%to draw plots from previously processed data:
loadData=1;
if loadData==1
    for instanceInd=1:8
        instanceName=['instance',num2str(instanceInd)];
        %     instanceName='instance1';
        fileName=['D:\data\',date,'\MUA_',instanceName,'.mat'];
        load(fileName)
        sampFreq=30000;
        stimDurms=1000;%in ms
        stimDur=stimDurms/1000;%in seconds
        preStimDur=300/1000;%length of pre-stimulus-onset period, in s
        postStimDur=300/1000;%length of post-stimulus-offset period, in s
        downsampleFreq=30;
        stimCondCol='rgbk';
        for stimCond=3:6
            meanChannelMUA=[];
            for channelInd=1:128
                stimCondInd=find(trialStimConds==2^stimCond);
                stimCondChannelDataMUA=channelDataMUA{channelInd}(stimCondInd,:);
                meanChannelMUA(channelInd,:)=mean(stimCondChannelDataMUA,1);
                %     plot(meanChannelMUA(channelInd,:))
            end
            fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'cond',num2str(stimCond-2)','.mat']);
            save(fileName,'meanChannelMUA');
            
            for channelInd=1:128
                figInd=ceil(channelInd/36);
                figure(figInd);hold on
                subplotInd=channelInd-((figInd-1)*36);
                subplot(6,6,subplotInd);
                plot(meanChannelMUA(channelInd,:),stimCondCol(stimCond-2))
                ax=gca;
                ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
                ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
                %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
                title(num2str(channelInd));
            end
        end
        for figInd=1:4
            figure(figInd)
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd)]);
            print(pathname,'-dtiff');
        end
        close all
    end
end
pause=1;