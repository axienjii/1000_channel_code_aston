function plot_all_RFs_aston_resting_state_paper
%Written by Xing 29/8/18
%Plots RF centres and sizes of all 1000 channels (can select channel 
%inclusion based on SNR of MUA).

% channelRFs(channelInd,:)=[RF.centrex RF.centrey RF.sz RF.szdeg RF.ang RF.theta RF.ecc channelSNR(channelInd,:) horizontalRadius verticalRadius];

drawBarArea=0;

date='280818_B2_aston';
date='290818_B1_aston';
date='best_aston_280818-290818';
switch(date)%x & y co-ordinates of centre-point
    case '280818_B2_aston'
        x0 = 70;
        y0 = -70;
        speed = 20*25.8601/1000; %this is speed in pixels per ms
    case '290818_B1_aston'
        x0 = 30;
        y0 = -30;
        speed = 4*25.8601/1000; %this is speed in pixels per ms
    case 'best_aston_280818-290818'
        arrayOfInterest=2;%a combination of bars was used to generate this data- default to larger bar
        if arrayOfInterest==1||arrayOfInterest==3||arrayOfInterest==6||arrayOfInterest==7||arrayOfInterest==8||arrayOfInterest==15
            x0 = 30;%290818 mapping with small thin bar
            y0 = -30;
        else
            x0 = 70;%280818 mapping with larger bar
            y0 = -70;
            speed = 20*25.8601/1000; %this is speed in pixels per ms
        end
end

bardur = 1; %duration in seconds
bardist = speed*bardur*1000;

sampFreq=30000;
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;

%assign arrays according to layout on cortex:
V1MtLAtP=[8 1;2 1;7 2;7 1;1 1;6 2;6 1;5 2;1 1;1 2;2 1;2 2;3 1;3 2;5 1;4 3];
%locations of arrays, first columns gives their rank order from medial to more lateral, 
%and second column gives their rank order going from more anterior to more posterior
%V4 arrays are coded similarly.

channelRFs1000=[];
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    fileName=fullfile('X:\aston',date,['RFs_',instanceName,'.mat']);
    if instanceInd==2
        fileName=fullfile('X:\aston',date,['RFs_',instanceName,'_RS.mat']);
    end
    load(fileName)
    channelRFs1000=[channelRFs1000;channelRFs];
end
SNRthreshold=2;
meanChannelSNR=mean(channelRFs1000(:,8:11),2);
goodInd=find(meanChannelSNR>=SNRthreshold);
badInd=find(meanChannelSNR<SNRthreshold);
length(goodInd)/1024

%calculate area of sweeping bar
for i=1:length(x0)
    leftEdge=x0(i)-bardist(i)/2;
    rightEdge=x0(i)+bardist(i)/2;
    topEdge=y0(i)+bardist(i)/2;
    bottomEdge=y0(i)-bardist(i)/2;
    XVEC1(i,:) = [leftEdge rightEdge rightEdge leftEdge leftEdge];
    YVEC1(i,:) = [bottomEdge bottomEdge topEdge topEdge bottomEdge];
end

%all channels
figure
hold on
scatter(0,0,'r','o','filled');%fix spot
if drawBarArea==1
    for i=1:size(XVEC1,1)
        h = line(XVEC1(i,:),YVEC1(i,:),'LineWidth',1);
        set(h,'Color',[0.5 0.5 0.5])
    end
end
colind = hsv(16);
arrayNums=[];
goodArrays=1:16;
% goodArrays=[1 2 3 4 9 10 11 13 14 15 16];
% colind = hsv(11);
badQuadrant=[];
for i=1:length(goodInd)
    channelRow=goodInd(i);
    instanceInd=ceil(channelRow/128);
    channelInd=mod(channelRow,128);
    if channelInd==0
        channelInd=128;
    end
    [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd);
    arrayCol=find(goodArrays==arrayNum);
    arrayNums=[arrayNums arrayNum];
    if strcmp(area,'V1')
        markerCol='k';%V1
    else
        markerCol='b';%V4
    end
%     if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
%         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','o');
%     else
%         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','x');
%         %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
%     end
    if channelRFs1000(goodInd(i),1)<0||channelRFs1000(goodInd(i),2)>10
        if area=='V1'
            areaNum=1;
        elseif area=='V4'
            areaNum=4;
        end
        badQuadrant=[badQuadrant;arrayNum channelNum areaNum instanceInd channelInd];
    end
    if area=='V1'
        areaNum=1;
        plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','x');
    elseif area=='V4'
        areaNum=4;
        plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o');
    end
    if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
    else
        %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
    end
end
xlim([-100 300]);
ylim([-300 100]);
xlim([-50 250]);
ylim([-250 50]);
arrayNums=unique(arrayNums);
%draw dotted lines indicating [0,0]
plot([0 0],[-350 200],'k:')
plot([-200 300],[0 0],'k:')
plot([-200 300],[200 -300],'k:')
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
ellipse(250,250,0,0,[0.1 0.1 0.1]);
ellipse(300,300,0,0,[0.1 0.1 0.1]);
ellipse(350,350,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(28000),-sqrt(28000),'10','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(40000),-sqrt(40000),'12','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(56000),-sqrt(56000),'14','FontSize',14,'Color',[0.7 0.7 0.7]);
xlim([leftEdge-50 rightEdge+50]);
ylim([bottomEdge-50 topEdge+50]);
axis square
ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
titleText=['all good channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)),' channels'];
title(titleText);
% for i=1:16
%     text(220,-100-i*8,num2str(i),'Color',colind(i,:))
% end
for i=1:16
    text(220,-5-i*8,num2str(i),'Color',colind(i,:))
end
for i=1:length(badInd)
    scatter(channelRFs1000(badInd(i),1),channelRFs1000(badInd(i),2),'r','x');
end

axis equal
xlim([-40 260]);
ylim([-170 30]);
xlim([-50 250]);
xlim([-25 150]);

%all channels (for paper)
figure
hold on
scatter(0,0,'r','o','filled');%fix spot
if drawBarArea==1
    for i=1:size(XVEC1,1)
        h = line(XVEC1(i,:),YVEC1(i,:),'LineWidth',1);
        set(h,'Color',[0.5 0.5 0.5])
    end
end
colind = hsv(16);
colind(8,:)=[139/255 69/255 19/255];
colind=colind([1 2 4 5 3 6 7 8 9 10 12 13 14 15 16 11],:);%rearrange to match locations of arrays on Lick's cortex (for paper)
colind(16,:)=[0 0 0];
arrayNums=[];
goodArrays=1:16;
% goodArrays=[1 2 3 4 9 10 11 13 14 15 16];
% colind = hsv(11);
plotCircles=1;
badQuadrant=[];
for i=1:length(goodInd)
    channelRow=goodInd(i);
    instanceInd=ceil(channelRow/128);
    channelInd=mod(channelRow,128);
    if channelInd==0
        channelInd=128;
    end
    [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd);
    arrayCol=find(goodArrays==arrayNum);
    arrayNums=[arrayNums arrayNum];
    if strcmp(area,'V1')
        markerCol='k';%V1
    else
        markerCol='b';%V4
    end
%     if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
%         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','o');
%     else
%         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','x');
%         %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
%     end
    if channelRFs1000(goodInd(i),1)<0||channelRFs1000(goodInd(i),2)>10
        if area=='V1'
            areaNum=1;
        elseif area=='V4'
            areaNum=4;
        end
        badQuadrant=[badQuadrant;arrayNum channelNum areaNum instanceInd channelInd];
    end
    if area=='V1'
        areaNum=1;
        if plotCircles==1
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));
        elseif plotCircles==0
            text(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),num2str(channelNum),'Color',colind(arrayCol,:));
        end
    elseif area=='V4'
        areaNum=4;
%         if plotCircles==1
%             plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));
%         elseif plotCircles==0
%             text(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),num2str(channelNum),'Color',colind(arrayCol,:));
%         end
    end
    if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
    else
        %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
    end
end
xlim([-100 300]);
ylim([-300 100]);
xlim([-50 250]);
ylim([-250 50]);
arrayNums=unique(arrayNums);
%draw dotted lines indicating [0,0]
plot([0 0],[-350 200],'k:')
plot([-200 300],[0 0],'k:')
plot([-200 300],[200 -300],'k:')
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(10*pixPerDeg,10*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(12*pixPerDeg,12*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(14*pixPerDeg,14*pixPerDeg,0,0,[0.1 0.1 0.1]);
% text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(28000),-sqrt(28000),'10','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(40000),-sqrt(40000),'12','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(56000),-sqrt(56000),'14','FontSize',14,'Color',[0.7 0.7 0.7]);
xlim([leftEdge-50 rightEdge+50]);
ylim([bottomEdge-50 topEdge+50]);
axis square
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-10*pixPerDeg -8*pixPerDeg -6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-10','-8','-6','-4','-2','0'});
titleText=['all good channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)),' channels'];
% title(titleText);
% for i=1:16
%     text(220,-100-i*8,num2str(i),'Color',colind(i,:))
% end
% for i=1:16
%     text(220,-5-i*8,num2str(i),'Color',colind(i,:))
% end

% axis equal
% xlim([-30 250]);
% ylim([-150 30]);
% ylim([-300 30]);
% xlim([-30 300]);
xlim([-10 140]);
xlim([-10 240]);
xlim([-10 320]);
ylim([-120 20]);
ylim([-120 30]);
ylim([-150 20]);
ylim([-250 20]);
ylim([-310 20]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
axis on
set(gca,'XColor','none')
set(gca,'YColor','none')
pathname=fullfile('D:\aston_data\results\RFs_map_figure');
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff','-r600');
