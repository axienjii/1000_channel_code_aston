function analyse_microstim_saccade5(date,allInstanceInd,allGoodChannels)
%20/7/17
%Written by Xing. Extracts and analyses MUA data from raw .NS6 file, during presentation
%of simulated and real phosphenes. Modified from analyse_microstim_saccade.

%Matches data between .nev and .mat files, identifies indices of trials to
%be included in analyses. 

%Note that dasbit was supposed to send a trial ID, consisting of a sequence of 8 digits (0, 4 and 6) in a random order.
%In practice, 1 to 2 of the 8 digits are missing, likely due to insufficient time delays between sending of the bits.
%Hence, the digits that were received need to be matched against the trial IDs that are encoded in the .mat file.
%The trial is identifiable if the digits that are present in the .nev file are also present in the .mat file, and in the
%correct order. This is implemented in the part of the code that flanks this line:
%match=find(trialStimConds(nevSeqInd,rowInd)==convertedGoodTrialIDs(matchInd:8,goodTrialIDscounter));

% date='200717_B1';
saveEyeData=1;
switch date
    case '200717_B1'
        electrodeConds=1;
    case '200717_B2'
        electrodeConds=[1 2 5 6];
    case '210717_B3'
        electrodeConds=11:14;
    case '070817_B1'
        electrodeConds=5;
    case '070817_B2'
        electrodeConds=5;
    case '070817_B3'
        electrodeConds=6;
end
matFile=['D:\data\',date,'\',date,'_data\microstim_saccade_',date,'.mat'];
load(matFile);
[dummy goodTrials]=find(performance~=0);
goodTrialConds=allTrialCond(goodTrials,:);
goodTrialIDs=TRLMAT(goodTrials,:);

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

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
            checkEncodes=1
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
        goodTrialCondsMatch=goodTrialConds(matMatchInd,:);%update list of stimulus conditions based on matched trials between .mat and .nev files
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
        %identify trials where microstimulation was delivered on a
        %particular electrode:
        for arrayInd=1:length(arrayNums)
            for electrodeInd=1:length(electrodeNums)
                a=find(arrayID==arrayNums(arrayInd));%identify particular combination of array and electrode number
                b=find(electrodeID==electrodeNums(electrodeInd));
                trialIndConds{arrayInd,electrodeInd}=intersect(a,b);%identify trials where stimulus was a particular electrode and array combination
                %                 trialPerf{arrayInd,electrodeInd}=performanceNEV(intersect(a,b));%notes down whether monkey's response was correct or incorrect
            end
        end
        colInd=hsv(length(trialIndConds(:)));
        for uniqueElectrode=1:length(trialIndConds(:))
            scatter(saccadeEndY(trialIndConds{uniqueElectrode}),saccadeEndX(trialIndConds{uniqueElectrode}),[],colInd(uniqueElectrode,:));
        end
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
        title('saccade endpoints'); 
        
        RTs=allHitRT(goodTrials);%reaction time from target onset
        figure
        plot(sort(RTs))
        
        %read in eye data:        
        eyeChannels=[129 130];
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        fixTimes=allFixT(goodTrials)/1000;%durations of fixation period before target onset  
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6']; 
        if saveEyeData==1
            for channelInd=1:length(eyeChannels)
                readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
                NSchOriginal=openNSx(instanceNS6FileName,'read',readChannel);
                NSch{channelInd}=NSchOriginal.Data;
            end
            save(['D:\data\',date,'\',instanceName,'_NSch.mat'],'NSch');
        else
            load(['D:\data\',date,'\',instanceName,'_NSch.mat'],'NSch');
        end
        figInd1=figure;hold on
        figInd2=figure;
        for uniqueElectrode=1:length(trialIndConds(:))
%             figure;
            switch electrodeConds(uniqueElectrode)
                case 1
                    electrode=34;
                    RFx=101.4;
                    RFy=-87.2;
                    array=13;
                    instance=7;
                    %candidate channels for simultaneous stimulation and recording:
                    % instance 7, array 13, electrode 34: RF x, RF y, size (pix), size (dva):
                    %[101.373182692835,-87.1965720730945,30.6314285392835,1.18450541719806]
                    %SNR 20.7, impedance 13
                    %record from 25, 26, 27
                case 2
                    electrode=35;
                    RFx=101.4;
                    RFy=-86.9;
                    array=13;
                    instance=7;
                    % instance 7, array 13, electrode 35: RF x, RF y, size (pix), size (dva):
                    %[101.419820931771,-86.8574476383865,38.9826040277579,1.50744212233355]
                    %SNR 20.8, impedance 13
                    %record from 26, 27, 28
                case 3
                    electrode=38;
                    RFx=37.6;
                    RFy=-44.1;
                    array=1;
                    instance=1;
                    %SNR 6.5, impedance 38
                case 4
                    electrode=36;
                    RFx=40.5;
                    RFy=-44.7;
                    array=1;
                    instance=1;
                    %SNR 12, impedance 58
                case 5
                    electrode=37;
                    RFx=112.9;
                    RFy=-71.3;
                    array=13;
                    instance=7;
                    %SNR 23.5, impedance 33
                case 6
                    electrode=38;
                    RFx=112.9;
                    RFy=-71.3;
                    array=13;
                    instance=7;
                    %SNR 23.6, impedance 33
                case 7
                    electrode=27;
                    RFx=120.9;
                    RFy=-130.7;
                    array=9;
                    instance=5;
                    %SNR 8.3, impedance 43
                case 8
                    electrode=26;
                    RFx=119.7;
                    RFy=-114.9;
                    array=9;
                    instance=5;
                    %SNR 8.6, impedance 52
                case 9
                    electrode=37;
                    RFx=31.6;
                    RFy=-63.3;
                    array=1;
                    instance=1;
                    %SNR 6.1, impedance 40
                case 10
                    electrode=34;
                    RFx=27.5;
                    RFy=-22.4;
                    array=1;
                    instance=1;
                    %SNR 2.0, impedance 43
                case 11
                    electrode=101-64;
                    RFx=133.7;
                    RFy=-114.2;
                    array=10;
                    instance=6;
                    %SNR 20.6, impedance 43
                case 12
                    electrode=112-64;
                    RFx=150.4;
                    RFy=-103.0;
                    array=10;
                    instance=6;
                    %SNR 35.4, impedance 27
                case 13
                    electrode=120-64;
                    RFx=166.2;
                    RFy=-96.4;
                    array=10;
                    instance=6;
                    %SNR 20.2, impedance 33
                case 14
                    electrode=121-64;
                    RFx=88.4;
                    RFy=-133.5;
                    array=10;
                    instance=6;
                    %SNR 5.1, impedance 27
            end
            trialDataXY={};
            for channelInd=1:length(eyeChannels)
                trialData=[];
                for trialInd=1:length(trialIndConds{uniqueElectrode})
                    time=trialIndConds{uniqueElectrode}(trialInd);
                    startPoint=timeStimOnsMatch(time)-sampFreq*fixTimes(time)+1;
                    if size(NSch{channelInd},2)>=startPoint+sampFreq*(fixTimes(time)+saccadeWindow)-1%from start of fixation through the variable fixation period (ranging from 300 to 800 ms), plus 250 ms after target onset.
                        trialData(trialInd,:)=NSch{channelInd}([startPoint:startPoint+sampFreq*minFixDur-1 startPoint+sampFreq*fixTimes(time):startPoint+sampFreq*fixTimes(time)+sampFreq*saccadeWindow-1]);%splice two periods together: first 300 ms after onset of fixation, and 250 ms following target onset
                        %trialData{channelInd}(trialInd,:)=NSch{channelInd}(startPoint:startPoint+sampFreq*(fixTimes(trialInd)+saccadeWindow)-1);%raw data in uV, read in data during fixation
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
                subplot(2,1,1)
                plot(EYExs(trialInd,tempInd));
                hold on
                subplot(2,1,2)
                plot(EYEys(trialInd,tempInd));
                hold on
            end
            subplot(2,1,1)
            title(['X eye position up till reward delivery. N trials = ',num2str(length(trialIndConds{uniqueElectrode}))])
            yLim=get(gca,'YLim');
            plot([sampFreq*preStimDur sampFreq*preStimDur],[yLim(1) yLim(2)],'k:')
            ax=gca;
            ax.XTick=[0 sampFreq*preStimDur];
            ax.XTickLabel={num2str(-preStimDur*1000),'0'};
            subplot(2,1,2)
            yLim=get(gca,'YLim');
            plot([sampFreq*preStimDur sampFreq*preStimDur],[yLim(1) yLim(2)],'k:')
            ax=gca;
            title(['Y eye position up till reward delivery. N trials = ',num2str(length(trialIndConds{uniqueElectrode}))])
            ax.XTick=[0 sampFreq*preStimDur];
            ax.XTickLabel={num2str(-preStimDur*1000),'0'};
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile('D:\data',date,[instanceName,'_electrode',num2str(electrode),'_eye_traces']);
            print(pathname,'-dtiff');
            eyert=find(eyepx>0);
            [degpervoltx,saccRTx] = eyeanalysis_calibration(EYExs,EYEys,eyepx,eyert,sampFreq,RFx/Par.PixPerDeg);
            if degpervoltx<0
                degpervoltx=-degpervoltx;
            end
            degpervoltx=0.0027;
            figure(figInd1)
            hold on
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
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
                plot(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,'o','Color',colInd(uniqueElectrode,:),'MarkerSize',14);%RF location
                text(RFx/Par.PixPerDeg+0.1,RFy/Par.PixPerDeg+0.15,num2str(electrode),'FontSize',8,'Color',colInd(uniqueElectrode,:));
            end
            %scatter(RFx/Par.PixPerDeg,RFy/Par.PixPerDeg,[],colInd(uniqueElectrode,:),'filled');%RF location
            hold on
        end
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250/Par.PixPerDeg 200/Par.PixPerDeg],'k:')
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[0 0],'k:')
        plot([-200/Par.PixPerDeg 300/Par.PixPerDeg],[200/Par.PixPerDeg -300/Par.PixPerDeg],'k:')
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
        title('rough saccade end points');
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,[instanceName,'_saccade_endpoints_RFs']);
        print(pathname,'-dtiff');
    end
end
pause=1;