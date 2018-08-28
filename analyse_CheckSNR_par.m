function analyse_CheckSNR_par
instanceHalf=1;%1: instances 1-4; 2: instances 5-8
parfor instanceCount=1:4
    instanceName=['instance',num2str(instanceCount+4*(instanceHalf-1))];
    stimDur=400/1000;%in seconds
    NEV=openNEV;
    date='230517_B1';
    NS=openNSx('t:1:6000000');%20 s
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
end%end of parfor loop

%Average across trials and plot activity:
% load(fileName);
% figure(1)
% hold on
meanChannelMUA=[];
for channelInd=1:NS.MetaTags.ChannelCount
    meanChannelMUA(channelInd,:)=mean(channelDataMUA{channelInd}(:,:),1);
    %     plot(meanChannelMUA(channelInd,:))
end
fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'.mat']);
save(fileName,'meanChannelDataMUA');

for channelInd=1:NS.MetaTags.ChannelCount
    figInd=ceil(channelInd/36);
    figure(figInd);hold on
    subplotInd=channelInd-((figInd-1)*36);
    subplot(6,6,subplotInd);
    plot(meanChannelMUA(channelInd,:))
    ax=gca;
    ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
    ax.XTickLabel={'-300','0','400'};
    %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
    title(num2str(channelInd));
end
pause=1;