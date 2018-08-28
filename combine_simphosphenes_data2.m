function combine_simphosphenes_data2
%Written by Xing 24/7/17
%Combines data across 3 recordings- 110717_B1, 110717_B2, and 120717_B1.

%combine NEV data:
allGoodChannels=[{1:128} {1:128} {1:128} {1:128}];
allInstanceInd=5:8;
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    goodChannels=allGoodChannels{instanceCount};
    for channelCount=1:length(goodChannels)
        channelInd=goodChannels(channelCount);
        %load in 120717_B123:
        date='120717_B1';
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
        load(fileName);
        channelDataMUA_12B123=channelDataMUA;
        goodTrialCondsMatch_12B123=goodTrialCondsMatch;
        goodTrialsInd_12B123=goodTrialsInd;
        indStimOnsMatch_12B123=indStimOnsMatch;
        matMatchInd_12B123=matMatchInd;
        performanceMatch_12B123=performanceMatch;
        performanceNEV_12B123=performanceNEV;
        timeStimOnsMatch_12B123=timeStimOnsMatch;
        trialStimConds_12B123=trialStimConds;
        %load in 120717_B1, B2 and B3:
%         channelDataMUA_12B123=[];
%         goodTrialCondsMatch_12B123=[];
%         goodTrialsInd_12B123=[];
%         indStimOnsMatch_12B123=[];
%         matMatchInd_12B123=[];
%         performanceMatch_12B123=[];
%         performanceNEV_12B123=[];
%         timeStimOnsMatch_12B123=[];
%         trialStimConds_12B123=[];
%         for subSession=1:3
%             date=['120717_B',num2str(subSession)];
%             fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
%             load(fileName);
%             channelDataMUA_12B123=[channelDataMUA_12B123 channelDataMUA];
%             goodTrialCondsMatch_12B123=[goodTrialCondsMatch_12B123;goodTrialCondsMatch];
%             goodTrialsInd_12B123=[goodTrialsInd_12B123 goodTrialsInd];
%             indStimOnsMatch_12B123=[indStimOnsMatch_12B123 indStimOnsMatch];
%             matMatchInd_12B123=[matMatchInd_12B123 matMatchInd];
%             performanceMatch_12B123=[performanceMatch_12B123 performanceMatch];
%             performanceNEV_12B123=[performanceNEV_12B123 performanceNEV];
%             timeStimOnsMatch_12B123=[timeStimOnsMatch_12B123 timeStimOnsMatch];
%             trialStimConds_12B123=[trialStimConds_12B123 trialStimConds];
%         end
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
        channelDataMUA=[channelDataMUA channelDataMUA_B2 channelDataMUA_12B123];
        goodTrialCondsMatch=[goodTrialCondsMatch;goodTrialCondsMatch_B2;goodTrialCondsMatch_12B123];
        goodTrialsInd=[goodTrialsInd goodTrialsInd_B2 goodTrialsInd_12B123];
        indStimOnsMatch=[indStimOnsMatch indStimOnsMatch_B2 indStimOnsMatch_12B123];
        matMatchInd=[matMatchInd matMatchInd_B2 matMatchInd_12B123];
        performanceMatch=[performanceMatch performanceMatch_B2 performanceMatch_12B123];
        performanceNEV=[performanceNEV performanceNEV_B2 performanceNEV_12B123];
        timeStimOnsMatch=[timeStimOnsMatch timeStimOnsMatch_B2 timeStimOnsMatch_12B123];
        trialStimConds=[trialStimConds trialStimConds_B2 trialStimConds_12B123];
        date='110717_B1_B2_120717_B123';
        folderName=fullfile('D:\data',date);
        if ~exist(folderName)%'exist' returns value of 7 if folder exists
            mkdir(folderName)
        end
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
    load('D:\data\120717_B1\120717_B1_data\simphosphenes6_120717_B123.mat')
    [dummy goodTrials]=find(performance~=0);
    goodTrialConds_B123=goodTrialConds;
    goodTrialIDs_B123=goodTrialIDs;
    %combine and save:
    goodTrialConds=[goodTrialConds_B1;goodTrialConds_B2;goodTrialConds_B123];
    goodTrialIDs=[goodTrialIDs_B1;goodTrialIDs_B2;goodTrialIDs_B123];
    date='110717_B1_B2_120717_B123';
    folderName=fullfile('D:\data',date,[date,'_data']);
    if ~exist(folderName,'dir')
        mkdir(folderName)
    end
    matFile=['D:\data\',date,'\',date,'_data\simphosphenes6_',date,'.mat'];
    save(matFile,'goodTrialConds','goodTrialIDs');
end