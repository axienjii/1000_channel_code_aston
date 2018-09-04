function analyse_microstim_letter_across_sessions(date)
%27/2/18
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual line orientation task, for lines composed of 5 phosphenes.
%Current amplitude was equal to 2.5 times the current threshold value (as
%opposed to 1.5 times the threshold value).
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
allSetsPerfMicroBin=[];
allSetsPerfVisualBin=[];
analyseConds=0;
for calculateVisual=[0 1]
    for setNo=[1:6 9 17:24 26 28:29]%1:29%[1:11 13:26 28:29]%1:24 for 10 electrodes per letter; subsequent sessions use 15 electrodes per letter
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
                case 1
                    date='170418_B9';%next batch of new electrode combinations
                    setElectrodes=[{[34 14 44 58 34 22 63 20 23 3]} {[39 10 7 16 41 12 42 43 31 23]}];%170418_B & B?
                    setArrays=[{[12 12 14 16 16 16 14 14 12 14]} {[16 16 12 12 12 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=0;
                case 2
                    date='170418_B10';
                    setElectrodes=[{[9 46 24 22 62 11 36 40 5 43]} {[37 16 15 1 48 56 57 6 15 7]}];%170418_B & B?
                    setArrays=[{[16 16 16 16 16 8 16 14 12 12]} {[16 16 16 8 14 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=0;
                case 3
                    date='180418_B8';
                    setElectrodes=[{[12 6 61 56 55 27 48 30 3 13]} {[40 46 4 44 15 35 6 57 22 30]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 14 12 14 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=0;
                case 4
                    date='180418_B9';
                    setElectrodes=[{[35 16 32 15 30 61 47 58 19 2]} {[39 50 23 22 16 20 24 60 42 14]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 16 16 14 14 12 12]} {[12 16 16 16 14 14 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=0;
                case 5
                    date='200418_B7';
                    setElectrodes=[{[9 45 28 32 48 62 1 16 28 12]} {[6 16 19 45 14 18 11 56 64 29]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 8 14 12 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=0;
                case 6
                    date='200418_B8';
                    setElectrodes=[{[40 6 48 22 43 53 63 13 21 61]} {[16 18 61 23 64 19 22 48 6 10]}];%180418_B & B?
                    setArrays=[{[16 16 16 8 8 16 14 14 12 12]} {[12 12 12 12 14 8 8 16 16 16]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=0;
                case 7
                    date='230418_B6';
                    setElectrodes=[{[2 5 5 59 45 27 31 29 47 49]} {[38 19 45 14 50 2 44 10 27 28]}];%180418_B & B?
                    setArrays=[{[12 12 14 16 8 8 14 12 13 14]} {[16 16 14 12 12 12 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=0;
                case 8
                    date='230418_B7';
                    setElectrodes=[{[39 38 34 56 52 50 21 54 29 44]} {[17 35 38 60 9 32 64 31 32 13]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 14 12]} {[9 16 16 16 8 14 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=0;
                case 9
                    date='250418_B4';
                    setElectrodes=[{[64 13 58 36 15 30 28 64 33 21]} {[35 39 17 33 9 34 1 58 52 26]}];%180418_B & B?
                    setArrays=[{[9 12 14 16 16 16 14 12 13 12]} {[16 12 9 12 12 12 12 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=0;
                case 10
                    date='250418_B5';
                    setElectrodes=[{[3 44 64 55 9 27 59 12 20 52]} {[59 45 19 7 56 11 31 60 44 19]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=0;
                case 11
                    date='300418_B5';
                    setElectrodes=[{[35 40 21 60 22 10 30 63 14 21]} {[23 11 7 6 59 13 19 60 24 63]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 8 8 14 12 13 14]} {[16 16 14 14 14 12 12 12 12 12]}];
                    setInd=49;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=0;
                case 12
                    date='300418_B6';
                    setElectrodes=[{[50 4 53 40 57 52 19 64 41 60]} {[48 22 12 13 29 61 25 33 41 34]}];%180418_B & B?
                    setArrays=[{[12 14 16 8 8 8 8 14 13 14]} {[16 16 16 14 14 12 12 13 13 13]}];
                    setInd=50;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=0;
                case 13
                    date='010518_B6';
                    setElectrodes=[{[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
                    setArrays=[{[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=51;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=0;
                case 14
                    date='010518_B7';
                    setElectrodes=[{[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]}];
                    setInd=52;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=0;
                case 15
                    date='020518_B6';
                    setElectrodes=[{[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
                    setArrays=[{[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
                    setInd=53;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=0;
                case 16
                    date='020518_B7';
                    setElectrodes=[{[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
                    setInd=54;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=0;
                case 17
                    date='030518_B9';
                    setElectrodes=[{[48 15 39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
                    setArrays=[{[9 12 14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=55;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=0;
                case 18
                    date='030518_B17';
                    setElectrodes=[{[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
                    setInd=56;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=0;
                case 19
                    date='070518_B5';
                    setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
                    setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
                    setInd=57;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=0;
                case 20
                    date='070518_B6';
                    setElectrodes=[{[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
                    setArrays=[{[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
                    setInd=58;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=0;
                case 21
                    date='080518_B6';
                    setElectrodes=[{[27 19 20 46 11 44 34 5 42 25]} {[7 28 30 10 40 43 56 15 3 21]}];%010518_B & B
                    setArrays=[{[9 12 12 14 8 8 13 10 10 12]} {[15 15 13 13 10 10 10 10 11 11]}];
                    setInd=59;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=0;
                case 22
                    date='080518_B7';
                    setElectrodes=[{[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
                    setArrays=[{[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
                    setInd=60;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=0;
                case 23
                    date='090518_B5';
                    setElectrodes=[{[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]}];%010518_B & B
                    setArrays=[{[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]}];
                    setInd=61;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=0;
                case 24
                    date='090518_B6';
                    setElectrodes=[{[28 49 62 63 7 8 61 20 35 55]} {[63 5 56 35 36 55 55 48 22 62]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 11 10 10 13 13]} {[15 15 13 13 13 10 11 11 11 11]}];
                    setInd=62;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=0;
                case 25
                    date='290518_B7';%15 electrodes per letter
                    setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=127;
                    visualOnly=0;
%                 case 25
%                     date='300518_B1';
%                     setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
%                     setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
%                     setInd=69;
%                     numTargets=2;
%                     electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
%                     currentThresholdChs=127;
%                     visualOnly=0;
                case 26
                    date='040618_B10';
                    setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=128;
                    visualOnly=0;
%                 case 26
%                     date='140618_B4';
%                     setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
%                     setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
%                     setInd=69;
%                     numTargets=2;
%                     electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
%                     currentThresholdChs=129;
%                     visualOnly=0;
                case 27
                    date='140618_B5';
                    setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
                    setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=129;
                    visualOnly=0;
                case 28
                    date='140618_B7';
                    setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
                    setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=129;
                    visualOnly=0;
                case 29%setInd 71
                    date='180618_B7';
                    setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
                    setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
                    setInd=71;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=130;
                    visualOnly=0;
                    localDisk=1;
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='170418_B8';%next batch of new electrode combinations
                    setElectrodes=[{[34 14 44 58 34 22 63 20 23 3]} {[39 10 7 16 41 12 42 43 31 23]}];%170418_B & B?
                    setArrays=[{[12 12 14 16 16 16 14 14 12 14]} {[16 16 12 12 12 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=1;
                case 2
                    date='170418_B7';
                    setElectrodes=[{[9 46 24 22 62 11 36 40 5 43]} {[37 16 15 1 48 56 57 6 15 7]}];%170418_B & B?
                    setArrays=[{[16 16 16 16 16 8 16 14 12 12]} {[16 16 16 8 14 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=1;
                case 3
                    date='180418_B6';
                    setElectrodes=[{[12 6 61 56 55 27 48 30 3 13]} {[40 46 4 44 15 35 6 57 22 30]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 14 12 14 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=1;
                case 4
                    date='180418_B4';
                    setElectrodes=[{[35 16 32 15 30 61 47 58 19 2]} {[39 50 23 22 16 20 24 60 42 14]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 16 16 14 14 12 12]} {[12 16 16 16 14 14 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=1;
                case 5
                    date='200418_B6';
                    setElectrodes=[{[9 45 28 32 48 62 1 16 28 12]} {[6 16 19 45 14 18 11 56 64 29]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 8 14 12 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=1;
                case 6
                    date='200418_B5';
                    setElectrodes=[{[40 6 48 22 43 53 63 13 21 61]} {[16 18 61 23 64 19 22 48 6 10]}];%180418_B & B?
                    setArrays=[{[16 16 16 8 8 16 14 14 12 12]} {[12 12 12 12 14 8 8 16 16 16]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=1;
                case 7
                    date='230418_B5';
                    setElectrodes=[{[2 5 5 59 45 27 31 29 47 49]} {[38 19 45 14 50 2 44 10 27 28]}];%180418_B & B?
                    setArrays=[{[12 12 14 16 8 8 14 12 13 14]} {[16 16 14 12 12 12 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=1;
                case 8
                    date='230418_B4';
                    setElectrodes=[{[39 38 34 56 52 50 21 54 29 44]} {[17 35 38 60 9 32 64 31 32 13]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 14 12]} {[9 16 16 16 8 14 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=1;
                case 9
                    date='240418_B6';
                    setElectrodes=[{[64 13 58 36 15 30 28 64 33 21]} {[35 39 17 33 9 34 1 58 52 26]}];%180418_B & B?
                    setArrays=[{[9 12 14 16 16 16 14 12 13 12]} {[16 12 9 12 12 12 12 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=1;
                case 10
                    date='240418_B4';
                    setElectrodes=[{[3 44 64 55 9 27 59 12 20 52]} {[59 45 19 7 56 11 31 60 44 19]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=1;
                case 11
                    date='250418_B8';
                    setElectrodes=[{[35 40 21 60 22 10 30 63 14 21]} {[23 11 7 6 59 13 19 60 24 63]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 8 8 14 12 13 14]} {[16 16 14 14 14 12 12 12 12 12]}];
                    setInd=49;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=1;
                case 12
                    date='260418_B5';
                    setElectrodes=[{[50 4 53 40 57 52 19 64 41 60]} {[48 22 12 13 29 61 25 33 41 34]}];%180418_B & B?
                    setArrays=[{[12 14 16 8 8 8 8 14 13 14]} {[16 16 16 14 14 12 12 13 13 13]}];
                    setInd=50;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=1;
                case 13
                    date='010518_B2';
                    setElectrodes=[{[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
                    setArrays=[{[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=51;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=1;
                case 14
                    date='010518_B4';
                    setElectrodes=[{[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]}];
                    setInd=52;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=1;
                case 15
                    date='020518_B4';
                    setElectrodes=[{[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
                    setArrays=[{[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
                    setInd=53;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=1;
                case 16
                    date='020518_B3';
                    setElectrodes=[{[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
                    setInd=54;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=1;
                case 17
                    date='030518_B8';
                    setElectrodes=[{[48 15 39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
                    setArrays=[{[9 12 14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=55;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=1;
                case 18
                    date='030518_B7';
                    setElectrodes=[{[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
                    setInd=56;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=1;
                case 19
                    date='040518_B2';
                    setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
                    setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
                    setInd=57;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=1;
                case 20
                    date='070518_B2';
                    setElectrodes=[{[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
                    setArrays=[{[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
                    setInd=58;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=1;
                case 21
                    date='080518_B3';
                    setElectrodes=[{[27 19 20 46 11 44 34 5 42 25]} {[7 28 30 10 40 43 56 15 3 21]}];%010518_B & B
                    setArrays=[{[9 12 12 14 8 8 13 10 10 12]} {[15 15 13 13 10 10 10 10 11 11]}];
                    setInd=59;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=1;
                case 22
                    date='080518_B4';
                    setElectrodes=[{[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
                    setArrays=[{[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
                    setInd=60;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=1;
                case 23
                    date='090518_B2';
                    setElectrodes=[{[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]}];%010518_B & B
                    setArrays=[{[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]}];
                    setInd=61;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=1;
                case 24
                    date='090518_B4';
                    setElectrodes=[{[28 49 62 63 7 8 61 20 35 55]} {[63 5 56 35 36 55 55 48 22 62]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 11 10 10 13 13]} {[15 15 13 13 13 10 11 11 11 11]}];
                    setInd=62;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=1;
                case 25
                    date='290518_B5';%15 electrodes per letter, coloured dots
                    setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=127;
                    visualOnly=1;
                    %         case 26
                    %                     date='040618_B6';%coloured dots
                    %             setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
                    %             setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
                    %             setInd=69;
                    %             numTargets=2;
                    %             electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    %             currentThresholdChs=127;
                    %             visualOnly=1;
                case 26
                    date='040618_B7';%black dots
                    setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=127;
                    visualOnly=1;
                    %                 case 27
                    %                     date='070618_B4';%coloured dots
                    %             setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
                    %             setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
                    %             setInd=70;
                    %             numTargets=2;
                    %             electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    %             currentThresholdChs=128;
                    %             visualOnly=1;
                case 27
                    date='070618_B7';%black dots
                    setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
                    setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=128;
                    visualOnly=1;
                    %         case 28
                    %                     date='070618_B5';%coloured dots
                    %             setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
                    %             setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
                    %             setInd=70;
                    %             numTargets=2;
                    %             electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    %             currentThresholdChs=128;
                    %             visualOnly=1;
                case 28
                    date='070618_B6';%black dots
                    setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
                    setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=128;
                    visualOnly=1;
%                 case 29%setInd 71
%                     date='180618_B3';%coloured dots
%                     setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
%                     setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
%                     setInd=71;
%                     numTargets=2;
%                     electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
%                     currentThresholdChs=130;
%                     visualOnly=1;
                case 29
                    date='180618_B5';%black dots
                    setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
                    setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
                    setInd=71;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=130;
                    visualOnly=1;
                    localDisk=1;
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
                initialPerfTrials=100;%first set of trials are the most important
                if calculateVisual==0
                    perfMicroBin=perfMicroBin(1:initialPerfTrials);
                    if ~isempty(perfMicroBin)
                        allSetsPerfMicroBin=[allSetsPerfMicroBin;perfMicroBin];
                        save(['D:\microPerf_',date,'.mat'],'perfMicroBin');
                    end
                elseif calculateVisual==1
                    perfVisualBin=perfVisualBin(1:initialPerfTrials);
                    %perfVisualBin=perfVisualBin(end-initialPerfTrials+1:end);
                    if ~isempty(perfVisualBin)
                        allSetsPerfVisualBin=[allSetsPerfVisualBin;perfVisualBin];
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
                    title(['RF locations for letter task, ',date], 'Interpreter', 'none');
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
pathname=['D:\data\letter_behavioural_performance_all_sets_',date,'_',num2str(initialPerfTrials),'trials'];
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff');

perfMat=['D:\data\letter_behavioural_performance_all_sets_',date,'_',num2str(initialPerfTrials),'trials.mat'];
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