function analyse_microstim_letter_example_080219_B10_aston
%12/9/19
%Written by Xing, plots figure of performance during example letter
%task in Aston, for paper.
date='080219_B10_aston';
allInstanceInd=1;
interleaved=0;%set interleaved to 0, if trigger pulse was sent using microB. set interleaved to 1, if stimulation was sent by calling stimulator.play function
drummingOn=0;%for sessions after 9/4/18, drumming with only 2 targets was uesd 
localDisk=0;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end
matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
dataDir=[rootdir,date,'\',date,'_data'];
if ~exist('dataDir','dir')
    copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
end
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
preStimDur=300/1000;
stimDur=stimDurms/1000;%in seconds
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

analyseConds=1;
if analyseConds==1
    switch(date)
        %microstim task only:
        case '080219_B10_aston';
            setElectrodes=[{[40 48 44 9 17 8 12 57]} {[48 47 32 60 59 8 57 55]}];%080219_B8 & B10
            setArrays=[{[16 16 16 16 16 14 14 13]} {[16 16 14 13 13 14 14 12]}];
            setInd=7;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
            currentThresholdChs=64;
            visualOnly=0;
    end
end
load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);

processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=[rootdir,date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        
        %read in eye data:
        recordedRaw=1;
        if recordedRaw==0%7/9/17
            eyeChannels=[1 2];
        elseif recordedRaw==1%11/9/17
            eyeChannels=[129 130];
        end
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        %         instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
        %         eyeDataMat=['D:\data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
        %         if exist(eyeDataMat,'file')
        %             load(eyeDataMat,'NSch');
        %         else
        %             if recordedRaw==0
        %                 NSchOriginal=openNSx(instanceNS6FileName);
        %                 for channelInd=1:length(eyeChannels)
        %                     NSch{channelInd}=NSchOriginal.Data(channelInd,:);
        %                 end
        %             elseif recordedRaw==1
        %                 for channelInd=1:length(eyeChannels)
        %                     readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
        %                     NSchOriginal=openNSx(instanceNS6FileName,readChannel);
        %                     NSch{channelInd}=NSchOriginal.Data;
        %                 end
        %             end
        %             save(eyeDataMat,'NSch');
        %         end
        
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
                if trialNo>1
                    trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(encodeInd(trialNo-1):encodeInd(trialNo));
                else
                    trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo));
                end
                ErrorB=Par.ErrorB;
                CorrectB=Par.CorrectB;
                MicroB=Par.MicroB;
                StimB=Par.StimB;
                TargetB=Par.TargetB;
                if visualOnly==0
                    if ~isempty(find(trialEncodes==2^CorrectB))&&~isempty(find(trialEncodes==2^MicroB))&&~isempty(find(trialEncodes==2^TargetB))
                        perfNEV(trialNo)=1;
                    elseif ~isempty(find(trialEncodes==2^ErrorB))&&~isempty(find(trialEncodes==2^MicroB))&&~isempty(find(trialEncodes==2^TargetB))
                        perfNEV(trialNo)=-1;
                    end
                    if length(find(trialEncodes==2^MicroB))>=1
                        microstimTrialNEV(trialNo)=1;
                    end
                elseif visualOnly==1
                    if ~isempty(find(trialEncodes==2^CorrectB))&&~isempty(find(trialEncodes==2^StimB))&&~isempty(find(trialEncodes==2^TargetB))
                        perfNEV(trialNo)=1;
                    elseif ~isempty(find(trialEncodes==2^ErrorB))&&~isempty(find(trialEncodes==2^StimB))&&~isempty(find(trialEncodes==2^TargetB))
                        perfNEV(trialNo)=-1;
                    end
                    microstimTrialNEV(trialNo)=0;
                end
                trialNo=trialNo+1;
            end
        end
        
        tallyCorrect=length(find(perfNEV==1));
        tallyIncorrect=length(find(perfNEV==-1));
        meanPerf=tallyCorrect/(tallyCorrect+tallyIncorrect);
        visualTrialsInd=find(microstimTrialNEV==0);%not entirely correct- includes microstim trials where fix breaks happen before dasbit sent MicroB
        microstimTrialsInd=find(microstimTrialNEV==1);
        correctTrialsInd=find(perfNEV==1);
        incorrectTrialsInd=find(perfNEV==-1);
        correctVisualTrialsInd=intersect(visualTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
        incorrectVisualTrialsInd=intersect(visualTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
        correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
        incorrectMicrostimTrialsInd=intersect(microstimTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
        meanPerfVisual=length(correctVisualTrialsInd)/(length(correctVisualTrialsInd)+length(incorrectVisualTrialsInd))
        meanPerfMicrostim=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectMicrostimTrialsInd))
        totalRespTrials=length(correctTrialsInd)+length(incorrectTrialsInd);%number of trials where a response was made
        indRespTrials=sort([correctTrialsInd incorrectTrialsInd]);%indices of trials where response was made
        micro=[];
        for trialRespInd=1:totalRespTrials
            trialNo=indRespTrials(trialRespInd);
            corr(trialRespInd)=~isempty(find(correctTrialsInd==trialNo));
            incorr(trialRespInd)=~isempty(find(incorrectTrialsInd==trialNo));
            if exist('microstimTrialNEV','var')
                if length(microstimTrialNEV)>=trialNo
                    micro(trialRespInd)=microstimTrialNEV(trialNo);
                end
            end
        end
        visualInd=find(micro~=1);
        corrInd=find(corr==1);
        corrVisualInd=intersect(visualInd,corrInd);
        if exist('microstimTrialNEV','var')
            microInd=find(micro==1);
            corrMicroInd=intersect(microInd,corrInd);
        end
        perfMicroBin=[];
        perfVisualBin=[];
        perfMicroTrialNo=[];
        perfVisualTrialNo=[];
        numTrialsPerBin=5;
        for trialRespInd=1:length(micro)
            if micro(trialRespInd)==1
                firstMicroTrialInBin=find(microInd==trialRespInd);
                if firstMicroTrialInBin<=length(microInd)-numTrialsPerBin+1
                    binMicroTrials=microInd(firstMicroTrialInBin:firstMicroTrialInBin+numTrialsPerBin-1);
                    corrMicroInBin=intersect(binMicroTrials,corrMicroInd);
                    perfMicroBin=[perfMicroBin length(corrMicroInBin)/numTrialsPerBin];
                    perfMicroTrialNo=[perfMicroTrialNo trialRespInd];
                end
            elseif micro(trialRespInd)==0
                firstVisualTrialInBin=find(visualInd==trialRespInd);
                if firstVisualTrialInBin<=length(visualInd)-numTrialsPerBin+1
                    binVisualTrials=visualInd(firstVisualTrialInBin:firstVisualTrialInBin+numTrialsPerBin-1);
                    corrVisualInBin=intersect(binVisualTrials,corrVisualInd);
                    perfVisualBin=[perfVisualBin length(corrVisualInBin)/numTrialsPerBin];
                    perfVisualTrialNo=[perfVisualTrialNo trialRespInd];
                end
            end
        end
        
        if analyseConds==1
            figure;
            uniqueResponsesTally={};
            uniqueBehavResponses={};
            total=zeros(1,length(setElectrodes));
            allTargetLocation=[];
            for trialInd=1:length(allElectrodeNum)
                for setNo=1:numTargets
                    if isequal(allElectrodeNum{trialInd}(:),setElectrodes{setNo}(:))
                        allTargetLocation(trialInd)=setNo;
                    end
                end
            end
            for setNo=1:length(setElectrodes)
                condInds{setNo}=find(allTargetLocation==setNo);
                corrIndsM{setNo}=intersect(condInds{setNo},correctMicrostimTrialsInd);
                incorrIndsM{setNo}=intersect(condInds{setNo},incorrectMicrostimTrialsInd);
                perfM(setNo)=length(corrIndsM{setNo})/(length(corrIndsM{setNo})+length(incorrIndsM{setNo}));
                corrIndsV{setNo}=intersect(condInds{setNo},correctVisualTrialsInd);
                incorrIndsV{setNo}=intersect(condInds{setNo},incorrectVisualTrialsInd);
                perfV(setNo)=length(corrIndsV{setNo})/(length(corrIndsV{setNo})+length(incorrIndsV{setNo}));
                letterLocations=double('TR');
                letters='T   L';
                for responseInd=1:length(letterLocations)%tally number of incorrect trials (does not include correct trials)
                    temp1=find(behavResponse==letterLocations(responseInd));
                    temp2=intersect(temp1,condInds{setNo});
                    uniqueResponsesTally{setNo}(responseInd)=length(temp2);
                    total(setNo)=total(setNo)+uniqueResponsesTally{setNo}(responseInd);
                end
                if visualOnly==1
                    uniqueResponsesTally{setNo}(responseInd)=length(corrIndsV{setNo});%tally number of correct trials
                    total(setNo)=total(setNo)+length(corrIndsV{setNo});
                elseif visualOnly==0
                    uniqueResponsesTally{setNo}(responseInd)=length(corrIndsM{setNo});%tally number of correct trials
                    total(setNo)=total(setNo)+length(corrIndsM{setNo});
                end
%                 correctResponsesV{setNo}=behavResponse(corrIndsV{setNo});
%                 incorrectResponsesV{setNo}=behavResponse(incorrIndsV{setNo});
%                 uniqueBehavResponses{setNo}=unique(incorrectResponsesV{setNo})
%                 uniqueReponses=[];
%                 for uniqueReponseInd=1:length(uniqueBehavResponses{setNo})
%                     uniqueResponses=find(incorrectResponsesV{setNo}==uniqueBehavResponses{setNo}(uniqueReponseInd));
%                     uniqueResponsesTally{setNo}(uniqueReponseInd)=length(uniqueResponses);
%                     total(setNo)=total(setNo)+uniqueResponsesTally{setNo}(uniqueReponseInd);
%                 end
            end

            figure;
            figCols=[0 0 1;0 1 0];
            for setNo=1:length(setElectrodes)
                if setNo==1
%                     subplot(2,3,2);
%                     subplot(2,6,2:3);
                    subplot(1,2,1);
                elseif setNo==2
%                     subplot(2,3,3);
%                     subplot(2,6,4:5);
                    subplot(1,2,2);
                end
                hold on
                %draw dotted lines indicating [0,0]
                plot([0 0],[-250 200],'k:');
                plot([-200 300],[0 0],'k:');
%                 plot([-200 300],[200 -300],'k:');
%            ellipse(Par.PixPerDeg*2,Par.PixPerDeg*2,0,0,[0.1 0.1 0.1]);
           ellipse(Par.PixPerDeg*4,Par.PixPerDeg*4,0,0,[0.1 0.1 0.1]);
%            ellipse(Par.PixPerDeg*6,Par.PixPerDeg*6,0,0,[0.1 0.1 0.1]);
%            ellipse(Par.PixPerDeg*8,Par.PixPerDeg*8,0,0,[0.1 0.1 0.1]);
                for electrodeCount=1:length(setElectrodes{setNo})
                    electrode=setElectrodes{setNo}(electrodeCount);
                    array=setArrays{setNo}(electrodeCount);
                    electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode);%matching channel number
                    electrodeIndtemp2=find(goodArrays8to16(:,7)==array);%matching array number
                    electrodeInd=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                    RFx=goodArrays8to16(electrodeInd,1);
                    RFy=goodArrays8to16(electrodeInd,2);
                    plot(RFx,RFy,'o','Color',figCols(setNo,:),'MarkerFaceColor',figCols(setNo,:),'MarkerSize',4);hold on
                    currentThreshold=goodCurrentThresholds(electrodeInd);
%                     if electrodeCount==1
%                         text(RFx-28,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
%                         text(RFx-28,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
%                     else
%                         text(RFx+4,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
%                         text(RFx+4,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
%                     end
                    for electrodePairInd=1:size(electrodePairs,2)-1
                        electrode1=setElectrodes{setNo}(electrodePairInd);
                        array1=setArrays{setNo}(electrodePairInd);
                        electrode2=setElectrodes{setNo}(electrodePairInd+1);
                        array2=setArrays{setNo}(electrodePairInd+1);
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode1);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array1);%matching array number
                        electrodeInd1=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode2);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array2);%matching array number
                        electrodeInd2=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        RFx1=goodArrays8to16(electrodeInd1,1);
                        RFy1=goodArrays8to16(electrodeInd1,2);
                        RFx2=goodArrays8to16(electrodeInd2,1);
                        RFy2=goodArrays8to16(electrodeInd2,2);
%                         plot([RFx1 RFx2],[RFy1 RFy2],'k--');
                    end
                end
                scatter(0,0,'r','o','filled');%fix spot
%                 text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
%                 text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
%                 text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
%                 text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
                axis equal
%                 xlim([-20 220]);
%                 ylim([-160 20]);
%            xlim([-20 190]);
%            ylim([-135 20]);
           xlim([-20 170]);
           ylim([-115 20]);
                if setNo==1
%                     title([' RF locations, ',date,' letter task'], 'Interpreter', 'none');
                end
%             for arrayInd=1:length(arrays)
%                 text(175,0-10*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
%             end
            ax=gca;
            ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
            ax.XTickLabel={'0','2','4','6','8'};
            ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
            ax.YTickLabel={'8','6','4','2','0'};
           set(gca,'XAxisLocation','top','YAxisLocation','left');
           set(gca,'Box','off')
           set(ax,'xcolor','none')
           ax.XAxis.Label.Color=[0 0 0];
           ax.XAxis.Label.Visible='on';
           set(ax,'ycolor','none')
           ax.YAxis.Label.Color=[0 0 0];
           ax.YAxis.Label.Visible='on';
            end
%             xlabel('x-coordinates (dva)')
%             ylabel('y-coordinates (dva)')
            
%             %            if numTargets==4
%             subplot(2,3,1);
%             %            else
%             %                subplot(2,4,3);
%             %            end
%             if numTargets==4
%                 b=bar([perfV(1) perfM(1);perfV(2) perfM(2);perfV(3) perfM(3);perfV(4) perfM(4)],'FaceColor','flat');
%             elseif numTargets==2
%                 b=bar([perfV(1) perfM(1);perfV(2) perfM(2)],'FaceColor','flat');
%             end
%             b(1).FaceColor = 'flat';
%             b(2).FaceColor = 'flat';
%             b(1).FaceColor = [0 0.4470 0.7410];
%             b(2).FaceColor = [1 0 0];
%             set(gca, 'XTick',1:numTargets)
%             set(gca,'XTick',[])
%             xLimits=get(gca,'xlim');
%             ylim([0 1])
%             hold on
%             plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
%            xlim([0.6 2.7])
%            set(gca,'Box','off')
        end
        
        %         figInd1=figure;hold on
        if ~isempty(perfMicroBin)
            subplot(2,3,4:6);
            ylim([0 1]);
            set(gca, 'YTick',[0 0.5 1])
            initialPerfTrials=50;%first set of trials are the most important
            hold on
            plot(perfMicroTrialNo,perfMicroBin,'r-');
            xLimits=get(gca,'xlim');
            plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
            xlim([0 length(perfMicroBin)+1]);
%             subplot(4,4,13:16);
%             ylim([0 1]);
%             plot(perfVisualTrialNo,perfVisualBin,'bx-');
%             hold on
%             xLimits=get(gca,'xlim');
%             plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
        end
%         title(['performance across the session, on visual (blue) & microstim (red) trials, ',num2str(numTrialsPerBin),' trials/bin']);
%         xlabel('trial number (across the session)');
%         ylabel('performance');
%         pathname=fullfile(rootdir,date,['behavioural_performance_RF_locations_',date]);
%         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         print(pathname,'-dtiff');
    end
end
pause=1;