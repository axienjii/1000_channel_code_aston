function analyse_microstim_artefact(date,allInstanceInd,allGoodChannels)
%17/8/17
%Written by Xing. Plots profile of stimulation artefact across channels.

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

stimDurms=800;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=400/1000;%length of post-stimulus-offset period, in s
artefactDur=50/1000;%length of microstimulation period to analyse, in ms
sampFreq=30000;

stimDurCheckerboard=400/1000;%in seconds
preStimDurCheckerboard=300/1000;%length of pre-stimulus-onset period, in s
postStimDurCheckerboard=300/1000;%length of post-stimulus-offset period, in s

switch date
    case '150817_B9'
        arrayNumber=13;electrodeNumber=37;%array 13, electrode 37 (g)
    case '160817_B1'
        arrayNumber=13;electrodeNumber=37;%array 13, electrode 37 (g)
    case '160817_B2'
        arrayNumber=13;electrodeNumber=38;%array 13, electrode 37 (g)
    case '160817_B5'
        arrayNumber=13;electrodeNumber=41;%array 13, electrode 41
    case '160817_B6'
        arrayNumber=13;electrodeNumber=55;%array 13, electrode 55
    case '160817_B7'
        arrayNumber=13;electrodeNumber=56;%array 13, electrode 56
    case '160817_B8'
        arrayNumber=13;electrodeNumber=61;%array 13, electrode 61
end

matFile=['X:\best\',date,'\',date,'_data\microstim_saccade_',date,'.mat'];
load(matFile);
[dummy goodTrials]=find(performance~=0);%either 1 (correct) or -1 (incorrect)
goodTrialConds=allCurrentLevel(goodTrials);
goodTrialIDs=TRLMAT(goodTrials,:);

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

processRaw=0;
if processRaw==1
    for instanceCount=1:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
        codeTargOn=2;%In runstim code, TargB (target bit) is 2.
        corrBit=7;
        ErrorBit=0;
        %dasbit sends a change in the bit (either high or low) on one of the 8 ports
        oldIndStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^codeTargOn);%starts at 2^0, till 2^7
        oldTimeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(oldIndStimOns);%time stamps corresponding to stimulus onset
        correctTrialCodes=[codeTargOn 4 corrBit];%identify trials where fixation was maintained throughout
        incorrectTrialCodes=[codeTargOn 4 ErrorBit];%identify trials where fixation was maintained throughout
        indStimOns=[];
        timeStimOns=[];
        trialStimConds=[];
        performanceNEV=[];
        for i=1:length(oldIndStimOns)
            if oldIndStimOns(i)+11<length(NEV.Data.SerialDigitalIO.UnparsedData)
                trialCodes(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i):oldIndStimOns(i)+11);
                if sum(trialCodes(i,1:length(correctTrialCodes))==2.^correctTrialCodes)==length(correctTrialCodes)||sum(trialCodes(i,1:length(correctTrialCodes))==2.^incorrectTrialCodes)==length(incorrectTrialCodes)
                    indStimOns=[indStimOns oldIndStimOns(i)];
                    timeStimOns=[timeStimOns oldTimeStimOns(i)];
                    trialStimConds=[trialStimConds NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i)+3:oldIndStimOns(i)+10)];%read out stimulus condition
                    if trialCodes(i,3)==2^corrBit
                        performanceNEV=[performanceNEV 1];
                    elseif trialCodes(i,3)==2^ErrorBit
                        performanceNEV=[performanceNEV -1];
                    end
                end
            end
        end             
        convertedGoodTrialIDs=goodTrialIDs';
        convertedGoodTrialIDs=2.^convertedGoodTrialIDs;
        goodTrialIDscounter=1;
        goodTrialsInd=[];
        indStimOnsMatch=[];
        timeStimOnsMatch=[];
        matMatchInd=[];
        for rowInd=1:length(indStimOns)
            matchInd=1;
            ID=[];
            for nevSeqInd=1:7%scan through the trial ID to find matching digits
                match=find(trialStimConds(nevSeqInd,rowInd)==convertedGoodTrialIDs(matchInd:8,goodTrialIDscounter));
                if ~isempty(match)
                    match=match(1);                    
                    ID=[ID trialStimConds(nevSeqInd,rowInd)];
                end
            end
            if length(ID)>=6%all 6 digits are present and in the correct order
                goodTrialsInd=[goodTrialsInd rowInd];
                indStimOnsMatch=[indStimOnsMatch indStimOns(rowInd)];
                timeStimOnsMatch=[timeStimOnsMatch timeStimOns(rowInd)];
                IDs(:,rowInd)=convertedGoodTrialIDs(1:6,goodTrialIDscounter);
                matMatchInd=[matMatchInd goodTrialIDscounter];
                goodTrialIDscounter=goodTrialIDscounter+1;
            else%if the trials do not align at first, search through subsequent trials in goodTrialIDs to find matching one. If none match, then that trial (although present in NEV data) will be excluded
                matchFlag=0;
                while matchFlag==0
                    matchInd=1;
                    ID=[];
                    for nevSeqInd=1:7
                        match=find(trialStimConds(nevSeqInd,rowInd)==convertedGoodTrialIDs(matchInd:8,goodTrialIDscounter));
                        if ~isempty(match)
                            match=match(1);
                            ID=[ID trialStimConds(nevSeqInd,rowInd)];
                        end
                    end
                    if length(ID)>=6
                        goodTrialIDscounter=goodTrialIDscounter+1;
                        goodTrialsInd=[goodTrialsInd rowInd];
                        indStimOnsMatch=[indStimOnsMatch indStimOns(rowInd)];
                        timeStimOnsMatch=[timeStimOnsMatch timeStimOns(rowInd)];
                        IDs(:,rowInd)=convertedGoodTrialIDs(1:6,goodTrialIDscounter);%store the X- and Y- positions for that stimulus presentation
                        matchFlag=1;
                        matMatchInd=[matMatchInd goodTrialIDscounter];
                    else
                        goodTrialIDscounter=goodTrialIDscounter+1;
                    end
                end
            end
        end
        trialIndConds={};
        goodTrialCondsMatch=goodTrialConds(matMatchInd);%update list of microstimulation current amplitude conditions based on matched trials between .mat and .nev files
        performanceInd=goodTrials(matMatchInd);
        performanceMatch=performance(performanceInd); 
        numCorrTrials=length(find(performanceMatch==1));
        numIncorrTrials=length(find(performanceMatch==-1));
%         if length(performanceNEV)>matMatchInd(end)
%         performanceNEVMatch=performanceNEV(performanceInd); 
%         end
        for currentInd=1:length(finalCurrentVals)%current amplitude conditions
            trialIndConds{currentInd}=find(goodTrialCondsMatch(:)==finalCurrentVals(currentInd));
            trialPerf{currentInd}=performanceNEV(trialIndConds{currentInd});%notes down whether monkey's response was correct or incorrect
        end

        %read in neural data:
%         switch(instanceInd)
%             case(5)
%                 goodChannels=53:128;
%             otherwise
%                 goodChannels=1:128;
%         end
        goodChannels=allGoodChannels{instanceCount};
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6']; 
        for channelCount=1:length(goodChannels)
            channelInd=goodChannels(channelCount);
            readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
            tic
            NSchOriginal=openNSx(instanceNS6FileName,'read',readChannel);
            NSch=NSchOriginal.Data;
%             load('D:\data\050717_B2\instance1_ch1_NSch_data.mat','NSchOriginal');
%             load('D:\data\040717_B1\instance5_ch1_NSch_data.mat')
            %         NS=openNSx(instanceNS6FileName);
            % NS=openNSx('t:1:6000000');%200 s
%             if size((NSchOriginal.Data),2)>1
%                 NSchOriginal=NSch;
%                 NSch=[];
%                 for chunkInd=1:length(NSchOriginal.Data)
%                     NSch=[NSch NSchOriginal.Data{(chunkInd)}];
%                 end
%             end
            S=double(NSch);%for MUA extraction, process data for that channel at one shot, across entire session
            %extract MUA for each channel and trial:
            channelDataMUA=[];
            %MAKE MUAe
            %Bandpassed, rectified and low-passed data
            %================================================
            Fs=sampFreq;%sampling frequency
            %BANDPASS
            Fbp=[500,9000];
            N  = 2;    % filter order
            Fn = Fs/2; % Nyquist frequency
            [B, A] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn]); % compute filter coefficients
            dum1 = filtfilt(B, A, S); % apply filter to the data
            %RECTIFY
            dum2 = abs(dum1);
            
            %LOW-PASS
            Fl=200;
            N  = 2;    % filter order
            Fn = Fs/2; % Nyquist frequency
            [B, A] = butter(N,Fl/Fn,'low'); % compute filter coefficients
            muafilt = filtfilt(B, A, dum2);
            if downSampling==0
                channelDataMUA=muafilt;
                fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'.mat']);
                if saveFullMUA==1
                    save(fileName,'channelDataMUA','trialStimConds','matMatchInd','timeStimOnsMatch','indStimOnsMatch','goodTrialsInd','goodTrialCondsMatch','performanceNEV','performanceMatch','-v7.3');
                end
            elseif downSampling==1
                %Downsample
                muafilt = downsample(muafilt,downsampleFreq); % apply filter to the data and downsample
                
                %50Hz removal
                FsD = Fs/downsampleFreq;
                Fn = FsD/2; % Downsampled Nyquist frequency
                for v = [50 100 150];
                    Fbp = [v-2,v+2];
                    [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
                    muafilt = filtfilt(Blp, Alp, muafilt);
                end
                
                %Assign to vargpout
                channelDataMUA=muafilt;
                fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
                if saveFullMUA==1
                    save(fileName,'channelDataMUA','trialStimConds','matMatchInd','timeStimOnsMatch','indStimOnsMatch','goodTrialsInd','goodTrialCondsMatch','performanceNEV','performanceMatch');
                end
            end
            toc
        end
    end
end

%extract microstim artefact for each channel and trial, average across
%trials, depending on level of current delivered and whether trial was a
%hit or miss:
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    goodChannels=allGoodChannels{instanceCount};
    for channelCount=1:length(goodChannels)
        channelInd=goodChannels(channelCount);
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
        load(fileName);
        trialData=[];
        meanChannelMUA=[];
        timeStimOnsMatch;%edit to analyse data for each condition separately
        for trialInd=1:length(timeStimOnsMatch)
            if downSampling==1
                startPoint=floor(timeStimOnsMatch(trialInd)/downsampleFreq);
                if length(channelDataMUA)>=startPoint+sampFreq/downsampleFreq*artefactDur-1
                    spontanAct(trialInd,:)=channelDataMUA(startPoint-sampFreq/downsampleFreq*(preStimDur+artefactDur):startPoint-1);%raw data in uV, read in data during stimulus presentation
                    microstimAct(trialInd,:)=channelDataMUA(startPoint-sampFreq/downsampleFreq*artefactDur:startPoint+sampFreq/downsampleFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                end
            end
        end
        meanSpontanAct(channelInd,:)=mean(spontanAct(:));%average across trials and spontaneous activity period
        peakMicrostimAct(channelInd,:)=max(microstimAct,[],2);%find peak activity level for each trial during microstimulation period
        meanMicrostimAct=mean(peakMicrostimAct(:));%find mean peak across trials
        meanChannelMUA(channelInd,:)=mean([spontanAct microstimAct],1);
        
        figInd=ceil(channelInd/36);
        figure(figInd);
        subplotInd=channelInd-((figInd-1)*36);
        subplot(6,6,subplotInd);
        plot(meanChannelMUA(channelInd,:));
        hold on
        ax=gca;
        if downSampling==0
            ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
            ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
        elseif downSampling==1
            ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
            ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
        end
        %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
        title(num2str(channelInd));
        %set axis limits
        maxResponse=max(meanChannelMUA(channelInd,:));
        minResponse=min(meanChannelMUA(channelInd,:));
        diffResponse=maxResponse-minResponse;
        %draw dotted lines indicating stimulus presentation
        if downSampling==0
            plot([sampFreq*preStimDur sampFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            plot([sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
        elseif downSampling==1
            plot([sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            plot([sampFreq/downsampleFreq*(preStimDur+stimDur) sampFreq/downsampleFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
        end
        ylim([minResponse-diffResponse/10 maxResponse+diffResponse/10]);
        xlim([0 length(meanChannelMUA(channelInd,:))]);
    end
end
%         figLetters=figure;
%         hold on
%         letterYMin=[];
%         letterYMax=[];
%         letterYMaxLoc=[];
%         for letterCond=1:10
%             meanChannelMUA(letterCond,:)=mean(trialData(find(goodTrialCondsMatch(:,1)==letterCond),:),1);
%             if sum(meanChannelMUA(letterCond,:))>0
%                 %                     subplot(5,2,letterCond)
%                 colind = hsv(10);
%                 if smoothResponse==1
%                     smoothMUA = smooth(meanChannelMUA(letterCond,:),30);
%                     plot(smoothMUA,'Color',colind(letterCond,:),'LineWidth',1);
%                 elseif smoothResponse==0
%                     plot(meanChannelMUA(letterCond,:),'Color',colind(letterCond,:),'LineWidth',1);
%                 end
%                 hold on
%                 ax=gca;
%                 if downSampling==0
%                     ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
%                     ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
%                 elseif downSampling==1
%                     ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
%                     ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
%                 end
%                 %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
%                 %                     title([num2str(channelInd),' letter ',allLetters(letterCond)]);
%                 %set axis limits
%                 if smoothResponse==1
%                     [maxResponse maxInd]=max(smoothMUA);
%                     minResponse=min(smoothMUA);
%                 elseif smoothResponse==0
%                     [maxResponse maxInd]=max(meanChannelMUA(letterCond,:));
%                     minResponse=min(meanChannelMUA(letterCond,:));
%                 end
%                 diffResponse=maxResponse-minResponse;
%                 letterYMin=[letterYMin minResponse];
%                 letterYMax=[letterYMax maxResponse];
%                 letterYMaxLoc=[letterYMaxLoc maxInd];
%             end
%         end
%         %draw dotted lines indicating stimulus presentation
%         if smoothResponse==1
%             minResponse=min(letterYMin);
%             [maxResponse maxLetter]=max(letterYMax);
%         end
%         diffResponse=maxResponse-minResponse;
%         if downSampling==0
%             plot([sampFreq*preStimDur sampFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%             plot([sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%         elseif downSampling==1
%             plot([sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%             plot([sampFreq/downsampleFreq*(preStimDur+stimDur) sampFreq/downsampleFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%         end
%         for i=1:10
%             text(letterYMaxLoc(i)+diffResponse/40,letterYMax(i)+diffResponse/40,allLetters(i),'Color',colind(i,:),'FontSize',10)
%             text(1450,maxResponse+diffResponse/10-i*diffResponse/40,allLetters(i),'Color',colind(i,:),'FontSize',8)
%         end
%         ylim([minResponse-diffResponse/10 maxResponse+diffResponse/10]);
%         xlim([0 length(meanChannelMUA(letterCond,:))]);
%         title([num2str(channelInd),' letters']);
%         axes('Position',[.7 .7 .2 .2])%left bottom width height: the left and bottom elements define the distance from the lower left corner of the container (typically a figure, uipanel, or uitab) to the lower left corner of the position boundary. The width and height elements are the position boundary dimensions.
%         box on
%         draw_rf_letters(instanceInd,channelInd,0)
%         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         pathname=fullfile('D:\data',date,[instanceName,'_','channel_',num2str(channelInd),'_visual_response_letters_smooth']);
%         print(pathname,'-dtiff');
%         % create smaller axes in top right, and plot on it
%         close(figLetters)
%     end
%     for figInd=1:4
%         figure(figInd)
%         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd),'_visual_response']);
%         print(pathname,'-dtiff');
%     end
%     close all
% end
    
% %combine RF data and visual response data across 4 of the instances:
% allChannelRFs=[];
% for instanceInd=1:8
%     loadDate='best_260617-280617';
%     fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
%     load(fileName)
%     allChannelRFs=[allChannelRFs;channelRFs];
% end
% 
% blueColorMap = [linspace(1, 0, 124) linspace(0, 1, 132)];%zeros(1, 132)
% redColorMap = [zeros(1, 132) linspace(0, 1, 124)];
% colorMap = [redColorMap; redColorMap; blueColorMap]';
% singleArray=[];
% for i=1:10
%     singleArray=[singleArray allNormChannelsResponse{i}];
% end
% figure;
% histogram(singleArray)
% meanAllResp=mean(singleArray(:));%calculate mean across all responses, channels and time points
% sdAllResp=std(singleArray(:));%calculate SD across all responses, channels and time points
% colInds=linspace(meanAllResp-2*sdAllResp,meanAllResp+2*sdAllResp,255);
% colInds(1)=-10000;%some arbitrarily low value, to capture all the low activity levels 
% tempAllNormChannelsResponse=allNormChannelsResponse;
% 
% % figure;hold on
% for letterCond=1:10
%     figure;hold on
% %     subplot(2,5,letterCond);hold on
%     colInd=allNormMeanChannelResponse1024(:,letterCond);
%     col=255-[colInd*255 colInd*5 colInd];
%     scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
%     xlim([0 200]);
%     ylim([-200 0]);
%     scatter(0,0,'r','o','filled');%fix spot
%     %draw dotted lines indicating [0,0]
%     plot([0 0],[-250 200],'k:')
%     plot([-200 300],[0 0],'k:')
%     plot([-200 300],[200 -300],'k:')
%     ellipse(50,50,0,0,[0.1 0.1 0.1]);
%     ellipse(100,100,0,0,[0.1 0.1 0.1]);
%     ellipse(150,150,0,0,[0.1 0.1 0.1]);
%     ellipse(200,200,0,0,[0.1 0.1 0.1]);
%     text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
%     text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
%     text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
%     text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
%     axis square
%     xlim([0 200]);
%     ylim([-200 0]);
%     title(['visual responses to symbol ',allLetters(letterCond)]);
%     allLetters='IUALTVSYJ?';
%     screenWidth=1024;
%     screenHeight=768;
%     sampleSize=112;%a multiple of 14, the number of divisions in the letters
%     visualWidth=sampleSize;%in pixels
%     visualHeight=visualWidth;%in pixels
%     Par.PixPerDeg=25.860053410707074;
%     
%     topLeft=1;%distance from fixation spot to top-left corner of sample, measured diagonally (eccentricity)
%     sampleX = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%location of sample stimulus, in RF quadrant 150 230%want to try 20
%     sampleY = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%[30 140]
%     destRect=[screenWidth/2+sampleX screenHeight/2+sampleY screenWidth/2+sampleX+visualWidth screenHeight/2+sampleY+visualHeight];
%     plot([0 0],[-240 60],'k:')
%     plot([-60 240],[0 0],'k:')
%     colind = hsv(10);
%     colind = colind(5,:);
%     if letterCond<10%all symbols except the square
%         targetLetter=allLetters(letterCond);
%         letterPath=['D:\data\letters\',targetLetter,'.bmp'];
%         originalOutline=imread(letterPath);
%         shape=imresize(originalOutline,[visualHeight,visualWidth]);
%         whiteMask=shape==0;
%         whiteMask=whiteMask*255;
%         shapeRGB(:,:,1)=whiteMask+shape*255*colind(1);
%         shapeRGB(:,:,2)=whiteMask+shape*255*colind(2);
%         shapeRGB(:,:,3)=whiteMask+shape*255*colind(3);
%         h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1));
%         set(h, 'AlphaData', 0.1);
%         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene letter ',allLetters(letterCond)]);
%         print(pathname,'-dtiff');
%     end
%     
%     for timePoint=1:size(normChannelsResponse{letterCond},2)
%         figure;hold on
%         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         set(gca,'Color',[0 0 0]);
%         %     subplot(2,5,letterCond);hold on
%         xlim([0 200]);
%         ylim([-200 0]);
%         scatter(0,0,'r','o','filled');%fix spot
%         text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
%         text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
%         text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
%         text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
%         axis square
%         xlim([0 200]);
%         ylim([-200 0]);
%         title(['visual responses to symbol ',allLetters(letterCond)]);
%         allLetters='IUALTVSYJ?';
%         screenWidth=1024;
%         screenHeight=768;
%         sampleSize=112;%a multiple of 14, the number of divisions in the letters
%         visualWidth=sampleSize;%in pixels
%         visualHeight=visualWidth;%in pixels
%         Par.PixPerDeg=25.860053410707074;
%         
%         topLeft=1;%distance from fixation spot to top-left corner of sample, measured diagonally (eccentricity)
%         sampleX = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%location of sample stimulus, in RF quadrant 150 230%want to try 20
%         sampleY = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%[30 140]
%         destRect=[screenWidth/2+sampleX screenHeight/2+sampleY screenWidth/2+sampleX+visualWidth screenHeight/2+sampleY+visualHeight];
%         plot([0 0],[-240 60],'k:')
%         plot([-60 240],[0 0],'k:')
%         if timePoint>=300&&timePoint<=1100
%             colind = hsv(10);
%             colind = colind(5,:);
%             colind = [0 0 0];
%             if letterCond<10%all symbols except the square
%                 targetLetter=allLetters(letterCond);
%                 letterPath=['D:\data\letters\',targetLetter,'.bmp'];
%                 originalOutline=imread(letterPath);
%                 shape=imresize(originalOutline,[visualHeight,visualWidth]);
%                 whiteMask=shape==0;
%                 whiteMask=whiteMask*255;
%                 shapeRGB(:,:,1)=255-whiteMask+shape*255*colind(1);
%                 shapeRGB(:,:,2)=255-whiteMask+shape*255*colind(2);
%                 shapeRGB(:,:,3)=255-whiteMask+shape*255*colind(3);
%                 h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1));
%             elseif letterCond==10%square full of sim phosphenes
%                 shape=zeros(visualHeight,visualWidth);
%                 whiteMask=shape==0;
%                 shapeRGB(:,:,1)=255-whiteMask+shape*255*colind(1);
%                 shapeRGB(:,:,2)=255-whiteMask+shape*255*colind(2);
%                 shapeRGB(:,:,3)=255-whiteMask+shape*255*colind(3);
%                 h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1));
%             end
%             set(h, 'AlphaData', 0.4);
%         end
%         hold on            
%         %draw dotted lines indicating [0,0]
%         plot([0 0],[-250 200],'r:')
%         plot([-200 300],[0 0],'r:')
%         plot([-200 300],[200 -300],'r:')
%         ellipse(50,50,0,0,[1 1 1]);
%         ellipse(100,100,0,0,[1 1 1]);
%         ellipse(150,150,0,0,[1 1 1]);
%         ellipse(200,200,0,0,[1 1 1]);
% %         colInd=allNormChannelsResponse{letterCond}(:,timePoint);
% %         col=[colInd*250 colInd*5 colInd];
%         %scale activity levels between -7.7 and 25.5, while keeping zero
%         %point constant:
%         findPositive=find(allNormChannelsResponse{letterCond}(:,timePoint)>=0);
%         tempAllNormChannelsResponse{letterCond}(findPositive,timePoint)=allNormChannelsResponse{letterCond}(findPositive,timePoint);%/25.5479;
%         findNegative=find(allNormChannelsResponse{letterCond}(:,timePoint)<0);
%         tempAllNormChannelsResponse{letterCond}(findNegative,timePoint)=allNormChannelsResponse{letterCond}(findNegative,timePoint);%/7.7113;
%         for tempInd=1:length(allNormChannelsResponse{letterCond}(:,timePoint))%convert activity levels into colour indices for 'colorMap' colour map
%             temp=find(colInds<=tempAllNormChannelsResponse{letterCond}(tempInd,timePoint));
%             colInd(tempInd)=temp(end);
%         end
%         scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
%         scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],colorMap(colInd));
%         axis square
%         xlim([0 200]);
%         ylim([-200 0]);
%         framesResponse(timePoint)=getframe;
%         close all
%     end
%     pathname=fullfile('D:\data',date,['1024-channel responses to letter ',allLetters(letterCond),'.mat']);
%     if letterCond==10%square full of sim phosphenes
%         pathname=fullfile('D:\data',date,['1024-channel responses to square.mat']);
%     end
%     save(pathname,'framesResponse','-v7.3')
% %     movieFig=figure;
% %     movie(movieFig,framesResponse,1,50);  
%     moviename=fullfile('D:\data',date,['1024-channel responses to letter ',allLetters(letterCond),'.avi']);
%     if letterCond==10%square full of sim phosphenes
%         moviename=fullfile('D:\data',date,'1024-channel responses to square.avi');
%     end
%     v = VideoWriter(moviename);
%     v.FrameRate=500;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
%     open(v)
%     for timePoint=1:length(framesResponse)
%         writeVideo(v,framesResponse(timePoint))
%     end
%     close(v)
% end
% pauseHere=1;
% 
% %to draw a frame from the saved data:
% date='110717_B1_B2_120717_B123';
% timePoint=390;
% allLetters='IUALTVSYJ?';
% for letterCond=9%1:10
%     if letterCond<10
%         load(['D:\data\110717_B1_B2_120717_B123\1024-channel responses to letter ',allLetters(letterCond),'.mat'])
%     else
%         load('D:\data\110717_B1_B2_120717_B123\1024-channel responses to square.mat')
%     end
%     figure;
%     imshow(framesResponse(timePoint).cdata)
%     if letterCond<10
%         pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene letter ',allLetters(letterCond),'_time',num2str(timePoint)]);
%     else
%         pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene square_time',num2str(timePoint)]);
%     end
%     print(pathname,'-dtiff');
% end
% 
% %all symbols in one figure:
% figure;
% date='110717_B1_B2_120717_B123';
% timePoint=390;
% allLetters='IUALTVSYJ?';
% for letterCond=1:10
%     if letterCond<10
%         load(['D:\data\110717_B1_B2_120717_B123\1024-channel responses to letter ',allLetters(letterCond),'.mat'])
%     else
%         load('D:\data\110717_B1_B2_120717_B123\1024-channel responses to square.mat')
%     end
%     subplot(2,5,letterCond);
%     imshow(framesResponse(timePoint).cdata)
% end
% pathname=fullfile('D:\data',date,['1024-channel visual responses to simulated phosphene letters_time',num2str(timePoint)]);
% print(pathname,'-dtiff');