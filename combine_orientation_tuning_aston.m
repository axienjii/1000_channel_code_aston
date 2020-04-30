function combine_orientation_tuning_aston
%Written by Xing 29/11/19
%Read in preferred orientation across all 8 instances, and compile into one
%output file, which will be used in plot_all_RFs.m, to generate RF map
%which is colour-coded by preferred orientation.
date='030918_B1_aston';
load('X:\aston\030918_B1_aston\030918_data\CheckSNR_030918_B1_aston.mat')
best=1;
switch(date)
    case '030918_B1_aston'
        whichDir=2;
        best=1;
end
if whichDir==1%local copy available
    topDir='D:\aston';
elseif whichDir==2%local copy deleted; use server copy
    if best==1
        topDir='X:\aston';
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

%combine across Lick and Aston:
fig1=figure;
subplot(1,2,1)
load('X:\best\080618_B3\good_channels_preferred_orientations.mat')
histogram(allPrefOri);
xlim([0 180]);
ylim([0 150]);
title('monkey 1, N=597');
set(gca,'Box','off');
oriTunedChs=find(allPrefOri~=-1);
length(oriTunedChs)%597
set(gca,'XTick',[0 90 180]);
ylabel('no of channels');
%load polar angles of RFs:
allPolarAngleRFs=[];
for instance=1:8
    load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat']);
    RFx=channelRFs(:,1);
    RFy=channelRFs(:,2);
    allPolarAngleRFs=[allPolarAngleRFs;atan2(RFy,RFx)];
end
[rhoPA,pPA]=corrcoef([allPrefOri(oriTunedChs),-rad2deg(allPolarAngleRFs(oriTunedChs))],'rows','pairwise')%r=; p
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(oriTunedChs)-2;
sprintf(['Lick, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 
%Lick, polar angle and orientation tuning: r(595) = 0.097228, p = 0.0175
fig2=figure;
subplot(1,2,1);
scatter(allPrefOri(oriTunedChs),-rad2deg(allPolarAngleRFs(oriTunedChs)),'.');
%cut the data at 90 degrees (as less channels show preferred tuing around
%90 degrees, and splice the two halves of data together to simulate
%circular statistics
allPrefOriCut=allPrefOri-90;
ind=allPrefOriCut<0;
allPrefOriCut(ind)=allPrefOriCut(ind)+180;
allPolarAngleRFsCut=-rad2deg(allPolarAngleRFs)+90;
fig3=figure;
subplot(1,2,1);
scatter(allPrefOriCut(oriTunedChs),allPolarAngleRFsCut(oriTunedChs),'.');
[rhoPA,pPA]=corrcoef([allPrefOriCut(oriTunedChs),allPolarAngleRFsCut(oriTunedChs)],'rows','pairwise')%r=; p
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(oriTunedChs)-2;
sprintf(['Lick, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 
%Lick, polar angle: r(595) = 0.11235, p = 0.0060

figure(fig1)
subplot(1,2,2)
load('X:\aston\030918_B1_aston\good_channels_preferred_orientations.mat')
histogram(allPrefOri);
xlim([0 180]);
ylim([0 80]);
title('monkey 2, N=354');
set(gca,'Box','off');
set(gca,'XTick',[0 180]);
set(gca,'XTick',[0 90 180]);
oriTunedChs=find(allPrefOri~=-1);
length(oriTunedChs)%354
xlabel('pref orientation');

%load polar angles of RFs:
allPolarAngleRFs=[];
for instance=1:8
    load(['D:\aston_data\best_aston_280818-290818\RFs_instance',num2str(instance),'.mat']);
    RFx=channelRFs(:,1);
    RFy=channelRFs(:,2);
    allPolarAngleRFs=[allPolarAngleRFs;atan2(RFy,RFx)];
end
[rhoPA,pPA]=corrcoef([allPrefOri(oriTunedChs),-rad2deg(allPolarAngleRFs(oriTunedChs))],'rows','pairwise')%r=; p
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(oriTunedChs)-2;
sprintf(['Aston, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 
%Aston, polar angle: r(352) = 0.084637, p = 0.1119
figure(fig2);
subplot(1,2,2);
scatter(allPrefOri(oriTunedChs),-rad2deg(allPolarAngleRFs(oriTunedChs)),'.');
%cut the data at 90 degrees (as less channels show preferred tuing around
%90 degrees, and splice the two halves of data together to simulate
%circular statistics
allPrefOriCut=allPrefOri-90;
ind=allPrefOriCut<0;
allPrefOriCut(ind)=allPrefOriCut(ind)+180;
allPolarAngleRFsCut=-rad2deg(allPolarAngleRFs)+90;
figure(fig3);
subplot(1,2,2);
scatter(allPrefOriCut(oriTunedChs),allPolarAngleRFsCut(oriTunedChs),'.');
[rhoPA,pPA]=corrcoef([allPrefOriCut(oriTunedChs),allPolarAngleRFsCut(oriTunedChs)],'rows','pairwise')%r=; p
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(oriTunedChs)-2;
sprintf(['Aston, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 
%Aston, polar angle: r(352) = 0.051916, p = 0.3301