function analyse_microstim_line_across_sessions_5phosphenes(date)
%22/12/17
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual line orientation task, for lines composed of 5 phosphenes.
%Calculates mean performance across sets of electrodes, for the first few
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

analyseConds=0;
for calculateVisual=[0 1]
    for setNo=[1:19]%26
        perfNEV=[];
        timeInd=[];
        encodeInd=[];
        microstimTrialNEV=[];
        allLRorTB=[];
        allTargetLocation=[];
        corr=[];
        incorr=[];
        localDisk=1;
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='131217_B14';
                    setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;16 16 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=53;
                    visualOnly=0;
                    localDisk=0;
                case 2
                    date='141217_B4';
                    setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;16 16 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=54;
                    visualOnly=0;
                    interleaved=1;
                    localDisk=0;
                case 3
                    date='141217_B7';
                    setElectrodes=[52 28 34 35 55;45 30 28 23 37];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;8 16 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=54;
                    visualOnly=0;
                    interleaved=1;
                    localDisk=0;
                case 4
                    date='141217_B9';
                    setElectrodes=[40 7 43 48 55;38 47 39 35 27];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 8 15 15;16 16 14 12 9];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=54;
                    visualOnly=0;
                    interleaved=1;
                    localDisk=0;
                case 5
                    date='151217_B5';
                    setElectrodes=[40 50 12 44 26;40 64 22 19 62];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 12 9 9;16 16 16 8 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=0;
                    interleaved=1;
                case 6
                    date='151217_B7';
                    setElectrodes=[7 64 61 58 2;50 61 21 27 46];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 16 14 12;16 16 16 8 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=0;
                    interleaved=1;
                case 7
                    date='151217_B9';
                    setElectrodes=[40 21 13 20 61;39 47 16 32 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 16 14 12 12;12 14 14 14 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=0;
                    interleaved=1;
                case 8
                    date='151217_B11';
                    setElectrodes=[50 36 28 35 55;63 48 26 40 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 12 13 11;15 13 13 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=0;
                    interleaved=1;
                case 9
                    date='181217_B12';
                    setElectrodes=[45 44 50 15 7;44 19 27 32 28];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 8 8 15 15;8 8 8 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=56;
                    visualOnly=0;
                    interleaved=1;
                case 10
                    date='191217_B10';
                    setElectrodes=[33 5 23 29 56;37 39 33 64 9];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 12 12 13;16 12 12 9 9];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=0;
                    interleaved=1;
                case 11
                    date='191217_B12';
                    setElectrodes=[59 29 24 31 38;15 12 15 29 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 14 12 13 13;16 16 14 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=0;
                    interleaved=1;
                case 12
                    date='191217_B14';
                    setElectrodes=[10 28 47 34 13;56 51 39 43 36];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;13 13 10 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=0;
                    interleaved=1;
                case 13
                    date='191217_B16';
                    setElectrodes=[27 33 49 51 55;49 31 52 46 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 13 11;15 13 13 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=0;
                    interleaved=1;
                case 14
                    date='191217_B18';
                    setElectrodes=[46 32 15 22 3;32 53 47 58 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 10 10 10 11;13 13 10 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=0;
                    interleaved=1;
                case 15
                    date='201217_B4';
                    setElectrodes=[40 44 12 28 31;63 61 47 58 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 14 14 14 14;16 16 14 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 16
                    date='201217_B6';
                    setElectrodes=[39 45 47 54 32;15 53 12 29 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 14 14 14 14;16 14 14 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 17
                    date='201217_B8';
                    setElectrodes=[17 58 13 20 30;22 63 13 21 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[9 14 14 14 14;16 14 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 18
                    date='201217_B10';
                    setElectrodes=[39 63 30 40 63;50 27 32 29 33];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 16 15 15;8 8 14 12 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 19
                    date='201217_B12';
                    setElectrodes=[21 29 48 22 38;20 63 22 20 52];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;16 14 12 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
            end
        elseif calculateVisual==1
            localDisk=1;
            switch(setNo)
                %visual task only:
                case 1
                    date='131217_B13';
                    setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;16 16 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=53;
                    visualOnly=1;
                    localDisk=0;
                case 2
                    date='141217_B2';
                    setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;16 16 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=54;
                    visualOnly=1;
                    localDisk=0;
                case 3
                    date='141217_B6';
                    setElectrodes=[52 28 34 35 55;45 30 28 23 37];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;8 16 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=54;
                    visualOnly=1;
                    localDisk=0;
                case 4
                    date='141217_B8';
                    setElectrodes=[40 7 43 48 55;38 47 39 35 27];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 8 15 15;16 16 14 12 9];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=54;
                    visualOnly=1;
                    localDisk=0;
                case 5
                    date='151217_B4';
                    setElectrodes=[40 50 12 44 26;40 64 22 19 62];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 12 9 9;16 16 16 8 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=1;
                case 6
                    date='151217_B6';
                    setElectrodes=[7 64 61 58 2;50 61 21 27 46];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 16 14 12;16 16 16 8 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=1;
                case 7
                    date='151217_B8';
                    setElectrodes=[40 21 13 20 61;39 47 16 32 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 16 14 12 12;12 14 14 14 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=1;
                case 8
                    date='151217_B10';
                    setElectrodes=[50 36 28 35 55;63 48 26 40 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 12 13 11;15 13 13 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=55;
                    visualOnly=1;
                case 9
                    date='181217_B11';
                    setElectrodes=[45 44 50 15 7;44 19 27 32 28];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 8 8 15 15;8 8 8 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=56;
                    visualOnly=1;
                    interleaved=1;
                case 10
                    date='191217_B4';
                    setElectrodes=[33 5 23 29 56;37 39 33 64 9];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 12 12 13;16 12 12 9 9];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=1;
                    interleaved=1;
                case 11
                    date='191217_B11';
                    setElectrodes=[59 29 24 31 38;15 12 15 29 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 14 12 13 13;16 16 14 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=1;
                    interleaved=1;
                case 12
                    date='191217_B13';
                    setElectrodes=[10 28 47 34 13;56 51 39 43 36];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;13 13 10 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=1;
                    interleaved=1;
                case 13
                    date='191217_B15';
                    setElectrodes=[27 33 49 51 55;49 31 52 46 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 13 11;15 13 13 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=1;
                    interleaved=1;
                case 14
                    date='191217_B17';
                    setElectrodes=[46 32 15 22 3;32 53 47 58 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 10 10 10 11;13 13 10 10 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=57;
                    visualOnly=1;
                    interleaved=1;
                case 15
                    date='201217_B2';
                    setElectrodes=[40 44 12 28 31;63 61 47 58 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 14 14 14 14;16 16 14 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=1;
                    interleaved=1;
                case 16
                    date='201217_B5';
                    setElectrodes=[39 45 47 54 32;15 53 12 29 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 14 14 14 14;16 14 14 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=1;
                    interleaved=1;
                case 17
                    date='201217_B7';
                    setElectrodes=[17 58 13 20 30;22 63 13 21 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[9 14 14 14 14;16 14 14 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=1;
                    interleaved=1;
                case 18
                    date='201217_B9';
                    setElectrodes=[39 63 30 40 63;50 27 32 29 33];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 16 15 15;8 8 14 12 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=1;
                    interleaved=1;
                case 19
                    date='201217_B11';
                    setElectrodes=[21 29 48 22 38;20 63 22 20 52];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 13 13 13;16 14 12 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=58;
                    visualOnly=1;
                    interleaved=1;
            end
        end
        
        if localDisk==1
            rootdir='D:\data\';
        elseif localDisk==0
            rootdir='X:\best\';
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
                        if find(trialEncodes==2^CorrectB)
                            perfNEV(trialNo)=1;
                        elseif find(trialEncodes==2^ErrorB)
                            perfNEV(trialNo)=-1;
                        end
                        for trialCurrentLevelInd=1:length(allCurrentLevel)
                            if sum(allCurrentLevel{trialCurrentLevelInd})>0
                                microstimTrialNEV(trialCurrentLevelInd)=1;
                            else
                                microstimTrialNEV(trialCurrentLevelInd)=0;
                            end
                        end
                        trialNo=trialNo+1;
                    end
                end
                
                tallyCorrect=length(find(perfNEV==1));
                tallyIncorrect=length(find(perfNEV==-1));
                meanPerf=tallyCorrect/(tallyCorrect+tallyIncorrect);
                visualTrialsInd=find(microstimTrialNEV==0);%not entirely correct- includes microstim trials where fix breaks happen before dasbit sent MicroB
                microstimTrialsInd=find(microstimTrialNEV==1);
                correctTrialsInd=find(perfNEV==1);
                incorrectTrialsInd=find(perfNEV==-1);
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
                    if exist('microstimTrialNEV','var')
                        if length(microstimTrialNEV)>=trialNo
                            micro(trialRespInd)=microstimTrialNEV(trialNo);
                        end
                    end
                end
                visualInd=find(micro~=1);
                corrInd=find(corr==1);
                corrVisualInd=intersect(visualInd,corrInd);
                if exist('microstimTrialNEV','var')
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
                initialPerfTrials=8;%first set of trials are the most important
                if calculateVisual==0
                    perfMicroBin=perfMicroBin(1:initialPerfTrials);
                    if ~isempty(perfMicroBin)
                        allSetsPerfMicroBin(setNo,:)=perfMicroBin;
                        save(['D:\microPerf_',date,'.mat'],'perfMicroBin');
                    end
                elseif calculateVisual==1
                    perfVisualBin=perfVisualBin(1:initialPerfTrials);
                    %perfVisualBin=perfVisualBin(end-initialPerfTrials+1:end);
                    if ~isempty(perfVisualBin)
                        allSetsPerfVisualBin(setNo,:)=perfVisualBin;
                        save(['D:\visualPerf_',date,'.mat'],'perfVisualBin');
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
                    
                    figure;
                    subplot(2,4,1:2);
                    for electrodeCount=1:4
                        electrode=setElectrodes(setInd,electrodeCount);
                        array=setArrays(setInd,electrodeCount);
                        load([dataDir,'\array',num2str(array),'.mat']);
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
                    %            pathname=fullfile('D:\data',date,['behavioural_performance_per_condition_',date]);
                    %            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                    %            print(pathname,'-dtiff');
                end                
            end
        end
    end
    if calculateVisual==0
        figure;
        meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
        subplot(2,1,1);
        hold on
        plot(meanAllSetsPerfMicroBin,'r');
        ylim([0 1]);
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
        plot([10 10],[0 1],'k:');
        xlabel('trial number (from beginning of session)');
        ylabel('mean performance across electrode sets');
    end
    if calculateVisual==1
        subplot(2,1,2);
        hold on
        meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
        plot(meanAllSetsPerfVisualBin,'b');
        ylim([0 1]);
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
        plot([10 10],[0 1],'k:');
        xlabel('trial number (from beginning of session)');
%         xlabel('trial number (from end of session)');
        ylabel('mean performance across electrode sets');
    end
end
title(['performance across the session, on visual (blue) & microstim (red) trials']);
pathname=fullfile('D:\data\behavioural_performance_all_sets_221217');
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff');

perfMat=['D:\data\behavioural_performance_all_sets_221217_',num2str(initialPerfTrials),'trials.mat'];
save(perfMat,'meanAllSetsPerfVisualBin','meanAllSetsPerfMicroBin');
pause=1;

significantByThisTrialMicro=0;
for trialInd=1:length(meanAllSetsPerfMicroBin)
    x=sum(meanAllSetsPerfMicroBin(1:trialInd))*size(allSetsPerfMicroBin,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfMicroBin,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialMicro(trialInd)=1;
    end
end
significantByThisTrialMicro

significantByThisTrialVisual=0;
for trialInd=1:length(meanAllSetsPerfVisualBin)
    x=sum(meanAllSetsPerfVisualBin(1:trialInd))*size(allSetsPerfVisualBin,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfVisualBin,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialVisual(trialInd)=1;
    end
end
significantByThisTrialVisual