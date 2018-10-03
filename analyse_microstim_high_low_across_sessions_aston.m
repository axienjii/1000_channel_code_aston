function analyse_microstim_high_low_across_sessions
%Written by Xing 14/2/18
%Compile performance data across electrode sets, include data where certain
%minimum number of trials obtained per condition, and compare performance
%between conditions where current amplitude used was a multiple of either
%1.5 or 2.5 times the current threshold.

excludeMin30=0;%set to 1 to exclude datasets where minimum of 30 uA current was imposed; set to 0 to include all datasets
minTrials=10;
allMeanPerfMicrostimCond=[];
for electrodeSetInd=1:26
    localDisk=0;
    switch(electrodeSetInd)        
        case 1
            date='060218_B4';
            setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%setInd 9 151217_B4 & B5
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=71;
            visualOnly=0;
            interleaved=0;
            min30=1;
        case 2
            date='060218_B5';
            setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%setInd 14 191217_B4 & B10
            setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=71;
            visualOnly=0;
            interleaved=0;
            min30=1;
        case 3
            date='060218_B6';
            setElectrodes=[{[]} {[]} {[39 63 30 40 63]} {[50 27 32 29 33]}];%setInd 22 201217_B & B?
            setArrays=[{[]} {[]} {[16 16 16 15 15]} {[8 8 14 12 13]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=71;
            visualOnly=0;
            interleaved=0;
            min30=1;
        case 4
            date='060218_B7';
            setElectrodes=[{[]} {[]} {[21 29 48 22 38]} {[20 63 22 20 52]}];%setInd 23 201217_B & B?
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 14 12 12 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=71;
            visualOnly=0;
            interleaved=0;
            min30=1;
        case 5
            date='070218_B3';
            setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;
            min30=0;
        case 6
            date='070218_B4';
            setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B17 & B19
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;
            min30=0;
        case 7
            date='070218_B5';
            setElectrodes=[{[]} {[]} {[39 45 47 54 32]} {[15 53 12 29 59]}];%201217_B & B?
            setArrays=[{[]} {[]} {[12 14 14 14 14]} {[16 14 14 14 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;
            min30=0;
        case 8
            date='070218_B6';
            setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%191217_B11 & B12
            setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;
            min30=0;
        case 9
            date='070218_B7';
            setElectrodes=[{[]} {[]} {[52 28 34 35 55]} {[45 30 28 23 37]}];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;
            min30=1;
        case 10
            date='070218_B8';
            setElectrodes=[{[]} {[]} {[40 47 56 24 21]} {[22 52 38 29 57]}];%040118_B17 & B19
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;
            min30=1;
        case 11
            date='070218_B9';
            setElectrodes=[{[]} {[]} {[39 45 47 54 32]} {[15 53 12 29 59]}];%201217_B & B?
            setArrays=[{[]} {[]} {[12 14 14 14 14]} {[16 14 14 14 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;
            min30=1;
        case 12
            date='070218_B10';
            setElectrodes=[{[]} {[]} {[59 29 24 31 38]} {[15 12 15 29 58]}];%191217_B11 & B12
            setArrays=[{[]} {[]} {[14 14 12 13 13]} {[16 16 14 14 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=72;
            visualOnly=0;
            interleaved=0;  
            min30=1;
        case 13
            date='080218_B3';
            setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%191217_B13 & B14
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=73;
            visualOnly=0;
            interleaved=0;  
            min30=0;
        case 14
            date='080218_B4';
            setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%191217_B17 & B18
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=73;
            visualOnly=0;
            interleaved=0; 
            min30=0;  
        case 15
            date='080218_B5';
            setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%151217_B8 & B9?
            setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=73;
            visualOnly=0;
            interleaved=0;  
            min30=0;
        case 16
            date='080218_B6';
            setElectrodes=[{[]} {[]} {[50 36 28 35 55]} {[63 48 26 40 35]}];%151217_B10 & B11?
            setArrays=[{[]} {[]} {[12 12 12 13 11]} {[15 13 13 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=73;
            visualOnly=0;
            interleaved=0;    
            min30=0;
        case 17
            date='080218_B7';
            setElectrodes=[{[]} {[]} {[10 28 47 34 13]} {[56 51 39 43 36]}];%191217_B13 & B14
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=73;
            visualOnly=0;
            interleaved=0;  
            min30=1;
        case 18
            date='080218_B8';
            setElectrodes=[{[]} {[]} {[46 32 15 22 3]} {[32 53 47 58 59]}];%191217_B17 & B18
            setArrays=[{[]} {[]} {[10 10 10 10 11]} {[13 13 10 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=73;
            visualOnly=0;
            interleaved=0;   
            min30=1;
        case 19
            date='080218_B9';
            setElectrodes=[{[]} {[]} {[39 47 16 32 49]} {[40 21 13 20 61]}];%151217_B8 & B9?
            setArrays=[{[]} {[]} {[12 14 14 14 15]} {[8 16 14 12 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=73;
            visualOnly=0;
            interleaved=0;  
            min30=1;
        case 20
            date='090218_B4';
            setElectrodes=[{[]} {[]} {[45 44 50 15 7]} {[44 19 27 32 28]}];%181217_B11 & B12
            setArrays=[{[]} {[]} {[8 8 8 15 15]} {[8 8 8 14 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=74;
            visualOnly=0;
            interleaved=0;  
            min30=1;  
        case 21
            date='090218_B5';
            setElectrodes=[{[]} {[]} {[42 45 0 20 18]} {[12 38 0 29 57]}];%190118_B & B?
            setArrays=[{[]} {[]} {[10 10 0 10 11]} {[13 10 0 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=74;
            visualOnly=0;
            interleaved=0;  
            min30=1;
        case 22
            date='090218_B6';
            setElectrodes=[{[]} {[]} {[50 36 28 35 55]} {[63 48 26 40 35]}];%151217_B10 & B11?
            setArrays=[{[]} {[]} {[12 12 12 13 11]} {[15 13 13 10 10]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=74;
            visualOnly=0;
            interleaved=0;   
            min30=1; 
        case 23
            date='140218_B4';
            setElectrodes=[{[]} {[]} {[40 64 22 19 62]} {[40 50 12 44 26]}];%151217_B4 & B5
            setArrays=[{[]} {[]} {[16 16 16 8 15]} {[16 16 12 9 9]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=75;
            visualOnly=0;
            interleaved=0;
            min30=0;
            localDisk=1;
        case 24
            date='140218_B5';
            setElectrodes=[{[]} {[]} {[33 5 23 29 56]} {[37 39 33 64 9]}];%191217_B4 & B10
            setArrays=[{[]} {[]} {[12 12 12 12 13]} {[16 12 12 9 9]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=75;
            visualOnly=0;
            interleaved=0;
            min30=0;
            localDisk=1;
        case 25
            date='140218_B6';
            setElectrodes=[{[]} {[]} {[39 63 30 40 63]} {[50 27 32 29 33]}];%201217_B & B?
            setArrays=[{[]} {[]} {[16 16 16 15 15]} {[8 8 14 12 13]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=75;
            visualOnly=0;
            interleaved=0;
            min30=0;
            localDisk=1;
        case 26
            date='140218_B7';
            setElectrodes=[{[]} {[]} {[21 29 48 22 38]} {[20 63 22 20 52]}];%201217_B & B?
            setArrays=[{[]} {[]} {[12 12 13 13 13]} {[16 14 12 12 12]}];
            setElectrodes=[setElectrodes{3}([1 2 4 5]);setElectrodes{4}([1 2 4 5])];
            setArrays=[setArrays{3}([1 2 4 5]);setArrays{4}([1 2 4 5])];
            numTargets=2;
            electrodePairs=[1:size(setElectrodes,2);1:size(setElectrodes,2)];
            currentThresholdChs=75;
            visualOnly=0;
            interleaved=0;   
            min30=0; 
            localDisk=1;
    end
    if localDisk==1
        rootdir='D:\data\';
    elseif localDisk==0
        rootdir='X:\best\';
    end
    includeFlag=1;
    if excludeMin30==1
        if min30==1
            includeFlag=0;
        end
    end
    if includeFlag==1
        load([rootdir,'\',date,'\','\perf_conds_high_vs_low_',date,'.mat'],'meanPerfMicrostimCond','numTrialsMicrostimCond','currentAmplitudes','condPair');
        for condPairInd=1:4
            if condPair(condPairInd)==1
                if numTrialsMicrostimCond((condPairInd-1)*2+1)>=minTrials&&numTrialsMicrostimCond((condPairInd-1)*2+2)>=minTrials
                    allMeanPerfMicrostimCond=[allMeanPerfMicrostimCond;meanPerfMicrostimCond((condPairInd-1)*2+1) meanPerfMicrostimCond((condPairInd-1)*2+2)];
                end
            end
        end
    end
end
figure;
scatter(allMeanPerfMicrostimCond(:,1),allMeanPerfMicrostimCond(:,2),'ko')
[h,p,ci,stats]=ttest(allMeanPerfMicrostimCond(:,1),allMeanPerfMicrostimCond(:,2));
axis square
hold on
plot([0 1],[0 1],'k--');
if excludeMin30==0
    xlabel('performance on 1.5x threshold condition');
    ylabel('performance on 2.5x threshold condition');
    str=sprintf('combine sets, with and without 30 uA min. N=%d p=%0.4f',size(allMeanPerfMicrostimCond,1),p);
    title(str);
elseif excludeMin30==1
    xlabel('performance on 1.5x threshold condition');
    ylabel('performance on 2.5x threshold condition');
    title(sprintf('electrode sets without 30 uA min. N=%d p=%0.4f',size(allMeanPerfMicrostimCond,1),p));
end
