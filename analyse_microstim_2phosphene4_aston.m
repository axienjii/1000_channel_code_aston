function analyse_microstim_2phosphene4(date,allInstanceInd)
%29/9/17
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual 2-phosphene task.
%Sends 3 encodes for microB (two for the 'fake' stimulation triggers, and 1
%for the real stimulation trigger).

localDisk=0;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
dataDir=[rootdir,date,'\',date,'_data'];
if ~exist('dataDir','dir')
    copyfile(['Z:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);    
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
analyseConds2=1;
if analyseConds==1
    switch(date)
        case '031017_B11'
            setElectrodes=[50 55 37 51;25 8 63 42];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10;12 10 15 13];
            setInd=1;
            numTargets=2;
            visualOnly=0;
        case '031017_B13'
            setElectrodes=[50 55 37 51;25 8 63 42];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10;12 10 15 13];
            setInd=1;
            numTargets=4;
            visualOnly=0;
        case '091017_B13'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=5;
            visualOnly=0;
        case '091017_B15'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 4;2 4];
            currentThresholdChs=5;
            visualOnly=0;
        case '091017_B16'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 4;2 4;1 2;3 4];
            currentThresholdChs=5;
            visualOnly=0;
        case '091017_B17'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=4;
            electrodePairs=[1 4;2 4;1 2;3 4];
            currentThresholdChs=5;
            visualOnly=0;
        case '101017_B40'
            setElectrodes=[49 8 37 51;46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 15 8 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=5;
            visualOnly=0;
        case '101017_B42'
            setElectrodes=[49 8 37 51;46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 15 8 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 4;2 4];
            currentThresholdChs=6;
            visualOnly=0;
        case '111017_B10'
            setElectrodes=[49 8 37 51;50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 8 14 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=7;
            visualOnly=0;
        case '111017_B11'
            setElectrodes=[49 8 37 51;50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 8 14 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=8;
            visualOnly=0;
        case '111017_B14'
            setElectrodes=[49 8 37 51;50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 8 14 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 4;2 4];
            currentThresholdChs=8;
            visualOnly=0;
        case '131017_B9'
            setElectrodes=[49 8 37 51;45 32 50 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;14 14 8 13];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=10;
            visualOnly=0;
        case '181017_B21'
            setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=11;
            visualOnly=0;
        case '181017_B28'
            setElectrodes=[46 21 49 57];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 11 15 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=12;
            visualOnly=0;
        case '191017_B33'
            setElectrodes=[30 18 12 29];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=13;
            visualOnly=0;
        case '191017_B35'
            setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=14;
            visualOnly=0;
        case '191017_B37'
            setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=15;
            visualOnly=0;
        case '191017_B39'
            setElectrodes=[3 22 34 42];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=16;
            visualOnly=0;
        case '191017_B41'
            setElectrodes=[45 18 56 29];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=17;
            visualOnly=0;
        case '201017_B28'
            setElectrodes=[26 60 48 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=19;
            visualOnly=0;
        case '201017_B30'
            setElectrodes=[27 51 11 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=20;
            visualOnly=0;
        case '231017_B11'
            setElectrodes=[25 35 45 37];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 8 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=21;
            visualOnly=0;
        case '231017_B39'
            setElectrodes=[52 52 48 47];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=22;
            visualOnly=0;
        case '231017_B43'
            setElectrodes=[18 47 43 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 8 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=24;
            visualOnly=0;
        case '231017_B42'
            setElectrodes=[12 23 45 50];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=22;
            visualOnly=0;
        case '231017_B45'
            setElectrodes=[10 55 19 30];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 8 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=25;
            visualOnly=0;
        case '231017_B49'
            setElectrodes=[35 22 40 41];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=26;
            visualOnly=0;
        case '241017_B17'
            setElectrodes=[46 19 44 18];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 8 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=28;
            visualOnly=0;
        case '241017_B46'
            setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=29;
            visualOnly=0;
        case '241017_B49'
            setElectrodes=[43 55 55 50];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=30;
            visualOnly=0;
        case '241017_B51'
            setElectrodes=[27 50 15 58];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=31;
            visualOnly=0;
        case '241017_B54'
            setElectrodes=[38 55 44 27];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 8 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=32;
            visualOnly=0;
        case '241017_B56'
            setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=33;
            visualOnly=0;
        case '241017_B58'
            setElectrodes=[39 62 40 13];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=34;
            visualOnly=0;
        case '241017_B59'
            setElectrodes=[28 53 62 49;27 50 15 58;41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13;12 13 15 13;12 12 16 12];
            setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[27 50 15 58];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=34;
            visualOnly=0;
        case '241017_B60'
            setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[27 50 15 58];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=34;
            visualOnly=0;
        case '251017_B19'
            setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[27 50 15 34];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
%             setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
%             setArrays=[12 12 16 12];
%             setElectrodes=[38 62 15 49];%first row: set 1, LRTB; second row: set 2, LRTB
%             setArrays=[16 15 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=35;
            visualOnly=0;
        case '251017_B51'
            setElectrodes=[29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 10];
            setElectrodes=[46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 8 12];
            setElectrodes=[50 55 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 11 14 12];%replaced second electrode (e27 on a8) with that from set 5
            setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=36;
            visualOnly=0;
        case '251017_B52'
            setElectrodes=[29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 10];
            setElectrodes=[46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 8 12];
            setElectrodes=[50 55 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 11 14 12];%replaced second electrode (e27 on a8) with that from set 5
            setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 13 10];
            setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[27 50 15 34];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 16 12];
            setElectrodes=[38 62 15 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=36;
            visualOnly=0;
            
            %visual task only:
        case '091017_B7'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=4;
            electrodePairs=[1 4;2 4;1 2;3 4];
            currentThresholdChs=5;
            visualOnly=1;
        case '091017_B14'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=4;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=5;
            visualOnly=1;
        case '101017_B39'
            setElectrodes=[49 8 37 51;46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 15 8 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=5;
            visualOnly=1;
        case '101017_B41'
            setElectrodes=[49 8 37 51;46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 15 8 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 4;2 4];
            currentThresholdChs=5;
            visualOnly=1;
        case '111017_B1'
            setElectrodes=[49 8 37 51;50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 8 14 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=7;
            visualOnly=1;
        case '111017_B13'
            setElectrodes=[49 8 37 51;50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;16 8 14 12];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 4;2 4];
            currentThresholdChs=7;
            visualOnly=1;
        case '131017_B1'
            setElectrodes=[49 8 37 51;45 32 50 33];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;14 14 8 13];
            setInd=2;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=10;
            visualOnly=1;
        case '181017_B18'
            setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=11;
            visualOnly=1;
        case '181017_B27'
            setElectrodes=[46 21 49 57];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 11 15 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=12;
            visualOnly=1;
        case '191017_B29'
            setElectrodes=[30 18 12 29];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=13;
            visualOnly=1;
        case '191017_B34'
            setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=14;
            visualOnly=1;
        case '191017_B36'
            setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=15;
            visualOnly=1;
        case '191017_B38'
            setElectrodes=[3 22 34 42];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=16;
            visualOnly=1;
        case '191017_B40'
            setElectrodes=[45 18 56 29];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 11 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=17;
            visualOnly=1;
        case '201017_B27'
            setElectrodes=[26 60 48 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=19;
            visualOnly=1;
        case '201017_B29'
            setElectrodes=[27 51 11 43];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=20;
            visualOnly=1;
        case '231017_B10'
            setElectrodes=[25 35 45 37];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 8 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=21;
            visualOnly=1;
        case '231017_B38'
            setElectrodes=[52 52 48 47];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=22;
            visualOnly=1;
        case '231017_B40'
            setElectrodes=[18 47 43 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 8 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=23;
            visualOnly=1;
        case '231017_B41'
            setElectrodes=[12 23 45 50];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=24;
            visualOnly=1;
        case '231017_B44'
            setElectrodes=[10 55 19 30];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 8 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=25;
            visualOnly=1;
        case '231017_B48'
            setElectrodes=[35 22 40 41];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=26;
            visualOnly=1;
        case '241017_B15'
            setElectrodes=[46 19 44 18];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 8 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=28;
            visualOnly=1;
        case '241017_B44'
            setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=29;
            visualOnly=1;
        case '241017_B48'
            setElectrodes=[43 55 55 50];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=30;
            visualOnly=1;
        case '241017_B50'
            setElectrodes=[27 50 15 58];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=31;
            visualOnly=1;
        case '241017_B53'
            setElectrodes=[38 55 44 27];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 8 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=32;
            visualOnly=1;
        case '241017_B55'
            setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 12 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=33;
            visualOnly=1;
        case '241017_B57'
            setElectrodes=[39 62 40 13];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 16 12];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=34;
            visualOnly=1;
        case '251017_B15'
            setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
            setElectrodes=[27 50 15 34];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 13];
%             setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
%             setArrays=[12 12 16 12];
%             setElectrodes=[38 62 15 49];%first row: set 1, LRTB; second row: set 2, LRTB
%             setArrays=[16 15 15 13];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=35;
            visualOnly=1;
        case '251017_B48'
            setElectrodes=[29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[12 13 15 10];
            setElectrodes=[46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 15 8 12];
            setElectrodes=[50 55 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[16 11 14 12];%replaced second electrode (e27 on a8) with that from set 5
            setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[10 10 13 10];
            setInd=1;
            numTargets=2;
            electrodePairs=[1 2;3 4];
            currentThresholdChs=36;
            visualOnly=1;
            
    end
end
load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
    
processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
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
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                elseif find(trialEncodes==2^ErrorB)
                    perfNEV(trialNo)=-1;
                end
                if visualOnly==0
                    if length(find(trialEncodes==2^MicroB))==3
                        microstimTrialNEV(trialNo)=1;
                    end
                elseif visualOnly==1
                    if length(find(trialEncodes==2^MicroB))==2
                        microstimTrialNEV(trialNo)=1;
                    else
                        microstimTrialNEV(trialNo)=0;
                    end
                end
                %analyse individual conditions:
                if analyseConds2==1&&length(allElectrodeNum)>=trialNo
                    electrode=allElectrodeNum(trialNo);
                    array=allArrayNum(trialNo);
                    electrode2=allElectrodeNum2(trialNo);
                    array2=allArrayNum2(trialNo);
                    electrodeMatch=find(setElectrodes(setInd,:)==electrode);
                    arrayMatch=find(setArrays(setInd,:)==array);
                    matchingCh=intersect(electrodeMatch,arrayMatch);%one electrode of a pair
                    electrodeMatch2=find(setElectrodes(setInd,:)==electrode2);
                    arrayMatch2=find(setArrays(setInd,:)==array2);
                    matchingCh2=intersect(electrodeMatch2,arrayMatch2);%the other electrode of a pair
                    if isequal(sort([matchingCh matchingCh2]),[1 2])
                        LRorTB=2;
                        targetLocation=1;
                    elseif isequal(sort([matchingCh matchingCh2]),[3 4])
                        LRorTB=2;
                        targetLocation=2;
                    elseif isequal(sort([matchingCh matchingCh2]),[1 4])
                        LRorTB=1;
                        targetLocation=1;
                    elseif isequal(sort([matchingCh matchingCh2]),[2 4])
                        LRorTB=1;
                        targetLocation=2;
                    end
                    allLRorTB(trialNo)=LRorTB;
                    allTargetLocation(trialNo)=targetLocation;
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
        numTrialsPerBin=5;
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
           leftPerfV=0;leftPerfM=0;rightPerfV=0;rightPerfM=0;
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
        
%         figInd1=figure;hold on
        subplot(2,4,5:8);
        ylim([0 1]);
        initialPerfTrials=50;%first set of trials are the most important
        hold on
        plot(perfMicroTrialNo,perfMicroBin,'rx-');
        plot(perfVisualTrialNo,perfVisualBin,'bx-');
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
        if ~isempty(perfMicroTrialNo)
            firstTrialsM=perfMicroTrialNo(initialPerfTrials-numTrialsPerBin+1);
            plot([firstTrialsM firstTrialsM],[0 1],'r:');
            [pM hM statsM]=ranksum(perfMicroBin(1:50),0.5)
            [hM pM ciM statsM]=ttest(perfMicroBin(1:50),0.5)
            formattedpM=num2str(pM);
            formattedpM=formattedpM(2:end);
            text(xLimits(2)/11,0.14,'p','Color','r','FontAngle','italic');
            text(xLimits(2)/10,0.14,['= ',formattedpM],'Color','r');
            topPerfM
            bottomPerfM
        end
        if ~isempty(perfVisualTrialNo)
            firstTrialsV=perfVisualTrialNo(initialPerfTrials-numTrialsPerBin+1);
            plot([firstTrialsV firstTrialsV],[0 1],'b:');
            [pV hV statsV]=ranksum(perfVisualBin(1:50),0.5)
            [hV pV ciV statsV]=ttest(perfVisualBin(1:50),0.5)
            formattedpV=num2str(pV);
            formattedpV=formattedpV(2:end);
            text(xLimits(2)/11,0.2,'p','Color','b','FontAngle','italic');
            text(xLimits(2)/10,0.2,['= ',formattedpV],'Color','b');
            topPerfV
            bottomPerfM
        end
        title(['performance across the session, on visual (blue) & microstim (red) trials, ',num2str(numTrialsPerBin),' trials/bin']);
        xlabel('trial number (across the session)');
        ylabel('performance'); 
        pathname=fullfile(rootdir,date,['behavioural_performance_RF_locations_',date]);
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         print(pathname,'-dtiff');
    end
end
pause=1;

% switch(date)%manually compiled results
%     case '251017_B52'%Z=3.52, p<.001
%     allPerfM=[7887,6667;6250,8261;7778,6792;7079,8056;8621,6979;8286,6182;7143,7708;5333,7627]/10000;
% end
% figure;hold on%plot mean performance across electrode sets (excluding control)
% if visualOnly==0
%     perfPlot=allPerfM;
% else
%     perfPlot=allPerfV;
% end
% bar(1,mean(perfPlot(:,1)))
% errorbar(1,mean(perfPlot(:,1)),std(perfPlot(:,1)))
% bar(2,mean(perfPlot(:,2)))
% errorbar(2,mean(perfPlot(:,2)),std(perfPlot(:,2)))
% ylim([0 1])
% set(gca,'XTick',[1 2]);
% set(gca,'XTickLabels',[{'vertical'} {'horizontal'}]);
% plot([0 2.5],[0.5 0.5],'k--');
% xlabel('target')
% ylabel('mean performance')
% title(['performance across ',num2str(size(perfPlot,1)),' sets, error 1 SD'])
% tempPerf=perfPlot(1:size(perfPlot,1),1:2);
% tempPerf=tempPerf(:);
% [p,h,stats]=signrank(tempPerf,0.5)%for 160518_B3, Z=2.70, p=.007. for 150518_B8, Z=4.57, p<.001
