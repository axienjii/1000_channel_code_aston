function analyse_microstim_line(date,allInstanceInd)
%07/12/17
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual 4-phosphene ('line') task.

interleaved=0;%set interleaved to 0, if trigger pulse was sent using microB. set interleaved to 1, if stimulation was sent by calling stimulator.play function
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
dataDir=[rootdir,date,'\',date,'_data'];
if ~exist('dataDir','dir')
    copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);    
end
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

analyseConds=1;
if analyseConds==1
    switch(date)
        %microstim task only:
        case '051217_B8'
            setElectrodes=[50 28 35 55;63 48 40 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 11;15 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=0;  
        case '051217_B15'
            setElectrodes=[40 21 13 61;40 12 30 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[8 16 14 12;12 14 14 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=0;   
        case '051217_B17'
            setElectrodes=[10 47 53 24;32 55 46 57];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 11;13 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=0;  
        case '051217_B19'
            setElectrodes=[37 62 20 18;38 55 58 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 10 11;13 10 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=0; 
        case '131217_B14'
            setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 16 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=53;
            visualOnly=0;    
        case '141217_B4'
            setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 16 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=54;
            visualOnly=0;   
            interleaved=1;   
        case '141217_B7'
            setElectrodes=[52 28 34 35 55;45 30 28 23 37];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;8 16 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=54;
            visualOnly=0;    
            interleaved=1; 
        case '141217_B9'
            setElectrodes=[40 7 43 48 55;38 47 39 35 27];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 8 15 15;16 16 14 12 9];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=54;
            visualOnly=0;     
            interleaved=1; 
        case '151217_B5'
            setElectrodes=[40 50 12 44 26;40 64 22 19 62];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 12 9 9;16 16 16 8 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=0;   
            interleaved=1;   
        case '151217_B7'
            setElectrodes=[7 64 61 58 2;50 61 21 27 46];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 14 12;16 16 16 8 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=0;    
            interleaved=1; 
        case '151217_B9'
            setElectrodes=[40 21 13 20 61;39 47 16 32 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[8 16 14 12 12;12 14 14 14 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=0;   
            interleaved=1;  
        case '151217_B11'
            setElectrodes=[50 36 28 35 55;63 48 26 40 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 12 13 11;15 13 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=0;    
            interleaved=1; 
        case '181217_B7'
            setElectrodes=[40 50 12 44 26;40 64 22 19 62];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 12 9 9;16 16 16 8 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=56;
            visualOnly=0;   
            interleaved=1;   
        case '181217_B8'
            setElectrodes=[7 64 61 58 2;50 61 21 27 46];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 14 12;16 16 16 8 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=56;
            visualOnly=0;    
            interleaved=1; 
        case '181217_B9'
            setElectrodes=[40 21 13 20 61;39 47 16 32 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[8 16 14 12 12;12 14 14 14 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=56;
            visualOnly=0;   
            interleaved=1;  
        case '181217_B10'
            setElectrodes=[50 36 28 35 55;63 48 26 40 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 12 13 11;15 13 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=56;
            visualOnly=0;    
            interleaved=1; 
        case '181217_B12'
            setElectrodes=[45 44 50 15 7;44 19 27 32 28];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[8 8 8 15 15;8 8 8 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=56;
            visualOnly=0;    
            interleaved=1; 
        case '191217_B10'
            setElectrodes=[33 5 23 29 56;37 39 33 64 9];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 12 12 13;16 12 12 9 9];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=0;    
            interleaved=1; 
        case '191217_B12'
            setElectrodes=[59 29 24 31 38;15 12 15 29 58];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[14 14 12 13 13;16 16 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=0;    
            interleaved=1; 
        case '191217_B14'
            setElectrodes=[10 28 47 34 13;56 51 39 43 36];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;13 13 10 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=0;    
            interleaved=1; 
        case '191217_B16'
            setElectrodes=[27 33 49 51 55;49 31 52 46 51];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 13 11;15 13 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=0;    
            interleaved=1; 
        case '191217_B18'
            setElectrodes=[46 32 15 22 3;32 53 47 58 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 10 10 11;13 13 10 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=0;    
            interleaved=1; 
        case '201217_B4'
            setElectrodes=[40 44 12 28 31;63 61 47 58 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 16 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '201217_B6'
            setElectrodes=[39 45 47 54 32;15 53 12 29 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 14 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '201217_B8'
            setElectrodes=[17 58 13 20 30;22 63 13 21 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[9 14 14 14 14;16 14 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '201217_B10'
            setElectrodes=[39 63 30 40 63;50 27 32 29 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 15 15;8 8 14 12 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '201217_B12'
            setElectrodes=[21 29 48 22 38;20 63 22 20 52];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 14 12 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B10'
            setElectrodes=[40 31;63 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B13'
            setElectrodes=[40 44 12 28 31;63 61 47 58 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 16 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1;
        case '211217_B6'
            setElectrodes=[39 32;15 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B8'
            setElectrodes=[39 45 47 54 32;15 53 12 29 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 14 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B14'
            setElectrodes=[17 30;22 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[9 14;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B16'
            setElectrodes=[17 58 13 20 30;22 63 13 21 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[9 14 14 14 14;16 14 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B18'
            setElectrodes=[39 63;50 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15;8 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B20'
            setElectrodes=[39 63 30 40 63;50 27 32 29 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 15 15;8 8 14 12 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B22'
            setElectrodes=[21 38;20 52];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B24'
            setElectrodes=[21 29 48 22 38;20 63 22 20 52];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 14 12 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B25'
            setElectrodes=[21 29 48 22 38;20 63 22 20 52];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 14 12 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B26'
            setElectrodes=[39 63 30 40 63;50 27 32 29 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 15 15;8 8 14 12 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B27'
            setElectrodes=[17 58 13 20 30;22 63 13 21 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[9 14 14 14 14;16 14 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;    
            interleaved=1; 
        case '211217_B28'
            setElectrodes=[39 45 47 54 32;15 53 12 29 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 14 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;
            interleaved=1;
        case '211217_B29'
            setElectrodes=[40 44 12 28 31;63 61 47 58 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 16 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=0;
            interleaved=1;
        case '221217_B8'
            setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B12'
            setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%221217_B & B
            setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B16'
            setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B20'
            setElectrodes=[{[]} {[]} {[27 33 49 51 55]} {[49 31 52 46 51]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 13 13 13 11]} {[15 13 13 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B25'
            setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%221217_B & B
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B9'
            setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B13'
            setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%221217_B & B
            setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B17'
            setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B22'
            setElectrodes=[{[]} {[]} {[27 33 49 51 55]} {[49 31 52 46 51]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 13 13 13 11]} {[15 13 13 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B26'
            setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%221217_B & B
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '221217_B27'
            setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%221217_B27 (not interleaved)
            setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=0;
            interleaved=1;
        case '030118_B6';
            setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%030118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B11';
            setElectrodes=[{[]} {[]} {[50 61 21 27 46]} {[7 64 61 58 2]}];%0118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 16 14 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B15';
            setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%0118_B & B?
            setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B20';
            setElectrodes=[{[]} {[]} {[63 48 26 40 35]} {[50 36 28 35 55]}];%0118_B & B?
            setArrays=[{[]} {[]} {[15 13 13 10 10]} {[12 12 12 13 11]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B24';
            setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%0118_B & B?
            setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B9';
            setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%030118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B13';
            setElectrodes=[{[]} {[]} {[50 61 21 27 46]} {[7 64 61 58 2]}];%0118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 16 14 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B17';
            setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%0118_B & B?
            setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B22';
            setElectrodes=[{[]} {[]} {[63 48 26 40 35]} {[50 36 28 35 55]}];%0118_B & B?
            setArrays=[{[]} {[]} {[15 13 13 10 10]} {[12 12 12 13 11]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '030118_B26';
            setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%0118_B & B?
            setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=0;
            interleaved=1;
        case '040118_B5';
            setElectrodes=[{[]} {[]} {[2 57 47 61 53]} {[22 27 13 21 61]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 16 14 12 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B9';
            setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B13';
            setElectrodes=[{[]} {[]} {[40 7 43 48 55]} {[38 47 39 35 27]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[16 16 8 15 15]} {[16 16 14 12 9]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B17';
            setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B21';
            setElectrodes=[{[]} {[]} {[43 62 21 20 18]} {[38 55 56 62 34]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 10 10 10 11]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B7';
            setElectrodes=[{[]} {[]} {[2 57 47 61 53]} {[22 27 13 21 61]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B11';
            setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B15';
            setElectrodes=[{[]} {[]} {[40 7 43 48 55]} {[38 47 39 35 27]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[16 16 8 15 15]} {[16 16 14 12 9]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B19';
            setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '040118_B23';
            setElectrodes=[{[]} {[]} {[43 62 21 20 18]} {[38 55 56 62 34]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 10 10 10 11]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=0;
            interleaved=1;
        case '160218_B4';
            setElectrodes=[40 64 22 19 62;40 50 12 44 26];%151217_B4 & B5
            setArrays=[16 16 16 8 15;16 16 12 9 9];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=76;
            visualOnly=0;
            interleaved=1;
        case '160218_B5';
            setElectrodes=[39 47 16 32 49;40 21 13 20 61];%151217_B8 & B9?
            setArrays=[12 14 14 14 15;8 16 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=76;
            visualOnly=0;
            interleaved=1;
        case '190218_B4';
            setElectrodes=[2 57 47 61 53;22 27 13 21 61];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;16 16 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=0;
            interleaved=1;
        case '190218_B6';
            setElectrodes=[52 28 34 35 55;45 30 28 23 37];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;8 16 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=0;
            interleaved=1;
        case '190218_B8';
            setElectrodes=[40 7 43 48 55;38 47 39 35 27];%151217_B8 & B9?
            setArrays=[16 16 8 15 15;16 16 14 12 9];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=0;
            interleaved=1;
        case '190218_B10';
            setElectrodes=[50 61 21 27 46;7 64 61 58 2];%151217_B8 & B9?
            setArrays=[16 16 16 8 15;16 16 16 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=0;
            interleaved=1;
        case '200218_B5';
            setElectrodes=[50 36 28 35 55;63 48 26 40 35];%151217_B8 & B9?
            setArrays=[12 12 12 13 11;15 13 13 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=0;
            interleaved=1;
        case '200218_B7';
            setElectrodes=[45 44 50 15 7;44 19 27 32 28];%151217_B8 & B9?
            setArrays=[8 8 8 15 15;8 8 8 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=0;
            interleaved=1;
        case '200218_B9';
            setElectrodes=[33 5 23 29 56;37 39 33 64 9];%151217_B8 & B9?
            setArrays=[12 12 12 12 13;16 12 12 9 9];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=0;
            interleaved=1;
        case '200218_B11';
            setElectrodes=[59 29 24 31 38;15 12 15 29 58];%151217_B8 & B9?
            setArrays=[14 14 12 13 13;16 16 14 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=0;
            interleaved=1;
        case '210218_B4';
            setElectrodes=[10 28 47 34 13;56 51 39 43 36];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;13 13 10 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=0;
            interleaved=1;
        case '210218_B6';
            setElectrodes=[27 33 49 51 55;49 31 52 46 51];%151217_B8 & B9?
            setArrays=[12 13 13 13 11;15 13 13 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=0;
            interleaved=1;
        case '210218_B8';
            setElectrodes=[46 32 15 22 3;32 53 47 58 59];%151217_B8 & B9?
            setArrays=[10 10 10 10 11;13 13 10 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=0;
            interleaved=1;
        case '210218_B10';
            setElectrodes=[40 44 12 28 31;63 61 47 58 4];%151217_B8 & B9?
            setArrays=[12 14 14 14 14;16 16 14 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=0;
            interleaved=1;
        case '220218_B4';
            setElectrodes=[39 45 47 54 32;15 53 12 29 59];%151217_B8 & B9?
            setArrays=[12 14 14 14 14;16 14 14 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=0;
            interleaved=1;
        case '220218_B6';
            setElectrodes=[17 58 13 20 30;22 63 13 21 44];%151217_B8 & B9?
            setArrays=[9 14 14 14 14;16 14 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=0;
            interleaved=1;
        case '220218_B8';
            setElectrodes=[39 63 30 40 63;50 27 32 29 33];%151217_B8 & B9?
            setArrays=[16 16 16 15 15;8 8 14 12 13];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=0;
            interleaved=1;
        case '220218_B10';
            setElectrodes=[21 29 48 22 38;20 63 22 20 52];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;16 14 12 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=0;
            interleaved=1;
        case '230218_B5';
            setElectrodes=[40 47 56 24 21;22 52 38 29 57];%151217_B8 & B9?
            setArrays=[10 10 10 10 11;13 13 10 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=82;
            visualOnly=0;
            interleaved=1;
        case '230218_B7';
            setElectrodes=[43 62 21 20 18;38 55 56 62 34];%151217_B8 & B9?
            setArrays=[10 10 10 10 11;13 10 10 10 11];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=82;
            visualOnly=0;
            interleaved=1;
        case '260218_B8';
            setElectrodes=[41 13 22 23 12;35 34 48 47 1];%151217_B8 & B9?
            setArrays=[12 12 12 12 13;16 12 9 9 9];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=83;
            visualOnly=0;
            interleaved=1;
        case '260218_B10';
            setElectrodes=[34 42 26 58 60;57 43 40 6 1];%151217_B8 & B9?
            setArrays=[12 12 12 13 13;16 16 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=83;
            visualOnly=0;
            interleaved=1;
            
            %visual task only:
        case '051217_B7'
            setElectrodes=[50 28 35 55;63 48 40 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 11;15 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=1; 
        case '051217_B14'
            setElectrodes=[40 21 13 61;40 12 30 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[8 16 14 12;12 14 14 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=1;   
        case '051217_B16'
            setElectrodes=[10 47 53 24;32 55 46 57];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 11;13 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=1;   
        case '051217_B18'
            setElectrodes=[37 62 20 18;38 55 58 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 10 11;13 10 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4;1 2 3 4];
            currentThresholdChs=48;
            visualOnly=1; 
        case '131217_B13'
            setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 16 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=53;
            visualOnly=1; 
        case '141217_B2'
            setElectrodes=[2 57 47 61 53;22 27 13 21 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 16 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=54;
            visualOnly=1;    
        case '141217_B6'
            setElectrodes=[52 28 34 35 55;45 30 28 23 37];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;8 16 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=54;
            visualOnly=1;   
        case '141217_B8'
            setElectrodes=[40 7 43 48 55;38 47 39 35 27];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 8 15 15;16 16 14 12 9];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=54;
            visualOnly=1;   
        case '151217_B4'
            setElectrodes=[40 50 12 44 26;40 64 22 19 62];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 12 9 9;16 16 16 8 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=1;   
        case '151217_B6'
            setElectrodes=[7 64 61 58 2;50 61 21 27 46];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 14 12;16 16 16 8 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=1;  
        case '151217_B8'
            setElectrodes=[40 21 13 20 61;39 47 16 32 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[8 16 14 12 12;12 14 14 14 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=1;  
        case '151217_B10'
            setElectrodes=[50 36 28 35 55;63 48 26 40 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 12 13 11;15 13 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=55;
            visualOnly=1;  
        case '181217_B3'
            setElectrodes=[40 50 12 44 26;40 64 22 19 62];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 12 9 9;16 16 16 8 15];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=56;
            visualOnly=1;   
            interleaved=1;   
        case '181217_B11'
            setElectrodes=[45 44 50 15 7;44 19 27 32 28];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[8 8 8 15 15;8 8 8 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=56;
            visualOnly=1;    
            interleaved=1; 
        case '191217_B4'
            setElectrodes=[33 5 23 29 56;37 39 33 64 9];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 12 12 13;16 12 12 9 9];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=1;    
            interleaved=1; 
        case '191217_B11'
            setElectrodes=[59 29 24 31 38;15 12 15 29 58];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[14 14 12 13 13;16 16 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=1;    
            interleaved=1; 
        case '191217_B13'
            setElectrodes=[10 28 47 34 13;56 51 39 43 36];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;13 13 10 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=1;    
            interleaved=1; 
        case '191217_B15'
            setElectrodes=[27 33 49 51 55;49 31 52 46 51];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 13 11;15 13 13 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=1;    
            interleaved=1; 
        case '191217_B17'
            setElectrodes=[46 32 15 22 3;32 53 47 58 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 10 10 11;13 13 10 10 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=57;
            visualOnly=1;    
            interleaved=1; 
        case '201217_B2'
            setElectrodes=[40 44 12 28 31;63 61 47 58 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 16 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '201217_B5'
            setElectrodes=[39 45 47 54 32;15 53 12 29 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 14 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '201217_B7'
            setElectrodes=[17 58 13 20 30;22 63 13 21 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[9 14 14 14 14;16 14 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '201217_B9'
            setElectrodes=[39 63 30 40 63;50 27 32 29 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 15 15;8 8 14 12 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '201217_B11'
            setElectrodes=[21 29 48 22 38;20 63 22 20 52];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 14 12 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1;  
        case '211217_B9'
            setElectrodes=[40 31;63 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B12'
            setElectrodes=[40 44 12 28 31;63 61 47 58 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 16 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1;
        case '211217_B3'
            setElectrodes=[39 32;15 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B7'
            setElectrodes=[39 45 47 54 32;15 53 12 29 59];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 14 14 14 14;16 14 14 14 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B11'
            setElectrodes=[17 30;22 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[9 14;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B15'
            setElectrodes=[17 58 13 20 30;22 63 13 21 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[9 14 14 14 14;16 14 14 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B17'
            setElectrodes=[39 63;50 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15;8 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B19'
            setElectrodes=[39 63 30 40 63;50 27 32 29 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 16 16 15 15;8 8 14 12 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B21'
            setElectrodes=[21 38;20 52];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13;16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '211217_B23'
            setElectrodes=[21 29 48 22 38;20 63 22 20 52];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 13 13 13;16 14 12 12 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=58;
            visualOnly=1;    
            interleaved=1; 
        case '221217_B2'
            setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B10'
            setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%221217_B & B
            setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B14'
            setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B18'
            setElectrodes=[{[]} {[]} {[27 33 49 51 55]} {[49 31 52 46 51]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 13 13 13 11]} {[15 13 13 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B23'
            setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%221217_B & B
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1 2;1 2];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B3'
            setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B11'
            setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%221217_B & B
            setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B15'
            setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B19'
            setElectrodes=[{[]} {[]} {[27 33 49 51 55]} {[49 31 52 46 51]}];%221217_B & B
            setArrays=[{[]} {[]} {[12 13 13 13 11]} {[15 13 13 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '221217_B24'
            setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%221217_B & B
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=60;
            visualOnly=1;
            interleaved=1;
        case '030118_B4';
            setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%030118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B10';
            setElectrodes=[{[]} {[]} {[50 61 21 27 46]} {[7 64 61 58 2]}];%0118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 16 14 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B14';
            setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%0118_B & B?
            setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B19';
            setElectrodes=[{[]} {[]} {[63 48 26 40 35]} {[50 36 28 35 55]}];%0118_B & B?
            setArrays=[{[]} {[]} {[15 13 13 10 10]} {[12 12 12 13 11]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B23';
            setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%0118_B & B?
            setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1 2 3 4 5;1 2 3 4 5];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B8';
            setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%030118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B12';
            setElectrodes=[{[]} {[]} {[50 61 21 27 46]} {[7 64 61 58 2]}];%0118_B & B?
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 16 14 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B16';
            setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%0118_B & B?
            setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B21';
            setElectrodes=[{[]} {[]} {[63 48 26 40 35]} {[50 36 28 35 55]}];%0118_B & B?
            setArrays=[{[]} {[]} {[15 13 13 10 10]} {[12 12 12 13 11]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '030118_B25';
            setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%0118_B & B?
            setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=61;
            visualOnly=1;
            interleaved=1;
        case '040118_B4';
            setElectrodes=[{[]} {[]} {[2 57 47 61 53]} {[22 27 13 21 61]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 16 14 12 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B8';
            setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B12';
            setElectrodes=[{[]} {[]} {[40 7 43 48 55]} {[38 47 39 35 27]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[16 16 8 15 15]} {[16 16 14 12 9]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B16';
            setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B20';
            setElectrodes=[{[]} {[]} {[43 62 21 20 18]} {[38 55 56 62 34]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 10 10 10 11]}];
            setElectrodes=[setElectrodes{3};setElectrodes{4}];
            setArrays=[setArrays{3};setArrays{4}];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B6';
            setElectrodes=[{[]} {[]} {[2 57 47 61 53]} {[22 27 13 21 61]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B10';
            setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B14';
            setElectrodes=[{[]} {[]} {[40 7 43 48 55]} {[38 47 39 35 27]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[16 16 8 15 15]} {[16 16 14 12 9]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B18';
            setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '040118_B22';
            setElectrodes=[{[]} {[]} {[43 62 21 20 18]} {[38 55 56 62 34]}];%040118_B & B?
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 10 10 10 11]}];
            setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
            setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=62;
            visualOnly=1;
            interleaved=1;
        case '190218_B3';
            setElectrodes=[2 57 47 61 53;22 27 13 21 61];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;16 16 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=1;
            interleaved=1;
        case '190218_B5';
            setElectrodes=[52 28 34 35 55;45 30 28 23 37];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;8 16 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=1;
            interleaved=1;
        case '190218_B7';
            setElectrodes=[40 7 43 48 55;38 47 39 35 27];%151217_B8 & B9?
            setArrays=[16 16 8 15 15;16 16 14 12 9];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=1;
            interleaved=1;
        case '190218_B9';
            setElectrodes=[50 61 21 27 46;7 64 61 58 2];%151217_B8 & B9?
            setArrays=[16 16 16 8 15;16 16 16 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=77;
            visualOnly=1;
            interleaved=1;
        case '200218_B4';
            setElectrodes=[50 36 28 35 55;63 48 26 40 35];%151217_B8 & B9?
            setArrays=[12 12 12 13 11;15 13 13 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=1;
            interleaved=1;
        case '200218_B6';
            setElectrodes=[45 44 50 15 7;44 19 27 32 28];%151217_B8 & B9?
            setArrays=[8 8 8 15 15;8 8 8 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=1;
            interleaved=1;
        case '200218_B8';
            setElectrodes=[33 5 23 29 56;37 39 33 64 9];%151217_B8 & B9?
            setArrays=[12 12 12 12 13;16 12 12 9 9];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=1;
            interleaved=1;
        case '200218_B10';
            setElectrodes=[59 29 24 31 38;15 12 15 29 58];%151217_B8 & B9?
            setArrays=[14 14 12 13 13;16 16 14 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=78;
            visualOnly=1;
            interleaved=1;
        case '210218_B3';
            setElectrodes=[10 28 47 34 13;56 51 39 43 36];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;13 13 10 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=1;
            interleaved=1;
        case '210218_B5';
            setElectrodes=[27 33 49 51 55;49 31 52 46 51];%151217_B8 & B9?
            setArrays=[12 13 13 13 11;15 13 13 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=1;
            interleaved=1;
        case '210218_B7';
            setElectrodes=[46 32 15 22 3;32 53 47 58 59];%151217_B8 & B9?
            setArrays=[10 10 10 10 11;13 13 10 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=1;
            interleaved=1;
        case '210218_B9';
            setElectrodes=[40 44 12 28 31;63 61 47 58 4];%151217_B8 & B9?
            setArrays=[12 14 14 14 14;16 16 14 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=79;
            visualOnly=1;
            interleaved=1;
        case '220218_B3';
            setElectrodes=[39 45 47 54 32;15 53 12 29 59];%151217_B8 & B9?
            setArrays=[12 14 14 14 14;16 14 14 14 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=1;
            interleaved=1;
        case '220218_B5';
            setElectrodes=[17 58 13 20 30;22 63 13 21 44];%151217_B8 & B9?
            setArrays=[9 14 14 14 14;16 14 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=1;
            interleaved=1;
        case '220218_B7';
            setElectrodes=[39 63 30 40 63;50 27 32 29 33];%151217_B8 & B9?
            setArrays=[16 16 16 15 15;8 8 14 12 13];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=1;
            interleaved=1;
        case '220218_B9';
            setElectrodes=[21 29 48 22 38;20 63 22 20 52];%151217_B8 & B9?
            setArrays=[12 12 13 13 13;16 14 12 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=80;
            visualOnly=1;
            interleaved=1;
        case '230218_B4';
            setElectrodes=[40 47 56 24 21;22 52 38 29 57];%151217_B8 & B9?
            setArrays=[10 10 10 10 11;13 13 10 10 10];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=82;
            visualOnly=1;
            interleaved=1;
        case '230218_B6';
            setElectrodes=[43 62 21 20 18;38 55 56 62 34];%151217_B8 & B9?
            setArrays=[10 10 10 10 11;13 10 10 10 11];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=82;
            visualOnly=1;
            interleaved=1;
        case '260218_B5';
            setElectrodes=[41 13 22 23 12;35 34 48 47 1];%151217_B8 & B9?
            setArrays=[12 12 12 12 13;16 12 9 9 9];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=83;
            visualOnly=1;
            interleaved=1;
        case '260218_B9';
            setElectrodes=[34 42 26 58 60;57 43 40 6 1];%151217_B8 & B9?
            setArrays=[12 12 12 13 13;16 16 14 12 12];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=83;
            visualOnly=1;
            interleaved=1;
    end
end
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
%         instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6']; 
%         eyeDataMat=['D:\data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
%         if exist(eyeDataMat,'file')
%             load(eyeDataMat,'NSch');
%         else
%             if recordedRaw==0
%                 NSchOriginal=openNSx(instanceNS6FileName);
%                 for channelInd=1:length(eyeChannels)
%                     NSch{channelInd}=NSchOriginal.Data(channelInd,:);
%                 end
%             elseif recordedRaw==1
%                 for channelInd=1:length(eyeChannels)
%                     readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
%                     NSchOriginal=openNSx(instanceNS6FileName,readChannel);
%                     NSch{channelInd}=NSchOriginal.Data;
%                 end
%             end
%             save(eyeDataMat,'NSch');
%         end       
        
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
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                elseif find(trialEncodes==2^ErrorB)
                    perfNEV(trialNo)=-1;
                end
                if visualOnly==0
                    if interleaved==0%stimulation sent using trigger pulse from dasbit(microB,1)
                        if length(find(trialEncodes==2^MicroB))>=1
                            microstimTrialNEV(trialNo)=1;
                        end
                    elseif interleaved==1%stimulation sent using stimulator.play function
                        microstimTrialNEV(trialNo)=1;
                    end
                elseif visualOnly==1
                    if length(find(trialEncodes==2^StimB))==1
                        microstimTrialNEV(trialNo)=0;
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
        if visualOnly==1
            numTrialsPerBin=20;
        elseif visualOnly==0
            numTrialsPerBin=5;
        end
        for trialRespInd=1:totalRespTrials-numTrialsPerBin
            if length(micro)>=trialRespInd
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
           for electrodeCount=1:size(setElectrodes,2)
               for setInd=1:2
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
                   for electrodePairInd=1:size(electrodePairs,2)-1
                       electrode1=setElectrodes(setInd,electrodePairInd);
                       array1=setArrays(setInd,electrodePairInd);
                       electrode2=setElectrodes(setInd,electrodePairInd+1);
                       array2=setArrays(setInd,electrodePairInd+1);
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
               end
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
           title(['RF locations for line orientation task, ',date], 'Interpreter', 'none');
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
           set(gca, 'XTickLabel', {'left' 'right' 'up' 'down'})
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
        
%         figInd1=figure;hold on
        subplot(2,4,5:8);
        ylim([0 1]);
        initialPerfTrials=50;%first set of trials are the most important
        hold on
        plot(perfMicroTrialNo,perfMicroBin,'rx-');
        plot(perfVisualTrialNo,perfVisualBin,'bx-');
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
%         if ~isempty(perfMicroTrialNo)
%             if initialPerfTrials-numTrialsPerBin+1<=length(perfMicroTrialNo)
%                 firstTrialsM=perfMicroTrialNo(initialPerfTrials-numTrialsPerBin+1);
%                 plot([firstTrialsM firstTrialsM],[0 1],'r:');
%                 [pM hM statsM]=ranksum(perfMicroBin(1:50),0.5)
%                 [hM pM ciM statsM]=ttest(perfMicroBin(1:50),0.5)
%                 formattedpM=num2str(pM);
%                 formattedpM=formattedpM(2:end);
%                 text(xLimits(2)/11,0.14,'p','Color','r','FontAngle','italic');
%                 text(xLimits(2)/10,0.14,['= ',formattedpM],'Color','r');
%             end
%         end
        if ~isempty(perfVisualTrialNo)
            firstTrialsV=perfVisualTrialNo(initialPerfTrials-numTrialsPerBin+1);
            plot([firstTrialsV firstTrialsV],[0 1],'b:');
            if length(perfVisualBin)>=50
                [pV hV statsV]=ranksum(perfVisualBin(1:50),0.5)
                [hV pV ciV statsV]=ttest(perfVisualBin(1:50),0.5)
            else
                [pV hV statsV]=ranksum(perfVisualBin(1:end),0.5)
                [hV pV ciV statsV]=ttest(perfVisualBin(1:end),0.5)
            end
            formattedpV=num2str(pV);
            formattedpV=formattedpV(2:end);
            text(xLimits(2)/11,0.2,'p','Color','b','FontAngle','italic');
            text(xLimits(2)/10,0.2,['= ',formattedpV],'Color','b');
        end
        title(['performance across the session, on visual (blue) & microstim (red) trials, ',num2str(numTrialsPerBin),' trials/bin']);
        xlabel('trial number (across the session)');
        ylabel('performance'); 
        pathname=fullfile(rootdir,date,['behavioural_performance_RF_locations_',date]);
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
    end
end
pause=1;