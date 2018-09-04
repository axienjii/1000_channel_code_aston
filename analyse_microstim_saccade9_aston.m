function analyse_microstim_saccade9(date,allInstanceInd)
%09/7/17
%Written by Xing, uses serial port data to identify trial number. Analyses
%data for runstim_microstim_saccade_catch10.m, with an arbitrarily large
%target window and random selsection of electrodes which microstimulation
%was delivered (out of 201 electrodes on arrays 8 to 16).

matFile=['D:\data\',date,'\',date,'_data\microstim_saccade_',date,'.mat'];
load(matFile);
maxNumTrials=size(TRLMAT,1);
if maxNumTrials<=length(performance)
    performance=performance(1:maxNumTrials);
    allArrayNum=allArrayNum(1:maxNumTrials);
    allBlockNo=allBlockNo(1:maxNumTrials);
    allElectrodeNum=allElectrodeNum(1:maxNumTrials);
    allFixT=allFixT(1:maxNumTrials);
    allHitRT=allHitRT(1:maxNumTrials);
    allHitX=allHitX(1:maxNumTrials);
    allHitY=allHitY(1:maxNumTrials);
    allInstanceNum=allInstanceNum(1:maxNumTrials);
    allSampleX=allSampleX(1:maxNumTrials);
    allSampleY=allSampleY(1:maxNumTrials);
    allStimDur=allStimDur(1:maxNumTrials);
    allTargetArrivalTime=allTargetArrivalTime(1:maxNumTrials);
    allTargetArrivalTime=allTargetArrivalTime(1:maxNumTrials);
end
[dummy goodTrials]=find(performance~=0);
% goodTrialConds=allTrialCond(goodTrials,:);
goodTrialIDs=TRLMAT(goodTrials,:);

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

alignTargOn=1;%1: align eye movement data across trials, relative to target onset (variable from trial to trial, from 300 to 800 ms after fixation). 0: plot the first 300 ms of fixation, followed by the period from target onset to saccade response?
onlyGoodSaccadeTrials=0;%set to 1 to exclude trials where the time taken to reach the target exceeds the allowedSacTime.
allowedSacTime=250/1000;

stimDurms=500;%in ms- min 0, max 500
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);        
        
        %read in eye data:
        eyeChannels=[1 2];
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6']; 
        eyeDataMat=['D:\data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
        if exist(eyeDataMat,'file')
            load(eyeDataMat,'NSch');
        else
            for channelInd=1:length(eyeChannels)
                readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
                NSchOriginal=openNSx(instanceNS6FileName);
                NSch{channelInd}=NSchOriginal.Data(channelInd,:);
            end
            save(eyeDataMat,'NSch');
        end       
        
        %identify trials using encodes sent via serial port: 
        trialNo=1;
        breakHere=0;
        while breakHere==0
            encode=double(num2str(trialNo));%serial port encodes. e.g. 0 is encoded as 48, 1 as 49, 10 as [49 48], 12 as [49 50]
            tempInd=strfind(NEV.Data.SerialDigitalIO.UnparsedData',encode);
            if isempty(tempInd)
                breakHere=1;
            else
                timeInd(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(tempInd(1));
                encodeInd(trialNo)=tempInd(1);
                trialNo=trialNo+1;
            end
        end
                
        microstimTrialsInd=find(allCurrentLevel>0);
        correctTrialsInd=find(performance==1);
        correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
        fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset

        figInd1=figure;hold on
        figInd2=figure;hold on
        figInd3=figure;hold on
        for uniqueElectrode=1:size(goodArrays8to16,1)
            array=goodArrays8to16(uniqueElectrode,7);
            arrayColInd=find(arrays==array);
            electrode=goodArrays8to16(uniqueElectrode,8);
            RFx=goodArrays8to16(uniqueElectrode,1);
            RFy=goodArrays8to16(uniqueElectrode,2);
            
            electrodeInd=find(cell2mat(allElectrodeNum)==electrode);
            arrayInd=find(cell2mat(allArrayNum)==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
        
            trialDataXY={};
            degpervoltx=0.0027;
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
            for trialCounter=1:length(matchTrials)%for each correct microstim trial
                trialNo=matchTrials(trialCounter);%trial number, out of all trials from that session  
                %identify time of reward delivery:
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^4);
                timeTrialStartInd=temp(end);%index in NEV file that appears in trial- though not necessarily the start (I think)
                timeTrialStart=NEV.Data.SerialDigitalIO.TimeStamp(timeTrialStartInd);%timestamp in NEV file corresponding to reward delivery
                corrBit=7;
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^corrBit);
                timeRewardInd=temp(end);%index in NEV file corresponding to reward delivery
                timeReward=NEV.Data.SerialDigitalIO.TimeStamp(timeRewardInd);%timestamp in NEV file corresponding to reward delivery
                codeMicrostimOn=2;%sent at the end of microstimulation train
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:timeRewardInd)==2^codeMicrostimOn);%(two encodes before reward encode)
                timeMicrostimInd=temp(end);%index in NEV file corresponding to reward delivery
                timeMicrostim=NEV.Data.SerialDigitalIO.TimeStamp(timeMicrostimInd);%timestamp in NEV file corresponding to reward delivery
                timeMicrostimToReward=timeMicrostim:timeReward;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                trialDataX{trialCounter}=NSch{1}(timeMicrostimToReward);
                trialDataY{trialCounter}=NSch{2}(timeMicrostimToReward);
                preStimDur=0.4;
                timeSmooth=timeMicrostim-preStimDur*sampFreq:timeReward;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                trialDataXSmooth{trialCounter}=double(NSch{1}(timeSmooth));
                trialDataYSmooth{trialCounter}=double(NSch{2}(timeSmooth));
                numDataPointsAfterStim=timeReward-timeMicrostim;
                eyepx=-0.15*sampFreq:double(numDataPointsAfterStim);
                eyepx=eyepx/sampFreq;
%                 [EYExs,EYEys] = eyeanalysis_baseline_correct(double(trialDataXSmooth{trialCounter}),double(trialDataYSmooth{trialCounter}),eyepx,sampFreq,1:size(trialDataX{1},1));
%                 figure(figInd1)
%                 subplot(2,1,1)
%                 plot(trialDataX{trialCounter});hold on
%                 subplot(2,1,2)
%                 plot(trialDataY{trialCounter});hold on
                figure(figInd2)
                subplot(2,1,1)
                plot(trialDataXSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                subplot(2,1,2)
                plot(trialDataYSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                baselineX=mean(trialDataXSmooth{trialCounter}(1:5000));
                baselineY=mean(trialDataYSmooth{trialCounter}(1:5000));
                %quick-and-dirty estimate of saccade end position:
                roughPosIndX=(trialDataXSmooth{trialCounter}(10460)-baselineX)*degpervoltx*Par.PixPerDeg;%position during saccade, very rough calculation
                roughPosIndY=(trialDataYSmooth{trialCounter}(10460)-baselineY)*degpervoltx*Par.PixPerDeg;
%                 scatter(-roughPosIndX,-roughPosIndY,[],cols(arrayColInd,:),'MarkerFaceColor',cols(arrayColInd,:));
                %accurate calculation of saccade end position:
                numHistBins=50;
                posIndX=NaN;
                posIndY=NaN;
                if min(trialDataXSmooth{trialCounter})>5500&&max(trialDataYSmooth{trialCounter})<1500%exclude extreme outliers
                    try
%                         figHistogram=figure;
                        [hX binEdges]=histcounts(trialDataXSmooth{trialCounter},numHistBins);
                        [b1 b2]=calculateSaccadeEndpoint([1:length(hX)]',hX');%return the midpoints of the peaks of the bimodal distribution, relative to histogram bins
                        if floor(b1)<numHistBins&&floor(b2)<numHistBins&&floor(b1)>0&&floor(b2)>0
                            saccadeEndXB1=binEdges(floor(b1))+(b1-floor(b1))*(binEdges(2)-binEdges(1));%calculate precise midpoint of distribution of eye position values
                            saccadeEndXB2=binEdges(floor(b2))+(b2-floor(b2))*(binEdges(2)-binEdges(1));%calculate precise midpoint of distribution of eye position values
                            saccadeEndXHistBin=min([saccadeEndXB1 saccadeEndXB2]);%for X position, deflections from fixation are represented by smaller values, hence use middle point of second peak in bimodal distribution of eye positions
                            posIndX=(baselineX-saccadeEndXHistBin)*degpervoltx*Par.PixPerDeg;
                        end
                        [hY binEdges]=histcounts(trialDataYSmooth{trialCounter},numHistBins);
                        [b1 b2]=calculateSaccadeEndpoint([1:length(hY)]',hY');
                        if floor(b1)<numHistBins&&floor(b2)<numHistBins&&floor(b1)>0&&floor(b2)>0
                            saccadeEndYB1=binEdges(floor(b1))+(b1-floor(b1))*(binEdges(2)-binEdges(1));%calculate precise midpoint of distribution of eye position values
                            saccadeEndYB2=binEdges(floor(b2))+(b2-floor(b2))*(binEdges(2)-binEdges(1));%calculate precise midpoint of distribution of eye position values
                            saccadeEndYHistBin=max([saccadeEndYB1 saccadeEndYB2]);%for X position, deflections from fixation are represented by smaller values, hence use middle point of second peak in bimodal distribution of eye positions
                            posIndY=(saccadeEndYHistBin-baselineY)*degpervoltx*Par.PixPerDeg;
                        end
                    catch ME
                    end
                end
                if posIndX<5&&posIndY<5
                    manualCheck=1;
                    posIndX=NaN;
                    posIndY=NaN;
                end
                saccadeEndAllTrials(trialCounter,:)=[posIndX posIndY];
                electrodeAllTrials=electrode;
                figure(figInd3)                
                scatter(posIndX,-posIndY,[],cols(arrayColInd,:),'MarkerFaceColor',cols(arrayColInd,:));
%                 close(figHistogram);
            end
        end
        figure(figInd2)
        subplot(2,1,1)
        ylim([5000 10000])
        subplot(2,1,2)
        ylim([-1500 1000])
        figure(figInd3)
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
        xlim([-20 220]);
        ylim([-160 20]);
        title('saccade endpoints'); 
        for arrayInd=1:length(arrays)
            text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
        end
        xlabel('x-coordinates (pixels)')
        ylabel('y-coordinates (pixels)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,['saccade_endpoints_pixels_',date]);
        print(pathname,'-dtiff');   
        
        ax=gca;
        ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
        ax.XTickLabel={'0','2','4','6','8'};
        ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
        ax.YTickLabel={'-8','-6','-4','-2','0'};
        xlabel('x-coordinates (dva)')
        ylabel('y-coordinates (dva)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,['saccade_endpoints_dva_',date]);
        print(pathname,'-dtiff');   

        figure;hold on
        trialIndConds={};
        saccadeDur=double((rewOnsMatch-timeStimOnsMatch))./30000;%calculate the time between target onset and reward delivery
        saccadeWindow=ceil(10*max(saccadeDur))/10;%find the timing of the saccade on the trial with the latest saccade
        saccadeEndX=allHitX(correctMicrostimTrialsInd);%x-coordinate of saccade endpoint
        saccadeEndY=allHitY(correctMicrostimTrialsInd);%y-coordinate of saccade endpoint
        if iscell(allElectrodeNum)
            electrodeID=cell2mat(allElectrodeNum(correctMicrostimTrialsInd));%electrode through which microstimulation was delivered
        else
            electrodeID=allElectrodeNum(correctMicrostimTrialsInd);%electrode through which microstimulation was delivered
        end
        if iscell(allArrayNum)
            arrayID=cell2mat(allArrayNum(correctMicrostimTrialsInd));%array containing electrode through which microstimulation was delivered
        else
            arrayID=allArrayNum(correctMicrostimTrialsInd);%array containing electrode through which microstimulation was delivered
        end
        electrodeNums=unique(electrodeID(~isnan(electrodeID)));
        arrayNums=unique(arrayID(~isnan(arrayID)));
        
        
        %identify trials where microstimulation was delivered on a
        %particular electrode:
        colInd=hsv(length(trialIndConds(:)));
        for uniqueElectrode=1:length(trialIndConds(:))
            scatter(saccadeEndY(trialIndConds{uniqueElectrode}),saccadeEndX(trialIndConds{uniqueElectrode}),[],colInd(uniqueElectrode,:));
        end
        
        RTs=allHitRT(goodTrials);%reaction time from target onset
        if onlyGoodSaccadeTrials==1
            RTs=RTs(goodSaccadeInd);
        end
        figure
        plot(sort(RTs))
         
        
        %microstim:
        figure(figInd1)
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250/Par.PixPerDeg 200/Par.PixPerDeg],'k:');
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[0 0],'k:');
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[200/Par.PixPerDeg -300/Par.PixPerDeg],'k:');
        ellipse(2,2,0,0,[0.1 0.1 0.1]);
        ellipse(4,4,0,0,[0.1 0.1 0.1]);
        ellipse(6,6,0,0,[0.1 0.1 0.1]);
        ellipse(8,8,0,0,[0.1 0.1 0.1]);
        text(sqrt(2),-sqrt(2),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(8),-sqrt(8),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(18),-sqrt(18),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(32),-sqrt(32),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
        axis square
        xlim([-1 8]);
        ylim([-8 1]);
        title('rough saccade endpoints');
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,[instanceName,'_saccade_endpoints_RFs']);
        print(pathname,'-dtiff');   
        
        figure(figInd2)
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250/Par.PixPerDeg 200/Par.PixPerDeg],'k:');
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[0 0],'k:');
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[200/Par.PixPerDeg -300/Par.PixPerDeg],'k:');
        ellipse(2,2,0,0,[0.1 0.1 0.1]);
        ellipse(4,4,0,0,[0.1 0.1 0.1]);
        ellipse(6,6,0,0,[0.1 0.1 0.1]);
        ellipse(8,8,0,0,[0.1 0.1 0.1]);
        text(sqrt(2),-sqrt(2),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(8),-sqrt(8),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(18),-sqrt(18),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(32),-sqrt(32),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
        axis square
        xlim([-1 8]);
        ylim([-8 1]);
        title('RFs (square) and centroids of saccade endpoints (circle)');
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,[instanceName,'_centroids and RFs']);
        print(pathname,'-dtiff');
        close all
    end
end
pause=1;