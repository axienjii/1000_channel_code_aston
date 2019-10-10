function list_2phosphene_aston(date)
%22/8/19
%Written by Xing, makes list of data folders corresponding to a
%microstimulation/visual 2-phosphene task.

load('D:\aston_data\channel_area_mapping_aston.mat')
setNos=[1:3 5:12];
allDatesV=[];
allDatesM=[];
for calculateVisual=[0 1]
    figure;
    subplotNo=0;
    for setNo=setNos
        subplotNo=subplotNo+1;
        subplot(5,5,subplotNo);
        hold on
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='151118_B6_aston';
                    setElectrodes=[22 12 55 16];%TB task
                    setArrays=[8 14 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=18;
                    visualOnly=0;
                case 2
                    date='161118_B7_aston';
                    setElectrodes=[29 9 60 64];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=0;
                case 3
                    date='191118_B7_aston';
                    setElectrodes=[3 35 61 57];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=0;
                case 4%remove (saccade end points good, but RFs too slanted)
                    date='211118_B5_aston';
                    setElectrodes=[1 50 43 59];%
                    setArrays=[13 14 16 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 5
                    date='211118_B6_aston';
                    setElectrodes=[25 59 56 57];%
                    setArrays=[13 14 16 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 6
                    date='211118_B7_aston';
                    setElectrodes=[33 21 48 63];%
                    setArrays=[13 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 7
                    date='221118_B11_aston';
                    setElectrodes=[3 57 50 63];%
                    setArrays=[13 13 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 8
                    date='221118_B12_aston';
                    setElectrodes=[10 63 16 57];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 9
                    date='221118_B13_aston';
                    setElectrodes=[1 57 9 58];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 10
                    date='231118_B6_aston';
                    setElectrodes=[6 49 59 36];%
                    setArrays=[12 11 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=0;
                case 11
                    date='231118_B11_aston';
                    setElectrodes=[36 60 53 9];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=0;
                case 12
                    date='261118_B14_aston';
                    setElectrodes=[9 59 60 41];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=0;
            end 
            allDatesM=[allDatesM;{date}];
            %visual task only:
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='151118_B4_aston';
                    setElectrodes=[22 12 55 16];%TB task
                    setArrays=[8 14 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=18;
                    visualOnly=1;
                case 2
                    date='161118_B4_aston';
                    setElectrodes=[29 9 60 64];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=1;
                case 3
                    date='191118_B5_aston';
                    setElectrodes=[3 35 61 57];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=1;
                case 4%remove (saccade end points good, but RFs too slanted)
                    date='211118_B3_aston';
                    setElectrodes=[1 50 43 59];%
                    setArrays=[13 14 16 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                case 5
                    date='211118_B9_aston';
                    setElectrodes=[25 59 56 57];%
                    setArrays=[13 14 16 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                case 6
                    date='271118_B1_aston';
                    setElectrodes=[33 21 48 63];%
                    setArrays=[13 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
%                     date='211118_B10_aston';
%                     setElectrodes=[33 21 48 63];%
%                     setArrays=[13 14 16 11];
%                     setInd=1;
%                     numTargets=2;
%                     electrodePairs=[1 2;3 4];
%                     currentThresholdChs=21;
%                     visualOnly=1;
                case 7
                    date='221118_B5_aston';
                    setElectrodes=[3 57 50 63];%
                    setArrays=[13 13 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 8
                    date='221118_B10_aston';
                    setElectrodes=[10 63 16 57];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 9
                    date='221118_B14_aston';
                    setElectrodes=[1 57 9 58];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 10
                    date='231118_B5_aston';
                    setElectrodes=[6 49 59 36];%
                    setArrays=[12 11 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=1;
                case 11
                    date='231118_B10_aston';
                    setElectrodes=[36 60 53 9];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=1;
                case 12
                    date='261118_B13_aston';
                    setElectrodes=[9 59 60 41];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=1;
            end
            allDatesV=[allDatesV;{date}];
        end
        chRFs=[];
        for chInd=1:size(setElectrodes,2)
            electrode=setElectrodes(1,chInd);
            array=setArrays(1,chInd);
            instance=ceil(array/2);
            temp1=find(channelNums(:,instance)==electrode);
            temp2=find(arrayNums(:,instance)==array);
            ind=intersect(temp1,temp2);
            load(['D:\aston_data\best_aston_280818-290818\RFs_instance',num2str(instance),'.mat']);
            chRFs(chInd,:)=channelRFs(ind,1:2);
        end
        plot(chRFs(:,1),chRFs(:,2),'-')
        plot(chRFs(1,1),chRFs(1,2),'o')
        hold on
        axis equal
        title(setNo);
    end
end
save('D:\aston_data\list_2phosphene_datesM','allDatesM');
save('D:\aston_data\list_2phosphene_datesV','allDatesV');