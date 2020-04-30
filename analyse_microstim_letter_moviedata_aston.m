function analyse_microstim_letter_moviedata_aston(date)
%2/4/20
%Written by Xing, extracts eye movement data during a
%microstimulation/visual 2-phosphene task, using session 080219_B10_aston.

allInstanceInd=1;

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

alignTargOn=1;%1: align eye movement data across trials, relative to target onset (variable from trial to trial, from 300 to 800 ms after fixation). 0: plot the first 300 ms of fixation, followed by the period from target onset to saccade response?
onlyGoodSaccadeTrials=0;%set to 1 to exclude trials where the time taken to reach the target exceeds the allowedSacTime.
allowedSacTime=250/1000;

stimDurms=500;%in ms- min 0, max 500
preStimDur=300/1000;
stimDur=stimDurms/1000;%in seconds
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

localDisk=0;
analyseConds=0;
allSetsPerfMicroAllTrials=[];
allSetsPerfVisualAllTrials=[];
setNos=[1:3 5:12];%set 2 data is missing?
allPerfV=[];
allPerfM=[];
allRFsFigure=figure;
setNoSubplot=1;
eyeDataXFinal={};
eyeDataYFinal={};

for calculateVisual=0
    for setNo=[8 10]
        perfNEV=[];
        timeInd=[];
        encodeInd=[];
        microstimTrialNEV=[];
        allLRorTB=[];
        allTargetLocation=[];
        corr=[];
        incorr=[];
        localDisk=0;
        if calculateVisual==0
            switch(setNo)
            %microstim task:
                case 3
                    date='290119_B3_aston';
                    setElectrodes=[{[32 62 52 51 50 56 64 53 55 27]} {[40 48 62 27 2 51 50 56 64 53]}];%020119_B & B?
                    setArrays=[{[16 13 13 13 13 11 11 12 12 16]} {[16 16 16 16 16 13 13 11 11 12]}];
                    setInd=3;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=57;
                    visualOnly=0;
                case 4
                    date='040219_B4_aston';
                    setElectrodes=[{[40 53 32 30 21 49 57 47 50 9]} {[51 55 52 9 17 54 30 16 16 55]}];%040119_B & B?
                    setArrays=[{[16 13 14 14 14 13 13 12 14 16]} {[16 16 16 16 16 13 14 12 14 12]}];
                    setInd=4;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=60;
                    visualOnly=0;
                case 5
                    date='050219_B8_aston';
                    setElectrodes=[{[31 55 62 52 34 24 56 49]} {[51 32 62 52 30 24 9 53]}];%05119_B & B?
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 14 12]}];
                    setInd=5;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=61;
                    visualOnly=0;
                case 6
                    date='070219_B3_aston';
                    setElectrodes=[{[32 47 41 27 2 35 9 64]} {[31 40 53 51 50 16 64 47]}];%060119_B & B?
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 13 13 13 12 11 12]}];
                    setInd=6;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=62;
                    visualOnly=0;
                case 7
                    date='080219_B10_aston';
                    setElectrodes=[{[40 48 44 9 17 8 12 57]} {[48 47 32 60 59 8 57 55]}];%080219_B8 & B10
                    setArrays=[{[16 16 16 16 16 14 14 13]} {[16 16 14 13 13 14 14 12]}];
                    setInd=7;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=64;
                    visualOnly=0;
                case 8
                    date='110219_B6_aston';
                    setElectrodes=[{[31 47 44 52 2 12 16 64]} {[51 40 32 52 50 56 9 47]}];%110219_B6 & B8
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 14 13 13 11 14 12]}];
                    setInd=8;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=65;
                    visualOnly=0;
                case 9
                    date='140219_B3_aston';
                    setElectrodes=[{[51 55 41 9 34 59 16 50]} {[51 32 53 54 30 16 12 53]}];%00219_B & B?
                    setArrays=[{[16 16 16 16 16 13 12 13]} {[16 16 13 13 14 12 14 12]}];
                    setInd=9;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=69;
                    visualOnly=0;
                case 10
                    date='120219_B6_aston';
                    setElectrodes=[{[32 48 62 27 17 9 63 57]} {[31 47 62 51 21 24 64 55]}];%120219_B2 & B6
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 11 12]}];
                    setInd=10;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=67;
                    visualOnly=0;
                case 11
                    date='180219_B10_aston';
                    setElectrodes=[{[51 32 52 30 50 9 47 17]} {[51 55 41 17 30 24 9 53]}];%180219_B & B
                    setArrays=[{[16 14 13 14 13 14 12 16]} {[16 16 16 16 14 14 14 12]}];
                    setInd=11;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=71;
                    visualOnly=0;
                case 12
                    date='190219_B9_aston';
                    setElectrodes=[{[31 32 61 24 9 55 50 2]} {[31 44 52 2 32 59 12 47]}];%00219_B & B?
                    setArrays=[{[16 14 13 14 14 12 14 16]} {[16 16 16 16 14 13 14 12]}];
                    setInd=12;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=72;
                    visualOnly=0;
            end
            %visual task only:
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 3
                    date='280119_B2_aston';
                    setElectrodes=[{[32 62 52 51 50 56 64 53 55 27]} {[40 48 62 27 2 51 50 56 64 53]}];%020119_B & B?
                    setArrays=[{[16 13 13 13 13 11 11 12 12 16]} {[16 16 16 16 16 13 13 11 11 12]}];
                    setInd=3;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=56;
                    visualOnly=1;
                case 4
                    date='040219_B2_aston';
                    setElectrodes=[{[40 53 32 30 21 49 57 47 50 9]} {[51 55 52 9 17 54 30 16 16 55]}];%040119_B & B?
                    setArrays=[{[16 13 14 14 14 13 13 12 14 16]} {[16 16 16 16 16 13 14 12 14 12]}];
                    setInd=4;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=60;
                    visualOnly=1;
                case 5
                    date='060219_B6_aston';
                    setElectrodes=[{[31 55 62 52 34 24 56 49]} {[51 32 62 52 30 24 9 53]}];%050219_B8 & 060219_B6
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 14 12]}];
                    setInd=5;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=61;
                    visualOnly=1;
                case 6
                    date='060219_B7_aston';
                    setElectrodes=[{[32 47 41 27 2 35 9 64]} {[31 40 53 51 50 16 64 47]}];%060119_B & B?
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 13 13 13 12 11 12]}];
                    setInd=6;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=62;
                    visualOnly=1;
                case 7
                    date='080219_B8_aston';
                    setElectrodes=[{[40 48 44 9 17 8 12 57]} {[48 47 32 60 59 8 57 55]}];%080219_B8 & B10
                    setArrays=[{[16 16 16 16 16 14 14 13]} {[16 16 14 13 13 14 14 12]}];
                    setInd=7;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=64;
                    visualOnly=1;
                case 8
                    date='110219_B4_aston';
                    setElectrodes=[{[31 47 44 52 2 12 16 64]} {[51 40 32 52 50 56 9 47]}];%110219_B6 & B8
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 14 13 13 11 14 12]}];
                    setInd=8;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=65;
                    visualOnly=1;
                case 9
                    date='130219_B2_aston';
                    setElectrodes=[{[51 55 41 9 34 59 16 50]} {[51 32 53 54 30 16 12 53]}];%120219_B2 & 130219_B3
                    setArrays=[{[16 16 16 16 16 13 12 13]} {[16 16 13 13 14 12 14 12]}];
                    setInd=9;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=69;
                    visualOnly=1;
                case 10
                    date='120219_B2_aston';
                    setElectrodes=[{[32 48 62 27 17 9 63 57]} {[31 47 62 51 21 24 64 55]}];%00219_B & B?
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 11 12]}];
                    setInd=10;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=67;
                    visualOnly=1;
                case 11
                    date='180219_B8_aston';
                    setElectrodes=[{[51 32 52 30 50 9 47 17]} {[51 55 41 17 30 24 9 53]}];%180219_B & B
                    setArrays=[{[16 14 13 14 13 14 12 16]} {[16 16 16 16 14 14 14 12]}];
                    setInd=11;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=71;
                    visualOnly=1;
                case 12
                    date='190219_B7_aston';
                    setElectrodes=[{[31 32 61 24 9 55 50 2]} {[31 44 52 2 32 59 12 47]}];%00219_B & B?
                    setArrays=[{[16 14 13 14 14 12 14 16]} {[16 16 16 16 14 13 14 12]}];
                    setInd=12;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=72;
                    visualOnly=1;
            end
        end
        localDisk=0;
        
        if localDisk==1
            rootdir='D:\aston_data\';
        elseif localDisk==0
            rootdir='X:\aston\';
        end
        matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
        dataDir=[rootdir,date,'\',date,'_data'];
        %     if ~exist('dataDir','dir')
        %         copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
        %     end
        load(matFile);
        maxNumTrials=size(TRLMAT,1);
        if maxNumTrials<=length(performance)
            performance=performance(1:maxNumTrials);
            allArrayNum=allArrayNum(1:maxNumTrials);
            allBlockNo=allBlockNo(1:maxNumTrials);
            allElectrodeNum=allElectrodeNum(1:maxNumTrials);
            allFixT=allFixT(1:maxNumTrials);
            allHitRT=allHitRT(1:maxNumTrials);
            allHitX=allHitX(1:maxNumTrials);
            allHitY=allHitY(1:maxNumTrials);
            allInstanceNum=allInstanceNum(1:maxNumTrials);
            allSampleX=allSampleX(1:maxNumTrials);
            allSampleY=allSampleY(1:maxNumTrials);
            allStimDur=allStimDur(1:maxNumTrials);
            allTargetArrivalTime=allTargetArrivalTime(1:maxNumTrials);
            allTargetArrivalTime=allTargetArrivalTime(1:maxNumTrials);
        end
        [dummy goodTrials]=find(performance~=0);
        % goodTrialConds=allTrialCond(goodTrials,:);
        goodTrialIDs=TRLMAT(goodTrials,:);
        
        load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
        
        processRaw=1;
        if processRaw==1
            for instanceCount=1%:length(allInstanceInd)
                instanceInd=allInstanceInd(instanceCount);
                instanceName=['instance',num2str(instanceInd)];
                instanceNEVFileName=[rootdir,date,'\',instanceName,'.nev'];
                NEV=openNEV(instanceNEVFileName);
                
                %read in eye data:
                recordedRaw=1;
                if recordedRaw==0%7/9/17
                    eyeChannels=[1 2];
                elseif recordedRaw==1%11/9/17
                    if NEV.ElectrodesInfo(130).ConnectorPin==2
                        eyeChannels=[130 131];
                    elseif NEV.ElectrodesInfo(130).ConnectorPin==3
                        eyeChannels=[129 130];
                    end
                end
                minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
                instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
                eyeDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
                if exist(eyeDataMat,'file')
                    load(eyeDataMat,'NSch');
                else
                    if recordedRaw==0
                        NSchOriginal=openNSx(instanceNS6FileName);
                        for channelInd=1:length(eyeChannels)
                            NSch{channelInd}=NSchOriginal.Data(channelInd,:);
                        end
                    elseif recordedRaw==1
                        for channelInd=1:length(eyeChannels)
                            readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
                            NSchOriginal=openNSx(instanceNS6FileName,readChannel);
                            NSch{channelInd}=NSchOriginal.Data;
                        end
                    end
                    save(eyeDataMat,'NSch');
                end
                
                %identify trials using encodes sent via serial port:
                trialNo=1;
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
                        ErrorB=Par.ErrorB;
                        CorrectB=Par.CorrectB;
                        MicroB=Par.MicroB;
                        StimB=Par.StimB;
                        TargetB=Par.TargetB;
                        if find(trialEncodes==2^CorrectB)
                            perfNEV(trialNo)=1;
                        elseif find(trialEncodes==2^ErrorB)
                            perfNEV(trialNo)=-1;
                        else
                            perfNEV(trialNo)=0;
                        end
                        if perfNEV(trialNo)~=0
                            microstimInd=find(trialEncodes==2^MicroB)%stimulus onset
                            if length(microstimInd)>1
                                microstimInd=microstimInd(end);
                            end
                            if trialNo>1
%                                 stimOnTime=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+stimOnInd-1);
                                microstimTime=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+microstimInd-1);
                            else
%                                 stimOnTime=NEV.Data.SerialDigitalIO.TimeStamp(stimOnInd);
                                microstimTime=NEV.Data.SerialDigitalIO.TimeStamp(microstimInd);
                            end
                            allFixT(trialNo)
%                             eyeDataXFinal{trialNo}=NSch{1}(stimOnTime-0.3*sampFreq:stimOnTime+1.3*sampFreq);%eye data from 300 ms before stim onset to 1.3 s after stim onset
%                             length(eyeDataXFinal{trialNo})
%                             eyeDataYFinal{trialNo}=NSch{2}(stimOnTime-0.3*sampFreq:stimOnTime+1.3*sampFreq);
                            eyeDataXFinal{trialNo}=NSch{1}(microstimTime-0.3*sampFreq:microstimTime+1.167*sampFreq);%eye data from 300 ms before stim onset to 1.3 s after stim onset
                            length(eyeDataXFinal{trialNo})
                            eyeDataYFinal{trialNo}=NSch{2}(microstimTime-0.3*sampFreq:microstimTime+1.167*sampFreq);
                        end
                        trialNo=trialNo+1;
                    end
                end
                perfNEV=performance;
            end
            allArrayNumFinal=allArrayNum;
            allElectrodeNumFinal=allElectrodeNum;
            eyeDataTrialMat=['D:\aston_data\',date,'\eye_data_',date,'.mat'];
            save(eyeDataTrialMat,'eyeDataXFinal','eyeDataYFinal','allElectrodeNumFinal','allArrayNumFinal');
        end
    end
end