function list_motion_draw_RFs_aston(date)
%11/9/19
%Written by Xing, plots corrected RFs of channels used during a direction-of-motion task.

load('D:\aston_data\channel_area_mapping_aston.mat')
figure;
allDatesV=[];
allDatesM=[];
for calculateVisual=[0 1]
    figure;
    subplotNo=0;
    for setNo=[1:10 12 14:21]
        subplotNo=subplotNo+1;
        subplot(5,5,subplotNo);
        hold on
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='271118_B6_aston';
                    setElectrodes=[59 64 1;1 64 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 13;13 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=0;
                case 2
                    date='271118_B8_aston';
                    setElectrodes=[50 61 3;3 61 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 13 13;13 13 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=0;
                case 3
                    date='281118_B8_aston';
                    setElectrodes=[58 41 9;9 41 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=26;
                    visualOnly=0;
                case 4
                    date='291118_B9_aston';
                    setElectrodes=[57 33 10;10 33 57];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=0;
                case 5
                    date='291118_B10_aston';
                    setElectrodes=[49 41 36;36 41 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=0;
                case 6
                    date='041218_B3_aston';
                    setElectrodes=[16 9 57;57 9 16];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 14 11;11 14 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=0;
                case 7
                    date='041218_B5_aston';
                    setElectrodes=[12 63 58;58 63 12];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=0;
                case 8
                    date='041218_B7_aston';
                    setElectrodes=[35 63 49;49 63 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=0;
                case 9
                    date='051218_B5_aston';
                    setElectrodes=[48 63 25;25 63 48];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=30;
                    visualOnly=0;
                case 10
                    date='061218_B8_aston';
                    setElectrodes=[53 25 9;9 25 53];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 13;13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=31;
                    visualOnly=0;
                case 12
                    date='071218_B6_aston';
                    setElectrodes=[56 60 50;50 60 56];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=32;
                    visualOnly=0;
                case 14
                    date='101218_B5_aston';
                    setElectrodes=[55 59 41;41 59 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=0;
                case 15
                    date='101218_B7_aston';
                    setElectrodes=[43 35 58;58 35 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=0;
                case 16
                    date='101218_B9_aston';%only ~25 trials completed
                    setElectrodes=[34 16 57;57 16 34];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=0;
                case 17
                    date='121218_B8_aston';
                    setElectrodes=[41 12 49;49 12 41];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=0;
                case 18
                    date='121218_B10_aston';
                    setElectrodes=[58 35 58;58 35 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=0;
                case 19
                    date='141218_B4_aston';
                    setElectrodes=[60 16 59;59 16 60];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=0;
                case 20
                    date='141218_B7_aston';
                    setElectrodes=[40 54 9;9 54 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=0;
                case 21
                    date='171218_B3_aston';
                    setElectrodes=[51 62 17;17 62 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=36;
                    visualOnly=0;
            end
            allDatesM=[allDatesM;{date}];
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='271118_B3_aston';
                    setElectrodes=[59 64 1;1 64 59];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 13;13 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=1;
                case 2
                    date='271118_B7_aston';
                    setElectrodes=[50 61 3;3 61 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 13 13;13 13 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=25;
                    visualOnly=1;
                case 3
                    date='281118_B7_aston';
                    setElectrodes=[58 41 9;9 41 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=26;
                    visualOnly=1;
                case 4
                    date='291118_B1_aston';
                    setElectrodes=[57 33 10;10 33 57];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=1;
                case 5
                    date='291118_B2_aston';
                    setElectrodes=[49 41 36;36 41 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13;13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=27;
                    visualOnly=1;
                case 6
                    date='031218_B3_aston';
                    setElectrodes=[16 9 57;57 9 16];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 14 11;11 14 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=28;
                    visualOnly=1;
                case 7
                    date='041218_B4_aston';
                    setElectrodes=[12 63 58;58 63 12];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=1;
                case 8
                    date='041218_B6_aston';
                    setElectrodes=[35 63 49;49 63 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[14 11 11;11 11 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=29;
                    visualOnly=1;
                case 9
                    date='051218_B4_aston';
                    setElectrodes=[48 63 25;25 63 48];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=30;
                    visualOnly=1;
                case 10
                    date='061218_B6_aston';
                    setElectrodes=[53 25 9;9 25 53];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 13;13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=31;
                    visualOnly=1;
                case 12
                    date='071218_B1_aston';
                    setElectrodes=[56 60 50;50 60 56];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=32;
                    visualOnly=1;
                case 14
                    date='101218_B4_aston';
                    setElectrodes=[55 59 41;41 59 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=1;
                case 15
                    date='101218_B6_aston';
                    setElectrodes=[43 35 58;58 35 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=1;
                case 16
                    date='101218_B8_aston';
                    setElectrodes=[34 16 57;57 16 34];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=33;
                    visualOnly=1;
                case 17
                    date='121218_B7_aston';
                    setElectrodes=[41 12 49;49 12 41];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=1;
                case 18
                    date='121218_B9_aston';
                    setElectrodes=[58 35 58;58 35 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=34;
                    visualOnly=1;
                case 19
                    date='141218_B3_aston';
                    setElectrodes=[60 16 59;59 16 60];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 11;11 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=1;
                case 20
                    date='141218_B6_aston';
                    setElectrodes=[40 54 9;9 54 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=35;
                    visualOnly=1;
                case 21
                    date='171218_B2_aston';
                    setElectrodes=[51 62 17;17 62 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 13 13;13 13 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=36;
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
%         for condInd=1:size(setElectrodes,1)
%             chRFs=[];
%             for chInd=1:size(setElectrodes,2)
%                 electrode=setElectrodes(condInd,chInd);
%                 array=setArrays(condInd,chInd);
%                 instance=ceil(array/2);
%                 temp1=find(channelNums(:,instance)==electrode);
%                 temp2=find(arrayNums(:,instance)==array);
%                 ind=intersect(temp1,temp2);
%                 load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat']);
%                 chRFs(chInd,:)=channelRFs(ind,1:2);
%             end
%             plot(chRFs(:,1),chRFs(:,2),'-')
%             hold on
%         end
    end
end
save('D:\aston_data\list_motion_datesM','allDatesM');
save('D:\aston_data\list_motion_datesV','allDatesV');
%bad sets: 7 9