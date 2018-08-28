function combine_orientation_tuning
%Written by Xing 16/8/18
%Read in preferred orientation across all 8 instances, and compile into one
%output file, which will be used in plot_all_RFs.m, to generate RF map
%which is colour-coded by preferred orientation.
date='080618_B3';
load('X:\best\080618_B3\080618_data\CheckSNR_080618_B3.mat')
best=1;
switch(date)
    case '080618_B3'
        whichDir=2;
        best=1;
end
if whichDir==1%local copy available
    topDir='D:\data';
elseif whichDir==2%local copy deleted; use server copy
    if best==1
        topDir='X:\best';
    elseif best==0
        topDir='X:\other';
    end
end
allInstanceInd=1:8;
allPrefOri=zeros(1024,1);
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];    
    fileName=fullfile(topDir,date,['mean_MUA_',instanceName,'.mat']);
    load(fileName,'goodTuningChs','allPrefered_Ori');
    goodChs=zeros(128,1)-1;
    goodChs(goodTuningChs)=allPrefered_Ori(goodTuningChs);%copy preferred orientation for good channels, while setting a value of -1 for channels without good tuning
    allPrefOri(1+(instanceCount-1)*128:instanceCount*128)=goodChs;
end
saveFileName=fullfile(topDir,date,'good_channels_preferred_orientations.mat');
save(saveFileName,'allPrefOri');
