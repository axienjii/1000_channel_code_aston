function analyse_microstim_letter_100_trials_aston(date)
%9/8/19
%Written by Xing, reads out behavioural performance during first hundred
%trials for original letter task, for comparison with control task (both
%visual and microstim versions).
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
perfSessionsV=[];
perfSessionsM=[];
analyseConds=0;
for calculateVisual=[0 1]
    for setNo=3:12%3:12%1 to 4 use 10 electrodes per letter; subsequent sessions use 8 electrodes per letter
        %sets 8 to 12 reuse previous electrodes in new combinations
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
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    
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
        end
        
        if localDisk==1
            rootdir='D:\aston_data\';
        elseif localDisk==0
            rootdir='X:\aston\';
        end
        initialPerfTrials=100;
        if calculateVisual==0
            perfMicroBin=[];
            load(['D:\aston_data\perf_mat\microPerf_',date,'.mat'],'perfMicroBin');
            perfSessionsM=[perfSessionsM mean(perfMicroBin)];
        elseif calculateVisual==1
            perfVisualBin=[];
            load(['D:\aston_data\perf_mat\visualPerf_',date,'.mat'],'perfVisualBin');
            perfSessionsV=[perfSessionsV mean(perfVisualBin)];
        end        
    end
end
figure;
subplot(2,2,1);
edges=0:0.1:1;
mean(perfSessionsV)%original letter task, visual
h1=histogram(perfSessionsV,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
yLim=get(gca,'ylim');
plot([0.5 0.5],[0 yLim(2)+1],'k:');
xlim([0 1]);
% ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(perfSessionsV,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = 41.9156, p = 0.0000
% title('original, visual')

subplot(2,2,2);
edges=0:0.1:1;
mean(perfSessionsM)%original letter task, micro
h1=histogram(perfSessionsM,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
yLim=get(gca,'ylim');
plot([0.5 0.5],[0 yLim(2)+1],'k:');
xlim([0 1]);
% ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(perfSessionsM,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = 2.1995, p = 0.0554
title('original, micro')

load('D:\aston_data\control_letter_behavioural_performance_all_sets_080819_B2_aston_100trials.mat')
subplot(2,2,3);
edges=0:0.1:1;
mean(meanPerfAllSetsV)%control letter task, visual
h1=histogram(meanPerfAllSetsV,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
yLim=get(gca,'ylim');
plot([0.5 0.5],[0 yLim(2)+1],'k:');
xlim([0 1]);
% ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(meanPerfAllSetsV,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = -0.025097, p = 0.9805
title('control, visual')

subplot(2,2,4);
edges=0:0.1:1;
mean(meanPerfAllSetsM)%control letter task, micro
h1=histogram(meanPerfAllSetsM,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
yLim=get(gca,'ylim');
plot([0.5 0.5],[0 yLim(2)+1],'k:');
xlim([0 1]);
% ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(meanPerfAllSetsM,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = -0.95471, p = 0.3647
title('control, micro')

%compare original letter task with control task (micro):
[h,p,ci,stats]=ttest2(meanPerfAllSetsV,perfSessionsV)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = -10.5207, p = 0.0000
[h,p,ci,stats]=ttest2(meanPerfAllSetsM,perfSessionsM)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = -2.3888, p = 0.0281

% title(['performance across the session, on visual (blue) & microstim (red) trials']);
pathname=['D:\aston_data\letter_behavioural_performance_original_vs_control_',date,'_',num2str(initialPerfTrials),'trials_highres'];
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff');

perfMat=['D:\aston_data\letter_behavioural_performance_original_vs_control_',date,'_',num2str(initialPerfTrials),'trials.mat'];
save(perfMat,'perfSessionsV','perfSessionsM','meanPerfAllSetsV','meanPerfAllSetsM');
pause=1;
