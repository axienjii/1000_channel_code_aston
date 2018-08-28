function analyse_microstim_letter_eye(date,allInstanceInd)
%7/3/18
%Written by Xing, modified from analyse_microstim_letter.m, extracts eye data during a
%microstimulation/visual 'letter' task.
%Used on sessoin 220318_B4: analyse_microstim_letter_eye('220318_B4',1)

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

stimDurms=167;%in ms- min 0, max 500
preStimDur=300/1000;
stimDur=stimDurms/1000;%in seconds
postStimDur=600/1000;%length of post-stimulus-offset period, in s
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
            eyeChannels=[130 131];
        end
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
        eyeDataMat=['D:\data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
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
        figure;
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
                    stimOnInd=find(trialEncodes==2^MicroB);
                    if length(stimOnInd)>1
                        stimOnInd=stimOnInd(end);
                    end                    
                    if trialNo>1
                        trialEncodesStimOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+stimOnInd);
                    else
                        trialEncodesStimOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo)+stimOnInd);
                    end
                    targOnInd=find(trialEncodes==2^TargetB);
                    if length(targOnInd)>1
                        temp=find(targOnInd==stimOnInd+1);
                        if ~isempty(temp)
                            targOnInd=targOnInd(temp);
                        else
                            targOnInd=targOnInd(end);
                        end
                    end
                    if trialNo>1
                        trialEncodesTargOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+targOnInd);
                    else
                        trialEncodesTargOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo)+targOnInd);
                    end
%                     interval(trialNo)=trialEncodesTargOn(trialNo)-trialEncodesStimOn(trialNo);
%                     eyeDataX{trialNo}=NSch{1}(trialEncodesStimOn(trialNo):trialEncodesTargOn(trialNo));
%                     eyeDataY{trialNo}=NSch{2}(trialEncodesStimOn(trialNo):trialEncodesTargOn(trialNo));
                    eyeDataX{trialNo}=NSch{1}(trialEncodesTargOn(trialNo)-1.067*sampFreq:trialEncodesTargOn(trialNo)+400/1000*sampFreq);
                    eyeDataY{trialNo}=NSch{2}(trialEncodesTargOn(trialNo)-1.067*sampFreq:trialEncodesTargOn(trialNo)+400/1000*sampFreq);
%                     eyeDataX{trialNo}=NSch{1}(trialEncodesStimOn(trialNo)-preStimDur*sampFreq:trialEncodesStimOn(trialNo)+1167/1000*sampFreq);
%                     eyeDataY{trialNo}=NSch{2}(trialEncodesStimOn(trialNo)-preStimDur*sampFreq:trialEncodesStimOn(trialNo)+1167/1000*sampFreq);
                    subplot(2,1,1);
                    plot(eyeDataX{trialNo});
                    hold on
                    ax=gca;
                    ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
                    ax.XTickLabel={'-300','0','167','767'};
                    subplot(2,1,2);
                    plot(eyeDataY{trialNo});
                    hold on
                    ax=gca;
                    ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
                    ax.XTickLabel={'-300','0','167','767'};
                else
                    eyeDataX{trialNo}=[];
                    eyeDataY{trialNo}=[];
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
        goodTrialsInd=find(~cellfun(@isempty,eyeDataX));
        targetLocationsFinal=allTargetLocation(goodTrialsInd);
        eyeDataXFinal=eyeDataX(goodTrialsInd);
        eyeDataYFinal=eyeDataY(goodTrialsInd);
        perfNEVFinal=perfNEV(goodTrialsInd);
        figure
        for trialIndFinal=1:length(targetLocationsFinal)
            if perfNEVFinal(trialIndFinal)==1
                subplot(2,4,targetLocationsFinal(trialIndFinal));
                plot(eyeDataXFinal{trialIndFinal});
                hold on
                subplot(2,4,targetLocationsFinal(trialIndFinal)+4);
                plot(eyeDataYFinal{trialIndFinal});
                hold on
            end
        end
        allX=cell(1,4);
        allY=cell(1,4);
        for targetInd=1:4
            figure
            targetLocTrials=find(targetLocationsFinal==targetInd);
%             length(targetLocTrials)
            for targetLocTrialInd=1:length(targetLocTrials)
                if perfNEVFinal(targetLocTrials(targetLocTrialInd))==1
                    subplot(2,1,1);
                    plot(eyeDataXFinal{targetLocTrials(targetLocTrialInd)});
                    hold on
                    subplot(2,1,2);
                    plot(eyeDataYFinal{targetLocTrials(targetLocTrialInd)});
                    hold on
                    allX{targetInd}=[allX{targetInd} eyeDataXFinal{targetLocTrials(targetLocTrialInd)}(34700)-eyeDataXFinal{targetLocTrials(targetLocTrialInd)}(17980)];
                    allY{targetInd}=[allY{targetInd} eyeDataYFinal{targetLocTrials(targetLocTrialInd)}(34700)-eyeDataYFinal{targetLocTrials(targetLocTrialInd)}(17980)];
                end
            end
            subplot(2,1,1);
            ax=gca;
            ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
            ax.XTickLabel={'-300','0','167','767'};
            subplot(2,1,2);
            ax=gca;
            ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
            ax.XTickLabel={'-300','0','167','767'};
        end
        trimmean(allX{1},95);
        trimmean(allX{2},95);
        trimmean(allY{3},95);
        trimmean(allY{4},95);
        save([rootdir,date,'\eye_data.mat'],'eyeDataXFinal','eyeDataYFinal','perfNEVFinal','targetLocationsFinal','setElectrodes','setArrays');
        
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
                    elseif setInd==38||setInd==39||setInd==40||setInd==41||setInd==42||setInd==43
                        letters='T   O   A   L';
                    end
                elseif numTargets==2
                    if LRorTB==1
                        letterLocations=double('LR');
                        if setInd==37
                            letters='I   O';
                        elseif setInd==38||setInd==39||setInd==40||setInd==41||setInd==42||setInd==43
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
                    uniqueResponsesTally{setNo}(setNo)=length(corrIndsV{setNo});%tally number of correct trials
                    total(setNo)=total(setNo)+length(corrIndsV{setNo});
                elseif visualOnly==0
                    uniqueResponsesTally{setNo}(setNo)=length(corrIndsM{setNo});%tally number of correct trials
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
                    if electrodeCount==1
                        text(RFx-28,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                        text(RFx-28,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                    else
                        text(RFx+4,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                        text(RFx+4,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                    end
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
        print(pathname,'-dtiff');
    end
end
pause=1;