function plot_current_vs_impedance
%Written by Xing 25/8/17
%Load impedance values and current thresholds for channels on which
%microstim was delivered, check for any relationship.

load('C:\Users\User\Documents\impedance_values\070818\impedanceAllChannels.mat')
load('X:\best\070818_data\currentThresholdChs134.mat')
arrays=8:16;
for arrayInd=arrays
    [rowInd]=find(goodArrays8to16(:,7)==arrayInd);
    evalText=['array',num2str(arrayInd),'_currentThresholds=goodCurrentThresholds(rowInd);'];
    eval(evalText);    
end
save('D:\data\currentThresholds_240718.mat','array8_currentThresholds','array9_currentThresholds','array10_currentThresholds','array11_currentThresholds','array12_currentThresholds','array13_currentThresholds','array14_currentThresholds','array15_currentThresholds','array16_currentThresholds');

for rowInd=1:size(impedanceAllChannels,1)
    impedanceAllChannels(rowInd,4)=mod(impedanceAllChannels(rowInd,3),64);
    if mod(impedanceAllChannels(rowInd,3),64)==0
        impedanceAllChannels(rowInd,4)=64;
    end
end

% load('D:\data\currentThresholds_070917.mat')
load('D:\data\currentThresholds_240718.mat')
arrays=8:16;
for arrayInd=arrays
%     load(['Y:\Xing\070917_data\array',num2str(arrayInd),'.mat'])
    load(['X:\best\070917_B1\070917_B1_data\array',num2str(arrayInd),'.mat'])
end

for rowInd=1:size(goodArrays8to16,1)
    arrayInd=find(impedanceAllChannels(:,2)==goodArrays8to16(rowInd,7));
    chInd=find(impedanceAllChannels(:,4)==goodArrays8to16(rowInd,8));
    [temp ind]=intersect(arrayInd,chInd);
    goodArrays8to16(rowInd,6)=impedanceAllChannels(ind,1);
end

figure;hold on
for arrayInd=1:length(arrays)
    subplot(1,length(arrays)+1,arrayInd)
    evalText=['indCurrents=find(array',num2str(arrays(arrayInd)),'_currentThresholds~=0);'];
    eval(evalText);
    evalText=['goodCurrents=array',num2str(arrays(arrayInd)),'_currentThresholds(indCurrents);'];
    eval(evalText);
    evalText=['goodImpedances=array',num2str(arrays(arrayInd)),'(indCurrents,6);'];
    eval(evalText);
    plot(goodImpedances,goodCurrents,'ko');
%     ylim([0 140])
    ylim([0 40])
    title(['array ',num2str(arrays(arrayInd))]);
end
xlabel('impedance (kOhms)');
ylabel('current threshold at 50%');

figure;hold on
allGoodImpedances=[];
allGoodCurrents=[];
cols='crgbkmy';
cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
for arrayInd=1:length(arrays)
    evalText=['indCurrents=find(array',num2str(arrays(arrayInd)),'_currentThresholds~=0);'];
    eval(evalText);
    evalText=['goodCurrents=array',num2str(arrays(arrayInd)),'_currentThresholds(indCurrents);'];
    eval(evalText);
    allGoodCurrents=[allGoodCurrents;goodCurrents];
    evalText=['goodImpedances=array',num2str(arrays(arrayInd)),'(indCurrents,6);'];
    eval(evalText);
    allGoodImpedances=[allGoodImpedances;goodImpedances];
    scatter(goodImpedances,goodCurrents,[],cols(arrayInd,:),'filled');
    text(80,200-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
end
xlabel('impedance (kOhms)');
ylabel('current threshold at 50% (uA)');
[r p]=corr(allGoodImpedances,allGoodCurrents)
title(['current thresholds vs electrode impedances, colour-coded by array, N = ',num2str(length(allGoodCurrents)),'. r=',num2str(r),';p=',num2str(p)]);

figure;hold on
allRFx=[];
allRFy=[];
for arrayInd=1:length(arrays)
    evalText=['indCurrents=find(array',num2str(arrays(arrayInd)),'_currentThresholds~=0);'];
    eval(evalText);
    evalText=['RFx=array',num2str(arrays(arrayInd)),'(indCurrents,1);'];
    eval(evalText);
    allRFx=[allRFx;RFx];
    evalText=['RFy=array',num2str(arrays(arrayInd)),'(indCurrents,2);'];
    eval(evalText);
    allRFy=[allRFy;RFy];
    scatter(RFx,RFy,[],cols(arrayInd,:),'filled');
    text(140,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
end
ax=gca;
set(ax,'xlim',[0 200]);
set(ax,'ylim',[-150 0]);
xlabel('x-coordinates (pixels)');
ylabel('y-coordinates (pixels)');
title(['RF centres for channels with good current thresholds, colour-coded by array, N = ',num2str(length(allGoodCurrents))]);

scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
axis equal
xlim([-10 200]);
ylim([-160 10]);
pause