function analyse_2phosphene_correlation_current_level
%Written by Xing 2/2/18
%Analyse performance on 2-phosphene orientation task as a function of
%current level delivered (difference in current amplitude between the two
%electrodes, as well as mean current level).

%Select variable to examine:
% variable='currentDifference';
% variable='currentMean';
% variable='currentMax';
variable='currentMin';

minNumTrials=10;
%Data from task with 12-patterns of microstimulation:
load('D:\data\220118_2phosphene_current_perf.mat')
eval(['current1=',variable,';']);
meanPerfMicrostimCondTarget1=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget1=numTrialsCondMicrostimTarget;

a=cell2mat(current1(:));
allCurrent1=a(:);
b=cell2mat(meanPerfMicrostimCondTarget1(:));
allMeanPerfMicrostimCondTarget1=b(:);
c=cell2mat(numTrialsCondMicrostimTarget1(:));
allNumTrialsCondMicrostimTarget1=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget1<minNumTrials);
allCurrent1(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget1(tooFewTrials)=[];
[r1 p1]=corrcoef(allCurrent1,allMeanPerfMicrostimCondTarget1);
figure;
plot(allCurrent1,allMeanPerfMicrostimCondTarget1,'ko');
title(sprintf('r=%.2f p=%.2f',r1(2),p1(2)))
xlabel(variable);
ylabel('performance')

%Data from 2-phosphene and line task, before 12-pattern task:
load('D:\data\040118_2phosphene_current_perf.mat')
eval(['current2=',variable,';']);
meanPerfMicrostimCondTarget2=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget2=numTrialsCondMicrostimTarget;

a=cell2mat(current2(:));
allCurrent2=a(:);
b=cell2mat(meanPerfMicrostimCondTarget2(:));
allMeanPerfMicrostimCondTarget2=b(:);
c=cell2mat(numTrialsCondMicrostimTarget2(:));
allNumTrialsCondMicrostimTarget2=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget2<minNumTrials);
allCurrent2(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget2(tooFewTrials)=[];
removeNanDist=find(isnan(allCurrent2));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget2));
removeNan=[removeNanDist removeNanPerf];
allCurrent2(removeNan)=[];
allMeanPerfMicrostimCondTarget2(removeNan)=[];
[r2 p2]=corrcoef(allCurrent2,allMeanPerfMicrostimCondTarget2);
figure;
plot(allCurrent2,allMeanPerfMicrostimCondTarget2,'ko');
title(sprintf('r=%.2f p=%.2f',r2(2),p2(2)))
xlabel(variable);
ylabel('performance')

%combine datasets:
current=[current1 current2];
meanPerfMicrostimCondTarget=[meanPerfMicrostimCondTarget1 meanPerfMicrostimCondTarget2];
numTrialsCondMicrostimTarget=[numTrialsCondMicrostimTarget1 numTrialsCondMicrostimTarget2];

a=cell2mat(current(:));
allCurrent=a(:);
b=cell2mat(meanPerfMicrostimCondTarget(:));
allMeanPerfMicrostimCondTarget=b(:);
removeNanDist=find(isnan(allCurrent));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget));
removeNan=[removeNanDist removeNanPerf];
if ~isempty(removeNan)
    allCurrent(removeNan)=[];
    allMeanPerfMicrostimCondTarget(removeNan)=[];
end

[r p]=corrcoef(allCurrent,allMeanPerfMicrostimCondTarget);
figure;
plot(allCurrent,allMeanPerfMicrostimCondTarget,'ko');
title(sprintf('r=%.2f p=%.2f',r(2),p(2)))
xlabel(variable);
ylabel('performance')

%Carry out analyses using datasets where performance was at least 50%:
clear all
minNumTrials=10;
minPerf=0.4;
%Data from task with 12-patterns of microstimulation:
load('D:\data\220118_2phosphene_current_perf.mat')
eval(['current1=',variable,';']);
meanPerfMicrostimCondTarget1=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget1=numTrialsCondMicrostimTarget;

a=cell2mat(current1(:));
allCurrent1=a(:);
b=cell2mat(meanPerfMicrostimCondTarget1(:));
allMeanPerfMicrostimCondTarget1=b(:);
c=cell2mat(numTrialsCondMicrostimTarget1(:));
allNumTrialsCondMicrostimTarget1=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget1<minNumTrials);
allCurrent1(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget1(tooFewTrials)=[];
tooLowPerf=find(allMeanPerfMicrostimCondTarget1<minPerf);
allCurrent1(tooLowPerf)=[];
allMeanPerfMicrostimCondTarget1(tooLowPerf)=[];
[r1 p1]=corrcoef(allCurrent1,allMeanPerfMicrostimCondTarget1);
figure;
plot(allCurrent1,allMeanPerfMicrostimCondTarget1,'ko');
title(sprintf('r=%.2f p=%.2f',r1(2),p1(2)))
xlabel(variable);
ylabel('performance')

%Data from 2-phosphene and line task, before 12-pattern task:
load('D:\data\040118_2phosphene_current_perf.mat')
eval(['current2=',variable,';']);
meanPerfMicrostimCondTarget2=meanPerfMicrostimCondTarget;
numTrialsCondMicrostimTarget2=numTrialsCondMicrostimTarget;

a=cell2mat(current2(:));
allCurrent2=a(:);
b=cell2mat(meanPerfMicrostimCondTarget2(:));
allMeanPerfMicrostimCondTarget2=b(:);
c=cell2mat(numTrialsCondMicrostimTarget2(:));
allNumTrialsCondMicrostimTarget2=c(:);
tooFewTrials=find(allNumTrialsCondMicrostimTarget2<minNumTrials);
allCurrent2(tooFewTrials)=[];
allMeanPerfMicrostimCondTarget2(tooFewTrials)=[];
tooLowPerf=find(allMeanPerfMicrostimCondTarget2<minPerf);
allCurrent2(tooLowPerf)=[];
allMeanPerfMicrostimCondTarget2(tooLowPerf)=[];
removeNanDist=find(isnan(allCurrent2));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget2));
removeNan=[removeNanDist removeNanPerf];
allCurrent2(removeNan)=[];
allMeanPerfMicrostimCondTarget2(removeNan)=[];
[r2 p2]=corrcoef(allCurrent2,allMeanPerfMicrostimCondTarget2);
figure;
plot(allCurrent2,allMeanPerfMicrostimCondTarget2,'ko');
title(sprintf('r=%.2f p=%.2f',r2(2),p2(2)))
xlabel(variable);
ylabel('performance')

%combine datasets:
current=[allCurrent1;allCurrent2];
meanPerfMicrostimCondTarget=[allMeanPerfMicrostimCondTarget1;allMeanPerfMicrostimCondTarget2];
% numTrialsCondMicrostimTarget=[numTrialsCondMicrostimTarget1 numTrialsCondMicrostimTarget2];

a=current(:);
allCurrent=a(:);
b=meanPerfMicrostimCondTarget(:);
allMeanPerfMicrostimCondTarget=b(:);
removeNanDist=find(isnan(allCurrent));
removeNanPerf=find(isnan(allMeanPerfMicrostimCondTarget));
removeNan=[removeNanDist removeNanPerf];
if ~isempty(removeNan)
    allCurrent(removeNan)=[];
    allMeanPerfMicrostimCondTarget(removeNan)=[];
end

[r p]=corrcoef(allCurrent,allMeanPerfMicrostimCondTarget);
figure;
plot(allCurrent,allMeanPerfMicrostimCondTarget,'ko');
title(sprintf('r=%.2f p=%.2f',r(2),p(2)))
xlabel(variable);
ylabel('performance')