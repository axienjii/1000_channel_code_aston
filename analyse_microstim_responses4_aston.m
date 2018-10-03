function analyse_microstim_responses4_aston
%Written by Xing 11/9/18 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
localDisk=1;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end

% date='110918_B3';
% electrodeNums=[33];
% arrayNums=[13];
% date='110918_B5';
% electrodeNums=[24];
% arrayNums=[13];
% date='110918_B6';
% electrodeNums=[62];
% arrayNums=[13];
% date='110918_B7';
% electrodeNums=[7];
% arrayNums=[13];
% date='110918_B8';
% electrodeNums=[57];
% arrayNums=[13];
% date='110918_B9';
% electrodeNums=[33];
% arrayNums=[13];
% date='120918_B1';
% electrodeNums=[40 55 44 43 16 6 48 32 15 17 20 51];
% arrayNums=13*ones(1,length(electrodeNums));
% date='130918_B1';
% electrodeNums=[51 28 5];
% arrayNums=13*ones(1,length(electrodeNums));
% date='140918_B1';
% electrodeNums=[25];
% arrayNums=13*ones(1,length(electrodeNums));
% date='140918_B2';
% electrodeNums=[51 28 5 56 58 25 46 54 30 3 60 61];
% arrayNums=13*ones(1,length(electrodeNums));
% date='180918_B1';
% electrodeNums=[56 58 46 54];
% arrayNums=13*ones(1,length(electrodeNums));
% date='180918_B2';
% electrodeNums=[58 46 54 30];
% arrayNums=13*ones(1,length(electrodeNums));
% date='180918_B3';
% electrodeNums=[30];
% arrayNums=13*ones(1,length(electrodeNums));
% date='190918_B1';
% electrodeNums=[60 61 30 3 35 4 1 27 49 19 12 10 50 36 39 13 59 52];
% arrayNums=13*ones(1,length(electrodeNums));
% date='190918_B2';
% electrodeNums=[60 61 30 3 35 4 1 27 49 19 12 10 50 36 39 13 59 52];
% arrayNums=13*ones(1,length(electrodeNums));
% date='200918_B1';
% electrodeNums1=[12 10 50 36 39 13 59 52];
% arrayNums1=13*ones(1,length(electrodeNums1));
% electrodeNums2=[57 59 44 55 25 61 49 42 62 2 64 52 48 58 46 26 9 17 1 51 47 50 13 10 18 43 41];
% arrayNums2=11*ones(1,length(electrodeNums2));
% electrodeNums=[electrodeNums1 electrodeNums2];
% arrayNums=[arrayNums1 arrayNums2];
% date='210918_B1';
% electrodeNums1=[17 1 51 47 50 13 10 18 43 41];
% arrayNums1=11*ones(1,length(electrodeNums1));
% electrodeNums2=[3 49 23 50 58 63 8 4 16 30 29 15 1 62 28 22 38 7 54 59 45 25 57];
% arrayNums2=9*ones(1,length(electrodeNums2));
% electrodeNums=[electrodeNums1 electrodeNums2 56];
% arrayNums=[arrayNums1 arrayNums2 13];
% date='240918_B1';
% electrodeNums1=[62 28 22 38 7 54 59 45 25 57];
% arrayNums1=9*ones(1,length(electrodeNums1));
% date='250918_B1';
% electrodeNums1=[45 25 57];
% arrayNums1=9*ones(1,length(electrodeNums1));
% electrodeNums2=[23 52 64 51 5 16 56 46 63 38 40 48 55];
% arrayNums2=10*ones(1,length(electrodeNums2));
% electrodeNums3=[6 16 47 26 23 52 28 7 33 13 53];
% arrayNums3=12*ones(1,length(electrodeNums3));
% electrodeNums=[electrodeNums1 56 electrodeNums2 electrodeNums3];
% arrayNums=[arrayNums1 13 arrayNums2 arrayNums3];
% date='260918_B1';
% electrodeNums3=53;
% arrayNums3=12;
% electrodeNums4=[21 16 48 59 30 64 63 35 9 51 62 12 24 56 50 42];
% arrayNums4=14*ones(1,length(electrodeNums4));
% electrodeNums5=[6 24 16 8 15 7 27 44 32 63 1 3 21 39 40 46 13 55 33 64 4 62 56 23 14 22 48 38 49];
% arrayNums5=15*ones(1,length(electrodeNums5));
% electrodeNums6=[56 41 17 33 19 22 23 32 55 64 45 49 46 3 50 42 40 44 26 7 58 60 52 43];
% arrayNums6=16*ones(1,length(electrodeNums6));
% electrodeNums=[electrodeNums3 electrodeNums4 electrodeNums5 electrodeNums6];
% arrayNums=[arrayNums3 arrayNums4 arrayNums5 arrayNums6];
% date='270918_B1';
% electrodeNums=[43 34 36 62 48];
% arrayNums=16*ones(1,length(electrodeNums));
% electrodeNums=[electrodeNums 17 25 26 42 49 12 13 36 39 59 51 28 25 54 58 30 12 19 49 60 61 4 27 35];
% arrayNums=[arrayNums 11 11 11 11 11 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13];
% electrodeNums=[electrodeNums 15 51 23 38 40 46 55 56 63 28 52 16];
% electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
% arrayNums=[arrayNums 9 10 10 10 10 10 10 10 10 12 12 10];
% arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
date='280918_B1';
electrodeNums=[55 56 63 28 52 16];
arrayNums=[10 10 10 12 12 10];
electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];


date=[date,'_aston'];
finalCurrentValsFile=7;
% copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
setFalseAlarmZero=1;
if setFalseAlarmZero==1
    falseAlarms=0;
end
allElectrodeNums=cell2mat(allElectrodeNum);
allArrayNums=cell2mat(allArrayNum);
for uniqueElectrode=1:length(electrodeNums)
    array=arrayNums(uniqueElectrode);
    electrode=electrodeNums(uniqueElectrode);
    temp1=find(allElectrodeNums==electrode);
    temp2=find(allArrayNums==array);
    uniqueElectrodeTrials=intersect(temp1,temp2);
    if finalCurrentValsFile==2%staircase procedure was used, finalCurrentVals3.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals3.mat'])
    elseif finalCurrentValsFile==3%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals4.mat'])
    elseif finalCurrentValsFile==4%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals5.mat'])
    elseif finalCurrentValsFile==5%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals6.mat'])
    elseif finalCurrentValsFile==6%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals7.mat'])
    elseif finalCurrentValsFile==7%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals8.mat'])
    end
    currentAmplitudes=[];
    hits=[];
    misses=[];    
    currentAmpTrials=allCurrentLevel(uniqueElectrodeTrials);
    uniqueCurrentAmp=unique(currentAmpTrials);
    for currentAmpCond=1:length(uniqueCurrentAmp)
        currentAmplitude=uniqueCurrentAmp(currentAmpCond);
        currentAmpTrials=find(allCurrentLevel==currentAmplitude);
        if ~isempty(currentAmpTrials)
            temp3=intersect(microstimAllHitTrials,currentAmpTrials);
            temp4=intersect(temp3,uniqueElectrodeTrials);
            hits=[hits length(temp4)];
            temp5=intersect(microstimAllMissTrials,currentAmpTrials);
            temp6=intersect(temp5,uniqueElectrodeTrials);
            misses=[misses length(temp6)];
            currentAmplitudes=[currentAmplitudes currentAmplitude];
        end
    end
    hits./misses;
    for Weibull=0:1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
        [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
        hold on
        yLimits=get(gca,'ylim');
        plot([threshold threshold],yLimits,'r:')
        plot([theta theta],yLimits,'k:')
        %     text(threshold-10,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        ylabel('proportion of trials');
        xlabel('current amplitude (uA)');
        if Weibull==1
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', Weibull fit.'])
            pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_weibull']);
        elseif Weibull==0
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', sigmoid fit.'])
            pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_sigmoid']);
        end
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        thresholds(uniqueElectrode,Weibull+1)=threshold;
        thresholds(uniqueElectrode,Weibull+2)=electrode;
        thresholds(uniqueElectrode,Weibull+3)=array;
    end
end
save([rootdir,date,'\',date,'_thresholds.mat'],'thresholds');