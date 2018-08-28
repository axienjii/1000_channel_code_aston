function analyse_microstim_responses4_feng
%Written by Xing 05/12/17 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end

% date='010518_B1';
% setElectrodes=[{[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]} {[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
% setArrays=[{[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]} {[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2} setElectrodes{3} setElectrodes{4}];
% arrayNums=[setArrays{1} setArrays{2} setArrays{3} setArrays{4}];
% date='010518_B3';
% electrodeNums=[39 56 7 38 51 28 32];
% arrayNums=[10 10 12 13 13 16 16];
% date='010518_B5';
% electrodeNums=[39 51];
% arrayNums=[10 13];
% date='020518_B1';
% setElectrodes=[{[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
% setArrays=[{[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='020518_B2';
% setElectrodes=[{[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
% setArrays=[{[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='020518_B5';
% electrodeNums=[5 33 36 23];
% arrayNums=[12 12 16 10];
% date='030518_B2';
% setElectrodes=[{[48 15]}];%010518_B & B
% setArrays=[{[9 12]}];
% electrodeNums=[setElectrodes{1}];
% arrayNums=[setArrays{1}];
% date='030518_B3';
% setElectrodes=[{[39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
% setArrays=[{[14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='030518_B4';
% setElectrodes=[{[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
% setArrays=[{[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='030518_B5';
% electrodeNums=[29 54];
% arrayNums=[14 14];
% date='030518_B6';
% electrodeNums=[32 31 58];
% arrayNums=[10 13 13];
% date='040518_B1';
% setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
% setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='070518_B1';
% setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]} {[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
% setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]} {[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2} setElectrodes{3} setElectrodes{4}];
% arrayNums=[setArrays{1} setArrays{2} setArrays{3} setArrays{4}];
% date='070518_B3';
% electrodeNums=[50 31 60 34 37 48 48];
% arrayNums=[8 10 10 11 12 13 15];
% date='070518_B4';
% electrodeNums=[37 48];
% arrayNums=[12 15];
% date='080518_B1';
% setElectrodes=[{[27 19 20 46 11 44 34]}];%010518_B & B
% setArrays=[{[9 12 12 14 8 8 13]}];
% date='080518_B2';
% setElectrodes=[{[5 42 25]} {[7 28 30 10 40 43 56 15 3 21]} {[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
% setArrays=[{[10 10 12]} {[15 15 13 13 10 10 10 10 11 11]} {[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2} setElectrodes{3} setElectrodes{4}];
% arrayNums=[setArrays{1} setArrays{2} setArrays{3} setArrays{4}];
% date='080518_B5';
% electrodeNums=[11 34 3];
% arrayNums=[8 13 11];
% date='090518_B1';
% setElectrodes=[{[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]} {[28 49 62 63 7 8 61 20 35 55]} {[63 5 56 35 36 55 55 48 22 62]}];%010518_B & B
% setArrays=[{[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]} {[10 13 15 15 15 11 10 10 13 13]} {[15 15 13 13 13 10 11 11 11 11]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2} setElectrodes{3} setElectrodes{4}];
% arrayNums=[setArrays{1} setArrays{2} setArrays{3} setArrays{4}];
% date='090518_B3';
% electrodeNums=[28 48 35 56 15];
% arrayNums=[10 10 13 13 15];
% date='140518_B1';
% electrodeNums=[57 22 1 9 5];
% arrayNums=[8 8 8 8 9];
% date='140518_B2';
% electrodeNums=[23 31 28 51 5 23 59 11 4 60 18 30 25 32 33 50 41 37 58 27 4 5 28 36];
% arrayNums=[10 10 10 11 12 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 15 15 16 16];
% date='140518_B4';
% electrodeNums=[57 23 51 4 59 27 33 41];
% arrayNums=[8 10 11 12 12 13 13 13];
% date='140518_B5';
% electrodeNums=[57 4 59];
% arrayNums=[8 12 12];
% date='140518_B6';
% electrodeNums=[57 59];
% arrayNums=[8 12];
% date='140518_B10';
% electrodeNums=[1 44 9 26 19 63 47 38 8 28 13 36 45 21 25 59 37 57 41 21 24 25 64 40 3 49 51 1 8 9 17 12 13 61 22 3 26 60 42 54 36 63 37 36 53 55 40 57 47 13 2 25];
% arrayNums=[9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 10 10 10 10 11 11 11 11 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 13 13 14 14 14 14 15 15 16 16 16 16 16];
% date='150518_B2';
% electrodeNums=[51 1 8 9 17 12 13 61 22 3 26 60 42 54 36 63 37 36 53 55 40 57 47 13 2 25];
% arrayNums=[12 12 12 12 12 13 13 13 13 13 13 13 13 13 13 14 14 14 14 15 15 16 16 16 16 16];
% date='150518_B4';
% electrodeNums=[8 59 3 49];
% arrayNums=[9 10 12 12];
% date='150518_B5';
% electrodeNums=[17 12 61 36 25];
% arrayNums=[12 13 13 14 16];
% date='290518_B3';
% electrodeNums=[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42];%280518_B & B?
% arrayNums=[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10];
% date='290518_B4';
% setElectrodes=[{[31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
% setArrays=[{[10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='290518_B6';
% electrodeNums=[27 30 31 34 42 5];%280518_B & B?
% arrayNums=[8 12 10 10 10 12];
% date='040618_B1';
% setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
% setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='040618_B2';
% setElectrodes=[{[46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
% setArrays=[{[10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='040618_B5';
% electrodeNums=[32 46 30 36 33 34];
% arrayNums=[13 10 12 12 13 10];
% date='040618_B9';
% electrodeNums=[30];
% arrayNums=[12];
% date='070618_B1';
% electrodeNums=[52 50 48];
% arrayNums=[8 8 15];
% date='070618_B2';
% setElectrodes=[{[52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]} {[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
% setArrays=[{[8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]} {[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2} setElectrodes{3} setElectrodes{4}];
% arrayNums=[setArrays{1} setArrays{2} setArrays{3} setArrays{4}];
% date='070618_B3';
% setElectrodes=[{[28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
% setArrays=[{[9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
% electrodeNums=[setElectrodes{1} setElectrodes{2}];
% arrayNums=[setArrays{1} setArrays{2}];
% date='140618_B1';
% electrodeNums=[56 52 25 42 33 6 32 16 27 1 41];
% arrayNums=[16 8 12 12 13 14 14 16 8 9 13];
% date='140618_B3';
% electrodeNums=[42];
% arrayNums=[12];

finalCurrentValsFile=7;
% copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
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