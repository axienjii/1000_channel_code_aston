function analyse_microstim_saccade7(date,allInstanceInd)
%09/7/17
%Written by Xing, modified from analyse_microstim_saccade6. Reads in RF
%coordinate data from .mat files, instead of hard-coding in code. 
%Extracts and analyses MUA data from raw .NS6 file, during presentation
%of simulated and real phosphenes. Modified from analyse_microstim_saccade4
%Used to analyse data from 8/8/17.
%In this paradigm, catch dot presented after 1000 ms if no saccade made to
%microstim target. Exclude trials where saccade made to catch dot, from
%calculation of centroid.
%Also plots saccade end points for trials where simulated phosphene was
%visually presented.

%Matches data between .nev and .mat files, identifies indices of trials to
%be included in analyses. 

%Note that dasbit was supposed to send a trial ID, consisting of a sequence of 8 digits (0, 4 and 6) in a random order.
%In practice, 1 to 2 of the 8 digits are missing, likely due to insufficient time delays between sending of the bits.
%Hence, the digits that were received need to be matched against the trial IDs that are encoded in the .mat file.
%The trial is identifiable if the digits that are present in the .nev file are also present in the .mat file, and in the
%correct order. This is implemented in the part of the code that flanks this line:
%match=find(trialStimConds(nevSeqInd,rowInd)==convertedGoodTrialIDs(matchInd:8,goodTrialIDscounter));

switch date
    case '080817_B1'
        electrodeConds=1;
    case '080817_B2'
        electrodeConds=2;
    case '080817_B3'
        electrodeConds=3;
    case '080817_B4'
        electrodeConds=4:8;
    case '080817_B5'
        electrodeConds=8:9;
    case '080817_B6'
        electrodeConds=10;
    case '090817_B1'
        electrodeConds=2;
    case '090817_B2'
        electrodeConds=7;
    case '090817_B3'
        electrodeConds=1:4;%microstim accidentally delivered to array 10, instead of 12
    case '090817_B4'
        electrodeConds=1:13;
    case '090817_B5'
        electrodeConds=1;
    case '090817_B6'
        electrodeConds=5;
end
matFile=['D:\data\',date,'\',date,'_data\microstim_saccade_',date,'.mat'];
load(matFile);
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

processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
        codeTargOn=2;%In runstim code, TargB (target bit) is 2.
        corrBit=7;
        ErrorBit=0;
        %dasbit sends a change in the bit (either high or low) on one of the 8 ports
        indCorrBit=find(NEV.Data.SerialDigitalIO.UnparsedData==2^corrBit);
        checkTargOns=NEV.Data.SerialDigitalIO.UnparsedData(indCorrBit-2);%these occur two places before sending of the correct bit, and should have the value of 4
        if ~isempty(find(checkTargOns~=4))
            excludeInd=find(checkTargOns~=4);
            indCorrBit(excludeInd)=[];%remove falsely identified 'trials'
            checkTargOns=NEV.Data.SerialDigitalIO.UnparsedData(indCorrBit-2);
            if ~isempty(find(checkTargOns~=4))
                checkEncodes=1
            end
        end
        oldIndStimOns=indCorrBit-2;
        oldTimeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(oldIndStimOns);%time stamps corresponding to stimulus onset
        oldRewOns=NEV.Data.SerialDigitalIO.TimeStamp(indCorrBit);%time stamps corresponding to reward delivery
        correctTrialCodes=[codeTargOn 4 corrBit];%identify trials where fixation was maintained throughout
        incorrectTrialCodes=[codeTargOn 4 ErrorBit];%identify trials where fixation was maintained throughout
        indStimOns=[];
        timeStimOns=[];
        trialStimConds=[];
        performanceNEV=[];
        rewardOns=[];
        for i=1:length(oldIndStimOns)
            if oldIndStimOns(i)+10<length(NEV.Data.SerialDigitalIO.UnparsedData)
                trialCodes(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i):oldIndStimOns(i)+10);
                if sum(trialCodes(i,1:length(correctTrialCodes))==2.^correctTrialCodes)==length(correctTrialCodes)||sum(trialCodes(i,1:length(correctTrialCodes))==2.^incorrectTrialCodes)==length(incorrectTrialCodes)
                    indStimOns=[indStimOns oldIndStimOns(i)];
                    timeStimOns=[timeStimOns oldTimeStimOns(i)];
                    rewardOns=[rewardOns oldRewOns(i)];
                    trialStimConds=[trialStimConds NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i)+4:oldIndStimOns(i)+11)];%read out stimulus condition
                    if trialCodes(i,3)==2^corrBit
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
        rewOnsMatch=[];
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
                rewOnsMatch=[rewOnsMatch rewardOns(rowInd)];
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
                        rewOnsMatch=[rewOnsMatch rewardOns(rowInd)];
                        IDs(:,rowInd)=convertedGoodTrialIDs(1:6,goodTrialIDscounter);%store the X- and Y- positions for that stimulus presentation
                        matchFlag=1;
                        matMatchInd=[matMatchInd goodTrialIDscounter];
                    else
                        goodTrialIDscounter=goodTrialIDscounter+1;
                    end
                end
            end
        end
        figure;hold on
        trialIndConds={};
%         goodTrialCondsMatch=goodTrialConds(matMatchInd,:);%update list of stimulus conditions based on matched trials between .mat and .nev files
        performanceInd=goodTrials(matMatchInd);
        performanceMatch=performance(performanceInd); 
        numCorrTrials=length(find(performanceMatch==1));
        numIncorrTrials=length(find(performanceMatch==-1));
        saccadeDur=double((rewOnsMatch-timeStimOnsMatch))./30000;%calculate the time between target onset and reward delivery
        saccadeWindow=ceil(10*max(saccadeDur))/10;%find the timing of the saccade on the trial with the latest saccade
        saccadeEndX=allHitX(matMatchInd);%x-coordinate of saccade endpoint
        saccadeEndY=allHitY(matMatchInd);%y-coordinate of saccade endpoint
        if iscell(allElectrodeNum)
            electrodeID=cell2mat(allElectrodeNum(matMatchInd));%electrode through which microstimulation was delivered
        else
            electrodeID=allElectrodeNum(matMatchInd);%electrode through which microstimulation was delivered
        end
        if iscell(allArrayNum)
            arrayID=cell2mat(allArrayNum(matMatchInd));%array containing electrode through which microstimulation was delivered
        else
            arrayID=allArrayNum(matMatchInd);%array containing electrode through which microstimulation was delivered
        end
        electrodeNums=unique(electrodeID(~isnan(electrodeID)));
        arrayNums=unique(arrayID(~isnan(arrayID)));
        
        if onlyGoodSaccadeTrials==1
            goodSaccadeInd=find(saccadeDur<allowedSacTime);
            electrodeID=electrodeID(goodSaccadeInd);
            arrayID=arrayID(goodSaccadeInd);
            saccadeEndX=saccadeEndX(goodSaccadeInd);
            saccadeEndY=saccadeEndY(goodSaccadeInd);
            timeStimOnsMatch=timeStimOnsMatch(goodSaccadeInd);
        end
        
        %identify trials where microstimulation was delivered on a
        %particular electrode:
        for arrayInd=1:length(arrayNums)
            for electrodeInd=1:length(electrodeNums)
                a=find(arrayID==arrayNums(arrayInd));%identify particular combination of array and electrode number
                b=find(electrodeID==electrodeNums(electrodeInd));
                trialIndConds{arrayInd,electrodeInd}=intersect(a,b);%identify trials where stimulus was a particular electrode and array combination
                arrayCondsLUT(arrayInd,electrodeInd)=arrayNums(arrayInd);
                electrodeCondsLUT(arrayInd,electrodeInd)=electrodeNums(electrodeInd);
                if strcmp(date,'090817_B3')%microstimulation accidentally delivered to array 10, instead of 12
                    arrayCondsLUT(arrayInd,electrodeInd)=10;
                    load(['D:\data\',date,'\',date,'_data\impedance_array10.mat']);
                    electrodeCondsLUT(arrayInd,electrodeInd)=array10(electrodeInd,8);%for this recording session, electrodes used were ind 1 to 4 from array10 matrix
                end
                %                 trialPerf{arrayInd,electrodeInd}=performanceNEV(intersect(a,b));%notes down whether monkey's response was correct or incorrect
            end
        end
        colInd=hsv(length(trialIndConds(:)));
        for uniqueElectrode=1:length(trialIndConds(:))
            scatter(saccadeEndY(trialIndConds{uniqueElectrode}),saccadeEndX(trialIndConds{uniqueElectrode}),[],colInd(uniqueElectrode,:));
        end
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
        axis square
        xlim([0 200]);
        ylim([-200 0]);
        title('saccade endpoints'); 
        
        RTs=allHitRT(goodTrials);%reaction time from target onset
        if onlyGoodSaccadeTrials==1
            RTs=RTs(goodSaccadeInd);
        end
        figure
        plot(sort(RTs))
        
        %visual trials (block type 1):
        blockTypeGoodTrials=allBlockType(matMatchInd);
        visualTrialsGood=find(blockTypeGoodTrials==1);%index of good trials with visually presented simulated phosphene
        goodSampleX=allSampleX(matMatchInd);
        goodSampleY=allSampleY(matMatchInd);
        visualSampleX=goodSampleX(visualTrialsGood);
        visualSampleY=goodSampleY(visualTrialsGood);
% 
        %read in eye data:        
        eyeChannels=[129 130];
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        fixTimes=allFixT(matMatchInd)/1000;%durations of fixation period before target onset  
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6']; 
        eyeDataMat=['D:\data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
        if exist(eyeDataMat,'file')
            load(eyeDataMat,'NSch');
        else
            for channelInd=1:length(eyeChannels)
                readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
                NSchOriginal=openNSx(instanceNS6FileName,'read',readChannel);
                NSch{channelInd}=NSchOriginal.Data;
            end
            save(eyeDataMat,'NSch');
        end
        
        %visually presented simulated phosphene trials:
        flankingSamples=(30000/50)/2;%50-ms period before reward delivery
        visColInd=hsv(length(visualTrialsGood));
        trialDataXY={};
        for channelInd=1:length(eyeChannels)
            trialData=[];
            for trialInd=1:length(visualTrialsGood)
                startPoint=timeStimOnsMatch(visualTrialsGood(trialInd))-sampFreq*preStimDur+1;%align trials relative to target onset, examine 300 ms prior (min duration of fixation period prior to target onset)
                if size(NSch{channelInd},2)>=startPoint+sampFreq*(preStimDur+saccadeWindow)-1%from start of fixation through the variable fixation period (ranging from 300 to 800 ms), plus 250 ms after target onset.
                    trialDataVis(trialInd,:)=double(NSch{channelInd}([startPoint:startPoint+sampFreq*(preStimDur+saccadeWindow)+flankingSamples-1]));%from 300 ms prior to target onset, to 250 ms after target onset
                end
            end
            trialDataXYVis{channelInd}=trialDataVis;
        end
        eyepx=-sampFreq*minFixDur:sampFreq*saccadeWindow-1;
        eyepx=eyepx/sampFreq;
        [EYExsVis,EYEysVis] = eyeanalysis_baseline_correct(trialDataXYVis{1},trialDataXYVis{2},eyepx,sampFreq,1:size(trialDataXYVis{1},1));
        
        figure
        for trialInd=1:length(visualTrialsGood)
            time=visualTrialsGood(trialInd);
            tempInd=find(eyepx<saccadeDur(time));
            if EYEysVis(trialInd,tempInd(end))>-500%exclude trials where saccade made to catch dot
                subplot(2,1,1)
                plot(EYExsVis(trialInd,tempInd));
                hold on
                subplot(2,1,2)
                plot(EYEysVis(trialInd,tempInd));
                hold on
            end
        end
        subplot(2,1,1)
        title(['X eye position up till reward delivery. N trials = ',num2str(length(trialIndConds{uniqueElectrode}))])
        yLim=get(gca,'YLim');
        plot([sampFreq*preStimDur sampFreq*preStimDur],[yLim(1) yLim(2)],'k:');
        ax=gca;
        ax.XTick=[0 sampFreq*preStimDur];
        ax.XTickLabel={num2str(-preStimDur*1000),'0'};
        subplot(2,1,2)
        yLim=get(gca,'YLim');
        plot([sampFreq*preStimDur sampFreq*preStimDur],[yLim(1) yLim(2)],'k:');
        ax=gca;
        title(['Y eye position up till reward delivery. N trials = ',num2str(length(trialIndConds{uniqueElectrode}))])
        ax.XTick=[0 sampFreq*preStimDur];
        ax.XTickLabel={num2str(-preStimDur*1000),'0'};
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        if alignTargOn==0
            pathname=fullfile('D:\data',date,[instanceName,'_eye_traces']);
        elseif alignTargOn==1
            pathname=fullfile('D:\data',date,[instanceName,'_eye_traces_align_to_target_on']);
        end
        print(pathname,'-dtiff');
        eyert=find(eyepx>0);
        [degpervoltx,saccRTx] = eyeanalysis_calibration(EYExsVis,EYEysVis,eyepx,eyert,sampFreq,RFx/Par.PixPerDeg);
        if degpervoltx<0
            degpervoltx=-degpervoltx;
        end
        degpervoltx=0.0027;
        figure
        hold on
        for trialInd=1:length(visualTrialsGood)
            time=visualTrialsGood(trialInd);
            tempInd=find(eyepx<saccadeDur(time));%find(eyepx<saccRTx(trialInd)+0.05);
            posIndXVis(trialInd)=mean(EYExsVis(trialInd,tempInd(end)-flankingSamples:tempInd(end)+flankingSamples))*degpervoltx;%position during saccade
            posIndYVis(trialInd)=mean(EYEysVis(trialInd,tempInd(end)-flankingSamples:tempInd(end)+flankingSamples))*degpervoltx;
            if posIndYVis(trialInd)>=0%exclude trials where saccades made to catch dot
                scatter(-posIndXVis(trialInd),-posIndYVis(trialInd),[],visColInd(trialInd,:));
                scatter(visualSampleX(trialInd)/Par.PixPerDeg,-visualSampleY(trialInd)/Par.PixPerDeg,[],visColInd(trialInd,:),'s');
                line([-posIndXVis(trialInd) visualSampleX(trialInd)/Par.PixPerDeg],[-posIndYVis(trialInd) -visualSampleY(trialInd)/Par.PixPerDeg],'Color',visColInd(trialInd,:))
                distanceTargetSaccade(trialInd)=sqrt((visualSampleX(trialInd)/Par.PixPerDeg+posIndXVis(trialInd))^2+(-posIndYVis(trialInd)+visualSampleY(trialInd)/Par.PixPerDeg)^2);%distance between target location and saccade end location, in dva
            end
        end
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250/Par.PixPerDeg 200/Par.PixPerDeg],'k:');
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[0 0],'k:');
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[200/Par.PixPerDeg -300/Par.PixPerDeg],'k:');
        ellipse(50/Par.PixPerDeg,50/Par.PixPerDeg,0,0,[0.1 0.1 0.1]);
        ellipse(100/Par.PixPerDeg,100/Par.PixPerDeg,0,0,[0.1 0.1 0.1]);
        ellipse(150/Par.PixPerDeg,150/Par.PixPerDeg,0,0,[0.1 0.1 0.1]);
        ellipse(200/Par.PixPerDeg,200/Par.PixPerDeg,0,0,[0.1 0.1 0.1]);
        text(sqrt(1000/Par.PixPerDeg),-sqrt(1000/Par.PixPerDeg),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(4000/Par.PixPerDeg),-sqrt(4000/Par.PixPerDeg),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(10000/Par.PixPerDeg),-sqrt(10000/Par.PixPerDeg),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(18000/Par.PixPerDeg),-sqrt(18000/Par.PixPerDeg),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
        axis square
        xlim([0 200/Par.PixPerDeg]);
        ylim([-200/Par.PixPerDeg 0]);
        title('visual stimulus saccade endpoints'); 
        pathname=fullfile('D:\data',date,[instanceName,'_dva_visual_target_saccade_end']);
        print(pathname,'-dtiff');
        
        figure;
        histogram(distanceTargetSaccade(find(distanceTargetSaccade~=0)),10)
        pathname=fullfile('D:\data',date,[instanceName,'_dva_distance_histogram_visual_target_saccade_end']);
        print(pathname,'-dtiff');
        
        %microstim:
        figInd1=figure;hold on
        figInd2=figure;hold on
        for uniqueElectrode=1:length(trialIndConds(:))
            array=arrayCondsLUT(uniqueElectrode);
            electrode=electrodeCondsLUT(uniqueElectrode);  
            load(['D:\data\',date,'\',date,'_data\array',num2str(array),'.mat']);
            eval(['arrayRFs=array',num2str(array),';']);              
            electrodeRFind=find(arrayRFs(:,8)==electrode);
            RFx=arrayRFs(electrodeRFind,1);
            RFy=arrayRFs(electrodeRFind,2);
            trialDataXY={};
            for channelInd=1:length(eyeChannels)
                trialData=[];
                for trialInd=1:length(trialIndConds{uniqueElectrode})
                    time=trialIndConds{uniqueElectrode}(trialInd);
                    if alignTargOn==0
                        startPoint=timeStimOnsMatch(time)-sampFreq*fixTimes(time)+1;%start fixating
                        if size(NSch{channelInd},2)>=startPoint+sampFreq*(fixTimes(time)+saccadeWindow)-1%from start of fixation through the variable fixation period (ranging from 300 to 800 ms), plus 250 ms after target onset.
                            trialData(trialInd,:)=NSch{channelInd}([startPoint:startPoint+sampFreq*minFixDur-1 startPoint+sampFreq*fixTimes(time):startPoint+sampFreq*fixTimes(time)+sampFreq*saccadeWindow-1]);%splice two periods together: first 300 ms after onset of fixation, and 250 ms following target onset
                            %trialData{channelInd}(trialInd,:)=NSch{channelInd}(startPoint:startPoint+sampFreq*(fixTimes(trialInd)+saccadeWindow)-1);%raw data in uV, read in data during fixation
                        end
                    elseif alignTargOn==1
                        startPoint=timeStimOnsMatch(time)-sampFreq*preStimDur+1;%align trials relative to target onset, examine 300 ms prior (min duration of fixation period prior to target onset)
                        if size(NSch{channelInd},2)>=startPoint+sampFreq*(preStimDur+saccadeWindow)-1%from start of fixation through the variable fixation period (ranging from 300 to 800 ms), plus 250 ms after target onset.
                            trialData(trialInd,:)=NSch{channelInd}([startPoint:startPoint+sampFreq*(preStimDur+saccadeWindow)-1]);%from 300 ms prior to target onset, to 250 ms after target onset
                            %trialData{channelInd}(trialInd,:)=NSch{channelInd}(startPoint:startPoint+sampFreq*(fixTimes(trialInd)+saccadeWindow)-1);%raw data in uV, read in data during fixation
                        end
                    end
                end
                trialDataXY{channelInd}=trialData;
            end
            eyepx=-sampFreq*minFixDur:sampFreq*saccadeWindow-1;
            eyepx=eyepx/sampFreq;
            [EYExs,EYEys] = eyeanalysis_baseline_correct(trialDataXY{1},trialDataXY{2},eyepx,sampFreq,1:size(trialDataXY{1},1));
            
            figure
            for trialInd=1:length(trialIndConds{uniqueElectrode})
                time=trialIndConds{uniqueElectrode}(trialInd);
                tempInd=find(eyepx<saccadeDur(time));
                if EYEys(trialInd,tempInd(end))>-500%exclude trials where saccade made to catch dot                    
                    subplot(2,1,1)
                    plot(EYExs(trialInd,tempInd));
                    hold on
                    subplot(2,1,2)
                    plot(EYEys(trialInd,tempInd));
                    hold on
                end
            end
            subplot(2,1,1)
            title(['X eye position up till reward delivery. N trials = ',num2str(length(trialIndConds{uniqueElectrode}))])
            yLim=get(gca,'YLim');
            plot([sampFreq*preStimDur sampFreq*preStimDur],[yLim(1) yLim(2)],'k:');
            ax=gca;
            ax.XTick=[0 sampFreq*preStimDur];
            ax.XTickLabel={num2str(-preStimDur*1000),'0'};
            subplot(2,1,2)
            yLim=get(gca,'YLim');
            plot([sampFreq*preStimDur sampFreq*preStimDur],[yLim(1) yLim(2)],'k:');
            ax=gca;
            title(['Y eye position up till reward delivery. N trials = ',num2str(length(trialIndConds{uniqueElectrode}))])
            ax.XTick=[0 sampFreq*preStimDur];
            ax.XTickLabel={num2str(-preStimDur*1000),'0'};
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            if alignTargOn==0
                pathname=fullfile('D:\data',date,[instanceName,'_electrode',num2str(electrode),'_eye_traces']);
            elseif alignTargOn==1
                pathname=fullfile('D:\data',date,[instanceName,'_electrode',num2str(electrode),'_eye_traces_align_to_target_on']);
            end
            print(pathname,'-dtiff');
            eyert=find(eyepx>0);
            [degpervoltx,saccRTx] = eyeanalysis_calibration(EYExs,EYEys,eyepx,eyert,sampFreq,RFx/Par.PixPerDeg);
            if degpervoltx<0
                degpervoltx=-degpervoltx;
            end
            degpervoltx=0.0027;
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
            figure(figInd1)
            hold on
            for trialInd=1:length(trialIndConds{uniqueElectrode})
                time=trialIndConds{uniqueElectrode}(trialInd);
                tempInd=find(eyepx<saccadeDur(time));%find(eyepx<saccRTx(trialInd)+0.05);
                posIndX(trialInd)=mean(EYExs(trialInd,tempInd(end)-flankingSamples:tempInd(end)+flankingSamples))*degpervoltx;%position during saccade
                posIndY(trialInd)=mean(EYEys(trialInd,tempInd(end)-flankingSamples:tempInd(end)+flankingSamples))*degpervoltx;
                scatter(-posIndX(trialInd),-posIndY(trialInd),[],colInd(uniqueElectrode,:));
            end
            if mod(uniqueElectrode,2)==1
                plot(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,'x','Color',colInd(uniqueElectrode,:),'MarkerSize',14);%RF location
                text(RFx/Par.PixPerDeg-0.2,RFy/Par.PixPerDeg+0.15,num2str(electrode),'FontSize',8,'Color',colInd(uniqueElectrode,:));
            else
                plot(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,'+','Color',colInd(uniqueElectrode,:),'MarkerSize',14);%RF location
                text(RFx/Par.PixPerDeg+0.1,RFy/Par.PixPerDeg+0.15,num2str(electrode),'FontSize',8,'Color',colInd(uniqueElectrode,:));
            end
            plot(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,'o','Color',colInd(uniqueElectrode,:),'MarkerSize',14);%RF location
            %scatter(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,[],colInd(uniqueElectrode,:),'filled');%RF location

            figure%(figInd2)
            hold on
            axis square
            %remove saccades to catch dot:
            notCatchDotInd=find(posIndY>0);%catch dot located in upper hemifield at [0 100];
            posIndY=posIndY(notCatchDotInd);
            posIndX=posIndX(notCatchDotInd);
            %remove outliers (3 standard deviations from the mean):
            SDcutoff=2;
            if isequal(date,'260717_B2')&&electrode==21
                SDcutoff=1;
            end
            posIndX_noOutliers=posIndX;
            posIndY_noOutliers=posIndY;
            eccentricity=sqrt(posIndX.^2+posIndY.^2);
            meanEccentricity=mean(eccentricity);
            sdEccentricity=std(eccentricity);
            a=find(eccentricity>meanEccentricity+SDcutoff*sdEccentricity);
            posIndX_noOutliers(a)=[];
            posIndY_noOutliers(a)=[];
            %plot histogram
            h(uniqueElectrode) = histogram2(-posIndX_noOutliers,-posIndY_noOutliers);
            h(uniqueElectrode).FaceColor = 'flat';
            h(uniqueElectrode).NumBins = [25 25];
            h(uniqueElectrode).DisplayStyle = 'tile';
            h(uniqueElectrode).BinWidth=[0.5 0.5];
            view(2)            
            plot(-posIndX,-posIndY,'ro');%plot original data
            %calculate centroid using data from which outliers are removed
            stats=regionprops(true(size(h(uniqueElectrode).Values)),h(uniqueElectrode).Values,'WeightedCentroid');%returns Y (counted from bottom element of h.values) in first element, and X (counted from left-most element in h.Values) in second element
            centroidX=(stats.WeightedCentroid(2)/size(h(uniqueElectrode).Values,1))*(h(uniqueElectrode).XBinEdges(end)-h(uniqueElectrode).XBinEdges(1))+h(uniqueElectrode).XBinEdges(1);%convert the location of the centroid from h.Values coordinate space into visual field coordinate space
            centroidY=(stats.WeightedCentroid(1)/size(h(uniqueElectrode).Values,2))*(h(uniqueElectrode).YBinEdges(end)-h(uniqueElectrode).YBinEdges(1))+h(uniqueElectrode).YBinEdges(1);
            plot(centroidX,centroidY,'ko','MarkerFaceColor','r','MarkerSize',8);
            text(RFx/Par.PixPerDeg+0.3,RFy/Par.PixPerDeg+0.3,num2str(electrode),'FontSize',10,'Color',[1 0 0]);
            plot(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,'ko','MarkerSize',8,'MarkerFaceColor','g');%RF location
            scatter(0,0,'r','o','filled');%fix spot
            %draw dotted lines indicating [0,0]
            plot([0 0],[-350/Par.PixPerDeg 200/Par.PixPerDeg],'k:');
            plot([-200/Par.PixPerDeg 350/Par.PixPerDeg],[0 0],'k:');
            plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[200/Par.PixPerDeg -300/Par.PixPerDeg],'k:');
            ellipse(2,2,0,0,[0.1 0.1 0.1]);
            ellipse(4,4,0,0,[0.1 0.1 0.1]);
            ellipse(6,6,0,0,[0.1 0.1 0.1]);
            ellipse(8,8,0,0,[0.1 0.1 0.1]);
            ellipse(10,10,0,0,[0.1 0.1 0.1]);
            text(sqrt(2),-sqrt(2),'2','FontSize',14,'Color',[0.3 0.3 0.3]);
            text(sqrt(8),-sqrt(8),'4','FontSize',14,'Color',[0.3 0.3 0.3]);
            text(sqrt(18),-sqrt(18),'6','FontSize',14,'Color',[0.3 0.3 0.3]);
            text(sqrt(32),-sqrt(32),'8','FontSize',14,'Color',[0.3 0.3 0.3]);
            text(sqrt(50),-sqrt(50),'10','FontSize',14,'Color',[0.3 0.3 0.3]);
            xlim([-5 12]);
            ylim([-12 5]);
            title(['RF (green), saccade endpoints (red) and their centroid (red filled), electrode ',num2str(electrode)]);
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile('D:\data',date,[instanceName,'_saccade_endpoints_centroid_RFs_electrode',num2str(electrode)]);
            print(pathname,'-dtiff'); 
            
            %plot centroids and RFs on single figure
            figure(figInd2)
            hold on
            plot(centroidX,centroidY,'ko','MarkerFaceColor',colInd(uniqueElectrode,:),'MarkerSize',10);
            plot(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,'ks','MarkerSize',14,'MarkerFaceColor',colInd(uniqueElectrode,:));%RF location
            text(RFx/Par.PixPerDeg-0.01,RFy/Par.PixPerDeg,num2str(electrode),'FontSize',8,'Color',[0 0 0]);
            distanceRFSaccade(uniqueElectrode)=sqrt((RFx/Par.PixPerDeg-centroidX)^2+(RFy/Par.PixPerDeg-centroidY)^2);
            text(centroidX,centroidY,num2str(distanceRFSaccade(uniqueElectrode)),'FontSize',8,'Color',[0 0 0]);
        end
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