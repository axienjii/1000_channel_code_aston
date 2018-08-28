function analyse_microstim_letter(date,allInstanceInd)
%7/3/18
%Written by Xing, modified from analyse_microstim_line.m, calculates behavioural performance during a
%microstimulation/visual 'letter' task.

interleaved=0;%set interleaved to 0, if trigger pulse was sent using microB. set interleaved to 1, if stimulation was sent by calling stimulator.play function
drummingOn=0;%for sessions after 9/4/18, drumming with only 2 targets was uesd 
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
        case '080318_B9'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=89;
            visualOnly=0;
        case '080318_B10'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=89;
            visualOnly=0;
        case '090318_B5'
            setElectrodes=[{[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=90;
            visualOnly=0;
        case '090318_B6'
            setElectrodes=[{[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=90;
            visualOnly=0;
        case '090318_B7'
            setElectrodes=[{[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=90;
            visualOnly=0;
        case '090318_B9'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=90;
            visualOnly=0;
        case '120318_B3'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=91;
            visualOnly=0;
        case '120318_B4'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=91;
            visualOnly=0;
        case '120318_B5'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=91;
            visualOnly=0;
        case '120318_B6'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=91;
            visualOnly=0;
        case '120318_B7'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=91;
            visualOnly=0;
        case '120318_B8'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=91;
            visualOnly=0;
        case '130318_B2'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=92;
            visualOnly=0;
        case '130318_B3'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=92;
            visualOnly=0;
        case '130318_B4'
            setElectrodes=[{[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=92;
            visualOnly=0;
        case '140318_B3'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=92;
            visualOnly=0;
        case '160318_B3'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=95;
            visualOnly=0;
        case '190318_B3'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=96;
            visualOnly=0;
        case '200318_B6'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=97;
            visualOnly=0;
        case '210318_B4'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=98;
            visualOnly=0;
        case '210318_B5'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=98;
            visualOnly=0;
        case '220318_B3'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=99;
            visualOnly=0;
        case '220318_B4'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=99;
            visualOnly=0;
        case '280318_B5'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=101;
            visualOnly=0;
        case '280318_B6'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=101;
            visualOnly=0;
        case '290318_B5'
            setElectrodes=[{[4 58 53 1 10 27 12 54 29 44]} {[16 7 4 32 1 16 20 20 2 12]} {[33 17 4 6 34 36 13 22 45 40]} {[46 4 45 14 50 2 44 10 27 28]}];%290118_B & B?
            setArrays=[{[16 16 16 8 8 8 16 14 14 12]} {[12 12 16 16 8 14 14 12 12 12]} {[12 9 16 16 16 16 14 12 14 14]} {[16 16 14 12 12 12 12 12 12 12]}];
            setInd=40;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=102;
            visualOnly=0;
        case '290318_B6'
            setElectrodes=[{[4 58 53 1 10 27 12 54 29 44]} {[16 7 4 32 1 16 20 20 2 12]} {[33 17 4 6 34 36 13 22 45 40]} {[46 4 45 14 50 2 44 10 27 28]}];%290118_B & B?
            setArrays=[{[16 16 16 8 8 8 16 14 14 12]} {[12 12 16 16 8 14 14 12 12 12]} {[12 9 16 16 16 16 14 12 14 14]} {[16 16 14 12 12 12 12 12 12 12]}];
            setInd=40;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=102;
            visualOnly=0;
        case '040418_B4'
            setElectrodes=[{[40 6 22 50 48 63 11 31 30 31]} {[20 49 46 1 53 43 42 34 56 58]} {[1 31 37 31 8 29 48 39 58 41]} {[27 60 24 59 56 34 9 42 44 51]}];%030418_B & B?
            setArrays=[{[16 16 8 8 15 15 8 14 12 10]} {[16 10 15 15 13 10 10 10 9 12]} {[10 10 12 14 15 15 13 10 10 13]} {[16 14 12 12 9 10 10 10 10 10]}];
            setInd=41;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=104;
            visualOnly=0;
        case '040418_B5'
            setElectrodes=[{[40 6 22 50 48 63 11 31 30 31]} {[20 49 46 1 53 43 42 34 56 58]} {[1 31 37 31 8 29 48 39 58 41]} {[27 60 24 59 56 34 9 42 44 51]}];%030418_B & B?
            setArrays=[{[16 16 8 8 15 15 8 14 12 10]} {[16 10 15 15 13 10 10 10 9 12]} {[10 10 12 14 15 15 13 10 10 13]} {[16 14 12 12 9 10 10 10 10 10]}];
            setInd=41;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=104;
            visualOnly=0;
        case '040418_B6'
            setElectrodes=[{[40 6 22 50 48 63 11 31 30 31]} {[20 49 46 1 53 43 42 34 56 58]} {[1 31 37 31 8 29 48 39 58 41]} {[27 60 24 59 56 34 9 42 44 51]}];%030418_B & B?
            setArrays=[{[16 16 8 8 15 15 8 14 12 10]} {[16 10 15 15 13 10 10 10 9 12]} {[10 10 12 14 15 15 13 10 10 13]} {[16 14 12 12 9 10 10 10 10 10]}];
            setInd=41;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=104;
            visualOnly=0;
        case '050418_B8'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=105;
            visualOnly=0;
        case '050418_B9'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=105;
            visualOnly=0;
        case '050418_B11'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=105;
            visualOnly=0;
        case '050418_B12'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=105;
            visualOnly=0;
        case '090418_B6'
            setElectrodes=[{[49 28 55 53 8 16 46 51 25 50]} {[27 20 8 6 21 34 25 36 30 40]} {[30 38 55 23 32 38 8 6 21 55]} {[32 37 53 55 48 64 61 21 23 3]}];%030418_B & B?
            setArrays=[{[13 13 13 13 11 11 10 10 10 10]} {[13 13 11 11 10 11 10 10 10 10]} {[10 10 13 13 13 13 11 11 10 10]} {[13 13 13 10 10 10 10 10 10 11]}];
            setInd=43;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=106;
            visualOnly=0;
        case '090418_B7'
            setElectrodes=[{[30 38 55 23 32 38 8 6 21 55]} {[32 37 53 55 48 64 61 21 23 3]}];%030418_B & B?
            setArrays=[{[10 10 13 13 13 13 11 11 10 10]} {[13 13 13 10 10 10 10 10 10 11]}];
            setInd=43;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=106;
            visualOnly=0;
        case '090418_B8'
            setElectrodes=[{[49 28 55 53 8 16 46 51 25 50]} {[27 20 8 6 21 34 25 36 30 40]}];%030418_B & B?
            setArrays=[{[13 13 13 13 11 11 10 10 10 10]} {[13 13 11 11 10 11 10 10 10 10]}];
            setInd=43;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=106;
            visualOnly=0;
        case '100418_B5'
            setElectrodes=[{[49 28 55 53 8 16 46 51 25 50]} {[27 20 8 6 21 34 25 36 30 40]} {[30 38 55 23 32 38 8 6 21 55]} {[32 37 53 55 48 64 61 21 23 3]}];%030418_B & B?
            setArrays=[{[13 13 13 13 11 11 10 10 10 10]} {[13 13 11 11 10 11 10 10 10 10]} {[10 10 13 13 13 13 11 11 10 10]} {[13 13 13 10 10 10 10 10 10 11]}];
            setInd=43;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=107;
            visualOnly=0;
            drummingOn=1;
        case '110418_B6'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=108;
            visualOnly=0;
            drummingOn=1;
        case '120418_B7'
            setElectrodes=[{[40 6 22 50 48 63 11 31 30 31]} {[20 49 46 1 53 43 42 34 56 58]} {[1 31 37 31 8 29 48 39 58 41]} {[27 60 24 59 56 34 9 42 44 51]}];%030418_B & B?
            setArrays=[{[16 16 8 8 15 15 8 14 12 10]} {[16 10 15 15 13 10 10 10 9 12]} {[10 10 12 14 15 15 13 10 10 13]} {[16 14 12 12 9 10 10 10 10 10]}];
            setInd=41;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=109;
            visualOnly=0;
            drummingOn=1;
        case '170418_B9'%next batch of new electrode combinations
            setElectrodes=[{[34 14 44 58 34 22 63 20 23 3]} {[39 10 7 16 41 12 42 43 31 23]}];%170418_B & B?
            setArrays=[{[12 12 14 16 16 16 14 14 12 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=44;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=110;
            visualOnly=0;
        case '170418_B10'
            setElectrodes=[{[9 46 24 22 62 11 36 40 5 43]} {[37 16 15 1 48 56 57 6 15 7]}];%170418_B & B?
            setArrays=[{[16 16 16 16 16 8 16 14 12 12]} {[16 16 16 8 14 12 12 12 12 12]}];
            setInd=44;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=110;
            visualOnly=0;
        case '180418_B8'
            setElectrodes=[{[12 6 61 56 55 27 48 30 3 13]} {[40 46 4 44 15 35 6 57 22 30]}];%180418_B & B?
            setArrays=[{[12 14 16 16 16 16 14 12 14 14]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=45;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=111;
            visualOnly=0;
        case '180418_B9'
            setElectrodes=[{[35 16 32 15 30 61 47 58 19 2]} {[39 50 23 22 16 20 24 60 42 14]}];%180418_B & B?
            setArrays=[{[16 16 16 16 16 16 14 14 12 12]} {[12 16 16 16 14 14 12 12 12 12]}];
            setInd=45;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=111;
            visualOnly=0;
        case '200418_B7'
            setElectrodes=[{[9 45 28 32 48 62 1 16 28 12]} {[6 16 19 45 14 18 11 56 64 29]}];%180418_B & B?
            setArrays=[{[12 14 16 16 16 16 8 14 12 14]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=46;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=112;
            visualOnly=0;
        case '200418_B8'
            setElectrodes=[{[40 6 48 22 43 53 63 13 21 61]} {[16 18 61 23 64 19 22 48 6 10]}];%180418_B & B?
            setArrays=[{[16 16 16 8 8 16 14 14 12 12]} {[12 12 12 12 14 8 8 16 16 16]}];
            setInd=46;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=112;
            visualOnly=0;
        case '230418_B6'
            setElectrodes=[{[2 5 5 59 45 27 31 29 47 49]} {[38 19 45 14 50 2 44 10 27 28]}];%180418_B & B?
            setArrays=[{[12 12 14 16 8 8 14 12 13 14]} {[16 16 14 12 12 12 12 12 12 12]}];
            setInd=47;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=113;
            visualOnly=0;
        case '230418_B7'
            setElectrodes=[{[39 38 34 56 52 50 21 54 29 44]} {[17 35 38 60 9 32 64 31 32 13]}];%180418_B & B?
            setArrays=[{[16 16 16 16 8 8 16 14 14 12]} {[9 16 16 16 8 14 12 12 12 12]}];
            setInd=47;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=113;
            visualOnly=0;
        case '250418_B4'
            setElectrodes=[{[64 13 58 36 15 30 28 64 33 21]} {[35 39 17 33 9 34 1 58 52 26]}];%180418_B & B?
            setArrays=[{[9 12 14 16 16 16 14 12 13 12]} {[16 12 9 12 12 12 12 12 12 12]}];
            setInd=48;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=114;
            visualOnly=0;
        case '250418_B5'
            setElectrodes=[{[3 44 64 55 9 27 59 12 20 52]} {[59 45 19 7 56 11 31 60 44 19]}];%180418_B & B?
            setArrays=[{[16 16 16 16 8 8 16 14 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=48;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=114;
            visualOnly=0;
        case '300418_B5'
            setElectrodes=[{[35 40 21 60 22 10 30 63 14 21]} {[23 11 7 6 59 13 19 60 24 63]}];%180418_B & B?
            setArrays=[{[12 14 16 16 8 8 14 12 13 14]} {[16 16 14 14 14 12 12 12 12 12]}];
            setInd=49;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=117;
            visualOnly=0;
        case '300418_B6'
            setElectrodes=[{[50 4 53 40 57 52 19 64 41 60]} {[48 22 12 13 29 61 25 33 41 34]}];%180418_B & B?
            setArrays=[{[12 14 16 8 8 8 8 14 13 14]} {[16 16 16 14 14 12 12 13 13 13]}];
            setInd=50;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=117;
            visualOnly=0;
        case '010518_B6'
            setElectrodes=[{[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
            setArrays=[{[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
            setInd=51;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=118;
            visualOnly=0;
        case '010518_B7'
            setElectrodes=[{[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]}];%010518_B & B
            setArrays=[{[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]}];
            setInd=52;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=118;
            visualOnly=0;
        case '020518_B6'
            setElectrodes=[{[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
            setArrays=[{[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
            setInd=53;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=119;
            visualOnly=0;
        case '020518_B7'
            setElectrodes=[{[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
            setArrays=[{[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
            setInd=54;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=119;
            visualOnly=0;
        case '030518_B9'
            setElectrodes=[{[48 15 39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
            setArrays=[{[9 12 14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
            setInd=55;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=120;
            visualOnly=0;
        case '030518_B17'
            setElectrodes=[{[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
            setArrays=[{[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
            setInd=56;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=120;
            visualOnly=0;
        case '070518_B5'
            setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
            setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
            setInd=57;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=122;
            visualOnly=0;
        case '070518_B6'
            setElectrodes=[{[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
            setArrays=[{[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
            setInd=58;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=122;
            visualOnly=0;
        case '080518_B6'
            setElectrodes=[{[27 19 20 46 11 44 34 5 42 25]} {[7 28 30 10 40 43 56 15 3 21]}];%010518_B & B
            setArrays=[{[9 12 12 14 8 8 13 10 10 12]} {[15 15 13 13 10 10 10 10 11 11]}];
            setInd=59;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=123;
            visualOnly=0;
        case '080518_B7'
            setElectrodes=[{[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
            setArrays=[{[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
            setInd=60;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=123;
            visualOnly=0;
        case '090518_B5'
            setElectrodes=[{[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]}];%010518_B & B
            setArrays=[{[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]}];
            setInd=61;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=124;
            visualOnly=0;
        case '090518_B6'
            setElectrodes=[{[28 49 62 63 7 8 61 20 35 55]} {[63 5 56 35 36 55 55 48 22 62]}];%010518_B & B
            setArrays=[{[10 13 15 15 15 11 10 10 13 13]} {[15 15 13 13 13 10 11 11 11 11]}];
            setInd=62;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=124;
            visualOnly=0;
        case '290518_B7'%15 electrodes per letter
            setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
            setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
            setInd=69;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=127;
            visualOnly=0;
        case '300518_B1'
            setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
            setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
            setInd=69;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=127;
            visualOnly=0;
        case '040618_B10'
            setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
            setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
            setInd=69;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=128;
            visualOnly=0;
        case '140618_B4'
            setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
            setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
            setInd=69;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=129;
            visualOnly=0;
        case '140618_B5'
            setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
            setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
            setInd=70;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=129;
            visualOnly=0;
        case '140618_B7'
            setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
            setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
            setInd=70;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=129;
            visualOnly=0;
        case '180618_B7'
            setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
            setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
            setInd=71;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=130;
            visualOnly=0;
            
        %visual task only:
        case '060318_B3'
            setElectrodes=[{[39 64 30 19 55 3 41 6 20 23]} {[44 39 58 15 30 27 32 30 10 19]} {[39 37 39 17 41 34 6 11 20 23]} {[41 33 44 39 58 64 12 63 21 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[16 16 12 9 12 12 12 12 12 12]} {[12 12 14 14 16 16 16 14 14 12]}];
            setInd=34;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=87;
            visualOnly=1;
        case '070318_B2'
            setElectrodes=[{[39 38 34 56 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 30 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 16 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=35;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=87;
            visualOnly=1;
        case '070318_B5'
            setElectrodes=[{[39 38 34 56 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 16 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=36;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=87;
            visualOnly=1;
        case '070318_B6'
            setElectrodes=[{[39 38 34 56 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 16 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=36;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=87;
            visualOnly=1;
        case '070318_B7'
            setElectrodes=[{[39 38 34 56 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 16 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=36;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=87;
            visualOnly=1;
        case '070318_B8'
            setElectrodes=[{[39 38 34 56 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 16 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=36;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=87;
            visualOnly=1;
        case '070318_B9'
            setElectrodes=[{[39 38 34 56 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 16 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=36;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=87;
            visualOnly=1;
        case '080318_B7'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=89;
            visualOnly=1;
        case '080318_B8'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=89;
            visualOnly=1;
        case '090318_B2'
            setElectrodes=[{[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=90;
            visualOnly=1;
        case '090318_B8'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=37;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=90;
            visualOnly=1;
        case '150318_B4'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=94;
            visualOnly=1;
        case '150318_B5'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=94;
            visualOnly=1;
        case '150318_B6'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=94;
            visualOnly=1;
        case '160318_B2'
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%0118_B & B?
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
            setInd=37;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=95;
            visualOnly=1;
        case '200318_B5'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=97;
            visualOnly=1;
        case '210318_B2'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=98;
            visualOnly=1;
        case '220318_B2'
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=38;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=99;
            visualOnly=1;
        case '230318_B4'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '230318_B5'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '260318_B2'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '260318_B6'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '260318_B7'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '260318_B9'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '270318_B2'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '270318_B4'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;%only two targets per trial
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '270318_B5'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=100;
            visualOnly=1;
        case '280318_B2'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=101;
            visualOnly=1;
        case '280318_B4'
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=39;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=101;
            visualOnly=1;
        case '290318_B2'
            setElectrodes=[{[4 58 53 1 10 27 12 54 29 44]} {[16 7 4 32 1 16 20 20 2 12]} {[33 17 4 6 34 36 13 22 45 40]} {[46 4 45 14 50 2 44 10 27 28]}];%290118_B & B?
            setArrays=[{[16 16 16 8 8 8 16 14 14 12]} {[12 12 16 16 8 14 14 12 12 12]} {[12 9 16 16 16 16 14 12 14 14]} {[16 16 14 12 12 12 12 12 12 12]}];
            setInd=40;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=101;
            visualOnly=1;
        case '290318_B4'
            setElectrodes=[{[4 58 53 1 10 27 12 54 29 44]} {[16 7 4 32 1 16 20 20 2 12]} {[33 17 4 6 34 36 13 22 45 40]} {[46 4 45 14 50 2 44 10 27 28]}];%290118_B & B?
            setArrays=[{[16 16 16 8 8 8 16 14 14 12]} {[12 12 16 16 8 14 14 12 12 12]} {[12 9 16 16 16 16 14 12 14 14]} {[16 16 14 12 12 12 12 12 12 12]}];
            setInd=40;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=102;
            visualOnly=1;
        case '030418_B8'
            setElectrodes=[{[40 6 22 50 48 63 11 31 30 31]} {[20 49 46 1 53 43 42 34 56 58]} {[1 31 37 31 8 29 48 39 58 41]} {[27 60 24 59 56 34 9 42 44 51]}];%030418_B & B?
            setArrays=[{[16 16 8 8 15 15 8 14 12 10]} {[16 10 15 15 13 10 10 10 9 12]} {[10 10 12 14 15 15 13 10 10 13]} {[16 14 12 12 9 10 10 10 10 10]}];
            setInd=41;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=102;
            visualOnly=1;
        case '040418_B2'
            setElectrodes=[{[40 6 22 50 48 63 11 31 30 31]} {[20 49 46 1 53 43 42 34 56 58]} {[1 31 37 31 8 29 48 39 58 41]} {[27 60 24 59 56 34 9 42 44 51]}];%030418_B & B?
            setArrays=[{[16 16 8 8 15 15 8 14 12 10]} {[16 10 15 15 13 10 10 10 9 12]} {[10 10 12 14 15 15 13 10 10 13]} {[16 14 12 12 9 10 10 10 10 10]}];
            setInd=41;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=104;
            visualOnly=1;
        case '050418_B5'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=105;
            visualOnly=1;
        case '050418_B7'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=105;
            visualOnly=1;
        case '090418_B2'
            setElectrodes=[{[49 28 55 53 8 16 46 51 25 50]} {[27 20 8 6 21 34 25 36 30 40]} {[30 38 55 23 32 38 8 6 21 55]} {[32 37 53 55 48 64 61 21 23 3]}];%030418_B & B?
            setArrays=[{[13 13 13 13 11 11 10 10 10 10]} {[13 13 11 11 10 11 10 10 10 10]} {[10 10 13 13 13 13 11 11 10 10]} {[13 13 13 10 10 10 10 10 10 11]}];
            setInd=43;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=106;
            visualOnly=1;
        case '110418_B4'
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
            setInd=42;
            numTargets=4;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=108;
            visualOnly=1;
        case '170418_B8'%next batch of new electrode combinations
            setElectrodes=[{[34 14 44 58 34 22 63 20 23 3]} {[39 10 7 16 41 12 42 43 31 23]}];%170418_B & B?
            setArrays=[{[12 12 14 16 16 16 14 14 12 14]} {[16 16 12 12 12 12 12 12 12 12]}];
            setInd=44;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=110;
            visualOnly=1;
        case '170418_B7'
            setElectrodes=[{[9 46 24 22 62 11 36 40 5 43]} {[37 16 15 1 48 56 57 6 15 7]}];%170418_B & B?
            setArrays=[{[16 16 16 16 16 8 16 14 12 12]} {[16 16 16 8 14 12 12 12 12 12]}];
            setInd=44;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=110;
            visualOnly=1;
        case '180418_B6'
            setElectrodes=[{[12 6 61 56 55 27 48 30 3 13]} {[40 46 4 44 15 35 6 57 22 30]}];%180418_B & B?
            setArrays=[{[12 14 16 16 16 16 14 12 14 14]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=45;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=111;
            visualOnly=1;
        case '180418_B4'
            setElectrodes=[{[35 16 32 15 30 61 47 58 19 2]} {[39 50 23 22 16 20 24 60 42 14]}];%180418_B & B?
            setArrays=[{[16 16 16 16 16 16 14 14 12 12]} {[12 16 16 16 14 14 12 12 12 12]}];
            setInd=45;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=111;
            visualOnly=1;
        case '200418_B6'
            setElectrodes=[{[9 45 28 32 48 62 1 16 28 12]} {[6 16 19 45 14 18 11 56 64 29]}];%180418_B & B?
            setArrays=[{[12 14 16 16 16 16 8 14 12 14]} {[16 16 16 14 12 12 12 12 12 12]}];
            setInd=46;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=112;
            visualOnly=1;
        case '200418_B5'
            setElectrodes=[{[40 6 48 22 43 53 63 13 21 61]} {[16 18 61 23 64 19 22 48 6 10]}];%180418_B & B?
            setArrays=[{[16 16 16 8 8 16 14 14 12 12]} {[12 12 12 12 14 8 8 16 16 16]}];
            setInd=46;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=112;
            visualOnly=1;
        case '230418_B5'
            setElectrodes=[{[2 5 5 59 45 27 31 29 47 49]} {[38 19 45 14 50 2 44 10 27 28]}];%180418_B & B?
            setArrays=[{[12 12 14 16 8 8 14 12 13 14]} {[16 16 14 12 12 12 12 12 12 12]}];
            setInd=47;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=113;
            visualOnly=1;
        case '230418_B4'
            setElectrodes=[{[39 38 34 56 52 50 21 54 29 44]} {[17 35 38 60 9 32 64 31 32 13]}];%180418_B & B?
            setArrays=[{[16 16 16 16 8 8 16 14 14 12]} {[9 16 16 16 8 14 12 12 12 12]}];
            setInd=47;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=113;
            visualOnly=1;
        case '240418_B6'
            setElectrodes=[{[64 13 58 36 15 30 28 64 33 21]} {[35 39 17 33 9 34 1 58 52 26]}];%180418_B & B?
            setArrays=[{[9 12 14 16 16 16 14 12 13 12]} {[16 12 9 12 12 12 12 12 12 12]}];
            setInd=48;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=114;
            visualOnly=1;
        case '240418_B4'
            setElectrodes=[{[3 44 64 55 9 27 59 12 20 52]} {[59 45 19 7 56 11 31 60 44 19]}];%180418_B & B?
            setArrays=[{[16 16 16 16 8 8 16 14 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
            setInd=48;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=114;
            visualOnly=1;
        case '250418_B8'
            setElectrodes=[{[35 40 21 60 22 10 30 63 14 21]} {[23 11 7 6 59 13 19 60 24 63]}];%180418_B & B?
            setArrays=[{[12 14 16 16 8 8 14 12 13 14]} {[16 16 14 14 14 12 12 12 12 12]}];
            setInd=49;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=117;
            visualOnly=1;
        case '260418_B5'
            setElectrodes=[{[50 4 53 40 57 52 19 64 41 60]} {[48 22 12 13 29 61 25 33 41 34]}];%180418_B & B?
            setArrays=[{[12 14 16 8 8 8 8 14 13 14]} {[16 16 16 14 14 12 12 13 13 13]}];
            setInd=50;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=117;
            visualOnly=1;
        case '010518_B2'
            setElectrodes=[{[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
            setArrays=[{[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
            setInd=51;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=118;
            visualOnly=1;
        case '010518_B4'
            setElectrodes=[{[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]}];%010518_B & B
            setArrays=[{[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]}];
            setInd=52;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=118;
            visualOnly=1;
        case '020518_B4'
            setElectrodes=[{[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
            setArrays=[{[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
            setInd=53;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=119;
            visualOnly=1;
        case '020518_B3'
            setElectrodes=[{[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
            setArrays=[{[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
            setInd=54;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=119;
            visualOnly=1;
        case '030518_B8'
            setElectrodes=[{[48 15 39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
            setArrays=[{[9 12 14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
            setInd=55;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=120;
            visualOnly=1;
        case '030518_B7'
            setElectrodes=[{[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
            setArrays=[{[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
            setInd=56;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=120;
            visualOnly=1;
        case '040518_B2'
            setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
            setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
            setInd=57;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=122;
            visualOnly=1;
        case '070518_B2'
            setElectrodes=[{[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
            setArrays=[{[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
            setInd=58;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=122;
            visualOnly=1;
        case '080518_B3'
            setElectrodes=[{[27 19 20 46 11 44 34 5 42 25]} {[7 28 30 10 40 43 56 15 3 21]}];%010518_B & B
            setArrays=[{[9 12 12 14 8 8 13 10 10 12]} {[15 15 13 13 10 10 10 10 11 11]}];
            setInd=59;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=123;
            visualOnly=1;
        case '080518_B4'
            setElectrodes=[{[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
            setArrays=[{[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
            setInd=60;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=123;
            visualOnly=1;
        case '090518_B2'
            setElectrodes=[{[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]}];%010518_B & B
            setArrays=[{[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]}];
            setInd=61;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=124;
            visualOnly=1;
        case '090518_B4'
            setElectrodes=[{[28 49 62 63 7 8 61 20 35 55]} {[63 5 56 35 36 55 55 48 22 62]}];%010518_B & B
            setArrays=[{[10 13 15 15 15 11 10 10 13 13]} {[15 15 13 13 13 10 11 11 11 11]}];
            setInd=62;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=124;
            visualOnly=1;
        case '290518_B5'%15 electrodes per letter, coloured dots
            setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
            setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
            setInd=69;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=127;
            visualOnly=1;
        case '040618_B6'%coloured dots
            setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
            setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
            setInd=69;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=127;
            visualOnly=1;
        case '040618_B7'%black dots
            setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
            setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
            setInd=69;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=127;
            visualOnly=1;
        case '070618_B4'%coloured dots
            setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
            setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
            setInd=70;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=128;
            visualOnly=1;
        case '070618_B7'%black dots
            setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
            setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
            setInd=70;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=128;
            visualOnly=1;
        case '070618_B5'%coloured dots
            setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
            setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
            setInd=70;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=128;
            visualOnly=1;
        case '070618_B6'%black dots
            setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
            setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
            setInd=70;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=128;
            visualOnly=1;
        case '180618_B3'%coloured dots
            setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
            setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
            setInd=71;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=130;
            visualOnly=1;
        case '180618_B5'%black dots
            setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
            setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
            setInd=71;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=130;
            visualOnly=1;

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
        if drummingOn==1
            notDrummingTrials=find(allDrummingTrials==0);
            correctTrialsInd=intersect(correctTrialsInd,notDrummingTrials);
            incorrectTrialsInd=intersect(incorrectTrialsInd,notDrummingTrials);
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
            figure;
            uniqueResponsesTally={};
            uniqueBehavResponses={};
            total=zeros(1,length(setElectrodes));
            allTargetLocation=[];
            for trialInd=1:length(allElectrodeNum)
                for setNo=1:numTargets
                    if isequal(allElectrodeNum{trialInd}(:),setElectrodes{setNo}(:))
                        allTargetLocation(trialInd)=setNo;
                    end
                end
            end
            for setNo=1:length(setElectrodes)
                condInds{setNo}=find(allTargetLocation==setNo);
                corrIndsM{setNo}=intersect(condInds{setNo},correctMicrostimTrialsInd);
                incorrIndsM{setNo}=intersect(condInds{setNo},incorrectMicrostimTrialsInd);
                perfM(setNo)=length(corrIndsM{setNo})/(length(corrIndsM{setNo})+length(incorrIndsM{setNo}));
                corrIndsV{setNo}=intersect(condInds{setNo},correctVisualTrialsInd);
                incorrIndsV{setNo}=intersect(condInds{setNo},incorrectVisualTrialsInd);
                perfV(setNo)=length(corrIndsV{setNo})/(length(corrIndsV{setNo})+length(incorrIndsV{setNo}));
                if numTargets==4
                    letterLocations=double('LRTB');
                    if setInd==37
                        letters='I   O   A   L';
                    elseif setInd>=38
                        letters='T   O   A   L';
                    end
                elseif numTargets==2
                    if LRorTB==1
                        letterLocations=double('LR');
                        if setInd==37
                            letters='I   O';
                        elseif setInd>=38
                            letters='T   O';
                        end
                    elseif LRorTB==2
                        letterLocations=double('TB');
                        letters='A   L';
                    end
                end
                for responseInd=1:length(letterLocations)%tally number of incorrect trials (does not include correct trials)
                    temp1=find(behavResponse==letterLocations(responseInd));
                    temp2=intersect(temp1,condInds{setNo});
                    uniqueResponsesTally{setNo}(responseInd)=length(temp2);
                    total(setNo)=total(setNo)+uniqueResponsesTally{setNo}(responseInd);
                end
                if visualOnly==1
                    uniqueResponsesTally{setNo}(responseInd)=length(corrIndsV{setNo});%tally number of correct trials
                    total(setNo)=total(setNo)+length(corrIndsV{setNo});
                elseif visualOnly==0
                    uniqueResponsesTally{setNo}(responseInd)=length(corrIndsM{setNo});%tally number of correct trials
                    total(setNo)=total(setNo)+length(corrIndsM{setNo});
                end
%                 correctResponsesV{setNo}=behavResponse(corrIndsV{setNo});
%                 incorrectResponsesV{setNo}=behavResponse(incorrIndsV{setNo});
%                 uniqueBehavResponses{setNo}=unique(incorrectResponsesV{setNo})
%                 uniqueReponses=[];
%                 for uniqueReponseInd=1:length(uniqueBehavResponses{setNo})
%                     uniqueResponses=find(incorrectResponsesV{setNo}==uniqueBehavResponses{setNo}(uniqueReponseInd));
%                     uniqueResponsesTally{setNo}(uniqueReponseInd)=length(uniqueResponses);
%                     total(setNo)=total(setNo)+uniqueResponsesTally{setNo}(uniqueReponseInd);
%                 end
            end
            if numTargets==4
                b=bar([uniqueResponsesTally{1}(1)/total(1) uniqueResponsesTally{1}(2)/total(1) uniqueResponsesTally{1}(3)/total(1) uniqueResponsesTally{1}(4)/total(1);uniqueResponsesTally{2}(1)/total(2) uniqueResponsesTally{2}(2)/total(2) uniqueResponsesTally{2}(3)/total(2) uniqueResponsesTally{2}(4)/total(2);uniqueResponsesTally{3}(1)/total(3) uniqueResponsesTally{3}(2)/total(3) uniqueResponsesTally{3}(3)/total(3) uniqueResponsesTally{3}(4)/total(3);uniqueResponsesTally{4}(1)/total(4) uniqueResponsesTally{4}(2)/total(4) uniqueResponsesTally{4}(3)/total(4) uniqueResponsesTally{4}(4)/total(4)],'FaceColor','flat');
            elseif numTargets==2
                b=bar([uniqueResponsesTally{1}(1)/total(1) uniqueResponsesTally{1}(2)/total(1);uniqueResponsesTally{2}(1)/total(2) uniqueResponsesTally{2}(2)/total(2)],'FaceColor','flat');
            end
            b(1).FaceColor = 'flat';
            b(2).FaceColor = 'flat';
            if numTargets==4
                b(3).FaceColor = 'flat';
                b(4).FaceColor = 'flat';
            end
%             b(1).FaceColor = [0 0.4470 0.7410];
%             b(2).FaceColor = [1 0 0];
            set(gca, 'XTick',1:numTargets)
            if numTargets==4
                set(gca, 'XTickLabel', {[letters;letters;letters;letters]})
            elseif numTargets==2
                set(gca, 'XTickLabel', {[letters;letters]})
            end
%             set(gca, 'XTickLabel', {[char(uniqueBehavResponses{1}(2)) char(uniqueBehavResponses{1}(3)) char(uniqueBehavResponses{1}(4))] [char(uniqueBehavResponses{2}(2)) char(uniqueBehavResponses{2}(3)) char(uniqueBehavResponses{2}(4))] [char(uniqueBehavResponses{3}(2)) char(uniqueBehavResponses{3}(3)) char(uniqueBehavResponses{3}(4))] [char(uniqueBehavResponses{4}(2)) char(uniqueBehavResponses{4}(3)) char(uniqueBehavResponses{4}(4))]})
            xLimits=get(gca,'xlim');
            hold on
            plot([xLimits(1) xLimits(2)],[1/(numTargets) 1/(numTargets)],'k:');
            ylim([0 1])
            if numTargets==4
                xlim([0.5 4.5])
            elseif numTargets==2
                xlim([0.5 2.5])
            end
            title('proportion of responses to various targets');
            xlabel('target selected');
            ylabel('proportion of trials for a given (correct target) condition');
            pathname=fullfile(rootdir,date,['confusion_matrix_',date]);
%             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            print(pathname,'-dtiff');

            figure;
            for setNo=1:length(setElectrodes)
                if setNo<=2
                    subplot(4,8,setNo*2-1:setNo*2);
                elseif setNo>2
                    subplot(4,8,setNo*2+3:setNo*2+4);
                end
                for electrodeCount=1:length(setElectrodes{setNo})
                    electrode=setElectrodes{setNo}(electrodeCount);
                    array=setArrays{setNo}(electrodeCount);
                    load([dataDir,'\array',num2str(array),'.mat']);
                    electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode);%matching channel number
                    electrodeIndtemp2=find(goodArrays8to16(:,7)==array);%matching array number
                    electrodeInd=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                    RFx=goodArrays8to16(electrodeInd,1);
                    RFy=goodArrays8to16(electrodeInd,2);
                    plot(RFx,RFy,'o','Color',cols(array-7,:),'MarkerFaceColor',cols(array-7,:));hold on
                    currentThreshold=goodCurrentThresholds(electrodeInd);
%                     if electrodeCount==1
%                         text(RFx-28,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
%                         text(RFx-28,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
%                     else
%                         text(RFx+4,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
%                         text(RFx+4,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
%                     end
                    for electrodePairInd=1:size(electrodePairs,2)-1
                        electrode1=setElectrodes{setNo}(electrodePairInd);
                        array1=setArrays{setNo}(electrodePairInd);
                        electrode2=setElectrodes{setNo}(electrodePairInd+1);
                        array2=setArrays{setNo}(electrodePairInd+1);
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
                if setNo==1
                    title([' RF locations, ',date,' letter task'], 'Interpreter', 'none');
                end
            end
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
            if numTargets==4
                b=bar([perfV(1) perfM(1);perfV(2) perfM(2);perfV(3) perfM(3);perfV(4) perfM(4)],'FaceColor','flat');
            elseif numTargets==2
                b=bar([perfV(1) perfM(1);perfV(2) perfM(2)],'FaceColor','flat');
            end
            b(1).FaceColor = 'flat';
            b(2).FaceColor = 'flat';
            b(1).FaceColor = [0 0.4470 0.7410];
            b(2).FaceColor = [1 0 0];
            set(gca, 'XTick',1:numTargets)
            if numTargets==4
                set(gca, 'XTickLabel', {['left, ',allLetters(1)] ['right, ',allLetters(2)] ['up, ',allLetters(3)] ['down, ',allLetters(4)]})
            elseif numTargets==2
                if LRorTB==1
                    set(gca, 'XTickLabel', {['left, ',allLetters(1)] ['right, ',allLetters(2)]})
                elseif LRorTB==1
                    set(gca, 'XTickLabel', {['up, ',allLetters(3)] ['down, ',allLetters(4)]})
                end
            end
            xLimits=get(gca,'xlim');
            for setNo=1:length(setElectrodes)
                if ~isnan(perfV(setNo))
                    txt=sprintf('%.2f',perfV(setNo));
                    text(setNo-0.3,0.95,txt,'Color','b')
                end
                if ~isnan(perfM(setNo))
                    txt=sprintf('%.2f',perfM(setNo));
                    text(setNo,0.95,txt,'Color','r')
                end
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
        if ~isempty(perfMicroBin)&&~isempty(perfVisualBin)
            subplot(4,4,9:12);
            ylim([0 1]);
            initialPerfTrials=50;%first set of trials are the most important
            hold on
            plot(perfMicroTrialNo,perfMicroBin,'rx-');
            xLimits=get(gca,'xlim');
            plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
            subplot(4,4,13:16);
            ylim([0 1]);
            plot(perfVisualTrialNo,perfVisualBin,'bx-');
            hold on
            xLimits=get(gca,'xlim');
            plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
        else
            subplot(2,4,5:8);
            ylim([0 1]);
            initialPerfTrials=50;%first set of trials are the most important
            hold on
            plot(perfMicroTrialNo,perfMicroBin,'rx-');
            plot(perfVisualTrialNo,perfVisualBin,'bx-');
            xLimits=get(gca,'xlim');
            plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
    end
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
%             text(xLimits(2)/11,0.2,'p','Color','b','FontAngle','italic');
%             text(xLimits(2)/10,0.2,['= ',formattedpV],'Color','b');
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