function tallyTrials_testMat
load('Y:\Xing\simphosphenes5_20170710_test.mat')

allLetters='IUALTVSYJ?';
for letterInd=1:10
    for lumInd=1:40
        a=find(allTrialCond(:,1)==letterInd);
        b=find(allTrialCond(:,2)==lumInd);
        combinedTrialIndConds{letterInd,lumInd}=intersect(a,b);
        numTrialsCombined(letterInd,lumInd)=length(intersect(a,b));
        if letterInd<=8%familiar letters
            combinedTrialPerf{letterInd,lumInd}=performance(intersect(a,b));
            numCorrTrialsCombined(letterInd,lumInd)=sum(combinedTrialPerf{letterInd,lumInd}==1);
        elseif letterInd>=9%unfamiliar letters, J & P, were always rewarded
            combinedTrialPerf{letterInd,lumInd}=performance(intersect(a,b));
            numCorrTrialsCombined(letterInd,lumInd)=length(combinedTrialPerf{letterInd,lumInd});
        end
    end
end
find(numCorrTrialsCombined<5)
find(numTrialsCombined<5)

allTrialCond(:,4)=performance;
