function saccade_endpoints_aston_current_thresholding
%Written by Xing 7/6/19
%During tasks carried out in 221018_B1_aston & 241018_B2_aston, in which
%electrode identities were systematically interleaved, obtained 
%good saccade responses on very few channels on arrays 9 and 10. Hence, use
%current thresholding data from several other recording sessions, with good
%current thresholding data on arrays 9 and 10, to supplement sessions where
%saccade task was systematically carried out.

localDisk=0;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end
% figure;
% hold on
uiopen('D:\aston_data\results\saccade_endpoints_221018_B1_241018_B2_base.fig',1)
colind = hsv(16);
colind(8,:)=[139/255 69/255 19/255];
electrodeAllTrials=[];
arrayAllTrials=[];
saccadeEndAllTrials=[];
for sessionInd=1:3
    switch(sessionInd)
        case 1
            date='250918_B1_aston';
            electrodesInterest=[25 45 57 5 16 48 52];
            arraysInterest=[9 9 9 10 10 10 10];
        case 2
            date='270918_B1_aston';
            electrodesInterest=[15 23 40];
            arraysInterest=[9 10 10];
        case 3
            date='280918_B1_aston';
            electrodesInterest=[16 55 56 63];
            arraysInterest=[10 10 10 10];
        case 4
            date='171018_B1_aston';
            electrodesInterest=[54 60];
            arraysInterest=[10 10];
    end
    
    switch(date)        
        case '250918_B1_aston'
            electrodeNums1=[45 25 57];
            arrayNums1=9*ones(1,length(electrodeNums1));
            electrodeNums2=[23 52 64 51 5 16 56 46 63 38 40 48 55];
            arrayNums2=10*ones(1,length(electrodeNums2));
            electrodeNums3=[6 16 47 26 23 52 28 7 33 13 53];
            arrayNums3=12*ones(1,length(electrodeNums3));
            electrodeNums=[electrodeNums1 56 electrodeNums2 electrodeNums3];
            arrayNums=[arrayNums1 13 arrayNums2 arrayNums3];
            visualOnly=0;
            degPerVoltXFinal=0.0025;%guess- not measured on same day
            degPerVoltYFinal=0.0025;
        case '270918_B1_aston'
            electrodeNums=[43 34 36 62 48];
            arrayNums=16*ones(1,length(electrodeNums));
            electrodeNums=[electrodeNums 17 25 26 42 49 12 13 36 39 59 51 28 25 54 58 30 12 19 49 60 61 4 27 35];
            arrayNums=[arrayNums 11 11 11 11 11 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13];
            electrodeNums=[electrodeNums 15 51 23 38 40 46 55 56 63 28 52 16];
            electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
            arrayNums=[arrayNums 9 10 10 10 10 10 10 10 10 12 12 10];
            arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
            visualOnly=0;
            degPerVoltXFinal=0.0025;%guess- not measured on same day
            degPerVoltYFinal=0.0025;
        case '280918_B1_aston'
            electrodeNums=[55 56 63 28 52 16];
            arrayNums=[10 10 10 12 12 10];
            electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
            arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
            visualOnly=0;
            degPerVoltXFinal=0.0025;%guess- not measured on same day
            degPerVoltYFinal=0.0025;
    end
    for electrodeInd=1:length(electrodesInterest)
        electrodeInterest=electrodesInterest(electrodeInd);
        arrayInterest=arraysInterest(electrodeInd);
        temp1=find(electrodeNums==electrodeInterest);
        temp2=find(arrayNums==arrayInterest);
        originalElectrodeInd=intersect(temp1,temp2);
        load(['X:\aston\',date,'\saccade_data_',date,'_fix_to_rew.mat'])
        dataDir=[rootdir,date,'\',date,'_data'];
        matFile=[dataDir,'\microstim_saccade_',date,'.mat'];
        load(matFile);
        trialsElectrodeInterest=trialNoChs{originalElectrodeInd};%identify trials for that channel
        currentAmpElectrodeInterest=allCurrentLevel(trialsElectrodeInterest);
        maxCurrentTrialsInd=find(currentAmpElectrodeInterest==max(currentAmpElectrodeInterest))%identify trials where the highest current amplitudes were delivered (manual selection of channels already ensured that performance was 1, during condition where current amplitude is highest)
        posXinterest=posIndXChs{originalElectrodeInd}(maxCurrentTrialsInd);
        posYinterest=posIndYChs{originalElectrodeInd}(maxCurrentTrialsInd);
        for i=1:length(posXinterest)
            plot(posXinterest(i),-posYinterest(i),'MarkerEdgeColor',colind(arrayInterest,:),'Marker','d','MarkerFaceCol',colind(arrayInterest,:),'MarkerSize',3);
%             plot(posXinterest(i),-posYinterest(i),'MarkerEdgeColor',colind(arrayInterest,:),'Marker','o','MarkerFaceCol',colind(arrayInterest,:));
            electrodeAllTrials=[electrodeAllTrials;electrodeInterest];
            arrayAllTrials=[arrayAllTrials;arrayInterest];
            saccadeEndAllTrials=[saccadeEndAllTrials;posXinterest(i) posYinterest(i)];%combine position data across trials and channels
        end
    end
end
%figure saved as: D:\aston_data\results\saccade_endpoints_221018_B1_241018_B2_supp_diamonds_nonums
save('D:\aston_data\results\supplementary_chs_250918-280918.mat','electrodeAllTrials','arrayAllTrials','saccadeEndAllTrials');