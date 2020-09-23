function plot_all_RFs_aston
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
    fileName=fullfile('D:\aston_data',date,['RFs_',instanceName,'.mat']);
    load(fileName)
    channelRFs1000=[channelRFs1000;channelRFs];
end
SNRthreshold=2;
meanChannelSNR=mean(channelRFs1000(:,8:11),2);
goodInd=find(meanChannelSNR>=SNRthreshold);
badInd=find(meanChannelSNR<SNRthreshold);
length(goodInd)/1024
save('D:\aston_data\monkeyAGoodInd.mat','goodInd');

%calculate area of sweeping bar
for i=1:length(x0)
    leftEdge=x0(i)-bardist(i)/2;
    rightEdge=x0(i)+bardist(i)/2;
    topEdge=y0(i)+bardist(i)/2;
    bottomEdge=y0(i)-bardist(i)/2;
    XVEC1(i,:) = [leftEdge rightEdge rightEdge leftEdge leftEdge];
    YVEC1(i,:) = [bottomEdge bottomEdge topEdge topEdge bottomEdge];
end

% %all channels
% figure
% scatter(0,0,'r','o');%fix spot
% scatter(channelRFs1000(:,1),channelRFs1000(:,2),'k','x');
% xlim([-100 300]);
% ylim([-300 100]);
% ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% title('all channel RFs');
% 
% %all channels
% figure
% scatter(0,0,'r','o');%fix spot
% scatter(channelRFs1000(:,1),channelRFs1000(goodInd,2),'k','x');
% scatter(channelRFs1000(:,1),channelRFs1000(badInd,2),'r','x');
% xlim([-100 300]);
% ylim([-300 100]);
% ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% title('all channel RFs');
% 
% %all channels
% figure
% hold on
% scatter(0,0,'r','o');%fix spot
% for i=1:length(goodInd)
%     scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'k','x');
%     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
% end
% for i=1:length(badInd)
%     scatter(channelRFs1000(badInd(i),1),channelRFs1000(badInd(i),2),'r','x');
% end
% xlim([-100 300]);
% ylim([-300 100]);
% %plot area of sweeping bar
% h = line(XVEC1,YVEC1,'LineWidth',2);
% set(h,'Color','k')
% xlim([0 200]);
% ylim([-200 0]);
% axis square
% ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% title('all channel RFs');
 
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
%         if plotCircles==1
%             plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));
%         elseif plotCircles==0
%             text(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),num2str(channelNum),'Color',colind(arrayCol,:));
%         end
    elseif area=='V4'
        areaNum=4;
        if plotCircles==1
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));
        elseif plotCircles==0
            text(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),num2str(channelNum),'Color',colind(arrayCol,:));
        end
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

%calculate whether stimulus used in visual control task (for paper on
%implant quality) falls within conglomerate RFs
arrayNums=[];
goodArrays=1:16;
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
    if channelRFs1000(goodInd(i),1)<6*pixPerDeg&&channelRFs1000(goodInd(i),1)>-1*pixPerDeg&&channelRFs1000(goodInd(i),2)<1*pixPerDeg&&channelRFs1000(goodInd(i),2)>-4*pixPerDeg
        if area=='V1'
            areaNum=1;
            sizeGoodChannels(i,:)=[channelRFs1000(goodInd(i),12) channelRFs1000(goodInd(i),13)];
            coordsGoodChannels(i,:)=[channelRFs1000(goodInd(i),1) channelRFs1000(goodInd(i),2)];
        elseif area=='V4'
            areaNum=4;
        end
        badQuadrant=[badQuadrant;arrayNum channelNum areaNum instanceInd channelInd];
    end
end
numSDs=3;
empty=sum(coordsGoodChannels,2);
remove=find(empty==0);

sizeGoodChannels(remove,:)=[];
coordsGoodChannels(remove,:)=[];

meanSize=mean(sizeGoodChannels(:))
stdSize=std(sizeGoodChannels(:))
outlierSizeX=find(sizeGoodChannels(:,1)>numSDs*stdSize+meanSize);
outlierSizeY=find(sizeGoodChannels(:,2)>numSDs*stdSize+meanSize);
outlierSizeXY=union(outlierSizeX,outlierSizeY);
outlierSizeXY=union(outlierSizeXY,remove);
goodIndNoSizeOutliers=goodInd;
goodIndNoSizeOutliers(outlierSizeXY)=[];

meanCoordX=median(coordsGoodChannels(:,1))
meanCoordY=median(coordsGoodChannels(:,2))
stdCoordX=std(coordsGoodChannels(:,1))
stdCoordY=std(coordsGoodChannels(:,2))
outlierCoordX=find(coordsGoodChannels(:,1)>numSDs*stdCoordX+meanCoordX);
outlierCoordY=find(coordsGoodChannels(:,2)>numSDs*stdCoordY+meanCoordY);
outlierCoordXY=union(outlierCoordX,outlierCoordY);
outlierCoordXY=union(outlierCoordXY,remove);
goodIndNoCoordOutliers=goodInd;
goodIndNoCoordOutliers(outlierCoordXY)=[];

goodIndNoCoordSizeOutliers=intersect(goodIndNoSizeOutliers,goodIndNoCoordOutliers);
outlineRFs=boundary(channelRFs1000(goodIndNoCoordSizeOutliers,1),channelRFs1000(goodIndNoCoordSizeOutliers,2));

conglomerateRFsFig=figure;
hold on
for i=1:length(goodIndNoCoordSizeOutliers)
    channelRow=goodIndNoCoordSizeOutliers(i);
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
    if channelRFs1000(goodInd(i),1)<6*pixPerDeg&&channelRFs1000(goodInd(i),1)>-1*pixPerDeg&&channelRFs1000(goodInd(i),2)<1*pixPerDeg&&channelRFs1000(goodInd(i),2)>-4*pixPerDeg
        if area=='V1'
            areaNum=1;
            ellipse_solid(0.2,0.2,channelRFs1000(goodIndNoCoordSizeOutliers(i),1)/pixPerDeg,channelRFs1000(goodIndNoCoordSizeOutliers(i),2)/pixPerDeg,[0 0 0]);
        elseif area=='V4'
            areaNum=4;
        end
        badQuadrant=[badQuadrant;arrayNum channelNum areaNum instanceInd channelInd];
    end
    %     ellipse_solid(channelRFs1000(goodIndNoCoordSizeOutliers(i),12)/pixPerDeg,channelRFs1000(goodIndNoCoordSizeOutliers(i),13)/pixPerDeg,channelRFs1000(goodIndNoCoordSizeOutliers(i),1)/pixPerDeg,channelRFs1000(goodIndNoCoordSizeOutliers(i),2)/pixPerDeg,[0 0 0]);
end
xCoords=channelRFs1000(goodIndNoCoordSizeOutliers,1)/pixPerDeg;
yCoords=channelRFs1000(goodIndNoCoordSizeOutliers,2)/pixPerDeg;
plot(xCoords(outlineRFs),yCoords(outlineRFs));
xlim([-6.4,6.4]);
ylim([-5.6,1]);

% calculate block conditions 1
Xrange = [1 6.4];
Yrange = [-5.6 1];
XResolution = 0.3;
YResolution = 0.3;
NumRepeats = 10;
NumX = round((max(Xrange) - min(Xrange)) / XResolution + 1);
NumY = round((max(Yrange) - min(Yrange)) / YResolution + 1);
BlkConditions = zeros(2,NumX*NumY);
CondID = 0;
for thisX = 1:NumX
    thisXPos = min(Xrange) + (thisX-1) * XResolution;
    for thisY = 1:NumY
%         CondID = (thisX-1) * NumX + thisY;
        CondID = CondID + 1;
        thisYPos = min(Yrange) + (thisY-1) * YResolution;
        BlkConditions(1,CondID) = thisXPos;
        BlkConditions(2,CondID) = thisYPos;
    end
end

% calculate block conditions 2
Xrange = [-6.4 -1];
Yrange = [-5.6 1];
XResolution = 0.3;
YResolution = 0.3;
NumRepeats = 10;
NumX = round((max(Xrange) - min(Xrange)) / XResolution + 1);
NumY = round((max(Yrange) - min(Yrange)) / YResolution + 1);
BlkConditions2 = zeros(2,NumX*NumY);
CondID = 0;
for thisX = 1:NumX
    thisXPos = min(Xrange) + (thisX-1) * XResolution;
    for thisY = 1:NumY
%         CondID = (thisX-1) * NumX + thisY;
        CondID = CondID + 1;
        thisYPos = min(Yrange) + (thisY-1) * YResolution;
        BlkConditions2(1,CondID) = thisXPos;
        BlkConditions2(2,CondID) = thisYPos;
    end
end
BlkConditions = [BlkConditions,BlkConditions2];
boundaryX=xCoords(outlineRFs);
boundaryY=yCoords(outlineRFs);
overlapRFs = inpolygon(BlkConditions(1,:),BlkConditions(2,:),xCoords(outlineRFs),yCoords(outlineRFs));
save('D:\aston_data\conditions_overlapV1RFs_Aston.mat','overlapRFs','boundaryX','boundaryY');
hold on;plot(0,0,'bo');
figure;
hold on
for ind=1:size(BlkConditions,2)
    if overlapRFs(ind)==0
        plot(BlkConditions(1,ind),BlkConditions(2,ind),'bo');%no overlap
    elseif overlapRFs(ind)==1
        plot(BlkConditions(1,ind),BlkConditions(2,ind),'ro');%overlap
    end
end

%analyse RF size as a function of eccentricity:
channelsV1=[];
channelsV4=[];
channelsV1arrayNum=[];
channelsV4arrayNum=[];
v1fig=figure;hold on%colour-coded by array number
v4fig=figure;hold on%colour-coded by array number
for i=1:length(goodInd)
    channelRow=goodInd(i);
    instanceInd=ceil(channelRow/128);
    channelInd=mod(channelRow,128);
    if channelInd==0
        channelInd=128;
    end
    [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd);
    arrayCol=find(goodArrays==arrayNum);
    if channelRFs1000(goodInd(i),1)>0||channelRFs1000(goodInd(i),2)<10
        if area=='V1'
            areaNum=1;
            eccentricity=sqrt(channelRFs1000(goodInd(i),1)^2+channelRFs1000(goodInd(i),2)^2);
            if eccentricity<300&&channelRFs1000(goodInd(i),4)<10
                channelsV1=[channelsV1;eccentricity channelRFs1000(goodInd(i),4)];
                channelsV1arrayNum=[channelsV1arrayNum;colind(arrayNum,:)];
%                 figure(v1fig);
%                 plot(eccentricity,channelRFs1000(goodInd(i),4),'MarkerEdgeColor',colind(arrayNum,:),'Marker','x');
            end
        elseif area=='V4'
            areaNum=4;
            eccentricity=sqrt(channelRFs1000(goodInd(i),1)^2+channelRFs1000(goodInd(i),2)^2);
            if eccentricity<900&&channelRFs1000(goodInd(i),4)<50
                channelsV4=[channelsV4;eccentricity channelRFs1000(goodInd(i),4)];
                channelsV4arrayNum=[channelsV4arrayNum;colind(arrayNum,:)];
%                 figure(v4fig);
%                 plot(eccentricity,channelRFs1000(goodInd(i),4),'MarkerEdgeColor',colind(arrayNum,:),'Marker','x');
            end
        end
    end
end
% removeoutliers(channelsV1)
meanEccentricityV1=mean(channelsV1(:,1));
stdEccentricityV1=std(channelsV1(:,1));
notOutliers=find(channelsV1(:,1)<meanEccentricityV1+stdEccentricityV1*3);%outliers are considered to be values lying more than 3 SD from the mean
channelsV1NoOutliers=channelsV1(notOutliers,:);
channelsV1arrayNum=channelsV1arrayNum(notOutliers,:);
figure(v1fig);
scatter(channelsV1NoOutliers(:,1),channelsV1NoOutliers(:,2),[],channelsV1arrayNum)
set(gca,'XTick',[0:25:200],'XTickLabels',[0:8]);
xlabel('eccentricity (dva)')
ylabel('size (dva)')
title(['RF size versus eccentricity, V1 channels (N=',num2str(length(channelsV1NoOutliers)),'/',num2str(64*14),')'])
xlim([0 170]);
ylim([0 6]);

[r p]=corr(channelsV1NoOutliers)%R=0.4188, p<.001, N=603
figure;hold on
plot(channelsV1NoOutliers(:,1),channelsV1NoOutliers(:,2),'ko');
set(gca,'XTick',[0:25:200],'XTickLabels',[0:8]);
xlabel('eccentricity (dva)')
ylabel('size (dva)')
title(['RF size versus eccentricity, V1 channels (N=',num2str(length(channelsV1NoOutliers)),'/',num2str(64*14),')'])

meanEccentricityV4=mean(channelsV4(:,1));
stdEccentricityV4=std(channelsV4(:,1));
notOutliers=find(channelsV4(:,1)<meanEccentricityV4+stdEccentricityV4*3);%outliers are considered to be values lying more than 3 SD from the mean
channelsV4NoOutliers=channelsV4(notOutliers,:);
channelsV4arrayNum=channelsV4arrayNum(notOutliers,:);
figure(v4fig);
scatter(channelsV4NoOutliers(:,1),channelsV4NoOutliers(:,2),[],channelsV4arrayNum)
set(gca,'XTick',[0:25:200],'XTickLabels',[0:8]);
xlabel('eccentricity (dva)')
ylabel('size (dva)')
title(['RF size versus eccentricity, V4 channels (N=',num2str(length(channelsV4NoOutliers)),'/',num2str(64*2),')'])

[r p]=corr(channelsV4NoOutliers)%R=0.5698, p<.001, N=90
figure;hold on
plot(channelsV4NoOutliers(:,1),channelsV4NoOutliers(:,2),'ko');
set(gca,'XTick',[0:25:200],'XTickLabels',[0:8]);
xlabel('eccentricity (dva)')
ylabel('size (dva)')
title(['RF size versus eccentricity, V4 channels (N=',num2str(length(channelsV4NoOutliers)),'/',num2str(64*2),')'])

% %all good orientation-tuned channels, colour-coded by preferred orientation
% fileName='X:\best\080618_B3\good_channels_preferred_orientations.mat';%load data generated by analyse_RForitune.m and combine_orientation_tuning.m
% load(fileName,'allPrefOri');
% numTunedChs=length(find(allPrefOri~=-1));
% figure
% hold on
% scatter(0,0,'r','o','filled');%fix spot
% colindOri=cool(180);
% arrayNums=[];
% goodArrays=1:16;
% badQuadrant=[];
% for i=1:length(goodInd)
%     channelRow=goodInd(i);
%     instanceInd=ceil(channelRow/128);
%     channelInd=mod(channelRow,128);
%     if channelInd==0
%         channelInd=128;
%     end
%     [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd);
%     arrayCol=find(goodArrays==arrayNum);
%     arrayNums=[arrayNums arrayNum];
%     if strcmp(area,'V1')
%         markerCol='k';%V1
%     else
%         markerCol='b';%V4
%     end
% %     if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
% %         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','o');
% %     else
% %         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','x');
% %         %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
% %     end
%     if channelRFs1000(goodInd(i),1)<0||channelRFs1000(goodInd(i),2)>10
%         if area=='V1'
%             areaNum=1;
%         elseif area=='V4'
%             areaNum=4;
%         end
%         badQuadrant=[badQuadrant;arrayNum channelNum areaNum instanceInd channelInd];
%     end
%     if allPrefOri(i)~=-1
%         prefOri=round(allPrefOri(i));
%         if prefOri==0
%             prefOri=180;
%         end
%         if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
%             plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colindOri((prefOri),:),'Marker','o');
%         else
%             plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colindOri((prefOri),:),'Marker','x');
%             %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
%         end
%     else%not orientation-tuned
%         plotUntuned=1;
%         if plotUntuned==1
%             if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
%                 plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',[1 0 0],'Marker','o');
%             else
%                 plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',[1 0 0],'Marker','x');
%             end
%         end
%     end
% end
% colormap cool
% colorbar('Ticks',[0 0.5 1],'TickLabels',{'0','90','180'})
% arrayNums=unique(arrayNums);
% %draw dotted lines indicating [0,0]
% plot([0 0],[-250 200],'k:')
% plot([-200 300],[0 0],'k:')
% plot([-200 300],[200 -300],'k:')
% ellipse(50,50,0,0,[0.1 0.1 0.1]);
% ellipse(100,100,0,0,[0.1 0.1 0.1]);
% ellipse(150,150,0,0,[0.1 0.1 0.1]);
% ellipse(200,200,0,0,[0.1 0.1 0.1]);
% text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
% xlim([leftEdge-50 rightEdge+50]);
% ylim([bottomEdge-50 topEdge+50]);
% axis square
% ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% if plotUntuned==1
%     titleText=['all good channel RFs, colour-coded by preferred orientation, ',num2str(numTunedChs),'/',num2str(length(goodInd)),' channels'];
% else
%     titleText=['all good channel RFs, colour-coded by preferred orientation, ',num2str(length(goodInd)),' channels'];
% end
% title(titleText);
% axis equal
% xlim([-20 210]);
% ylim([-160 20]);
% if plotUntuned==1
%     text(170,-150,'red:  not orientation-tuned','Color',[1 0 0]);
% end

%all good channels, colour-coded by mean SNR
SNRFileName='D:\aston_data\results\allSNR_280818.mat';
load(SNRFileName,'allSNR');
goodSessionSNR=allSNR(:,1);%session 280818_B1_aston, first calculation of SNR values since his implantation
maxSNR=max(goodSessionSNR);
logGoodSessionSNR=ceil(log(goodSessionSNR))+1;%add 1 to create an entry for values of 0
figure
hold on
scatter(0,0,'r','o','filled');%fix spot
colindSNR=cool(1+ceil(max(logGoodSessionSNR)));%add 1 to create an entry for values of 0
ind1=1/ceil(max(logGoodSessionSNR));
arrayNums=[];
goodArrays=1:16;
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
    if goodSessionSNR(i)>0
        if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colindSNR(logGoodSessionSNR(i),:),'Marker','o');
        else
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colindSNR(logGoodSessionSNR(i),:),'Marker','x');
            %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
        end
    else%SNR of 0
        if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',[1 0 0],'Marker','o');
        else
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',[1 0 0],'Marker','x');
        end
    end
end
colormap cool
colorbar('Ticks',[0 ind1 1],'TickLabels',{'0','1',round(maxSNR)})
arrayNums=unique(arrayNums);
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:')
plot([-200 300],[0 0],'k:')
plot([-200 300],[200 -300],'k:')
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
xlim([leftEdge-50 rightEdge+50]);
ylim([bottomEdge-50 topEdge+50]);
axis square
ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
titleText=['all good channel RFs, colour-coded by SNR, ',num2str(length(goodInd)),' channels'];
title(titleText);
axis equal
xlim([-20 210]);
ylim([-160 20]);

%all good channels, colour-coded by eccentricity
plotMtLAtP=1;%1: medial-lateral; 2: anterior-posterior
plotV1=1;
plotV4=0;
figure
hold on
scatter(0,0,'r','o','filled');%fix spot
if drawBarArea==1
    for i=1:size(XVEC1,1)
        h = line(XVEC1(i,:),YVEC1(i,:),'LineWidth',1);
        set(h,'Color',[0.5 0.5 0.5])
    end
end
if plotMtLAtP==1
    colind = cool(max(V1MtLAtP(:,1)));
    if plotV1==0
        colind=cool(2);
    end
elseif plotMtLAtP==2
    colind = winter(max(V1MtLAtP(:,2)));
end
goodArrays=1:16;
% goodArrays=[1 2 3 4 9 10 11 13 14 15 16];
% colind = hsv(11);
countV4=0;
for i=1:length(goodInd)
    channelRow=goodInd(i);
    instanceInd=ceil(channelRow/128);
    channelInd=mod(channelRow,128);
    if channelInd==0
        channelInd=128;
    end
    [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd);
    if plotMtLAtP==1
        arrayCol=V1MtLAtP(find(goodArrays==arrayNum),1);%medial to lateral
    elseif plotMtLAtP==2
        arrayCol=V1MtLAtP(find(goodArrays==arrayNum),2);%anterior to posterior
    end
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
    if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
        countV4=countV4+1;
        if plotV4==1
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o');
        end
    elseif plotV1==1
        plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','x');
        %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
    end
end
xlim([-100 300]);
ylim([-300 100]);
arrayNums=unique(arrayNums);
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:')
plot([-200 300],[0 0],'k:')
plot([-200 300],[200 -300],'k:')
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
xlim([leftEdge-50 rightEdge+50]);
ylim([bottomEdge-50 topEdge+50]);
axis square
ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
if plotV4==0
    titleText=['all good V1 channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)-countV4),' channels'];
end
if plotV1==0
    titleText=['all good V4 channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(countV4),' channels'];
end
if plotV1==1&&plotV4==1
    titleText=['all good channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)),' channels'];
end
title(titleText);
if plotMtLAtP==1&&plotV1==1
    for i=1:7
        text(210,-100-i*8,num2str(i),'Color',colind(i,:))
    end
    text(210,-100-1*8,'   medial','Color',colind(1,:))
    text(210,-100-7*8,'   lateral','Color',colind(7,:))
elseif plotMtLAtP==1&&plotV1==0
    for i=1:2
        text(210,-100-i*8,num2str(i),'Color',colind(i,:))
    end
    text(210,-100-1*8,'   medial','Color',colind(1,:))
    text(210,-100-2*8,'   lateral','Color',colind(2,:))
elseif plotMtLAtP==2
    for i=1:3
        text(210,-100-i*8,num2str(i),'Color',colind(i,:))
    end
    text(210,-100-1*8,'   anterior','Color',colind(1,:))
    text(210,-100-3*8,'   posterior','Color',colind(3,:))
end

%good channels only
figure
colormap(cool)
hold on
scatter(0,0,'r','o');%fix spot
% c = linspace(0.1,1,size(V1MtLAtP,1));
% c=[c' 1-c'+0.01 c'];
c = linspace(1,10,max(V1MtLAtP(:,1)));
for i=1:length(goodInd)
    channelNo=channelRFs1000(goodInd(i));
    arrayNum=ceil(i/64);
    if arrayNum==2||arrayNum==5%V4 arrays
%         scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'g','x');
    else
        scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),[],c(V1MtLAtP(arrayNum,1)));
    end
%     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
end
for i=1:length(badInd)
%     scatter(channelRFs1000(badInd(i),1),channelRFs1000(badInd(i),2),'r','x');
end
xlim([-100 300]);
ylim([-300 100]);
%plot area of sweeping bar
if drawBarArea==1
    for i=1:size(XVEC1,1)
        h = line(XVEC1(i,:),YVEC1(i,:),'LineWidth',1);
        set(h,'Color',[0.5 0.5 0.5])
    end
end
xlim([50 150]);
ylim([-150 -50]);
axis square
ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
title('all channel RFs');