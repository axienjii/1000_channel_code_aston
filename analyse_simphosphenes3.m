function analyse_simphosphenes3(date,allInstanceInd,allGoodChannels,processRaw,drawImages)
%3/7/17
%Written by Xing. Extracts and analyses MUA data from raw .NS6 file, during presentation
%of simulated phosphene letters. Extracts MUA for each channel, clips it
%for each trial, and subsequently saves this trial-wise data in a .mat file
%(as opposed to analyse_simphosphenes, which saves the MUA data across the entire session).
%Uses previous (simphosphenes5.m) code where instead of sending stimbit at
%sample onset, stimbit was sent at target onset.

%Matches data between .nev and .mat files, identifies indices of trials to
%be included in analyses. From .mat file: variable performanceMatch
%provide list of trial responses (correct or incorrect) & goodTrialCondsMatch 
%lists stimulus conditions (letter, combination of luminance conditions
%across phosphenes, and whether the trial was a 'consecutively repeated' or
%a 'solitary' trial).

%Note that dasbit was supposed to send a trial ID, consisting of a sequence of 8 digits (0, 4 and 6) in a random order.
%In practice, 1 to 2 of the 8 digits are missing, likely due to insufficient time delays between sending of the bits.
%Hence, the digits that were received need to be matched against the trial IDs that are encoded in the .mat file.
%The trial is identifiable if the digits that are present in the .nev file are also present in the .mat file, and in the
%correct order. This is implemented in the part of the code that flanks this line:
%match=find(trialStimConds(nevSeqInd,rowInd)==convertedGoodTrialIDs(matchInd:8,goodTrialIDscounter));

% date='050717_B2';
% date='110717_B2';
% date='060717_B1';
matFile=['D:\data\',date,'\',date,'_data\simphosphenes6_',date,'.mat'];
load(matFile);
if ~isequal(date,'110717_B1_B2')&&~isequal(date,'120717_B1')&&~isequal(date,'110717_B1_B2_120717_B123')
    [dummy goodTrials]=find(performance~=0);
    goodTrialConds=allTrialCond(goodTrials,:);
    goodTrialIDs=TRLMAT(goodTrials,:);
end
if isequal(date,'120717_B1')
    goodTrialConds=[];
    load('D:\data\120717_B1\120717_B1_data\simphosphenes6_120717_B1.mat')
    [dummy goodTrials1]=find(performance~=0);
    goodTrialConds=allTrialCond(goodTrials1,:);
    TRLMATcombine=TRLMAT;
    performanceCombine=performance;
    load('D:\data\120717_B1\120717_B1_data\simphosphenes6_120717_B2.mat')
    [dummy goodTrials2]=find(performance~=0);
    TRLMATcombine=[TRLMATcombine;TRLMAT];
    goodTrialConds=[goodTrialConds;allTrialCond(goodTrials2,:)];
    performanceCombine=[performanceCombine performance];
    load('D:\data\120717_B1\120717_B1_data\simphosphenes6_120717_B3.mat')
    [dummy goodTrials3]=find(performance~=0);
    goodTrialConds=[goodTrialConds;allTrialCond(goodTrials3,:)];
    TRLMATcombine=[TRLMATcombine;TRLMAT];
    performanceCombine=[performanceCombine performance];
    goodTrialIDs=TRLMATcombine([goodTrials1 goodTrials2 goodTrials3],:);
    goodTrials=[goodTrials1 goodTrials2 goodTrials3];
    performance=performanceCombine;
    save('D:\data\120717_B1\120717_B1_data\simphosphenes6_120717_B123.mat','goodTrialConds','goodTrialIDs','performance')
end
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

% processRaw=0;
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
        oldIndStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^codeStimOn);%starts at 2^0, till 2^7
        oldTimeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(oldIndStimOns);%time stamps corresponding to stimulus onset
        correctTrialCodes=[codeStimOn codeTargOn 4 corrBit];%identify trials where fixation was maintained throughout
        incorrectTrialCodes=[codeStimOn codeTargOn 4 ErrorBit];%identify trials where fixation was maintained throughout
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
                    trialStimConds=[trialStimConds NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i)+4:oldIndStimOns(i)+11)];%read out stimulus condition
                    if trialCodes(i,4)==2^corrBit
                        performanceNEV=[performanceNEV 1];
                    elseif trialCodes(i,4)==2^ErrorBit
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
        goodTrialCondsMatch=goodTrialConds(matMatchInd,:);%update list of stimulus conditions based on matched trials between .mat and .nev files
        performanceInd=goodTrials(matMatchInd);
        performanceMatch=performance(performanceInd); 
        numCorrTrials=length(find(performanceMatch==1));
        numIncorrTrials=length(find(performanceMatch==-1));
%         if length(performanceNEV)>matMatchInd(end)
%         performanceNEVMatch=performanceNEV(performanceInd); 
%         end
        for letterInd=1:10%10 letters 
            for lumInd=1:40%40 luminance combinations
                a=find(goodTrialCondsMatch(:,1)==letterInd);
                b=find(goodTrialCondsMatch(:,2)==lumInd);
                trialIndConds{letterInd,lumInd}=intersect(a,b);%identify trials where stimulus was a particular letter and luminance combination
                trialTypeConds{letterInd,lumInd}=goodTrialCondsMatch(intersect(a,b),3);%notes down whether trial was supposed to be 'consecutively presented' or 'solitary'
                if letterInd<=8%familiar letters
                    trialPerf{letterInd,lumInd}=performanceNEV(intersect(a,b));%notes down whether monkey's response was correct or incorrect
                elseif letterInd>=9%unfamiliar letters, J & P, were always rewarded
                    trialPerf{letterInd,lumInd}=ones(length(performanceNEV(intersect(a,b))),1);%notes down whether monkey's response was correct or incorrect
                end
            end
        end
        %if his response was correct, always include the trial. if response
        %was wrong, check whether the trial was one of a pair. if it was
        %one of a pair, keep it. otherwise, use it for analyses of
        %incorrect trials.
        
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
            tic
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
%             trialData=[];
%             for trialInd=1:length(timeStimOnsMatch)
%                 if downSampling==0
%                     startPoint=timeStimOnsMatch(trialInd);
%                     if length(channelDataMUA)>=startPoint+sampFreq*postStimDur-1
%                         trialData(trialInd,:)=channelDataMUA(startPoint-sampFreq*preStimDur-sampFreq*stimDur:startPoint+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
%                     end
%                 elseif downSampling==1
%                     startPoint=floor(timeStimOnsMatch(trialInd)/downsampleFreq);
%                     if length(channelDataMUA)>=startPoint+sampFreq/downsampleFreq*postStimDur-1
%                         trialData(trialInd,:)=channelDataMUA(startPoint-sampFreq/downsampleFreq*preStimDur-sampFreq/downsampleFreq*stimDur:startPoint+sampFreq/downsampleFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
%                     end
%                 end
% %             end
%             fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_trialData.mat']);
%             save(fileName,'channelDataMUA','trialStimConds','matMatchInd','timeStimOnsMatch','indStimOnsMatch','goodTrialsInd','goodTrialCondsMatch','trialData','performanceNEV','performanceMatch');

        end
    end
end
% drawImages=1;
if drawImages==1
    for instanceCount=1:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
%         switch(instanceInd)
%             case(4)
%                 goodChannels=89:128;
%             otherwise
%                 goodChannels=1:128;
%         end
        goodChannels=allGoodChannels{instanceCount};
        for channelCount=1:length(goodChannels)
            channelInd=goodChannels(channelCount);
            fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
            load(fileName);
            goodTrialCondsMatch=goodTrialConds(matMatchInd,:);%update list of stimulus conditions based on matched trials between .mat and .nev files
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
            meanChannelMUA(channelInd,:)=mean(trialData,1);
            
            figInd=ceil(channelInd/36);
            figure(figInd);
            subplotInd=channelInd-((figInd-1)*36);
            subplot(6,6,subplotInd);
            plot(meanChannelMUA(channelInd,:))
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
            
            figLetters=figure;
            hold on
            letterYMin=[];
            letterYMax=[];
            letterYMaxLoc=[];
            for letterCond=1:10
                meanChannelMUA(letterCond,:)=mean(trialData(find(goodTrialCondsMatch(:,1)==letterCond),:),1);
                if sum(meanChannelMUA(letterCond,:))>0
                    %                     subplot(5,2,letterCond)
                    colind = hsv(10);
                    if smoothResponse==1
                        smoothMUA = smooth(meanChannelMUA(letterCond,:),30);
                        plot(smoothMUA,'Color',colind(letterCond,:),'LineWidth',1);
                    elseif smoothResponse==0
                        plot(meanChannelMUA(letterCond,:),'Color',colind(letterCond,:),'LineWidth',1);
                    end
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
                    %                     title([num2str(channelInd),' letter ',allLetters(letterCond)]);
                    %set axis limits
                    if smoothResponse==1
                        [maxResponse maxInd]=max(smoothMUA);
                        minResponse=min(smoothMUA);
                    elseif smoothResponse==0
                        [maxResponse maxInd]=max(meanChannelMUA(letterCond,:));
                        minResponse=min(meanChannelMUA(letterCond,:));
                    end
                    diffResponse=maxResponse-minResponse;
                    letterYMin=[letterYMin minResponse];
                    letterYMax=[letterYMax maxResponse];
                    letterYMaxLoc=[letterYMaxLoc maxInd];
                end
            end
            %draw dotted lines indicating stimulus presentation
            if smoothResponse==1
                minResponse=min(letterYMin);
                [maxResponse maxLetter]=max(letterYMax);
            end
            diffResponse=maxResponse-minResponse;
            if downSampling==0
                plot([sampFreq*preStimDur sampFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
                plot([sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            elseif downSampling==1
                plot([sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
                plot([sampFreq/downsampleFreq*(preStimDur+stimDur) sampFreq/downsampleFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            end
            allLetters='IUALTVSYJ?';
            for i=1:10
                if i==10
                    plot(letterYMaxLoc(i)+diffResponse/40,letterYMax(i)+diffResponse/40,'square','Color',colind(i,:),'MarkerSize',10)
                    plot(1485,maxResponse+diffResponse/10-i*diffResponse/40,'square','Color',colind(i,:),'MarkerSize',8)
                else
                    text(letterYMaxLoc(i)+diffResponse/40,letterYMax(i)+diffResponse/40,allLetters(i),'Color',colind(i,:),'FontSize',10)
                    text(1480,maxResponse+diffResponse/10-i*diffResponse/40,allLetters(i),'Color',colind(i,:),'FontSize',8)
                end
            end
            ylim([minResponse-diffResponse/10 maxResponse+diffResponse/10]);
            xlim([0 length(meanChannelMUA(letterCond,:))]);
            title([num2str(channelInd),' letters']);
            axes('Position',[.75 .75 .15 .15])%left bottom width height: the left and bottom elements define the distance from the lower left corner of the container (typically a figure, uipanel, or uitab) to the lower left corner of the position boundary. The width and height elements are the position boundary dimensions.
            box on
            draw_rf_letters(instanceInd,channelInd,0)
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile('D:\data',date,[instanceName,'_','channel_',num2str(channelInd),'_visual_response_letters_smooth']);
            print(pathname,'-dtiff');
            % create smaller axes in top right, and plot on it
            close(figLetters)
        end
        for figInd=1:4
            figure(figInd)
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd),'_visual_response']);
            print(pathname,'-dtiff');
        end
        close all
    end
end
pause=1;