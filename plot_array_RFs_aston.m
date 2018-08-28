function plot_array_RFs
%Written by Xing 31/5/17
%Plots RF centres and sizes of all 1000 channels (can select channel
%inclusion based on SNR of MUA).

% channelRFs(channelInd,:)=[RF.centrex RF.centrey RF.sz RF.szdeg RF.ang RF.theta RF.ecc channelSNR(channelInd,:) horizontalRadius verticalRadius];

date='best_260617-280617';

speed = 250/1000; %this is speed in pixels per ms
bardur = 1; %duration in seconds
bardist = speed*bardur*1000;

sampFreq=30000;
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;

%assign arrays according to layout on cortex:
V1MtLAtP=[7 1;2 1;1 1;6 2;6 1;5 2;5 1;4 2;1 1;1 2;1 3;2 1;2 2;3 1;3 2;4 1];
%locations of arrays, first columns gives their rank order from medial to more lateral,
%and second column gives their rank order going from more anterior to more posterior
%V4 arrays are coded similarly.

channelRFs1000=[];
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    fileName=fullfile('D:\data',date,['RFs_',instanceName,'.mat']);
    load(fileName)
    channelRFs1000=[channelRFs1000;channelRFs];
end
SNRthreshold=2;
meanChannelSNR=mean(channelRFs1000(:,8:11),2);
goodInd=find(meanChannelSNR>=SNRthreshold);
badInd=find(meanChannelSNR<SNRthreshold);
length(goodInd)/1024

%all good channels, colour-coded by eccentricity
plotMtLAtP=1;%1: medial-lateral; 2: anterior-posterior
for arrayOfInterest=1:16
    switch(date)%x & y co-ordinates of centre-point
        case '060617_B2'
            x0 = 70;
            y0 = -70;
        case '060617_B4'
            x0 = 100;
            y0 = -100;
        case '260617_B1'
            x0 = 70;
            y0 = -70;
        case '280617_B1'
            x0 = 30;
            y0 = -30;
        case 'best_260617-280617'
            if arrayOfInterest==1||arrayOfInterest==4
                x0 = 30;%280617 mapping with small thin bar
                y0 = -30;
            else
                x0 = 70;%260617 mapping with larger bar
                y0 = -70;
            end
    end
    if arrayOfInterest==2||arrayOfInterest==3
        plotV1=0;
        plotV4=1;
    else
        plotV1=1;
        plotV4=0;
    end

    %calculate area of sweeping bar
    leftEdge=x0-bardist/2;
    rightEdge=x0+bardist/2;
    topEdge=y0+bardist/2;
    bottomEdge=y0-bardist/2;
    XVEC1 = [leftEdge rightEdge rightEdge leftEdge leftEdge];
    YVEC1 = [bottomEdge bottomEdge topEdge topEdge bottomEdge];
    figure
    hold on
    scatter(0,0,'r','o','filled');%fix spot
    h = line(XVEC1,YVEC1,'LineWidth',1);
    set(h,'Color',[0.5 0.5 0.5])
    if plotMtLAtP==1
        colind = cool(7);
        if plotV1==0
            colind=cool(2);
        end
    elseif plotMtLAtP==2
        colind = winter(3);
    end
    goodArrays=1:16;
    % goodArrays=[1 2 3 4 9 10 11 13 14 15 16];
    % colind = hsv(11);
    countChannels=0;
    for i=1:length(goodInd)
        channelRow=goodInd(i);
        instanceInd=ceil(channelRow/128);
        channelInd=mod(channelRow,128);
        if channelInd==0
            channelInd=128;
        end
        testMattRFMap=1;
        if testMattRFMap==0
            [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd);
        elseif testMattRFMap==1
            load('D:\data\channel_area_mapping.mat')
            channelNum=channelNums(channelInd,instanceInd);
            arrayNum=arrayNums(channelInd,instanceInd);            
        end
        arrayColumn=mod(channelNum,8);
        if arrayColumn==0
            arrayColumn=8;
        end
        arrayRow=ceil(channelNum/8);
        if plotMtLAtP==1
            arrayCol=V1MtLAtP(find(goodArrays==arrayNum),1);%medial to lateral
        elseif plotMtLAtP==2
            arrayCol=V1MtLAtP(find(goodArrays==arrayNum),2);%anterior to posterior
        end
        if arrayNum==arrayOfInterest
            countChannels=countChannels+1;
            if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2&&plotV4==1%V4 RFs
                plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',[1-1/arrayColumn 0 1-1/arrayRow],'MarkerFaceColor',[1-1/arrayColumn 0 1-1/arrayRow],'Marker','o');
            elseif plotV1==1
                plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',[1-1/arrayColumn 0 1-1/arrayRow],'MarkerFaceColor',[1-1/arrayColumn 0 1-1/arrayRow],'Marker','o');
                %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
            end
%             text(channelRFs1000(goodInd(i),1)+1,channelRFs1000(goodInd(i),2),num2str(channelNum));
            text(channelRFs1000(goodInd(i),1)+0.2,channelRFs1000(goodInd(i),2),num2str(channelNum));
        end
    end
    xlim([-100 300]);
    ylim([-300 100]);
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
        titleText=['array ',num2str(arrayOfInterest),', V1 channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(countChannels),' channels'];
        fileName=['array_',num2str(arrayOfInterest),'_V1_channel_RFs_SNR',num2str(SNRthreshold)];
    end
    if plotV1==0
        titleText=['array ',num2str(arrayOfInterest),', V4 channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(countChannels),' channels'];
        fileName=['array_',num2str(arrayOfInterest),'_V4_channel_RFs_SNR',num2str(SNRthreshold)];
    end
    if plotV1==1&&plotV4==1
        titleText=['array ',num2str(arrayOfInterest),', good channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)),' channels'];
        fileName=['array_',num2str(arrayOfInterest),'_good_channel_RFs_SNR',num2str(SNRthreshold)];
    end
    title(titleText);
    pathName=fullfile('D:\data',date,fileName);
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%     print(pathName,'-dtiff');

    pathName=fullfile('D:\data',date,[fileName '_zoom']);
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%     print(pathName,'-dtiff');
    close all
end
