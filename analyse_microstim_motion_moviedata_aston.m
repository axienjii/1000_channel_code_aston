function analyse_microstim_motion_moviedata_aston
%15/4/20
%Written by Xing, extracts eye movement data during a
%microstimulation/visual motion task, with data from 101218_B5_aston or 121218_B10_aston.

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
allPerfV=[];
allPerfM=[];
allRFsFigure=figure;
setNoSubplot=1;
eyeDataXFinal={};
eyeDataYFinal={};
setNos=[1:10 12 14:21];
for calculateVisual=0
    for setNo=[14 18]
        perfNEV=[];
        timeInd=[];
        encodeInd=[];
        microstimTrialNEV=[];
        allLRorTB=[];
        allTargetLocation=[];
        corr=[];
        incorr=[];
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='271118_B6_aston';
                    setElectrodes=[59 64 1;1 64 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 13;13 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=0;
                case 2
                    date='271118_B8_aston';
                    setElectrodes=[50 61 3;3 61 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 13 13;13 13 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=0;
                case 3
                    date='281118_B8_aston';
                    setElectrodes=[58 41 9;9 41 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=26;
                    visualOnly=0;
                case 4
                    date='291118_B9_aston';
                    setElectrodes=[57 33 10;10 33 57];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=0;
                case 5
                    date='291118_B10_aston';
                    setElectrodes=[49 41 36;36 41 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=0;
                case 6
                    date='041218_B3_aston';
                    setElectrodes=[16 9 57;57 9 16];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 14 11;11 14 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=0;
                case 7
                    date='041218_B5_aston';
                    setElectrodes=[12 63 58;58 63 12];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=0;
                case 8
                    date='041218_B7_aston';
                    setElectrodes=[35 63 49;49 63 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=0;
                case 9
                    date='051218_B5_aston';
                    setElectrodes=[48 63 25;25 63 48];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=30;
                    visualOnly=0;
                case 10
                    date='061218_B8_aston';
                    setElectrodes=[53 25 9;9 25 53];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 13;13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=31;
                    visualOnly=0;
                case 12
                    date='071218_B6_aston';
                    setElectrodes=[56 60 50;50 60 56];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=32;
                    visualOnly=0;
                case 14
                    date='101218_B5_aston';
                    setElectrodes=[55 59 41;41 59 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=0;
                case 15
                    date='101218_B7_aston';
                    setElectrodes=[43 35 58;58 35 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=0;
                case 16
                    date='101218_B9_aston';%only ~25 trials completed
                    setElectrodes=[34 16 57;57 16 34];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=0;
                case 17
                    date='121218_B8_aston';
                    setElectrodes=[41 12 49;49 12 41];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=0;
                case 18
                    date='121218_B10_aston';
                    setElectrodes=[58 35 58;58 35 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=0;
                case 19
                    date='141218_B4_aston';
                    setElectrodes=[60 16 59;59 16 60];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=0;
                case 20
                    date='141218_B7_aston';
                    setElectrodes=[40 54 9;9 54 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=0;
                case 21
                    date='171218_B3_aston';
                    setElectrodes=[51 62 17;17 62 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=36;
                    visualOnly=0;
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='271118_B3_aston';
                    setElectrodes=[59 64 1;1 64 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 13;13 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=1;
                case 2
                    date='271118_B7_aston';
                    setElectrodes=[50 61 3;3 61 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 13 13;13 13 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=1;
                case 3
                    date='281118_B7_aston';
                    setElectrodes=[58 41 9;9 41 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=26;
                    visualOnly=1;
                case 4
                    date='291118_B1_aston';
                    setElectrodes=[57 33 10;10 33 57];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=1;
                case 5
                    date='291118_B2_aston';
                    setElectrodes=[49 41 36;36 41 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=1;
                case 6
                    date='031218_B3_aston';
                    setElectrodes=[16 9 57;57 9 16];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 14 11;11 14 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=28;
                    visualOnly=1;
                case 7
                    date='041218_B4_aston';
                    setElectrodes=[12 63 58;58 63 12];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=1;
                case 8
                    date='041218_B6_aston';
                    setElectrodes=[35 63 49;49 63 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=1;
                case 9
                    date='051218_B4_aston';
                    setElectrodes=[48 63 25;25 63 48];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=30;
                    visualOnly=1;
                case 10
                    date='061218_B6_aston';
                    setElectrodes=[53 25 9;9 25 53];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 13;13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=31;
                    visualOnly=1;
                case 12
                    date='071218_B1_aston';
                    setElectrodes=[56 60 50;50 60 56];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=32;
                    visualOnly=1;
                case 14
                    date='101218_B4_aston';
                    setElectrodes=[55 59 41;41 59 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=1;
                case 15
                    date='101218_B6_aston';
                    setElectrodes=[43 35 58;58 35 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=1;
                case 16
                    date='101218_B8_aston';
                    setElectrodes=[34 16 57;57 16 34];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=1;
                case 17
                    date='121218_B7_aston';
                    setElectrodes=[41 12 49;49 12 41];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=1;
                case 18
                    date='121218_B9_aston';
                    setElectrodes=[58 35 58;58 35 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=1;
                case 19
                    date='141218_B3_aston';
                    setElectrodes=[60 16 59;59 16 60];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=1;
                case 20
                    date='141218_B6_aston';
                    setElectrodes=[40 54 9;9 54 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=1;
                case 21
                    date='171218_B2_aston';
                    setElectrodes=[51 62 17;17 62 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=36;
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
                    if iscell(NSchOriginal.Data)
                        for blockInd=1:length(NSchOriginal.Data)
                            NSchtemp{channelInd}=[NSch{blockInd}{1} NSch{blockInd}{2}];
                        end
                        NSch=NSchtemp;
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
                            stimOnInd=find(trialEncodes==2^StimB)%stimulus onset
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
                            eyeDataXFinal{trialNo}=NSch{1}(microstimTime-0.3*sampFreq:microstimTime+(1+3*0.15)*sampFreq);%eye data from 300 ms before stim onset to 1 s after stim offset
                            length(eyeDataXFinal{trialNo})
                            eyeDataYFinal{trialNo}=NSch{2}(microstimTime-0.3*sampFreq:microstimTime+(1+3*0.15)*sampFreq);
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