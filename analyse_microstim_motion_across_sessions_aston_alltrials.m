function analyse_microstim_motion_across_sessions_aston_alltrials(date)
%4/12/18
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual direction-of-motion task.
%Calculates mean performance across sets of electrodes, for the first 50
%trials.
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
setNos=[1:10 12 14:21];
for calculateVisual=[0 1]
    for setNo=setNos
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
                if ~strcmp(date,'291118_B9_aston')
                    instanceInd=allInstanceInd(instanceCount);
                    instanceName=['instance',num2str(instanceInd)];
                    instanceNEVFileName=[rootdir,date,'\',instanceName,'.nev'];
                    NEV=openNEV(instanceNEVFileName);
                    
                    %read in eye data:
                    recordedRaw=1;
                    if recordedRaw==0%7/9/17
                        eyeChannels=[1 2];
                    elseif recordedRaw==1%11/9/17
                        eyeChannels=[129 130];
                    end
                    minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
                    
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
                            if visualOnly==0
                                if ~isempty(find(trialEncodes==2^CorrectB))&&~isempty(find(trialEncodes==2^MicroB))&&~isempty(find(trialEncodes==2^TargetB))
                                    perfNEV(trialNo)=1;
                                elseif ~isempty(find(trialEncodes==2^ErrorB))&&~isempty(find(trialEncodes==2^MicroB))&&~isempty(find(trialEncodes==2^TargetB))
                                    perfNEV(trialNo)=-1;
                                end
                                if length(find(trialEncodes==2^MicroB))>=1
                                    microstimTrialNEV(trialNo)=1;
                                end
                            elseif visualOnly==1
                                if ~isempty(find(trialEncodes==2^CorrectB))&&~isempty(find(trialEncodes==2^StimB))&&~isempty(find(trialEncodes==2^TargetB))
                                    perfNEV(trialNo)=1;
                                elseif ~isempty(find(trialEncodes==2^ErrorB))&&~isempty(find(trialEncodes==2^StimB))&&~isempty(find(trialEncodes==2^TargetB))
                                    perfNEV(trialNo)=-1;
                                end
                                microstimTrialNEV(trialNo)=0;
                            end
%                             if find(trialEncodes==2^CorrectB)
%                                 perfNEV(trialNo)=1;
%                             elseif find(trialEncodes==2^ErrorB)
%                                 perfNEV(trialNo)=-1;
%                             end
%                             if visualOnly==0
%                                 if length(find(trialEncodes==2^MicroB))>=1
%                                     microstimTrialNEV(trialNo)=1;
%                                 end
%                             elseif visualOnly==1
%                                 if length(find(trialEncodes==2^StimB))==1
%                                     microstimTrialNEV(trialNo)=0;
%                                 end
%                             end
                            trialNo=trialNo+1;
                        end
                    end
                    if strcmp(date,'101218_B9_aston')%set with first 25 trials in one recording, and other 75 or so trials in another
                        minTrials=min([length(perfNEV) length(microstimTrialNEV)]);
                        perfNEV1=perfNEV(1:minTrials);
                        microstimTrialNEV1=microstimTrialNEV(1:minTrials);
                        load('X:\aston\121218_B4_aston\perf_NEV_121218_B4_aston.mat')
                        perfNEV=[perfNEV1 perfNEV];
                        microstimTrialNEV=[microstimTrialNEV1 microstimTrialNEV];
                    end
                    
                    tallyCorrect=length(find(perfNEV==1));
                    tallyIncorrect=length(find(perfNEV==-1));
                    meanPerf=tallyCorrect/(tallyCorrect+tallyIncorrect);
                    visualTrialsInd=find(microstimTrialNEV==0);%not entirely correct- includes microstim trials where fix breaks happen before dasbit sent MicroB
                    microstimTrialsInd=find(microstimTrialNEV==1);
                    correctTrialsInd=find(perfNEV==1);
                    incorrectTrialsInd=find(perfNEV==-1);
                elseif strcmp(date,'291118_B9_aston')
                    tallyCorrect=length(find(performance==1));
                    tallyIncorrect=length(find(performance==-1));
                    meanPerf=tallyCorrect/(tallyCorrect+tallyIncorrect);
                    correctTrialsInd=find(performance==1);
                    incorrectTrialsInd=find(performance==-1);
                    visualTrialsInd=find(allTrialType==1);%not entirely correct- includes microstim trials where fix breaks happen before dasbit sent MicroB
                    microstimTrialsInd=find(allTrialType==0);
                end
                correctVisualTrialsInd=intersect(visualTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                incorrectVisualTrialsInd=intersect(visualTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                incorrectMicrostimTrialsInd=intersect(microstimTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
                meanPerfVisual=length(correctVisualTrialsInd)/(length(correctVisualTrialsInd)+length(incorrectVisualTrialsInd))
                meanPerfMicrostim=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectMicrostimTrialsInd))
                totalRespTrials=length(correctTrialsInd)+length(incorrectTrialsInd);%number of trials where a response was made
                indRespTrials=sort([correctTrialsInd incorrectTrialsInd]);%indices of trials where response was made
                micro=[];
                for trialRespInd=1:totalRespTrials
                    trialNo=indRespTrials(trialRespInd);
                    corr(trialRespInd)=~isempty(find(correctTrialsInd==trialNo));
                    incorr(trialRespInd)=~isempty(find(incorrectTrialsInd==trialNo));
                    if ~strcmp(date,'291118_B9_aston')
                        if exist('microstimTrialNEV','var')
                            if length(microstimTrialNEV)>=trialNo
                                micro(trialRespInd)=microstimTrialNEV(trialNo);
                            end
                        end
                    elseif strcmp(date,'291118_B9_aston')
                        micro(trialRespInd)=~allTrialType(trialNo);
                    end
                end
                visualInd=find(micro~=1);
                corrInd=find(corr==1);
                corrVisualInd=intersect(visualInd,corrInd);
                if ~strcmp(date,'291118_B9_aston')
                    if exist('microstimTrialNEV','var')
                        microInd=find(micro==1);
                        corrMicroInd=intersect(microInd,corrInd);
                    end
                elseif strcmp(date,'291118_B9_aston')
                    microInd=find(micro==1);
                    corrMicroInd=intersect(microInd,corrInd);
                end
                perfMicroBin=[];
                perfVisualBin=[];
                perfMicroTrialNo=[];
                perfVisualTrialNo=[];
                numTrialsPerBin=1;
                for trialRespInd=1:length(micro)
                    if micro(trialRespInd)==1
                        firstMicroTrialInBin=find(microInd==trialRespInd);
                        if firstMicroTrialInBin<=length(microInd)-numTrialsPerBin+1
                            binMicroTrials=microInd(firstMicroTrialInBin:firstMicroTrialInBin+numTrialsPerBin-1);
                            corrMicroInBin=intersect(binMicroTrials,corrMicroInd);
                            perfMicroBin=[perfMicroBin length(corrMicroInBin)/numTrialsPerBin];
                            perfMicroTrialNo=[perfMicroTrialNo trialRespInd];
                        end
                    elseif micro(trialRespInd)==0
                        firstVisualTrialInBin=find(visualInd==trialRespInd);
                        if firstVisualTrialInBin<=length(visualInd)-numTrialsPerBin+1
                            binVisualTrials=visualInd(firstVisualTrialInBin:firstVisualTrialInBin+numTrialsPerBin-1);
                            corrVisualInBin=intersect(binVisualTrials,corrVisualInd);
                            perfVisualBin=[perfVisualBin length(corrVisualInBin)/numTrialsPerBin];
                            perfVisualTrialNo=[perfVisualTrialNo trialRespInd];
                        end
                    end
                end
                if calculateVisual==0
                    if ~isempty(perfMicroBin)
                        allSetsPerfMicroAllTrials(setNo,:)=mean(perfMicroBin);
                    end
                elseif calculateVisual==1
                    if ~isempty(perfVisualBin)
                        allSetsPerfVisualAllTrials(setNo,:)=mean(perfVisualBin);
                    end
                end
                
                if analyseConds==1
                    LRTBInd1=find(allLRorTB==1);
                    LRTBInd2=find(allLRorTB==2);
                    targetInd1=find(allTargetLocation==1);
                    targetInd2=find(allTargetLocation==2);
                    
                    condInds=intersect(LRTBInd1,targetInd1);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    leftPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    leftPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    
                    condInds=intersect(LRTBInd1,targetInd2);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    rightPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    rightPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    
                    condInds=intersect(LRTBInd2,targetInd1);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    topPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    topPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    
                    condInds=intersect(LRTBInd2,targetInd2);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    bottomPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    bottomPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    allPerfV(setNo,:)=perfV;
                    allPerfM(setNo,:)=perfM;
                    
                    figure;
                    subplot(2,4,1:2);
                    for electrodeCount=1:4
                        electrode=setElectrodes(setInd,electrodeCount);
                        array=setArrays(setInd,electrodeCount);
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array);%matching array number
                        electrodeInd=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        RFx=goodArrays8to16(electrodeInd,1);
                        RFy=goodArrays8to16(electrodeInd,2);
                        plot(RFx,RFy,'o','Color',cols(array-7,:),'MarkerFaceColor',cols(array-7,:));hold on
                        currentThreshold=goodCurrentThresholds(electrodeInd);
                        if electrodeCount==1
                            text(RFx-28,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                            text(RFx-28,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                        else
                            text(RFx+4,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                            text(RFx+4,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                        end
                    end
                    for electrodePairInd=1:size(electrodePairs,1)
                        electrode1=setElectrodes(setInd,electrodePairs(electrodePairInd,1));
                        array1=setArrays(setInd,electrodePairs(electrodePairInd,1));
                        electrode2=setElectrodes(setInd,electrodePairs(electrodePairInd,2));
                        array2=setArrays(setInd,electrodePairs(electrodePairInd,2));
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode1);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array1);%matching array number
                        electrodeInd1=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode2);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array2);%matching array number
                        electrodeInd2=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        RFx1=goodArrays8to16(electrodeInd1,1);
                        RFy1=goodArrays8to16(electrodeInd1,2);
                        RFx2=goodArrays8to16(electrodeInd2,1);
                        RFy2=goodArrays8to16(electrodeInd2,2);
                        plot([RFx1 RFx2],[RFy1 RFy2],'k--');
                    end
                    scatter(0,0,'r','o','filled');%fix spot
                    %draw dotted lines indicating [0,0]
                    plot([0 0],[-250 200],'k:');
                    plot([-200 300],[0 0],'k:');
                    plot([-200 300],[200 -300],'k:');
                    ellipse(50,50,0,0,[0.1 0.1 0.1]);
                    ellipse(100,100,0,0,[0.1 0.1 0.1]);
                    ellipse(150,150,0,0,[0.1 0.1 0.1]);
                    ellipse(200,200,0,0,[0.1 0.1 0.1]);
                    text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
                    text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
                    text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
                    text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
                    axis equal
                    xlim([-20 220]);
                    ylim([-160 20]);
                    title(['RF locations for 2-phosphene task, ',date], 'Interpreter', 'none');
                    for arrayInd=1:length(arrays)
                        text(175,0-10*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
                    end
                    ax=gca;
                    ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
                    ax.XTickLabel={'0','2','4','6','8'};
                    ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
                    ax.YTickLabel={'-8','-6','-4','-2','0'};
                    xlabel('x-coordinates (dva)')
                    ylabel('y-coordinates (dva)')
                    
                    %            if numTargets==4
                    subplot(2,4,3:4);
                    %            else
                    %                subplot(2,4,3);
                    %            end
                    b=bar([leftPerfV leftPerfM;rightPerfV rightPerfM;topPerfV topPerfM;bottomPerfV bottomPerfM],'FaceColor','flat');
                    b(1).FaceColor = 'flat';
                    b(2).FaceColor = 'flat';
                    b(1).FaceColor = [0 0.4470 0.7410];
                    b(2).FaceColor = [1 0 0];
                    set(gca, 'XTick',1:4)
                    set(gca, 'XTickLabel', {'slant left' 'slant right' 'vertical' 'horizontal'})
                    xLimits=get(gca,'xlim');
                    if ~isnan(leftPerfV)
                        txt=sprintf('%.2f',leftPerfV);
                        text(0.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(leftPerfM)
                        txt=sprintf('%.2f',leftPerfM);
                        text(1,0.95,txt,'Color','r')
                    end
                    if ~isnan(rightPerfV)
                        txt=sprintf('%.2f',rightPerfV);
                        text(1.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(rightPerfM)
                        txt=sprintf('%.2f',rightPerfM);
                        text(2,0.95,txt,'Color','r')
                    end
                    if ~isnan(topPerfV)
                        txt=sprintf('%.2f',topPerfV);
                        text(2.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(topPerfM)
                        txt=sprintf('%.2f',topPerfM);
                        text(3,0.95,txt,'Color','r')
                    end
                    if ~isnan(bottomPerfV)
                        txt=sprintf('%.2f',bottomPerfV);
                        text(3.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(bottomPerfM)
                        txt=sprintf('%.2f',bottomPerfM);
                        text(4,0.95,txt,'Color','r')
                    end
                    ylim([0 1])
                    hold on
                    plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
                    xlim([0 5])
                    title('mean performance, visual (blue) & microstim (red) trials');
                    xlabel('target condition');
                    ylabel('average performance across session');
                    %            pathname=fullfile('D:\aston_data',date,['behavioural_performance_per_condition_',date]);
                    %            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                    %            print(pathname,'-dtiff');
                end
                
                %         if ~isempty(perfMicroTrialNo)
                %             firstTrialsM=perfMicroTrialNo(initialPerfTrials-numTrialsPerBin+1);
                %             plot([firstTrialsM firstTrialsM],[0 1],'r:');
                %             [pM hM statsM]=ranksum(perfMicroBin(1:50),0.5)
                %             [hM pM ciM statsM]=ttest(perfMicroBin(1:50),0.5)
                %             formattedpM=num2str(pM);
                %             formattedpM=formattedpM(2:end);
                %             text(xLimits(2)/11,0.14,'p','Color','r','FontAngle','italic');
                %             text(xLimits(2)/10,0.14,['= ',formattedpM],'Color','r');
                %         end
                %         if ~isempty(perfVisualTrialNo)
                %             firstTrialsV=perfVisualTrialNo(initialPerfTrials-numTrialsPerBin+1);
                %             plot([firstTrialsV firstTrialsV],[0 1],'b:');
                %             [pV hV statsV]=ranksum(perfVisualBin(1:50),0.5)
                %             [hV pV ciV statsV]=ttest(perfVisualBin(1:50),0.5)
                %             formattedpV=num2str(pV);
                %             formattedpV=formattedpV(2:end);
                %             text(xLimits(2)/11,0.2,'p','Color','b','FontAngle','italic');
                %             text(xLimits(2)/10,0.2,['= ',formattedpV],'Color','b');
                %         end
            end
        end
    end
%     if calculateVisual==0
%         figure;
%         meanAllSetsPerfMicroBin=nanmean(allSetsPerfMicroBin,1);
%         subplot(2,1,1);
%         hold on
%         plot(meanAllSetsPerfMicroBin,'r');
%         ylim([0 1]);
%         xLimits=get(gca,'xlim');
%         plot([0 xLimits(2)],[0.5 0.5],'k:');
% %         plot([10 10],[0 1],'k:');
%         xlabel('trial number');
%         ylabel('mean performance');
%     end
%     if calculateVisual==1
%         subplot(2,1,2);
%         hold on
%         meanAllSetsPerfVisualBin=nanmean(allSetsPerfVisualBin,1);
%         plot(meanAllSetsPerfVisualBin,'b');
%         ylim([0 1]);
%         xLimits=get(gca,'xlim');
%         plot([0 xLimits(2)],[0.5 0.5],'k:');
% %         plot([10 10],[0 1],'k:');
%         xlabel('trial number');
% %         xlabel('trial number (from end of session)');
%         ylabel('mean performance');
%     end
end
goodSetsallSetsPerfVisualAllTrials=allSetsPerfVisualAllTrials(setNos);
goodSetsallSetsPerfMicroAllTrials=allSetsPerfMicroAllTrials(setNos);
mean(goodSetsallSetsPerfVisualAllTrials)
mean(goodSetsallSetsPerfMicroAllTrials)
figure;
subplot(2,1,1);
% plot(goodSetsallSetsPerfMicroAllTrials,'r');
b2=bar(goodSetsallSetsPerfMicroAllTrials);
b2(1).FaceColor = 'flat';
b2(1).FaceColor = [1 0 0];
hold on
plot([0 length(goodSetsallSetsPerfMicroAllTrials)+1],[0.5 0.5],'k:');
xlim([0 length(goodSetsallSetsPerfMicroAllTrials)+1]);
ylim([0 1]);
set(gca,'Box','off');
subplot(2,1,2);
% plot(goodSetsallSetsPerfVisualAllTrials,'b');
b3=bar(goodSetsallSetsPerfVisualAllTrials);
b3(1).FaceColor = 'flat';
b3(1).FaceColor = [0 0 1];
hold on
plot([0 length(goodSetsallSetsPerfVisualAllTrials)+1],[0.5 0.5],'k:');
xlim([0 length(goodSetsallSetsPerfVisualAllTrials)+1]);
ylim([0 1]);
set(gca,'Box','off');
%exported as behavioural_perf_motion_all_sets_171218_all_trials_aston.eps

perfMat=['D:\aston_data\behavioural_performance_first_sets_171218_all_trials_motion.mat'];
save(perfMat,'allSetsPerfVisualAllTrials','allSetsPerfMicroAllTrials','goodSetsallSetsPerfVisualAllTrials','goodSetsallSetsPerfMicroAllTrials','allPerfV','allPerfM');
pause=1;

%histogram:
subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfMicroAllTrials,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 7]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = 5.1546, p = 0.0001

subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfVisualAllTrials,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 12],'k:');
xlim([0 1]);
ylim([0 12]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 5 10];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = 15.63, p = 0.0000

significantByThisTrialMicro=0;
for trialInd=1:length(meanAllSetsPerfMicroBin)
    x=sum(meanAllSetsPerfMicroBin(1:trialInd))*size(allSetsPerfMicroBin,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfMicroBin,1)*trialInd,0.5);
    if Y<0.05
        significantByThisTrialMicro(trialInd)=1;
    end
end
significantByThisTrialMicro%4th trial onwards

significantByThisTrialVisual=0;
for trialInd=1:length(meanAllSetsPerfVisualBin)
    x=sum(meanAllSetsPerfVisualBin(1:trialInd))*size(allSetsPerfVisualBin,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfVisualBin,1)*trialInd,0.5);
    if Y<0.05
        significantByThisTrialVisual(trialInd)=1;
    end
end
significantByThisTrialVisual%2nd trial onwards