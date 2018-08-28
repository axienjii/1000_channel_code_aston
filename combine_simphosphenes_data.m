function combine_simphosphenes_data

%combine NEV data:
allGoodChannels=[{1:128} {1:128} {1:128} {1:128}];
allInstanceInd=5:8;
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    goodChannels=allGoodChannels{instanceCount};
    for channelCount=1:length(goodChannels)
        channelInd=goodChannels(channelCount);
        %load in B2:
        date='110717_B2';
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
        load(fileName);
        channelDataMUA_B2=channelDataMUA;
        goodTrialCondsMatch_B2=goodTrialCondsMatch;
        goodTrialsInd_B2=goodTrialsInd;
        indStimOnsMatch_B2=indStimOnsMatch;
        matMatchInd_B2=matMatchInd;
        performanceMatch_B2=performanceMatch;
        performanceNEV_B2=performanceNEV;
        timeStimOnsMatch_B2=timeStimOnsMatch;
        trialStimConds_B2=trialStimConds;
        %load in B1:
        date='110717_B1';
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
        load(fileName);
        %save combined variables:
        channelDataMUA=[channelDataMUA channelDataMUA_B2];
        goodTrialCondsMatch=[goodTrialCondsMatch;goodTrialCondsMatch_B2];
        goodTrialsInd=[goodTrialsInd goodTrialsInd_B2];
        indStimOnsMatch=[indStimOnsMatch indStimOnsMatch_B2];
        matMatchInd=[matMatchInd matMatchInd_B2];
        performanceMatch=[performanceMatch performanceMatch_B2];
        performanceNEV=[performanceNEV performanceNEV_B2];
        timeStimOnsMatch=[timeStimOnsMatch timeStimOnsMatch_B2];
        trialStimConds=[trialStimConds trialStimConds_B2];
        date='110717_B1_B2';
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
        save(fileName,'channelDataMUA','goodTrialCondsMatch','goodTrialsInd','indStimOnsMatch','matMatchInd','performanceMatch','performanceNEV','timeStimOnsMatch','trialStimConds')
    end
end

combineMat=1;
if combineMat==1
    %combine mat data:
    load('D:\data\110717_B1\110717_B1_data\simphosphenes6_110717_B1.mat')
    [dummy goodTrials]=find(performance~=0);
    goodTrialConds_B1=allTrialCond(goodTrials,:);
    goodTrialIDs_B1=TRLMAT(goodTrials,:);
    load('D:\data\110717_B1\110717_B1_data\simphosphenes6_110717_B2.mat')
    [dummy goodTrials]=find(performance~=0);
    goodTrialConds_B2=allTrialCond(goodTrials,:);
    goodTrialIDs_B2=TRLMAT(goodTrials,:);
    %combine and save:
    goodTrialConds=[goodTrialConds_B1;goodTrialConds_B2];
    goodTrialIDs=[goodTrialIDs_B1;goodTrialIDs_B2];
    date='110717_B1_B2';
    matFile=['D:\data\',date,'\',date,'_data\simphosphenes6_',date,'.mat'];
    save(matFile,'goodTrialConds','goodTrialIDs');
end