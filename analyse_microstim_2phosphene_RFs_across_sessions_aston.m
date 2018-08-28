function analyse_microstim_2phosphene_RFs_across_sessions(date)
%23/1/18
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual line orientation task, for 2 phosphenes, as well
%as distance of separation between pair of electrodes on the cortex. 
%Converts RF locations into cortical coordinates, using function 
%calculate_cortical_coords_from_RFs.m.
%Output is saved in .mat file, 040118_2phosphene_cortical_coords_perf.mat,
%which is combined with 220118_2phosphene_cortical_coords_perf.mat
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
    for setNo=[1:17 19:26 28:46]
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
                    date='091017_B13';
                case 2
                    date='101017_B40';
                case 3
                    date='111017_B11';
                case 4
                    date='131017_B9';
                case 5
                    date='181017_B21';
                case 6
                    date='181017_B28';
                case 7
                    date='191017_B33';
                case 8
                    date='191017_B35';
                case 9
                    date='191017_B37';
                case 10
                    date='191017_B39';
                case 11
                    date='191017_B41';
                case 12
                    date='201017_B28';
                case 13
                    date='201017_B30';
                case 14
                    date='231017_B11';
                case 15
                    date='231017_B39';
                case 16
                    date='231017_B43';
                case 17
                    date='231017_B42';
                case 18
                    date='231017_B45';
                case 19
                    date='231017_B49';
                case 20
                    date='241017_B17';
                case 21
                    date='241017_B46';
                case 22
                    date='241017_B49';
                case 23
                    date='241017_B51';
                case 24
                    date='241017_B54';
                case 25
                    date='241017_B56';
                case 26
                    date='241017_B58';
                case 27
                    date='211217_B10';
                case 28
                    date='211217_B6';
                case 29
                    date='211217_B14';
                case 30
                    date='211217_B18';
                case 31
                    date='211217_B22';
                case 32
                    date='221217_B8';
                case 33
                    date='221217_B12';
                case 34
                    date='221217_B16';
                case 35
                    date='221217_B20';
                case 36
                    date='221217_B25';
                case 37
                    date='030118_B9';
                case 38
                    date='030118_B13';
                case 39
                    date='030118_B17';
                case 40
                    date='030118_B22';
                case 41
                    date='030118_B26';
                case 42
                    date='040118_B7';
                case 43
                    date='040118_B11';
                case 44
                    date='040118_B15';
                case 45
                    date='040118_B19';
                case 46
                    date='040118_B23';
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
            end
        end
        
        if localDisk==1
            rootdir='D:\data\';
        elseif localDisk==0
            rootdir='X:\best\';
        end
        matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
        dataDir=[rootdir,date,'\',date,'_data'];
        if ~exist('matFile','file')
            copyfile([rootdir,date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
        end
        load(matFile);
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='091017_B13';
                    setElectrodes=[29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=5;
                    visualOnly=0;
                case 2
                    date='101017_B40';
                    setElectrodes=[46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=5;
                    visualOnly=0;
                case 3
                    date='111017_B11';
                    setElectrodes=[50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 8 14 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=8;
                    visualOnly=0;
                case 4
                    date='131017_B9';
                    setElectrodes=[45 32 50 33];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 14 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=10;
                    visualOnly=0;
                    localDisk=1;
                case 5
                    date='181017_B21';
                    setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 10 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=11;
                    visualOnly=0;
                case 6
                    date='181017_B28';
                    setElectrodes=[46 21 49 57];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 15 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=12;
                    visualOnly=0;
                case 7
                    date='191017_B33';
                    setElectrodes=[30 18 12 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=13;
                    visualOnly=0;
                case 8
                    date='191017_B35';
                    setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=14;
                    visualOnly=0;
                case 9
                    date='191017_B37';
                    setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=15;
                    visualOnly=0;
                case 10
                    date='191017_B39';
                    setElectrodes=[3 22 34 42];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=16;
                    visualOnly=0;
                case 11
                    date='191017_B41';
                    setElectrodes=[45 18 56 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=17;
                    visualOnly=0;
                case 12
                    date='201017_B28';
                    setElectrodes=[26 60 48 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=0;
                    localDisk=1;
                case 13
                    date='201017_B30';
                    setElectrodes=[27 51 11 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=0;
                    localDisk=1;
                case 14
                    date='231017_B11';
                    setElectrodes=[25 35 45 37];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                    localDisk=1;
                case 15
                    date='231017_B39';
                    setElectrodes=[52 52 48 47];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                    localDisk=1;
                case 16
                    date='231017_B43';
                    setElectrodes=[18 47 43 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=0;
                    localDisk=1;
                case 17
                    date='231017_B42';
                    setElectrodes=[12 23 45 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                    localDisk=1;
                case 18
                    date='231017_B45';
                    setElectrodes=[10 55 19 30];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=25;
                    visualOnly=0;
                    localDisk=1;
                case 19
                    date='231017_B49';
                    setElectrodes=[35 22 40 41];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=26;
                    visualOnly=0;
                    localDisk=1;
                case 20
                    date='241017_B17';
                    setElectrodes=[46 19 44 18];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 8 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=28;
                    visualOnly=0;
                    localDisk=1;
                case 21
                    date='241017_B46';
                    setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=29;
                    visualOnly=0;
                    localDisk=1;
                case 22
                    date='241017_B49';
                    setElectrodes=[43 55 55 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=30;
                    visualOnly=0;
                    localDisk=1;
                case 23
                    date='241017_B51';
                    setElectrodes=[27 50 15 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=31;
                    visualOnly=0;
                    localDisk=1;
                case 24
                    date='241017_B54';
                    setElectrodes=[38 55 44 27];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=32;
                    visualOnly=0;
                    localDisk=1;
                case 25
                    date='241017_B56';
                    setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=33;
                    visualOnly=0;
                    localDisk=1;
                case 26
                    date='241017_B58';
                    setElectrodes=[39 62 40 13];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=34;
                    visualOnly=0;
                    localDisk=1;
                case 27
                    date='211217_B10';
                    setElectrodes=[40 31;63 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 14;16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 28
                    date='211217_B6';
                    setElectrodes=[39 32;15 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 14;16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 29
                    date='211217_B14';
                    setElectrodes=[17 30;22 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[9 14;16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 30
                    date='211217_B18';
                    setElectrodes=[39 63;50 33];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15;8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 31
                    date='211217_B22';
                    setElectrodes=[21 38;20 52];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13;16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=58;
                    visualOnly=0;
                    interleaved=1;
                case 32
                    date='221217_B8';
                    setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%221217_B & B
                    setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 33
                    date='221217_B12';
                    setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%221217_B & B
                    setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 34
                    date='221217_B16';
                    setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%221217_B & B
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 35
                    date='221217_B20';
                    setElectrodes=[{[]} {[]} {[27 33 49 51 55]} {[49 31 52 46 51]}];%221217_B & B
                    setArrays=[{[]} {[]} {[12 13 13 13 11]} {[15 13 13 10 10]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 36
                    date='221217_B25';
                    setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%221217_B & B
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2;1 2];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 37
                    date='030118_B9';
                    setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%030118_B & B?
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 38
                    date='030118_B13';
                    setElectrodes=[{[]} {[]} {[50 61 21 27 46]} {[7 64 61 58 2]}];%0118_B & B?
                    setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 16 14 12]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 39
                    date='030118_B17';
                    setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%0118_B & B?
                    setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 40
                    date='030118_B22';
                    setElectrodes=[{[]} {[]} {[63 48 26 40 35]} {[50 36 28 35 55]}];%0118_B & B?
                    setArrays=[{[]} {[]} {[15 13 13 10 10]} {[12 12 12 13 11]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 41
                    date='030118_B26';
                    setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%0118_B & B?
                    setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=60;
                    visualOnly=0;
                    interleaved=1;
                case 42
                    date='040118_B7';
                    setElectrodes=[{[]} {[]} {[2 57 47 61 53]} {[22 27 13 21 61]}];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=62;
                    visualOnly=0;
                    interleaved=1;
                case 43
                    date='040118_B11';
                    setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=62;
                    visualOnly=0;
                    interleaved=1;
                case 44
                    date='040118_B15';
                    setElectrodes=[{[]} {[]} {[40 7 43 48 55]} {[38 47 39 35 27]}];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[{[]} {[]} {[16 16 8 15 15]} {[16 16 14 12 9]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=62;
                    visualOnly=0;
                    interleaved=1;
                case 45
                    date='040118_B19';
                    setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B & B?
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=62;
                    visualOnly=0;
                    interleaved=1;
                case 46
                    date='040118_B23';
                    setElectrodes=[{[]} {[]} {[43 62 21 20 18]} {[38 55 56 62 34]}];%040118_B & B?
                    setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 10 10 10 11]}];
                    setElectrodes=[setElectrodes{3}(1) setElectrodes{3}(end);setElectrodes{4}(1) setElectrodes{4}(end)];
                    setArrays=[setArrays{3}(1) setArrays{3}(end);setArrays{4}(1) setArrays{4}(end)];
                    numTargets=2;
                    electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
                    currentThresholdChs=62;
                    visualOnly=0;
                    interleaved=1;
            end
            if setNo>26
                setElectrodes=[setElectrodes(1,:) setElectrodes(2,:)];
                setArrays=[setArrays(1,:) setArrays(2,:)];
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
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
                        if setNo<=26
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
                            if strcmp(date,'231017_B45')
                                if length(find(trialEncodes==2^MicroB))==3
                                    microstimTrialNEV(trialNo)=1;
                                end
                                if length(find(trialEncodes==2^MicroB))==2
                                    microstimTrialNEV(trialNo)=1;
                                else
                                    microstimTrialNEV(trialNo)=0;
                                end
                            else
                                microstimTrialNEV=allCurrentLevel>0;
                            end
                        elseif setNo>26
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
                                if sum(allCurrentLevel(trialCurrentLevelInd))>0
                                    microstimTrialNEV(trialCurrentLevelInd)=1;
                                else
                                    microstimTrialNEV(trialCurrentLevelInd)=0;
                                end
                            end
                        end
                        %analyse individual conditions:
                        if length(allElectrodeNum)>=trialNo
                            electrode=allElectrodeNum(trialNo);
                            array=allArrayNum(trialNo);
                            electrode2=allElectrodeNum2(trialNo);
                            array2=allArrayNum2(trialNo);
                            electrodeMatch=find(setElectrodes==electrode);
                            arrayMatch=find(setArrays==array);
                            matchingCh=intersect(electrodeMatch,arrayMatch);%one electrode of a pair
                            electrodeMatch2=find(setElectrodes==electrode2);
                            arrayMatch2=find(setArrays==array2);
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
                    %divide trials by target location and calculate the distance between electrodes
                    correctMicrostimTrialsStimCondTarget1=intersect(correctMicrostimTrialsInd,targetLocation1TrialsInd);
                    correctMicrostimTrialsStimCondTarget2=intersect(correctMicrostimTrialsInd,targetLocation2TrialsInd);
                    incorrectMicrostimTrialsStimCondTarget1=intersect(incorrectMicrostimTrialsInd,targetLocation1TrialsInd);
                    incorrectMicrostimTrialsStimCondTarget2=intersect(incorrectMicrostimTrialsInd,targetLocation2TrialsInd);
                    meanPerfMicrostimCondTarget{setNo}(1,1)=length(correctMicrostimTrialsStimCondTarget1)/(length(correctMicrostimTrialsStimCondTarget1)+length(incorrectMicrostimTrialsStimCondTarget1));%mean performance for that condition
                    numTrialsCondMicrostimTarget{setNo}(1,1)=length(correctMicrostimTrialsStimCondTarget1)+length(incorrectMicrostimTrialsStimCondTarget1);%tally number of trials present for each condition
                    meanPerfMicrostimCondTarget{setNo}(1,2)=length(correctMicrostimTrialsStimCondTarget2)/(length(correctMicrostimTrialsStimCondTarget2)+length(incorrectMicrostimTrialsStimCondTarget2));%mean performance for that condition
                    numTrialsCondMicrostimTarget{setNo}(1,2)=length(correctMicrostimTrialsStimCondTarget2)+length(incorrectMicrostimTrialsStimCondTarget2);%tally number of trials present for each condition
                    for targetCondInd=1:2
                        if targetCondInd==1
                            electrodeTemp=setElectrodes([1 2]);%horizontal orientation
                            arrayTemp=setArrays([1 2]);
                        elseif targetCondInd==2
                            electrodeTemp=setElectrodes([3 4]);%vertical orientation
                            arrayTemp=setArrays([3 4]);
                        end
                        electrodeInd=[];
                        arrayInd=[];
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
                            eccentricity(electrodeSequence)=sqrt(RFx^2+RFy^2);
                        end
                        corticalDistance{setNo}(targetCondInd)=sqrt((real(w(1))-real(w(2)))^2+(imag(w(1))-imag(w(2)))^2);
                        eccentricities{setNo}(targetCondInd)=mean(eccentricity);
                        dvaEccentricities{setNo}(targetCondInd)=mean(eccentricity)/26;%approximately 26 pixels per degree
                    end
                end
                initialPerfTrials=10;%first set of trials are the most important
%                 if calculateVisual==0
%                     if sum(cell2mat(numTrialsCondMicrostimTarget)>=initialPerfTrials)==length(cell2mat(numTrialsCondMicrostimTarget))%if each condition has minimum number of trials present
%                         allSetsPerfMicro=[allSetsPerfMicro;cell2mat(meanPerfMicrostimCondTarget)];
%                         save(['D:\microPerf_',date,'.mat'],'allSetsPerfMicro');
%                     end
%                 elseif calculateVisual==1
%                     if sum(numTrialsCondVisual>=initialPerfTrials)==length(numTrialsCondVisual)%if each condition has minimum number of trials present
%                         allSetsPerfVisual=[allSetsPerfVisual;meanPerfVisualCond];
%                         save(['D:\visualPerf_',date,'.mat'],'allSetsPerfVisual');
%                     end
%                 end
            end
        end
    end
    if calculateVisual==0
        %cortical distance between electrodes:
        figure;
        hold on
        for setNo=[1:17 19:26 28:46]
            for targetCondInd=1:2
                plot(corticalDistance{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
            end
        end
        %only include sets where a certain minimum number of trials was
        %presented:
        figure;
        hold on
        for setNo=[1:17 19:26 28:46]
            for targetCondInd=1:2
                if numTrialsCondMicrostimTarget{setNo}(targetCondInd)>=initialPerfTrials
                    plot(corticalDistance{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
                end
            end
        end
        xlabel('cortical distance between electrode pair (mm)');
        ylabel('performance (proportion correct)');
        title('performance with cortical distance for 2-phosphene task');
        
        %eccentricity:
        figure;
        hold on
        for setNo=[1:17 19:26 28:46]
            for targetCondInd=1:2
                plot(dvaEccentricities{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
            end
        end
        %only include sets where a certain minimum number of trials was
        %presented:
        figure;
        hold on
        for setNo=[1:17 19:26 28:46]
            for targetCondInd=1:2
                if numTrialsCondMicrostimTarget{setNo}(targetCondInd)>=initialPerfTrials
                    plot(dvaEccentricities{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
                end
            end
        end
        xlabel('mean eccentricity');
        ylabel('performance (proportion correct)');
        title('performance with eccentricity for 2-phosphene task');

        save('D:\data\040118_2phosphene_cortical_coords_perf.mat','corticalDistance','numTrialsCondMicrostimTarget','meanPerfMicrostimCondTarget','eccentricities');
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