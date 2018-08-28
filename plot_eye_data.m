function plot_eye_data
%Written by Xing 7/7/17
%Plot X and Y channels for each target response condition during
%simphosphenes task (visually presented stimulated phosphene letters with 4
%target locations).
date='050717_B2';
date='110717_B2';
% load(['D:\data\',date,'\timeStimOnsMatch.mat'])%read in timeStimOnsMatch
% load(['D:\data\',date,'\performanceMatch.mat'],'performanceMatch')
% load(['D:\data\',date,'\goodTrialCondsMatch.mat'],'goodTrialCondsMatch')
load(['D:\data\',date,'\MUA_instance1_ch1_downsample.mat'],'timeStimOnsMatch','performanceMatch','goodTrialCondsMatch')

downSampling=0;

stimDurms=800;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;
allLetters='IUALTVSYJ?';

for eyeCh=129:130
    readChannel=['c:',num2str(eyeCh),':',num2str(eyeCh)];
    NSchOriginal=openNSx(['D:\data\',date,'\instance1.ns6'],'read',readChannel);
    save(['D:\data\',date,'\MUA_instance1_ch',num2str(eyeCh),'.mat'],'NSchOriginal');
%     load(['D:\data\',date,'\MUA_instance1_ch',num2str(eyeCh),'.mat']);
    channelDataMUA=NSchOriginal.Data;
%         load(['D:\data\',date,'\MUA_instance1_ch',num2str(eyeCh),'.mat']);
    
    figure
    hold on;
    trialData=[];
    for i=1:length(timeStimOnsMatch)
        startPoint=timeStimOnsMatch(i);
        trialData(i,:)=channelDataMUA(startPoint-sampFreq*preStimDur:startPoint+sampFreq*stimDur+sampFreq*(postStimDur+1)-1);%raw data in uV, read in data during stimulus presentation
%         trialData(i,:)=channelDataMUA(startPoint-sampFreq*preStimDur-sampFreq*stimDur:startPoint+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
        %     trialData(i,:)=channelDataMUA(startPoint-sampFreq*preStimDur:startPoint+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
        if performanceMatch(i)==1
            plot(trialData(i,:),'g');
        elseif performanceMatch(i)==-1
            plot(trialData(i,:),'r');
        end
    end
    set(gca,'XTick',[0 sampFreq*preStimDur sampFreq*(preStimDur+stimDur)]);
    set(gca,'XTickLabel',{num2str(-preStimDur*1000),'0',num2str(stimDurms)});
    
    figure
    hold on;
    trialData=[];
    for i=1:length(timeStimOnsMatch)
        if goodTrialCondsMatch(i,1)==1||goodTrialCondsMatch(i,1)==5
            subplot(2,2,1);hold on
            title('left')
        elseif goodTrialCondsMatch(i,1)==2||goodTrialCondsMatch(i,1)==6
            subplot(2,2,2);hold on
            title('right')
        elseif goodTrialCondsMatch(i,1)==3||goodTrialCondsMatch(i,1)==7
            subplot(2,2,3);hold on
            title('top')
        elseif goodTrialCondsMatch(i,1)==4||goodTrialCondsMatch(i,1)==8
            subplot(2,2,4);hold on
            title('bottom')
        end
        startPoint=timeStimOnsMatch(i);
        trialData(i,:)=channelDataMUA(startPoint-sampFreq*preStimDur:startPoint+sampFreq*stimDur+sampFreq*(postStimDur+1)-1);%raw data in uV, read in data during stimulus presentation
%         trialData(i,:)=channelDataMUA(startPoint-sampFreq*preStimDur:startPoint+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
        %     trialData(i,:)=channelDataMUA(startPoint-sampFreq*preStimDur:startPoint+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
        if performanceMatch(i)==1
            plot(trialData(i,:),'g');
        elseif performanceMatch(i)==-1
            plot(trialData(i,:),'r');
        end
    end
    for i=1:4
        subplot(2,2,i);hold on
        ax=get(gca,'ylim');
        set(gca,'XTick',[0 sampFreq*preStimDur sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur+postStimDur)]);
        set(gca,'XTickLabel',{num2str(-preStimDur*1000),'0',num2str(stimDur*1000),num2str(1000*(stimDur+postStimDur))});
        plot([sampFreq*preStimDur sampFreq*preStimDur],[ax(1) ax(2)],'k:')
        plot([sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur)],[ax(1) ax(2)],'k:')
        plot([sampFreq*(preStimDur+stimDur+postStimDur) sampFreq*(preStimDur+stimDur+postStimDur)],[ax(1) ax(2)],'k:')
    end
end
pause=1;