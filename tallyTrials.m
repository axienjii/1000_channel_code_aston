function tallyTrials
%Written by Xing 6/7/17 to combine data across multiple recording files.
%e.g. B1 and B2, or across different days. Checks number of trials per
%condition, and whether behavioural response was correct or incorrect.

%incorrect coding of number of trials per condition, 5-6/7/17:
% load('D:\data\050717_B2\goodTrialCondsMatch.mat');
% goodTrialCondsMatch1=goodTrialCondsMatch;
% load('D:\data\060717_B1\goodTrialCondsMatch.mat');
% goodTrialCondsMatch2=goodTrialCondsMatch;
% load('D:\data\050717_B2\trialPerf.mat')
% trialPerf1=trialPerf;
% load('D:\data\060717_B1\trialPerf.mat')
% trialPerf2=trialPerf;
% load('Y:\Xing\simphosphenes5_070717_test4.mat')

% save('D:\data\110717_B2\trialPerf.mat','trialPerf')
% save('D:\data\110717_B2\performanceMatch.mat','performanceMatch')
% save('D:\data\110717_B2\goodTrialCondsMatch.mat','goodTrialCondsMatch')

%semi-correct coding of number of trials per condition, 11/7/17:
load('D:\data\110717_B1\goodTrialCondsMatch.mat');
goodTrialCondsMatch1=goodTrialCondsMatch;
load('D:\data\110717_B2\goodTrialCondsMatch.mat');
goodTrialCondsMatch2=goodTrialCondsMatch;
load('D:\data\110717_B1\trialPerf.mat')
trialPerf1=trialPerf;
load('D:\data\110717_B2\trialPerf.mat')
trialPerf2=trialPerf;

allLetters='IUALTVSYJP';
combinedGoodTrialCondsMatch=[goodTrialCondsMatch1;goodTrialCondsMatch2];
for letterInd=1:10
    for lumInd=1:40
        a=find(combinedGoodTrialCondsMatch(:,1)==letterInd);
        b=find(combinedGoodTrialCondsMatch(:,2)==lumInd);
        combinedTrialIndConds{letterInd,lumInd}=intersect(a,b);
        numTrialsCombined(letterInd,lumInd)=length(intersect(a,b));
        if letterInd<=8%familiar letters
            combinedTrialPerf{letterInd,lumInd}=[trialPerf1{letterInd,lumInd}(:);trialPerf2{letterInd,lumInd}(:)];
            numCorrTrialsCombined(letterInd,lumInd)=sum(combinedTrialPerf{letterInd,lumInd}==1);
        elseif letterInd>=9%unfamiliar letters, J & P, were always rewarded
            combinedTrialPerf{letterInd,lumInd}=ones(length([trialPerf1{letterInd,lumInd}(:);trialPerf2{letterInd,lumInd}(:)]),1);
            numCorrTrialsCombined(letterInd,lumInd)=length(combinedTrialPerf{letterInd,lumInd});
        end
    end
end
find(numCorrTrialsCombined<3)
find(numTrialsCombined<5)

% trialsRemaining=find(numTrialsCombined<5)
% =[39 339 354 357]
% for ind=1:length(trialsRemaining)
%     [i j]=ind2sub([10,40],trialsRemaining(ind))
% end
% 9 4 
% 9 34 
% 4 36 
% 7 36 
% letterInd=7;
% lumInd=36;
% a=find(combinedGoodTrialCondsMatch(:,1)==letterInd);
% b=find(combinedGoodTrialCondsMatch(:,2)==lumInd);
% intersect(a,b)
% combinedGoodTrialCondsMatch(intersect(a,b),:)
% 
% final trialsRemaining:
% 9 4 0
% 9 34 0
% 4 36 1
% 7 36 0

%final dataset from 11/7/17 B1 & B2, and 12/7/17 B1:
load('D:\data\110717_B1_B2_120717_B123\MUA_instance1_ch1_downsample.mat')
for letterInd=1:10
    for lumInd=1:40
        a=find(goodTrialCondsMatch(:,1)==letterInd);
        b=find(goodTrialCondsMatch(:,2)==lumInd);
        combinedTrialIndConds{letterInd,lumInd}=intersect(a,b);
        numTrialsCombined(letterInd,lumInd)=length(intersect(a,b));
        if letterInd<=8%familiar letters
            combinedTrialPerf{letterInd,lumInd}=performanceMatch(intersect(a,b));
            numCorrTrialsCombined(letterInd,lumInd)=sum(combinedTrialPerf{letterInd,lumInd}==1);
        elseif letterInd>=9%unfamiliar letters/symbols, J & square, were always rewarded, ignore whether script records trial as being incorrect or incorrect
            combinedTrialPerf1{letterInd,lumInd}=ones(length(performanceMatch(intersect(a,b))),1);
            numCorrTrialsCombined(letterInd,lumInd)=length(combinedTrialPerf2{letterInd,lumInd});
        end
    end
end
find(numCorrTrialsCombined<3)
find(numTrialsCombined<5)