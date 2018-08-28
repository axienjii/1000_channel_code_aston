function analyse_2phosphene_correlation_cortical_distance
%Written by Xing 23/1/18
%Analyse performance on 2-phosphene orientation task as a function of
%distance between the two electrodes. Converts RF locations into cortical
%coordinates.

minNumTrials=10;
%Data from task with 12-patterns of microstimulation:
load('D:\data\results\220118_2phosphene_cortical_coords_perf.mat')
corticalDistance1=corticalDistance;
meanPerfMicrostimCondTarget1=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget1=numTrialsCondMicrostimTarget;

a=cell2mat(corticalDistance1(:));
allCorticalDistance1=a(:);
b=cell2mat(meanPerfMicrostimCondTarget1(:));
allMeanPerfMicrostimCondTarget1=b(:);
c=cell2mat(numTrialsCondMicrostimTarget1(:));
allNumTrialsCondMicrostimTarget1=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget1<minNumTrials);
allCorticalDistance1(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget1(tooFewTrials)=[];
[r1 p1]=corrcoef(allCorticalDistance1,allMeanPerfMicrostimCondTarget1);
figure;plot(allCorticalDistance1,allMeanPerfMicrostimCondTarget1,'ko');
xlabel('mean eccentricity');
ylabel('performance (proportion correct)');
title(['performance with cortical distance for 2-phosphene task, p=',num2str(p1(1,2))]);

%Data from 2-phosphene and line task, before 12-pattern task:
load('D:\data\results\040118_2phosphene_cortical_coords_perf.mat')
corticalDistance2=corticalDistance;
meanPerfMicrostimCondTarget2=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget2=numTrialsCondMicrostimTarget;

a=cell2mat(corticalDistance2(:));
allCorticalDistance2=a(:);
b=cell2mat(meanPerfMicrostimCondTarget2(:));
allMeanPerfMicrostimCondTarget2=b(:);
c=cell2mat(numTrialsCondMicrostimTarget2(:));
allNumTrialsCondMicrostimTarget2=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget2<minNumTrials);
allCorticalDistance2(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget2(tooFewTrials)=[];
removeNanDist=find(isnan(allCorticalDistance2));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget2));
removeNan=[removeNanDist removeNanPerf];
allCorticalDistance2(removeNan)=[];
allMeanPerfMicrostimCondTarget2(removeNan)=[];
[r2 p2]=corrcoef(allCorticalDistance2,allMeanPerfMicrostimCondTarget2);
figure;plot(allCorticalDistance2,allMeanPerfMicrostimCondTarget2,'ko');
xlabel('mean eccentricity');
ylabel('performance (proportion correct)');
title(['performance with cortical distance for 2-phosphene task, p=',num2str(p2(1,2))]);

%combine datasets:
corticalDistance=[corticalDistance1 corticalDistance2];
meanPerfMicrostimCondTarget=[meanPerfMicrostimCondTarget1 meanPerfMicrostimCondTarget2];
numTrialsCondMicrostimTarget=[numTrialsCondMicrostimTarget1 numTrialsCondMicrostimTarget2];

a=cell2mat(corticalDistance(:));
allCorticalDistance=a(:);
b=cell2mat(meanPerfMicrostimCondTarget(:));
allMeanPerfMicrostimCondTarget=b(:);
removeNanDist=find(isnan(allCorticalDistance));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget));
removeNan=[removeNanDist removeNanPerf];
if ~isempty(removeNan)
    allCorticalDistance(removeNan)=[];
    allMeanPerfMicrostimCondTarget(removeNan)=[];
end

[r p]=corrcoef(allCorticalDistance,allMeanPerfMicrostimCondTarget);
figure;plot(allCorticalDistance,allMeanPerfMicrostimCondTarget,'ko');
xlabel('mean eccentricity');
ylabel('performance (proportion correct)');
title(['performance with cortical distance for 2-phosphene task, p=',num2str(p(1,2))]);

%Carry out analyses using datasets where performance was at least 50%:
clear all
minNumTrials=10;
minPerf=0.4;
%Data from task with 12-patterns of microstimulation:
load('D:\data\220118_2phosphene_cortical_coords_perf.mat')
corticalDistance1=corticalDistance;
meanPerfMicrostimCondTarget1=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget1=numTrialsCondMicrostimTarget;

a=cell2mat(corticalDistance1(:));
allCorticalDistance1=a(:);
b=cell2mat(meanPerfMicrostimCondTarget1(:));
allMeanPerfMicrostimCondTarget1=b(:);
c=cell2mat(numTrialsCondMicrostimTarget1(:));
allNumTrialsCondMicrostimTarget1=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget1<minNumTrials);
allCorticalDistance1(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget1(tooFewTrials)=[];
tooLowPerf=find(allMeanPerfMicrostimCondTarget1<minPerf);
allCorticalDistance1(tooLowPerf)=[];
allMeanPerfMicrostimCondTarget1(tooLowPerf)=[];
[r1 p1]=corrcoef(allCorticalDistance1,allMeanPerfMicrostimCondTarget1);

%Data from 2-phosphene and line task, before 12-pattern task:
load('D:\data\040118_2phosphene_cortical_coords_perf.mat')
corticalDistance2=corticalDistance;
meanPerfMicrostimCondTarget2=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget2=numTrialsCondMicrostimTarget;

a=cell2mat(corticalDistance2(:));
allCorticalDistance2=a(:);
b=cell2mat(meanPerfMicrostimCondTarget2(:));
allMeanPerfMicrostimCondTarget2=b(:);
c=cell2mat(numTrialsCondMicrostimTarget2(:));
allNumTrialsCondMicrostimTarget2=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget2<minNumTrials);
allCorticalDistance2(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget2(tooFewTrials)=[];
tooLowPerf=find(allMeanPerfMicrostimCondTarget2<minPerf);
allCorticalDistance2(tooLowPerf)=[];
allMeanPerfMicrostimCondTarget2(tooLowPerf)=[];
removeNanDist=find(isnan(allCorticalDistance2));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget2));
removeNan=[removeNanDist removeNanPerf];
allCorticalDistance2(removeNan)=[];
allMeanPerfMicrostimCondTarget2(removeNan)=[];
[r2 p2]=corrcoef(allCorticalDistance2,allMeanPerfMicrostimCondTarget2);

%combine datasets:
corticalDistance=[allCorticalDistance1;allCorticalDistance2];
meanPerfMicrostimCondTarget=[allMeanPerfMicrostimCondTarget1;allMeanPerfMicrostimCondTarget2];
% numTrialsCondMicrostimTarget=[numTrialsCondMicrostimTarget1 numTrialsCondMicrostimTarget2];

a=corticalDistance(:);
allCorticalDistance=a(:);
b=meanPerfMicrostimCondTarget(:);
allMeanPerfMicrostimCondTarget=b(:);
removeNanDist=find(isnan(allCorticalDistance));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget));
removeNan=[removeNanDist removeNanPerf];
if ~isempty(removeNan)
    allCorticalDistance(removeNan)=[];
    allMeanPerfMicrostimCondTarget(removeNan)=[];
end

[r p]=corrcoef(allCorticalDistance,allMeanPerfMicrostimCondTarget);