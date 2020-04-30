function analyse_microstim_2phosphene5_moviedata_aston(date)
%2/4/20
%Written by Xing, extracts eye movement data during a
%microstimulation/visual 2-phosphene task, using session 191118_B7_aston.

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
    for setNo=7%3
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
                case 1
                    date='151118_B6_aston';
                    setElectrodes=[22 12 55 16];%TB task
                    setArrays=[8 14 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=18;
                    visualOnly=0;
                case 2
                    date='161118_B7_aston';
                    setElectrodes=[29 9 60 64];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=0;
                case 3
                    date='191118_B7_aston';
                    setElectrodes=[3 35 61 57];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=0;
                case 4%remove (saccade end points good, but RFs too slanted)
                    date='211118_B5_aston';
                    setElectrodes=[1 50 43 59];%
                    setArrays=[13 14 16 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 5
                    date='211118_B6_aston';
                    setElectrodes=[25 59 56 57];%
                    setArrays=[13 14 16 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 6
                    date='211118_B7_aston';
                    setElectrodes=[33 21 48 63];%
                    setArrays=[13 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 7
                    date='221118_B11_aston';
                    setElectrodes=[3 57 50 63];%
                    setArrays=[13 13 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 8
                    date='221118_B12_aston';
                    setElectrodes=[10 63 16 57];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 9
                    date='221118_B13_aston';
                    setElectrodes=[1 57 9 58];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 10
                    date='231118_B6_aston';
                    setElectrodes=[6 49 59 36];%
                    setArrays=[12 11 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=0;
                case 11
                    date='231118_B11_aston';
                    setElectrodes=[36 60 53 9];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=0;
                case 12
                    date='261118_B14_aston';
                    setElectrodes=[9 59 60 41];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=0;
            end 
            %visual task only:
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='151118_B4_aston';
                    setElectrodes=[22 12 55 16];%TB task
                    setArrays=[8 14 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=18;
                    visualOnly=1;
                case 2
                    date='161118_B4_aston';
                    setElectrodes=[29 9 60 64];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=1;
                case 3
                    date='191118_B5_aston';
                    setElectrodes=[3 35 61 57];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=1;
                case 4%remove (saccade end points good, but RFs too slanted)
                    date='211118_B3_aston';
                    setElectrodes=[1 50 43 59];%
                    setArrays=[13 14 16 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                case 5
                    date='211118_B9_aston';
                    setElectrodes=[25 59 56 57];%
                    setArrays=[13 14 16 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                case 6
                    date='271118_B1_aston';
                    setElectrodes=[33 21 48 63];%
                    setArrays=[13 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
%                     date='211118_B10_aston';
%                     setElectrodes=[33 21 48 63];%
%                     setArrays=[13 14 16 11];
%                     setInd=1;
%                     numTargets=2;
%                     electrodePairs=[1 2;3 4];
%                     currentThresholdChs=21;
%                     visualOnly=1;
                case 7
                    date='221118_B5_aston';
                    setElectrodes=[3 57 50 63];%
                    setArrays=[13 13 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 8
                    date='221118_B10_aston';
                    setElectrodes=[10 63 16 57];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 9
                    date='221118_B14_aston';
                    setElectrodes=[1 57 9 58];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 10
                    date='231118_B5_aston';
                    setElectrodes=[6 49 59 36];%
                    setArrays=[12 11 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=1;
                case 11
                    date='231118_B10_aston';
                    setElectrodes=[36 60 53 9];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=1;
                case 12
                    date='261118_B13_aston';
                    setElectrodes=[9 59 60 41];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
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