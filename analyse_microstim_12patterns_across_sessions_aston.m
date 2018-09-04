function analyse_microstim_12patterns_across_sessions(date)
%22/12/17
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual line orientation task, with 12 possible
%stimulation conditions.
%Output is saved in .mat file, 220118_2phosphene_cortical_coords_perf.mat,
%which is combined with 040118_2phosphene_cortical_coords_perf.mat (from
%analyse_microstim_2phosphene_RFs_across_sessions)
%and further processed by the function
%analyse_2phosphene_correlation_cortical_distance.m. 
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

for calculateVisual=[0 1]
    allSetsPerfMicro=[];
    allSetsPerfVisual=[];
    for setNo=1:22
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
                    date='120118_B5';
                case 2
                    date='120118_B7';
                case 3
                    date='120118_B9';
                case 4
                    date='150118_B3';
                case 5
                    date='150118_B5';
                case 6
                    date='150118_B7';
                case 7
                    date='150118_B9';
                case 8
                    date='150118_B11';
                case 9
                    date='160118_B6';
                case 10
                    date='160118_B8';
                case 11
                    date='160118_B10';
                case 12
                    date='160118_B12';
                case 13
                    date='160118_B14';
                case 14
                    date='180118_B12';
                case 15
                    date='180118_B14';
                case 16
                    date='180118_B16';
                case 17
                    date='180118_B18';
                case 18
                    date='180118_B20';
                case 19
                    date='190118_B9';
                case 20
                    date='190118_B11';
                case 21
                    date='190118_B13';
                case 22
                    date='190118_B15';
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='120118_B2';
                case 2
                    date='120118_B6';
                case 3
                    date='120118_B8';
                case 4
                    date='150118_B2';
                case 5
                    date='150118_B4';
                case 6
                    date='150118_B6';
                case 7
                    date='150118_B8';
                case 8
                    date='150118_B10';
                case 9
                    date='160118_B5';
                case 10
                    date='160118_B7';
                case 11
                    date='160118_B9';
                case 12
                    date='160118_B11';
                case 13
                    date='160118_B13';
                case 14
                    date='180118_B11';
                case 15
                    date='180118_B13';
                case 16
                    date='180118_B15';
                case 17
                    date='180118_B17';
                case 18
                    date='180118_B19';
                case 19
                    date='190118_B5';
                case 20
                    date='190118_B10';
                case 21
                    date='190118_B12';
                case 22
                    date='190118_B14';
            end
        end
        
        if localDisk==1
            rootdir='D:\data\';
        elseif localDisk==0
            rootdir='X:\best\';
        end
        matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
        dataDir=[rootdir,date,'\',date,'_data'];
        if ~exist('dataDir','dir')
            copyfile([rootdir,date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
        end
        load(matFile);
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='120118_B5';
                    setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%040118_B & B?
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=63;
                    visualOnly=0;
                    interleaved=0;
                case 2
                    date='120118_B7';
                    setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%040118_B & B?
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=63;
                    visualOnly=0;
                    interleaved=0;
                case 3
                    date='120118_B9';
                    setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=63;
                    visualOnly=0;
                    interleaved=0;
                case 4
                    date='150118_B3';
                    setElectrodes=[{[]} {[]} {[40 44 12 28 31]} {[63 61 47 58 43]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 14 14 14 14]} {[16 16 14 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 5
                    date='150118_B5';
                    setElectrodes=[{[]} {[]} {[39 45 47 54 32]} {[15 53 12 29 59]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 14 14 14 14]} {[16 14 14 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 6
                    date='150118_B7';
                    setElectrodes=[{[]} {[]} {[17 58 13 20 30]} {[22 63 13 21 44]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[9 14 14 14 14]} {[16 14 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 7
                    date='150118_B9';
                    setElectrodes=[{[]} {[]} {[39 63 30 40 63]} {[50 27 32 29 33]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[16 16 16 15 15]} {[8 8 14 12 13]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 8
                    date='150118_B11';
                    setElectrodes=[{[]} {[]} {[21 29 48 22 38]} {[20 63 22 20 52]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 14 12 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 9
                    date='160118_B6';
                    setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 10
                    date='160118_B8';
                    setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 11
                    date='160118_B10';
                    setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 12
                    date='160118_B12';
                    setElectrodes=[{[]} {[]} {[27 33 49 51 55]} {[49 31 52 46 51]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 13 13 13 11]} {[15 13 13 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 13
                    date='160118_B14';
                    setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 14
                    date='180118_B12';
                    setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%151217_B4 & B5
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 15
                    date='180118_B14';
                    setElectrodes=[{[]} {[]} {[50 61 21 27 46]} {[7 64 61 58 2]}];%151217_B6 & B7?
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 16 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 16
                    date='180118_B16';
                    setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%151217_B8 & B9?
                    setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 17
                    date='180118_B18';
                    setElectrodes=[{[]} {[]} {[50 36 28 35 55]} {[63 48 26 40 35]}];%151217_B10 & B11?
                    setArrays=[{[]} {[]} {[12 12 12 13 11]} {[15 13 13 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 18
                    date='180118_B20';
                    setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%181217_B11 & B12
                    setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 19
                    date='190118_B9';
                    setElectrodes=[{[]} {[]} {[2 57 47 61 53]} {[22 27 13 21 61]}];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
                case 20
                    date='190118_B11';
                    setElectrodes=[{[]} {[]} {[43 62 21 20 18]} {[38 55 56 62 34]}];%040118_B21 & B23?
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 10 10 10 11]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
                case 21
                    date='190118_B13';
                    setElectrodes=[{[]} {[]} {[34 42 0 41 60]} {[57 43 0 6 1]}];%190118_B & B?
                    setArrays=[{[]} {[]} {[12 12 0 13 13]} {[16 16 0 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
                case 22
                    date='190118_B15';
                    setElectrodes=[{[]} {[]} {[42 45 0 20 18]} {[12 38 0 29 57]}];%190118_B & B?
                    setArrays=[{[]} {[]} {[10 10 0 10 11]} {[13 10 0 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='120118_B2';
                    setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%040118_B & B?
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=63;
                    visualOnly=0;
                    interleaved=0;
                case 2
                    date='120118_B6';
                    setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%040118_B & B?
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=63;
                    visualOnly=0;
                    interleaved=0;
                case 3
                    date='120118_B8';
                    setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=63;
                    visualOnly=0;
                    interleaved=0;
                case 4
                    date='150118_B2';
                    setElectrodes=[{[]} {[]} {[40 44 12 28 31]} {[63 61 47 58 43]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 14 14 14 14]} {[16 16 14 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 5
                    date='150118_B4';
                    setElectrodes=[{[]} {[]} {[39 45 47 54 32]} {[15 53 12 29 59]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 14 14 14 14]} {[16 14 14 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 6
                    date='150118_B6';
                    setElectrodes=[{[]} {[]} {[17 58 13 20 30]} {[22 63 13 21 44]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[9 14 14 14 14]} {[16 14 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 7
                    date='150118_B8';
                    setElectrodes=[{[]} {[]} {[39 63 30 40 63]} {[50 27 32 29 33]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[16 16 16 15 15]} {[8 8 14 12 13]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 8
                    date='150118_B10';
                    setElectrodes=[{[]} {[]} {[21 29 48 22 38]} {[20 63 22 20 52]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 14 12 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=64;
                    visualOnly=0;
                    interleaved=0;
                case 9
                    date='160118_B5';
                    setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 10
                    date='160118_B7';
                    setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 11
                    date='160118_B9';
                    setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 12
                    date='160118_B11';
                    setElectrodes=[{[]} {[]} {[27 33 49 51 55]} {[49 31 52 46 51]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[12 13 13 13 11]} {[15 13 13 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 13
                    date='160118_B13';
                    setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%040118_B17 & B19
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=65;
                    visualOnly=0;
                    interleaved=0;
                case 14
                    date='180118_B11';
                    setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%151217_B4 & B5
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 15
                    date='180118_B13';
                    setElectrodes=[{[]} {[]} {[50 61 21 27 46]} {[7 64 61 58 2]}];%151217_B6 & B7?
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 16 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 16
                    date='180118_B15';
                    setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%151217_B8 & B9?
                    setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 17
                    date='180118_B17';
                    setElectrodes=[{[]} {[]} {[50 36 28 35 55]} {[63 48 26 40 35]}];%151217_B10 & B11?
                    setArrays=[{[]} {[]} {[12 12 12 13 11]} {[15 13 13 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 18
                    date='180118_B19';
                    setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%181217_B11 & B12
                    setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=66;
                    visualOnly=0;
                    interleaved=0;
                case 19
                    date='190118_B5';
                    setElectrodes=[{[]} {[]} {[2 57 47 61 53]} {[22 27 13 21 61]}];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
                case 20
                    date='190118_B10';
                    setElectrodes=[{[]} {[]} {[43 62 21 20 18]} {[38 55 56 62 34]}];%040118_B21 & B23?
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 10 10 10 11]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
                case 21
                    date='190118_B12';
                    setElectrodes=[{[]} {[]} {[34 42 0 41 60]} {[57 43 0 6 1]}];%190118_B & B?
                    setArrays=[{[]} {[]} {[12 12 0 13 13]} {[16 16 0 12 12]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
                case 22
                    date='190118_B14';
                    setElectrodes=[{[]} {[]} {[42 45 0 20 18]} {[12 38 0 29 57]}];%190118_B & B?
                    setArrays=[{[]} {[]} {[10 10 0 10 11]} {[13 10 0 10 10]}];
                    setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
                    setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=67;
                    visualOnly=0;
                    interleaved=0;
            end
        end
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
                %further divide trials by target location:
                targetLocation1TrialsInd=find(allTargetLocation==1);
                targetLocation2TrialsInd=find(allTargetLocation==2);
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
                for stimPatternInd=1:12%analyse performance for each condition
                    stimPatternTrialsInd=find(allStimPattern==stimPatternInd);%identify trials with this particular stimulation condition
                    correctMicrostimTrialsStimCond=intersect(correctMicrostimTrialsInd,stimPatternTrialsInd);%trialNo for microstim trials with a correct saccade for that condition
                    incorrectMicrostimTrialsStimCond=intersect(incorrectMicrostimTrialsInd,stimPatternTrialsInd);%trialNo for microstim trials with an incorrect saccade for that condition
                    meanPerfMicrostimCond(stimPatternInd)=length(correctMicrostimTrialsStimCond)/(length(correctMicrostimTrialsStimCond)+length(incorrectMicrostimTrialsStimCond));%mean performance for that condition
                    numTrialsCondMicrostim(stimPatternInd)=length(correctMicrostimTrialsStimCond)+length(incorrectMicrostimTrialsStimCond);%tally number of trials present for each condition
                    correctVisualTrialsStimCond=intersect(correctVisualTrialsInd,stimPatternTrialsInd);%trialNo for microstim trials with a correct saccade for that condition
                    incorrectVisualTrialsStimCond=intersect(incorrectVisualTrialsInd,stimPatternTrialsInd);%trialNo for microstim trials with an incorrect saccade for that condition
                    meanPerfVisualCond(stimPatternInd)=length(correctVisualTrialsStimCond)/(length(correctVisualTrialsStimCond)+length(incorrectVisualTrialsStimCond));%mean performance for that condition
                    numTrialsCondVisual(stimPatternInd)=length(correctVisualTrialsStimCond)+length(incorrectVisualTrialsStimCond);%tally number of trials present for each condition
                    %for 2-phosphene conditions, further divide trials by target location and calculate the distance between electrodes 
                    if stimPatternInd==1||stimPatternInd==2%conditions 1 and 2 involve a 2-phosphene task
                        correctMicrostimTrialsStimCondTarget1=intersect(correctMicrostimTrialsStimCond,targetLocation1TrialsInd);
                        correctMicrostimTrialsStimCondTarget2=intersect(correctMicrostimTrialsStimCond,targetLocation2TrialsInd);
                        incorrectMicrostimTrialsStimCondTarget1=intersect(incorrectMicrostimTrialsStimCond,targetLocation1TrialsInd);
                        incorrectMicrostimTrialsStimCondTarget2=intersect(incorrectMicrostimTrialsStimCond,targetLocation2TrialsInd);
                        meanPerfMicrostimCondTarget{setNo}(stimPatternInd,1)=length(correctMicrostimTrialsStimCondTarget1)/(length(correctMicrostimTrialsStimCondTarget1)+length(incorrectMicrostimTrialsStimCondTarget1));%mean performance for that condition
                        numTrialsCondMicrostimTarget{setNo}(stimPatternInd,1)=length(correctMicrostimTrialsStimCondTarget1)+length(incorrectMicrostimTrialsStimCondTarget1);%tally number of trials present for each condition
                        meanPerfMicrostimCondTarget{setNo}(stimPatternInd,2)=length(correctMicrostimTrialsStimCondTarget2)/(length(correctMicrostimTrialsStimCondTarget2)+length(incorrectMicrostimTrialsStimCondTarget2));%mean performance for that condition
                        numTrialsCondMicrostimTarget{setNo}(stimPatternInd,2)=length(correctMicrostimTrialsStimCondTarget2)+length(incorrectMicrostimTrialsStimCondTarget2);%tally number of trials present for each condition
                        for targetCondInd=1:2
                            if stimPatternInd==1
                                electrodeTemp=setElectrodes(targetCondInd,[1 4]);%only stimulate on outermost 2 electrodes
                                arrayTemp=setArrays(targetCondInd,[1 4]);
                            end
                            if stimPatternInd==2
                                electrodeTemp=setElectrodes(targetCondInd,[2 3]);%only stimulate on innermost 2 electrodes
                                arrayTemp=setArrays(targetCondInd,[2 3]);
                            end
                            electrodeInd=[];
                            arrayInd=[];
                            currentAmp=[];
                            for electrodeSequence=1:length(electrodeTemp)
                                electrodeIndtemp1=find(goodArrays8to16(:,8)==electrodeTemp(electrodeSequence));%matching channel number
                                electrodeIndtemp2=find(goodArrays8to16(:,7)==arrayTemp(electrodeSequence));%matching array number
                                electrodeInd(electrodeSequence)=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                                arrayInd(electrodeSequence)=find(arrays==arrayTemp(electrodeSequence));
                                instance(electrodeSequence)=ceil(arrayTemp(electrodeSequence)/2);
                                load([dataDir,'\array',num2str(arrayTemp(electrodeSequence)),'.mat']);
                                eval(['arrayRFs=array',num2str(arrayTemp(electrodeSequence)),';']);
                                RFx=goodArrays8to16(electrodeInd(electrodeSequence),1);
                                RFy=goodArrays8to16(electrodeInd(electrodeSequence),2);
                                w(electrodeSequence)=calculate_cortical_coords_from_RFs([RFx RFy]);
                                %this function returns the cortical distance in
                                %mm, for the x- and y-axes, in the variable
                                %'w,' with the x and y values contained in the
                                %real and imaginary parts of w, respectively
                                
                                %identify current level delivered:
                                currentAmp(electrodeSequence)=goodCurrentThresholds(electrodeInd(electrodeSequence));
                                eccentricity(electrodeSequence)=sqrt(RFx^2+RFy^2);
                            end
                            corticalDistance{setNo}(stimPatternInd,targetCondInd)=sqrt((real(w(1))-real(w(2)))^2+(imag(w(1))-imag(w(2)))^2);
                            currentDifference{setNo}(stimPatternInd,targetCondInd)=abs(diff(currentAmp));
                            currentMean{setNo}(stimPatternInd,targetCondInd)=mean(currentAmp(:));
                            currentMin{setNo}(stimPatternInd,targetCondInd)=min(currentAmp(:));
                            currentMax{setNo}(stimPatternInd,targetCondInd)=max(currentAmp(:));
                            eccentricities{setNo}(stimPatternInd,targetCondInd)=mean(eccentricity);
                            dvaEccentricities{setNo}(stimPatternInd,targetCondInd)=mean(eccentricity)/26;%approximately 26 pixels per degree
                        end
                    end
                end
                initialPerfTrials=10;%first set of trials are the most important
                if calculateVisual==0
                    if sum(numTrialsCondMicrostim>=initialPerfTrials)==length(numTrialsCondMicrostim)%if each condition has minimum number of trials present
                        allSetsPerfMicro=[allSetsPerfMicro;meanPerfMicrostimCond];
%                         save(['D:\microPerf_',date,'.mat'],'allSetsPerfMicro');
                    end
                elseif calculateVisual==1
                    if sum(numTrialsCondVisual>=initialPerfTrials)==length(numTrialsCondVisual)%if each condition has minimum number of trials present
                        allSetsPerfVisual=[allSetsPerfVisual;meanPerfVisualCond];
%                         save(['D:\visualPerf_',date,'.mat'],'allSetsPerfVisual');
                    end
                end
            end
        end
    end
    if calculateVisual==0
        figure;
        hold on
        for setNo=1:22
            for stimPatternInd=1:2
                for targetCondInd=1:2
                    plot(corticalDistance{setNo}(stimPatternInd,targetCondInd),meanPerfMicrostimCondTarget{setNo}(stimPatternInd,targetCondInd),'ko');
                end
            end
        end
        %only include sets where a certain minimum number of trials was
        %presented:
        figure;
        hold on
        for setNo=1:22
            for stimPatternInd=1:2
                for targetCondInd=1:2
                    if numTrialsCondMicrostimTarget{setNo}(stimPatternInd,targetCondInd)>=initialPerfTrials
                        plot(corticalDistance{setNo}(stimPatternInd,targetCondInd),meanPerfMicrostimCondTarget{setNo}(stimPatternInd,targetCondInd),'ko');
                    end
                end
            end
        end
%         save('D:\data\220118_2phosphene_cortical_coords_perf.mat','corticalDistance','numTrialsCondMicrostimTarget','meanPerfMicrostimCondTarget');
        
        figure;
        hold on
        for setNo=1:22
            for stimPatternInd=1:2
                for targetCondInd=1:2
                    plot(currentDifference{setNo}(stimPatternInd,targetCondInd),meanPerfMicrostimCondTarget{setNo}(stimPatternInd,targetCondInd),'ko');
                end
            end
        end
        %only include sets where a certain minimum number of trials was
        %presented:
        figure;
        hold on
        for setNo=1:22
            for stimPatternInd=1:2
                for targetCondInd=1:2
                    if numTrialsCondMicrostimTarget{setNo}(stimPatternInd,targetCondInd)>=initialPerfTrials
                        plot(currentDifference{setNo}(stimPatternInd,targetCondInd),meanPerfMicrostimCondTarget{setNo}(stimPatternInd,targetCondInd),'ko');
                    end
                end
            end
        end
        
        %eccentricity:
        figure;
        hold on
        for setNo=1:22
            for stimPatternInd=1:2
                for targetCondInd=1:2
                    plot(dvaEccentricities{setNo}(stimPatternInd,targetCondInd),meanPerfMicrostimCondTarget{setNo}(stimPatternInd,targetCondInd),'ko');
                end
            end
        end
        %only include sets where a certain minimum number of trials was
        %presented:
        figure;
        hold on
        for setNo=1:22
            for stimPatternInd=1:2
                for targetCondInd=1:2
                    if numTrialsCondMicrostimTarget{setNo}(stimPatternInd,targetCondInd)>=initialPerfTrials
                        plot(dvaEccentricities{setNo}(stimPatternInd,targetCondInd),meanPerfMicrostimCondTarget{setNo}(stimPatternInd,targetCondInd),'ko');
                    end
                end
            end
        end
%         save('D:\data\220118_2phosphene_cortical_coords_perf.mat','corticalDistance','numTrialsCondMicrostimTarget','meanPerfMicrostimCondTarget');
        xlabel('mean eccentricity');
        ylabel('performance (proportion correct)');
        title('performance with eccentricity for 2-phosphene task');
        
        save('D:\data\220118_2phosphene_current_perf.mat','currentDifference','currentMean','currentMin','currentMax','numTrialsCondMicrostimTarget','meanPerfMicrostimCondTarget','eccentricities','dvaEccentricities');

        figure;
        meanAllSetsPerfMicro=mean(allSetsPerfMicro,1);
        subplot(1,2,1);
        hold on
        b=bar(meanAllSetsPerfMicro,'FaceColor','flat');
        b(1).FaceColor = 'flat';
        if visualOnly==0
            b(1).FaceColor = [1 0 0];
        elseif visualOnly==1
            b(1).FaceColor = [0 0.4470 0.7410];
        end
        set(gca, 'XTick',1:12)
        set(gca, 'XTickLabel',1:12)
        xLimits=get(gca,'xlim');
        if visualOnly==1
            colText='b';
        elseif visualOnly==0
            colText='r';
        end
        for stimPatternInd=1:12
            if ~isnan(meanPerfMicrostimCond(stimPatternInd))
                txt=sprintf('%.2f',meanAllSetsPerfMicro(stimPatternInd));
                text(stimPatternInd-0.25,0.95,txt,'Color',colText)
            end
        end
        ylim([0 1])
        hold on
        plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
        xlim([0 13])
        title('mean performance, microstim (red) trials');
        xlabel('target condition');
        ylabel('average performance across session');
        pooledAllSetsPerfMicro=[allSetsPerfMicro(:,1) allSetsPerfMicro(:,2) (allSetsPerfMicro(:,3)+allSetsPerfMicro(:,4))/2 (allSetsPerfMicro(:,5)+allSetsPerfMicro(:,6))/2 (allSetsPerfMicro(:,7)+allSetsPerfMicro(:,8))/2 (allSetsPerfMicro(:,9)+allSetsPerfMicro(:,10))/2 (allSetsPerfMicro(:,11)+allSetsPerfMicro(:,12))/2];  
        [p,table,stats]=anova2(pooledAllSetsPerfMicro);
        results = multcompare(stats,'Estimate','column')
        results = multcompare(stats,'Estimate','row')
        reshapedAllSetsPerfMicro=pooledAllSetsPerfMicro(:);
        g1=[];%electrode set
        for rowInd=1:size(pooledAllSetsPerfMicro,2)
            g1=[g1;[1:size(pooledAllSetsPerfMicro,1)]'];
        end
        g2=[];%microstimulation pattern condition
        for rowInd=1:size(pooledAllSetsPerfMicro,2)
            g2=[g2;rowInd*ones(size(pooledAllSetsPerfMicro,1),1)];
        end
        [p,table,stats]=anovan(reshapedAllSetsPerfMicro,{g1,g2});
        results = multcompare(stats,'Dimension',[1 2])
    end
    if calculateVisual==1
        subplot(1,2,2);
        hold on
        meanAllSetsPerfVisual=mean(allSetsPerfVisual,1);
        b=bar(meanAllSetsPerfVisual,'FaceColor','flat');
        b(1).FaceColor = 'flat';
        if visualOnly==0
            b(1).FaceColor = [1 0 0];
        elseif visualOnly==1
            b(1).FaceColor = [0 0.4470 0.7410];
        end
        set(gca, 'XTick',1:12)
        set(gca, 'XTickLabel',1:12)
        xLimits=get(gca,'xlim');
        if visualOnly==1
            colText='b';
        elseif visualOnly==0
            colText='r';
        end
        for stimPatternInd=1:12
            if ~isnan(meanPerfVisualCond(stimPatternInd))
                txt=sprintf('%.2f',meanAllSetsPerfVisual(stimPatternInd));
                text(stimPatternInd-0.25,0.95,txt,'Color',colText)
            end
        end
        ylim([0 1])
        hold on
        plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
        xlim([0 13])
        title('mean performance, visual (blue) trials');
        xlabel('target condition');
        ylabel('average performance across session');
    end
end
title(['performance across the session, on visual (blue) & microstim (red) trials']);
pathname=['D:\data\behavioural_performance_all_sets_220118_',num2str(initialPerfTrials),'trials__12patterns'];
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff');

perfMat=['D:\data\behavioural_performance_all_sets_220118_',num2str(initialPerfTrials),'trials_12patterns.mat'];
save(perfMat,'meanAllSetsPerfVisual','meanAllSetsPerfMicro');
pause=1;

significantByThisTrialMicro=0;
for trialInd=1:length(meanAllSetsPerfMicro)
    x=sum(meanAllSetsPerfMicroBin(1:trialInd))*size(allSetsPerfMicro,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfMicro,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialMicro(trialInd)=1;
    end
end
significantByThisTrialMicro

significantByThisTrialVisual=0;
for trialInd=1:length(meanAllSetsPerfVisual)
    x=sum(meanAllSetsPerfVisualBin(1:trialInd))*size(allSetsPerfVisual,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfVisual,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialVisual(trialInd)=1;
    end
end
significantByThisTrialVisual