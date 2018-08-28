function analyse_simphosphenes4(date,allInstanceInd,allGoodChannels)
%3/7/17
%Written by Xing. Loads and analyses MUA data, during presentation
%of simulated phosphene letters.

allLetters='IUALTVSYJP';
if isequal(date,'110717_B1_B2')||isequal(date,'110717_B1')||isequal(date,'110717_B2')||isequal(date,'120717_B1')||isequal(date,'110717_B1_B2_120717_B123')
    allLetters='IUALTVSYJ?';
end

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

stimDurms=800;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;

stimDurCheckerboard=400/1000;%in seconds
preStimDurCheckerboard=300/1000;%length of pre-stimulus-onset period, in s
postStimDurCheckerboard=300/1000;%length of post-stimulus-offset period, in s

calculateVisualResponses=0;
if calculateVisualResponses==1
    for instanceCount=1:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        normMeanChannelResponse1024=[];
        normChannelsResponse=cell(1,length(allLetters));
        goodChannels=allGoodChannels{instanceCount};
        %load data from checkerboard task, to obtain maximum responses for
        %each channel:
        maxCheckerboardResp=[];
        loadDate='110717_B3';
        instanceName=['instance',num2str(instanceInd)];
        fileName=fullfile('D:\data',loadDate,['mean_MUA_',instanceName,'.mat']);
        load(fileName,'meanChannelMUA')
        for channelCount=1:length(goodChannels)
            channelInd=goodChannels(channelCount);
            
            %calculate max response during checkerboard task:
            maxCheckerboard=max(meanChannelMUA(channelInd,sampFreq*preStimDurCheckerboard/downsampleFreq:sampFreq*(preStimDurCheckerboard+stimDurCheckerboard)/downsampleFreq));
            baselineRespCheckerboard=mean(meanChannelMUA(channelInd,1:sampFreq*preStimDurCheckerboard/downsampleFreq-1));
            maxCheckerboardResp=maxCheckerboard-baselineRespCheckerboard;

            %letter task:
            fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat'])
            load(fileName)
            trialData=[];
            for trialInd=1:length(timeStimOnsMatch)
                if downSampling==0
                    startPoint=timeStimOnsMatch(trialInd);
                    if length(channelDataMUA)>=startPoint+sampFreq*stimDur+sampFreq*postStimDur-1
                        trialData(trialInd,:)=channelDataMUA(startPoint-sampFreq*preStimDur:startPoint+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                    end
                elseif downSampling==1
                    startPoint=floor(timeStimOnsMatch(trialInd)/downsampleFreq);
                    if length(channelDataMUA)>=startPoint+sampFreq/downsampleFreq*stimDur+sampFreq/downsampleFreq*postStimDur-1
                        trialData(trialInd,:)=channelDataMUA(startPoint-sampFreq/downsampleFreq*preStimDur:startPoint+sampFreq/downsampleFreq*stimDur+sampFreq/downsampleFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                    end
                end
            end                       
            baseline=mean(mean(trialData(:,1:sampFreq/downsampleFreq*preStimDur)));%calculate baseline activity over initial 300-ms fixation period
            for letterCond=1:10
                meanChannelMUAletter(letterCond,:)=mean(trialData(find(goodTrialCondsMatch(:,1)==letterCond),:),1);
                meanChannelResponse(letterCond,:)=mean(meanChannelMUAletter(letterCond,sampFreq/downsampleFreq*preStimDur+1:sampFreq/downsampleFreq*(preStimDur+stimDur)));
                normChannelsResponse{letterCond}=[normChannelsResponse{letterCond};meanChannelMUAletter(letterCond,:)-baseline];%store activity over the whole trial. each cell contains activity levels, with channels in rows, and time in columns
            end
            normMeanChannelResponse(channelCount,:)=(meanChannelResponse-baseline)/maxCheckerboardResp;%normalise response for each channel to maximum observed during checkerboard task, subtract spontaneous activity levels
            %normMeanChannelResponse(channelCount,:)=(meanChannelResponse-baseline)/(max(meanChannelResponse)-baseline);%normalise response for each channel to maximum, subtract spontaneous activity levels
        end
        normMeanChannelResponse1024=[normMeanChannelResponse1024;normMeanChannelResponse];%mean activity across stimulus presentation period, with channels in rows, and letter conditions in columns
        fileName=['D:\data\',date,'\visual_response_instance',num2str(instanceInd),'.mat'];
        save(fileName,'normChannelsResponse','normMeanChannelResponse1024')        
    end
end
    
%combine RF data and visual response data across 4 of the instances:
allChannelRFs=[];
for instanceInd=1:8
    loadDate='best_260617-280617';
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
    load(fileName)
    allChannelRFs=[allChannelRFs;channelRFs];
end
allNormMeanChannelResponse1024=[];
allNormChannelsResponse=cell(1,10);
for instanceInd=1:8
    loadDate='best_260617-280617';
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
    load(fileName)
    instanceName=['instance',num2str(instanceInd)];
    fileName=['D:\data\',date,'\visual_response_instance',num2str(instanceInd),'.mat'];
    load(fileName,'normChannelsResponse','normMeanChannelResponse1024')
    allNormMeanChannelResponse1024=[allNormMeanChannelResponse1024;normMeanChannelResponse1024];
    for letterCond=1:10
        allNormChannelsResponse{letterCond}=[allNormChannelsResponse{letterCond};normChannelsResponse{letterCond}];
    end
end

blueColorMap = [linspace(1, 0, 124) linspace(0, 1, 132)];%zeros(1, 132)
redColorMap = [zeros(1, 132) linspace(0, 1, 124)];
colorMap = [redColorMap; redColorMap; blueColorMap]';
singleArray=[];
for i=1:10
    singleArray=[singleArray allNormChannelsResponse{i}];
end
figure;
histogram(singleArray)
meanAllResp=mean(singleArray(:));%calculate mean across all responses, channels and time points
sdAllResp=std(singleArray(:));%calculate SD across all responses, channels and time points
colInds=linspace(meanAllResp-2*sdAllResp,meanAllResp+2*sdAllResp,255);
colInds(1)=-10000;%some arbitrarily low value, to capture all the low activity levels 
tempAllNormChannelsResponse=allNormChannelsResponse;

% figure;hold on
for letterCond=1:10
    figure;hold on
%     subplot(2,5,letterCond);hold on
    colInd=allNormMeanChannelResponse1024(:,letterCond);
    col=255-[colInd*255 colInd*5 colInd];
    scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
    xlim([0 200]);
    ylim([-200 0]);
    scatter(0,0,'r','o','filled');%fix spot
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
    axis square
    xlim([0 200]);
    ylim([-200 0]);
    title(['visual responses to symbol ',allLetters(letterCond)]);
    allLetters='IUALTVSYJ?';
    screenWidth=1024;
    screenHeight=768;
    sampleSize=112;%a multiple of 14, the number of divisions in the letters
    visualWidth=sampleSize;%in pixels
    visualHeight=visualWidth;%in pixels
    Par.PixPerDeg=25.860053410707074;
    
    topLeft=1;%distance from fixation spot to top-left corner of sample, measured diagonally (eccentricity)
    sampleX = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%location of sample stimulus, in RF quadrant 150 230%want to try 20
    sampleY = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%[30 140]
    destRect=[screenWidth/2+sampleX screenHeight/2+sampleY screenWidth/2+sampleX+visualWidth screenHeight/2+sampleY+visualHeight];
    plot([0 0],[-240 60],'k:')
    plot([-60 240],[0 0],'k:')
    colind = hsv(10);
    colind = colind(5,:);
    if letterCond<10%all symbols except the square
        targetLetter=allLetters(letterCond);
        letterPath=['D:\data\letters\',targetLetter,'.bmp'];
        originalOutline=imread(letterPath);
        shape=imresize(originalOutline,[visualHeight,visualWidth]);
        whiteMask=shape==0;
        whiteMask=whiteMask*255;
        shapeRGB(:,:,1)=whiteMask+shape*255*colind(1);
        shapeRGB(:,:,2)=whiteMask+shape*255*colind(2);
        shapeRGB(:,:,3)=whiteMask+shape*255*colind(3);
        h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1));
        set(h, 'AlphaData', 0.1);
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene letter ',allLetters(letterCond)]);
        print(pathname,'-dtiff');
    end
    
    for timePoint=1:size(normChannelsResponse{letterCond},2)
        figure;hold on
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        set(gca,'Color',[0 0 0]);
        %     subplot(2,5,letterCond);hold on
        xlim([0 200]);
        ylim([-200 0]);
        scatter(0,0,'r','o','filled');%fix spot
        text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
        axis square
        xlim([0 200]);
        ylim([-200 0]);
        title(['visual responses to symbol ',allLetters(letterCond)]);
        allLetters='IUALTVSYJ?';
        screenWidth=1024;
        screenHeight=768;
        sampleSize=112;%a multiple of 14, the number of divisions in the letters
        visualWidth=sampleSize;%in pixels
        visualHeight=visualWidth;%in pixels
        Par.PixPerDeg=25.860053410707074;
        
        topLeft=1;%distance from fixation spot to top-left corner of sample, measured diagonally (eccentricity)
        sampleX = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%location of sample stimulus, in RF quadrant 150 230%want to try 20
        sampleY = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%[30 140]
        destRect=[screenWidth/2+sampleX screenHeight/2+sampleY screenWidth/2+sampleX+visualWidth screenHeight/2+sampleY+visualHeight];
        plot([0 0],[-240 60],'k:')
        plot([-60 240],[0 0],'k:')
        if timePoint>=300&&timePoint<=1100
            colind = hsv(10);
            colind = colind(5,:);
            colind = [0 0 0];
            if letterCond<10%all symbols except the square
                targetLetter=allLetters(letterCond);
                letterPath=['D:\data\letters\',targetLetter,'.bmp'];
                originalOutline=imread(letterPath);
                shape=imresize(originalOutline,[visualHeight,visualWidth]);
                whiteMask=shape==0;
                whiteMask=whiteMask*255;
                shapeRGB(:,:,1)=255-whiteMask+shape*255*colind(1);
                shapeRGB(:,:,2)=255-whiteMask+shape*255*colind(2);
                shapeRGB(:,:,3)=255-whiteMask+shape*255*colind(3);
                h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1));
            elseif letterCond==10%square full of sim phosphenes
                shape=zeros(visualHeight,visualWidth);
                whiteMask=shape==0;
                shapeRGB(:,:,1)=255-whiteMask+shape*255*colind(1);
                shapeRGB(:,:,2)=255-whiteMask+shape*255*colind(2);
                shapeRGB(:,:,3)=255-whiteMask+shape*255*colind(3);
                h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1));
            end
            set(h, 'AlphaData', 0.4);
        end
        hold on            
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250 200],'r:')
        plot([-200 300],[0 0],'r:')
        plot([-200 300],[200 -300],'r:')
        ellipse(50,50,0,0,[1 1 1]);
        ellipse(100,100,0,0,[1 1 1]);
        ellipse(150,150,0,0,[1 1 1]);
        ellipse(200,200,0,0,[1 1 1]);
%         colInd=allNormChannelsResponse{letterCond}(:,timePoint);
%         col=[colInd*250 colInd*5 colInd];
        %scale activity levels between -7.7 and 25.5, while keeping zero
        %point constant:
        findPositive=find(allNormChannelsResponse{letterCond}(:,timePoint)>=0);
        tempAllNormChannelsResponse{letterCond}(findPositive,timePoint)=allNormChannelsResponse{letterCond}(findPositive,timePoint);%/25.5479;
        findNegative=find(allNormChannelsResponse{letterCond}(:,timePoint)<0);
        tempAllNormChannelsResponse{letterCond}(findNegative,timePoint)=allNormChannelsResponse{letterCond}(findNegative,timePoint);%/7.7113;
        for tempInd=1:length(allNormChannelsResponse{letterCond}(:,timePoint))%convert activity levels into colour indices for 'colorMap' colour map
            temp=find(colInds<=tempAllNormChannelsResponse{letterCond}(tempInd,timePoint));
            colInd(tempInd)=temp(end);
        end
        scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
        scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],colorMap(colInd));
        axis square
        xlim([0 200]);
        ylim([-200 0]);
        framesResponse(timePoint)=getframe;
        close all
    end
    pathname=fullfile('D:\data',date,['1024-channel responses to letter ',allLetters(letterCond),'.mat']);
    if letterCond==10%square full of sim phosphenes
        pathname=fullfile('D:\data',date,['1024-channel responses to square.mat']);
    end
    save(pathname,'framesResponse','-v7.3')
%     movieFig=figure;
%     movie(movieFig,framesResponse,1,50);  
    moviename=fullfile('D:\data',date,['1024-channel responses to letter ',allLetters(letterCond),'.avi']);
    if letterCond==10%square full of sim phosphenes
        moviename=fullfile('D:\data',date,'1024-channel responses to square.avi');
    end
    v = VideoWriter(moviename);
    v.FrameRate=500;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
    open(v)
    for timePoint=1:length(framesResponse)
        writeVideo(v,framesResponse(timePoint))
    end
    close(v)
end
pauseHere=1;

%to draw a frame from the saved data:
date='110717_B1_B2_120717_B123';
timePoint=390;
allLetters='IUALTVSYJ?';
for letterCond=9%1:10
    if letterCond<10
        load(['D:\data\110717_B1_B2_120717_B123\1024-channel responses to letter ',allLetters(letterCond),'.mat'])
    else
        load('D:\data\110717_B1_B2_120717_B123\1024-channel responses to square.mat')
    end
    figure;
    imshow(framesResponse(timePoint).cdata)
    if letterCond<10
        pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene letter ',allLetters(letterCond),'_time',num2str(timePoint)]);
    else
        pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene square_time',num2str(timePoint)]);
    end
    print(pathname,'-dtiff');
end

%all symbols in one figure:
figure;
date='110717_B1_B2_120717_B123';
timePoint=390;
allLetters='IUALTVSYJ?';
for letterCond=1:10
    if letterCond<10
        load(['D:\data\110717_B1_B2_120717_B123\1024-channel responses to letter ',allLetters(letterCond),'.mat'])
    else
        load('D:\data\110717_B1_B2_120717_B123\1024-channel responses to square.mat')
    end
    subplot(2,5,letterCond);
    imshow(framesResponse(timePoint).cdata)
end
pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene letters_time',num2str(timePoint)]);
print(pathname,'-dtiff');