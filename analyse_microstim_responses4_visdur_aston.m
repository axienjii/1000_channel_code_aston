function analyse_microstim_responses4_visdur_aston
%Written by Xing 17/7/19 to calculate hits, misses, false alarms, and
%correct rejections during microstim task with varying duration of the visual stimulus per condition.
%Load in .mat file recorded on stimulus
%presentation computer, from server. 

close all
localDisk=1;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end

date='170719_B7';%no catch trials
electrodeNums=[1 1 3 16 44 26 33 9 63 34];
arrayNums=[8 9 9 10 11 12 13 14 15 16];

date=[date,'_aston'];
finalCurrentValsFile=7;
% % copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% % copyfile(['D:\data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
if exist('allCatchTrial','var')
    visualAllHitTrials=intersect(find(performance==1),find(allCatchTrial==0));
    visualAllMissTrials=intersect(find(performance==-1),find(allCatchTrial==0));
    catchAllCRTrials=intersect(find(allCatchTrial==1),find(performance==1));%correct rejections
    catchAllFATrials=find(allFalseAlarms==1);%false alarms
else
    visualAllHitTrials=find(performance==1);
    visualAllMissTrials=find(performance==-1);
    catchAllCRTrials=[];
    catchAllFATrials=[];
end
correctRejections=length(catchAllCRTrials);
falseAlarms=length(catchAllFATrials);
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
    durs=[];
    hits=[];
    misses=[];    
    durTrials=allStimDur(uniqueElectrodeTrials);
    stimDurs=unique(durTrials);
    for durCond=1:length(stimDurs)
        stimDur=stimDurs(durCond);
        stimDurTrials=find(allStimDur==stimDur);
        if ~isempty(stimDurTrials)
            temp3=intersect(microstimAllHitTrials,stimDurTrials);
            temp4=intersect(temp3,uniqueElectrodeTrials);
            hits=[hits length(temp4)];
            temp5=intersect(microstimAllMissTrials,stimDurTrials);
            temp6=intersect(temp5,uniqueElectrodeTrials);
            misses=[misses length(temp6)];
            durs=[durs stimDur];
        end
    end
    hits./misses;
    for Weibull=0:1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
        figure('Name','Psychometric function')
        [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(durs,hits,misses,falseAlarms,correctRejections,Weibull);
        hold on
        yLimits=get(gca,'ylim');
        plot([threshold threshold],yLimits,'r:')
        plot([theta theta],yLimits,'k:')
        %     text(threshold-10,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' pulses'],'FontSize',12,'Color','k');
        ylabel('proportion of trials');
        xlabel('number of pulses per train');
        if Weibull==1
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', Weibull fit.'])
            pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_number_pulses_weibull']);
        elseif Weibull==0
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', sigmoid fit.'])
            pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_number_pulses_sigmoid']);
        end
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        thresholds(uniqueElectrode,Weibull+1)=threshold;
        thresholds(uniqueElectrode,Weibull+2)=electrode;
        thresholds(uniqueElectrode,Weibull+3)=array;
    end
end
save([rootdir,date,'\',date,'_thresholds.mat'],'thresholds');