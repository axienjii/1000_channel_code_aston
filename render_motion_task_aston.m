function render_motion_task_aston(movieVersion)
%Written by Xing 15/4/20. Read in images of monkeys in setup, identify
%x- and y-coordinates of arrays on cortex, and assign pixels on each array
%to each electrode. Combines pixel coordinates with microstimulation, RF
%centres, and eye movements. 

% movieVersion=1;
for monkeyInd=2
    if monkeyInd==1%Lick
        A = imread('X:\best\barsweep_video_in_setup\lick_realistic_skin_intact11.jpg');
        rootDir='X:\best';%'D:\data';
        remoteDir='X:\best';
        load('D:\data\channel_area_mapping.mat')
    elseif monkeyInd==2%Aston
        A = imread('D:\aston_data\barsweep_video_in_setup\aston_realistic_skin_intact11.jpg');
        rootDir='D:\aston_data';
        remoteDir='X:\aston';
        load('D:\aston_data\channel_area_mapping_aston.mat')
    end
    image(A);
    copyA=A;
    for xInd=365:385
        for yInd=335:355
            copyA(yInd,xInd,:)=[149 149 149];
        end
    end
    hold on
    if monkeyInd==1%Lick
        load('X:\best\barsweep_video_in_setup\lick_cornerCoords.mat')
    elseif monkeyInd==2%Aston
        load('D:\aston_data\barsweep_video_in_setup\aston_cornerCoords.mat')
    end
    selectScreenCorners=0;
    if selectScreenCorners==1
        [xScreenCorners yScreenCorners]=ginput(4);
        scatter(xScreenCorners,yScreenCorners,'filled','y')
        if monkeyInd==1%Lick
            save('D:\data\ori_video_in_setup\lick_screenCornerCoords.mat','xScreenCorners','yScreenCorners')
        end
    else
        load('X:\best\ori_video_in_setup\lick_screenCornerCoords.mat')
    end
    
    numElectrodesPerEdge=8;%8-by-8 arrays
    numArrays=16;%total number of arrays per hemisphere
    load([rootDir,'\barsweep_video_in_setup\allPixelIDs.mat'])
    
    %read in RF, eye data
    pixperdeg = 25.8601;
    bardur = 1000; %duration in miliseconds
    
    direct{1} = 'L to R';
    direct{2} = 'D to U';
    direct{3} = 'R to L';
    direct{4} = 'U to D';
    
    stimDurms=167;%in ms
    preStimDur=300/1000;%length of pre-stimulus-onset period, in s
    
    drawFrames=1;
    if drawFrames==1
        if monkeyInd==2
            switch(movieVersion)
                case 1
                    datapath = 'D:\aston_data\101218_B5_aston\eye_data_101218_B5_aston.mat';%setNo 14
                case 2
                    datapath = 'D:\aston_data\121218_B10_aston\eye_data_121218_B10_aston.mat';%setNo 18
                case 3
            end
        end
        load(datapath)
        discardTrials=find(cellfun(@isempty,eyeDataXFinal));
        eyeDataXFinal(discardTrials)=[];
        eyeDataYFinal(discardTrials)=[];
        allElectrodeNumFinal(discardTrials)=[];
        allArrayNumFinal(discardTrials)=[];
        
        discountFactor = 0.995;
        NumDiscountDP = 400;
%         NumDiscountDP = 0;
        % discountFactor = 1;
        movieFrameRate=30;
        samplerate = 15000; % Hz, movie sample rate, the lower the value, the slower the movie.
        TrueSampleRate = 30000; % Hz, the real sample rate of the eye data
        blanktime = [0.1 0.3]; % second(s), time before stimulus onset, used to align eye traces
        
        smoothwindow = 850; % span of the smooth window
        
%         voltsperdegX = 360;
%         voltsperdegY = 414;%load('X:\best\261018_B2\volts_per_dva.mat')
%         voltsperdegX = 399;
%         voltsperdegY = 439;%load('X:\best\140918_B1\volts_per_dva.mat')
%         voltsperdegX = 379;
%         voltsperdegY = 427;%load('X:\best\161018_B4\volts_per_dva.mat')
%         voltsperdegX = 360;
%         voltsperdegY = 414;%load('X:\best\261018_B2\volts_per_dva.mat')
%         voltsperdegX = 399;
%         voltsperdegY = 439;%load('X:\best\140918_B1\volts_per_dva.mat')
%         voltsperdegX = 391;
%         voltsperdegY = 417;%load('X:\best\180918_B3\volts_per_dva.mat')
%         voltsperdegX = 381;
%         voltsperdegY = 411;%load('X:\best\260918_B1\volts_per_dva.mat')
%         voltsperdegX = 386;
%         voltsperdegY = 421;%load('X:\best\270918_B1\volts_per_dva.mat')
        voltsperdegX = 398;
        voltsperdegY = 402;%load('X:\best\280918_B1\volts_per_dva.mat')
%         voltsperdegX = 393;
%         voltsperdegY = 397;%load('X:\best\041018_B2\volts_per_dva.mat')
%         voltsperdegX = ?;
%         voltsperdegY = 445;%load('X:\best\020719_B1\volts_per_dva.mat')
        RFpixperdeg = 25.8601;
        
        NumTotalTrialsInMovie = 60;
        % NumTotalTrialsInMovie = numel(eyeDataXFinal);
        randPermTrials=0;
        if randPermTrials==1
            ReRandTrialNumber = randperm(NumTotalTrialsInMovie);
        else
            ReRandTrialNumber = 1:NumTotalTrialsInMovie;
        end
        
        rainbow = 0;
        
        % find number of trials
        numTrials = numel(eyeDataXFinal);
        
        h=figure('position',[100 100 1000 750]);
        set(h,'color',[1 1 1]);
        totalFrame = 0;
        Conditions = [];
        trials = 0;
        
        colors = lines(5);
    
        frameNo=1;
        for thisTrial = 1:NumTotalTrialsInMovie
            disp(['working on trial ', num2str(thisTrial),'/',num2str(NumTotalTrialsInMovie)]);
            thisTrialIdx = ReRandTrialNumber(thisTrial);            
            % get RF locations
%             thisCond = targetLocationsFinal(thisTrialIdx)
            
            array = allArrayNumFinal{thisTrialIdx};
            elec = allElectrodeNumFinal{thisTrialIdx};
            numElec = numel(array);
            elecRFs.x = zeros(numElec,1);
            elecRFs.y = zeros(numElec,1);
            targetAcquiredFlag=0;
            for thisElec = 1:numElec
                instance=ceil(array(thisElec)/2);
                temp1=find(channelNums(:,instance)==elec(thisElec));
                temp2=find(arrayNums(:,instance)==array(thisElec));
                ind=intersect(temp1,temp2);
                load(['D:\aston_data\best_aston_280818-290818\RFs_instance',num2str(instance),'.mat']);
                elecRFs.x(thisElec) = channelRFs(ind,1);
                elecRFs.y(thisElec) = channelRFs(ind,2);
            end
            elecRFs.x = elecRFs.x / RFpixperdeg;
            elecRFs.y = elecRFs.y / RFpixperdeg;
            
            % prepare eye data
            numDP = numel(eyeDataXFinal{thisTrialIdx});
            trialData.x = -double(eyeDataXFinal{thisTrialIdx})/voltsperdegX;
            trialData.y = -double(eyeDataYFinal{thisTrialIdx})/voltsperdegY;
            % subtract first n samples
            trialData.x = trialData.x- mean(trialData.x(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate)));
            trialData.y = trialData.y- mean(trialData.y(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate)));
            
            % smooth the data
            trialData.x = smooth(trialData.x,smoothwindow,'lowess');
            trialData.y = smooth(trialData.y,smoothwindow,'lowess');
            for thisDP = 1:TrueSampleRate/movieFrameRate:numDP%30 kHz/1000 = 30 fps %34001
                copyA2=copyA;
                hold off
                %colour arrays based on delivery of microstimulation on individual electrodes:
                for arrayInd=1:numArrays
                    pixelIDs=allPixelIDs{arrayInd};
                    for colCount=1:numElectrodesPerEdge%each column of electrodes
                        for rowCount=1:numElectrodesPerEdge%each row of electrodes
                            if ~isempty(pixelIDs{rowCount,colCount})
                                for pixelCount=1:size(pixelIDs{rowCount,colCount},1)
                                    copyA2(round(pixelIDs{rowCount,colCount}(pixelCount,2)),round(pixelIDs{rowCount,colCount}(pixelCount,1)),:)=[0 0 255];%set to blue
                                end
                            end
                        end
                    end
                end
                
                image(copyA2);
                h2=figure;
                ax=gca;
                ax.Color=[149/255 149/255 149/255];
                hold on

%                 if thisDP/TrueSampleRate < (300 + 600)/1000 || thisDP/TrueSampleRate >= (300 + 600 + 250)/1000
                    plot(0,0,'ro','MarkerSize',8,'MarkerFaceColor',[1 0 0])
%                 end
                
                % plot targets
                if thisDP/TrueSampleRate >= (300+150*3+100)/1000 && thisDP/ TrueSampleRate <= (300+150*3+100+340)/1000&& targetAcquiredFlag==0
                    plot(0,-180,'.','color',[0 0 0],'markersize',20)%draw targets on screen (upper). Not to scale- actually 10 pixels in diameter, not 20
                    plot(0,210,'.','color',[0 0 0],'markersize',20)%draw targets on screen (lower)
                end
                for i = max(1,thisDP-NumDiscountDP):thisDP
                    if ~rainbow
                        tmp = colorspace('HSL->RGB',[240 - (240 -203.2258) *discountFactor^(thisDP-i),    1*discountFactor^(thisDP-i), 0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % normal version
                    else
                        tmp = colorspace('HSL->RGB',[mod(240 + 360 - (240 + 360 -239) * discountFactor^(thisDP-i),360),    1*discountFactor^(thisDP-i),    0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % rainbow version
                    end
                    plot(trialData.x(i)*pixperdeg,trialData.y(i)*pixperdeg,'.','markersize',32,'color',tmp);
                end
                %plot eye position
                plot(trialData.x(thisDP)*pixperdeg,trialData.y(thisDP)*pixperdeg,'.','markersize',32,'color',[0 0.4471 0.7294])
                if trialData.y(thisDP)>200||trialData.y(thisDP)<-200
                    targetAcquiredFlag=1;
                end
                % plot phosphene percepts
                if thisDP/TrueSampleRate >= 300/1000 && thisDP/ TrueSampleRate <= (300+3*150)/1000
                    if thisDP/TrueSampleRate >= 300/1000 && thisDP/ TrueSampleRate <= (300+150)/1000
                        plot(elecRFs.x(1)*pixperdeg,elecRFs.y(1)*pixperdeg,'.','color',[1 1 1],'markersize',15)%draw phosphenes on screen
                    end
                    if thisDP/TrueSampleRate >= (300+150)/1000 && thisDP/ TrueSampleRate <= (300+2*150)/1000
                        plot(elecRFs.x(2)*pixperdeg,elecRFs.y(2)*pixperdeg,'.','color',[1 1 1],'markersize',15)%draw phosphenes on screen
                    end
                    if thisDP/TrueSampleRate >= (300+150*2)/1000 && thisDP/ TrueSampleRate <= (300+3*150)/1000
                        plot(elecRFs.x(3)*pixperdeg,elecRFs.y(3)*pixperdeg,'.','color',[1 1 1],'markersize',15)%draw phosphenes on screen
                    end
                end
                %                 image(copyA2);
%                 if thisDP/TrueSampleRate >= (300+400+167)/1000
%                     pauseHere=1;
%                 end
                ax.XTick=[];
                ax.XTickLabel={'-10','-5','0','5','10'};
                ax.YTick=[];
                ax.YTickLabel={'-10','-5','0','5','10'};
                set(gca,'Box','off');
                set(gcf,'color','k');
                xlim([-1024/2 1024/2])
                ylim([-768/2 768/2])
                set(gca,'LooseInset',get(gca,'TightInset'))
                movingPoints=[0 0;1344 0;1344 917;0 917];
                yScreenCorners(3)=200;
                xScreenCorners(1)=103;
                xScreenCorners(2)=629;
                xScreenCorners(3)=630;
                xScreenCorners(4)=87;
                fixedPoints=[xScreenCorners*2 yScreenCorners*2];
                tform_cpp = fitgeotrans(movingPoints,fixedPoints,'projective');
                F = getframe(h2);
                F.cdata=flipud(F.cdata);%for images, x and y coordinates are swapped, hence target locations need to be flipped
                B = imwarp(F.cdata,tform_cpp);%warp the screen
                figure;
                imshow(B);
                for xInd=1:size(B,1)%draw stimuli and eye position on setup image
                    for yInd=1:size(B,2)
                        targetsArea=0;
                        if xInd>30&&xInd<325&&yInd>250&&yInd<340
                            targetsArea=1;
                            if sum(B(xInd,yInd,:))==0
                                pauseHere=1;
                            end
                        end
                        if sum(diff(B(xInd,yInd,:)))>1||targetsArea%sum(B(xInd,yInd,:))>50
                            copyA2(round(xScreenCorners(4))+90+xInd,round(yScreenCorners(4))-63+yInd,:)=B(xInd,yInd,:);
                        end
                    end
                end
                
                if thisDP/TrueSampleRate >= 300/1000 && thisDP/ TrueSampleRate <= (300+3*150)/1000
                    % highlight stimulating electrodes on setup image
                    if thisDP/TrueSampleRate >= 300/1000 && thisDP/ TrueSampleRate <= (300+150)/1000
                        arrayInd = allArrayNumFinal{thisTrialIdx}(1);
                        elec = allElectrodeNumFinal{thisTrialIdx}(1);
                    end
                    if thisDP/TrueSampleRate >= (300+150)/1000 && thisDP/ TrueSampleRate <= (300+2*150)/1000
                        arrayInd = allArrayNumFinal{thisTrialIdx}(2);
                        elec = allElectrodeNumFinal{thisTrialIdx}(2);
                    end
                    if thisDP/TrueSampleRate >= (300+150*2)/1000 && thisDP/ TrueSampleRate <= (300+3*150)/1000
                        arrayInd = allArrayNumFinal{thisTrialIdx}(3);
                        elec = allElectrodeNumFinal{thisTrialIdx}(3);                    
                    end
                    rowCount=mod(elec,8);
                    if rowCount==0
                        rowCount=8;
                    end
                    colCount=ceil(elec/8);
                    pixelIDs=allPixelIDs{arrayInd};
                    if ~isempty(pixelIDs{rowCount,colCount})
                        for pixelCount=1:size(pixelIDs{rowCount,colCount},1)
                            copyA2(round(pixelIDs{rowCount,colCount}(pixelCount,2)),round(pixelIDs{rowCount,colCount}(pixelCount,1)),:)=[255 255 0];%set to yellow
                        end
                    end
                end
                
                
                image(copyA2);
                
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                set(gca,'LooseInset',get(gca,'TightInset'))
                set(gca,'visible','off')
%                 totalFrame = totalFrame + 1;
%                 set(gca,'color',[0.6 0.6 0.6]);
%                 F = getframe(h);
%                 [X, Map] = frame2im(F);
%                 FrameData(:,:,:,totalFrame) = X;
                framesResponse(frameNo)=getframe;
                frameNo=frameNo+1;
                close all
            end
        end
        pathname=['D:\aston_data\motion_video_in_setup\setup 1024-channel motion',num2str(movieVersion),'.mat'];
        save(pathname,'framesResponse','-v7.3')
    else
        pathname=['D:\aston_data\motion_video_in_setup\setup 1024-channel motion',num2str(movieVersion),'.mat'];
        load(pathname,'framesResponse')
    end
        
    makeIndividualMovies=1;
    if makeIndividualMovies==1
        pathname=['D:\aston_data\motion_video_in_setup\setup 1024-channel motion',num2str(movieVersion),'.mat'];
        load(pathname)
        
        moviename=['D:\aston_data\motion_video_in_setup\setup 1024-channel motion',num2str(movieVersion),'.avi'];
        v = VideoWriter(moviename);
        v.Quality=100;
        v.FrameRate=movieFrameRate;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
        open(v)
        for timePoint=1:length(framesResponse)
            if size(framesResponse(timePoint).cdata,1)~=915||size(framesResponse(timePoint).cdata,2)~=1240
                framesResponse(timePoint).cdata=framesResponse(timePoint).cdata(1:915,1:1240,:);
                %                     framesResponse(timePoint).cdata=framesResponse(timePoint-1).cdata;
                timePoint
            end
            if size(framesResponse(timePoint).cdata,2)==1344
                framesResponse(timePoint).cdata=framesResponse(timePoint).cdata(1:914,3:1238,:);
            end
            writeVideo(v,framesResponse(timePoint))
        end
        close(v)
        
        % write to movie (MPEG4)
        moviename=['D:\aston_data\motion_video_in_setup\setup 1024-channel motion',num2str(movieVersion)];
        myVideo = VideoWriter(moviename,'MPEG-4');
        myVideo.FrameRate = movieFrameRate;
        myVideo.Quality = 100;
        open(myVideo);
        for thisframe = 1:length(framesResponse)
            %         thisFrameData = squeeze(framesResponse(:,:,:,thisframe));
            writeVideo(myVideo, framesResponse(thisframe));
        end
        close(myVideo);
    end
end
