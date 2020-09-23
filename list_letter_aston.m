function list_letter_aston(date)
%11/11/19
%Written by Xing, makes list of data folders corresponding to a
%microstimulation/visual letter task.

load('D:\aston_data\channel_area_mapping_aston.mat')
setNos=3:12;
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
                case 3
                    date='290119_B3_aston';
                    setElectrodes=[{[32 62 52 51 50 56 64 53 55 27]} {[40 48 62 27 2 51 50 56 64 53]}];%020119_B & B?
                    setArrays=[{[16 13 13 13 13 11 11 12 12 16]} {[16 16 16 16 16 13 13 11 11 12]}];
                    setInd=3;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=57;
                    visualOnly=0;
                case 4
                    date='040219_B4_aston';
                    setElectrodes=[{[40 53 32 30 21 49 57 47 50 9]} {[51 55 52 9 17 54 30 16 16 55]}];%040119_B & B?
                    setArrays=[{[16 13 14 14 14 13 13 12 14 16]} {[16 16 16 16 16 13 14 12 14 12]}];
                    setInd=4;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=60;
                    visualOnly=0;
                case 5
                    date='050219_B8_aston';
                    setElectrodes=[{[31 55 62 52 34 24 56 49]} {[51 32 62 52 30 24 9 53]}];%05119_B & B?
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 14 12]}];
                    setInd=5;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=61;
                    visualOnly=0;
                case 6
                    date='070219_B3_aston';
                    setElectrodes=[{[32 47 41 27 2 35 9 64]} {[31 40 53 51 50 16 64 47]}];%060119_B & B?
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 13 13 13 12 11 12]}];
                    setInd=6;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=62;
                    visualOnly=0;
                case 7
                    date='080219_B10_aston';
                    setElectrodes=[{[40 48 44 9 17 8 12 57]} {[48 47 32 60 59 8 57 55]}];%080219_B8 & B10
                    setArrays=[{[16 16 16 16 16 14 14 13]} {[16 16 14 13 13 14 14 12]}];
                    setInd=7;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=64;
                    visualOnly=0;
                case 8
                    date='110219_B6_aston';
                    setElectrodes=[{[31 47 44 52 2 12 16 64]} {[51 40 32 52 50 56 9 47]}];%110219_B6 & B8
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 14 13 13 11 14 12]}];
                    setInd=8;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=65;
                    visualOnly=0;
                case 9
                    date='140219_B3_aston';
                    setElectrodes=[{[51 55 41 9 34 59 16 50]} {[51 32 53 54 30 16 12 53]}];%00219_B & B?
                    setArrays=[{[16 16 16 16 16 13 12 13]} {[16 16 13 13 14 12 14 12]}];
                    setInd=9;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=69;
                    visualOnly=0;
                case 10
                    date='120219_B6_aston';
                    setElectrodes=[{[32 48 62 27 17 9 63 57]} {[31 47 62 51 21 24 64 55]}];%120219_B2 & B6
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 11 12]}];
                    setInd=10;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=67;
                    visualOnly=0;
                case 11
                    date='180219_B10_aston';
                    setElectrodes=[{[51 32 52 30 50 9 47 17]} {[51 55 41 17 30 24 9 53]}];%180219_B & B
                    setArrays=[{[16 14 13 14 13 14 12 16]} {[16 16 16 16 14 14 14 12]}];
                    setInd=11;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=71;
                    visualOnly=0;
                case 12
                    date='190219_B9_aston';
                    setElectrodes=[{[31 32 61 24 9 55 50 2]} {[31 44 52 2 32 59 12 47]}];%00219_B & B?
                    setArrays=[{[16 14 13 14 14 12 14 16]} {[16 16 16 16 14 13 14 12]}];
                    setInd=12;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=72;
                    visualOnly=0;
            end
            allDatesM=[allDatesM;{date}];
            %visual task only:
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 3
                    date='280119_B2_aston';
                    setElectrodes=[{[32 62 52 51 50 56 64 53 55 27]} {[40 48 62 27 2 51 50 56 64 53]}];%020119_B & B?
                    setArrays=[{[16 13 13 13 13 11 11 12 12 16]} {[16 16 16 16 16 13 13 11 11 12]}];
                    setInd=3;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=56;
                    visualOnly=1;
                case 4
                    date='040219_B2_aston';
                    setElectrodes=[{[40 53 32 30 21 49 57 47 50 9]} {[51 55 52 9 17 54 30 16 16 55]}];%040119_B & B?
                    setArrays=[{[16 13 14 14 14 13 13 12 14 16]} {[16 16 16 16 16 13 14 12 14 12]}];
                    setInd=4;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=60;
                    visualOnly=1;
                case 5
                    date='060219_B6_aston';
                    setElectrodes=[{[31 55 62 52 34 24 56 49]} {[51 32 62 52 30 24 9 53]}];%050219_B8 & 060219_B6
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 14 12]}];
                    setInd=5;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=61;
                    visualOnly=1;
                case 6
                    date='060219_B7_aston';
                    setElectrodes=[{[32 47 41 27 2 35 9 64]} {[31 40 53 51 50 16 64 47]}];%060119_B & B?
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 13 13 13 12 11 12]}];
                    setInd=6;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=62;
                    visualOnly=1;
                case 7
                    date='080219_B8_aston';
                    setElectrodes=[{[40 48 44 9 17 8 12 57]} {[48 47 32 60 59 8 57 55]}];%080219_B8 & B10
                    setArrays=[{[16 16 16 16 16 14 14 13]} {[16 16 14 13 13 14 14 12]}];
                    setInd=7;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=64;
                    visualOnly=1;
                case 8
                    date='110219_B4_aston';
                    setElectrodes=[{[31 47 44 52 2 12 16 64]} {[51 40 32 52 50 56 9 47]}];%110219_B6 & B8
                    setArrays=[{[16 16 16 16 16 14 14 11]} {[16 16 14 13 13 11 14 12]}];
                    setInd=8;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=65;
                    visualOnly=1;
                case 9
                    date='130219_B2_aston';
                    setElectrodes=[{[51 55 41 9 34 59 16 50]} {[51 32 53 54 30 16 12 53]}];%120219_B2 & 130219_B3
                    setArrays=[{[16 16 16 16 16 13 12 13]} {[16 16 13 13 14 12 14 12]}];
                    setInd=9;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=69;
                    visualOnly=1;
                case 10
                    date='120219_B2_aston';
                    setElectrodes=[{[32 48 62 27 17 9 63 57]} {[31 47 62 51 21 24 64 55]}];%00219_B & B?
                    setArrays=[{[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 11 12]}];
                    setInd=10;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=67;
                    visualOnly=1;
                case 11
                    date='180219_B8_aston';
                    setElectrodes=[{[51 32 52 30 50 9 47 17]} {[51 55 41 17 30 24 9 53]}];%180219_B & B
                    setArrays=[{[16 14 13 14 13 14 12 16]} {[16 16 16 16 14 14 14 12]}];
                    setInd=11;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=71;
                    visualOnly=1;
                case 12
                    date='190219_B7_aston';
                    setElectrodes=[{[31 32 61 24 9 55 50 2]} {[31 44 52 2 32 59 12 47]}];%00219_B & B?
                    setArrays=[{[16 14 13 14 14 12 14 16]} {[16 16 16 16 14 13 14 12]}];
                    setInd=12;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=72;
                    visualOnly=1;
            end
            allDatesV=[allDatesV;{date}];
        end
        chRFs=[];
        for condInd=1:size(setElectrodes,2)
            chRFs=[];
            for chInd=1:length(setElectrodes{condInd})
                electrode=setElectrodes{condInd}(chInd);
                array=setArrays{condInd}(chInd);
                instance=ceil(array/2);
                temp1=find(channelNums(:,instance)==electrode);
                temp2=find(arrayNums(:,instance)==array);
                ind=intersect(temp1,temp2);
                load(['D:\aston_data\best_aston_280818-290818\RFs_instance',num2str(instance),'.mat']);
                chRFs(chInd,:)=channelRFs(ind,1:2);
            end
            if condInd==1
                scatter(chRFs(:,1),chRFs(:,2),'o')
            elseif condInd==2
                scatter(chRFs(:,1),chRFs(:,2),'x')
            end
%             plot(chRFs(:,1),chRFs(:,2),'-')
            ylim([-70 10])
            axis equal
            hold on
            title(setNo);
        end
    end
end
save('D:\aston_data\list_letter_datesM','allDatesM');
save('D:\aston_data\list_letter_datesV','allDatesV');