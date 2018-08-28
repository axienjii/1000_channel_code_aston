function analyse_microstim_letter_multiset(date,allInstanceInd)
%16/5/18
%Written by Xing, modified from analyse_microstim_letter.m, calculates behavioural performance during a
%microstimulation/visual 'letter' task, for version in which each letter is depicted by several possible sets of electrodes within a recording.

interleaved=0;%set interleaved to 0, if trigger pulse was sent using microB. set interleaved to 1, if stimulation was sent by calling stimulator.play function
drummingOn=0;%for sessions after 9/4/18, drumming with only 2 targets was uesd 
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
dataDir=[rootdir,date,'\',date,'_data'];
if ~exist('dataDir','dir')
    copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
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
        case '150518_B8'
            setInds=53:62;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=125;
            visualOnly=0;
            lastControlCond=0;
        case '160518_B3'
            setInds=44:63;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=126;
            visualOnly=0;
            lastControlCond=1;
            
        %visual task only:
        case '150518_B6'
            setInds=53:62;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=125;
            visualOnly=1;
            lastControlCond=0;
        case '160518_B1'
            setInds=44:63;
            numTargets=2;
            electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2});1:length(setElectrodes{3});1:length(setElectrodes{4})];
            currentThresholdChs=126;
            visualOnly=1;
            lastControlCond=1;
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
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                elseif find(trialEncodes==2^ErrorB)
                    perfNEV(trialNo)=-1;
                end
                if visualOnly==0
                    if interleaved==0%stimulation sent using trigger pulse from dasbit(microB,1)
                        if length(find(trialEncodes==2^MicroB))>=1
                            microstimTrialNEV(trialNo)=1;
                        end
                    elseif interleaved==1%stimulation sent using sitmulator.play function
                        microstimTrialNEV(trialNo)=1;
                    end
                elseif visualOnly==1
                    if length(find(trialEncodes==2^StimB))==1
                        microstimTrialNEV(trialNo)=0;
                    end
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
        if drummingOn==1
            notDrummingTrials=find(allDrummingTrials==0);
            correctTrialsInd=intersect(correctTrialsInd,notDrummingTrials);
            incorrectTrialsInd=intersect(incorrectTrialsInd,notDrummingTrials);
        end
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
        if visualOnly==1
            numTrialsPerBin=20;
        elseif visualOnly==0
            numTrialsPerBin=5;
        end
        for trialRespInd=1:totalRespTrials-numTrialsPerBin
            if length(micro)>=trialRespInd
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
        end
        
        if analyseConds==1
            numSubPlots=4*length(setInds);
            numFigs=ceil(numSubPlots/20);
            for figCount=1:numFigs
                figInd(figCount)=figure;
            end
            uniqueResponsesTally={};
            uniqueBehavResponses={};
            total=zeros(1,length(setElectrodes));
            allTargetLocation=[];
            responseTrialsInd=find(performance~=0);%identify trials where response was made
            for condNo=1:length(setInds)
                figure(figInd(ceil(condNo/10)));
                [setElectrodes,setArrays]=lookup_set_electrodes_letter(setInds(condNo));
                allTargetLocation=zeros(1,length(allElectrodeNum));
                for trialInd=1:length(allElectrodeNum)
                    for setNo=3:4
                        if isequal(allElectrodeNum{trialInd}(:),setElectrodes{setNo}(:))
                            allTargetLocation(trialInd)=setNo;
                        end
                    end
                end
                for setNo=3:4
                    responseTrialsCondInd=allTargetLocation(responseTrialsInd);%identify trials where response was made, for that condition
                    tallyTrialsCond=length(find(responseTrialsCondInd==setNo));
                end%tally number of trials for that condition, on which a behavioural response was made
                for setNo=3:4
                    condInds{setNo}=find(allTargetLocation==setNo);
                    firstTrials=[];
                    if ~isempty(firstTrials)
                        corrIndsM{setNo}=intersect(condInds{setNo}(1:firstTrials),correctMicrostimTrialsInd);
                        incorrIndsM{setNo}=intersect(condInds{setNo}(1:firstTrials),incorrectMicrostimTrialsInd);
                    else
                        corrIndsM{setNo}=intersect(condInds{setNo},correctMicrostimTrialsInd);
                        incorrIndsM{setNo}=intersect(condInds{setNo},incorrectMicrostimTrialsInd);
                    end
                    
                    perfM(setNo)=length(corrIndsM{setNo})/(length(corrIndsM{setNo})+length(incorrIndsM{setNo}));
                    corrIndsV{setNo}=intersect(condInds{setNo},correctVisualTrialsInd);
                    incorrIndsV{setNo}=intersect(condInds{setNo},incorrectVisualTrialsInd);
                    perfV(setNo)=length(corrIndsV{setNo})/(length(corrIndsV{setNo})+length(incorrIndsV{setNo}));
                    allPerfM(condNo,setNo)=perfM(setNo);
                    allPerfV(condNo,setNo)=perfV(setNo);

                    if numTargets==4
                        letterLocations=double('LRTB');
                        if setInd==37
                            letters='I   O   A   L';
                        elseif setInd>=38
                            letters='T   O   A   L';
                        end
                    elseif numTargets==2
                        if LRorTB==1
                            letterLocations=double('LR');
                            if setInd==37
                                letters='I   O';
                            elseif setInd>=38
                                letters='T   O';
                            end
                        elseif LRorTB==2
                            letterLocations=double('TB');
                            letters='A   L';
                        end
                    end
%                     for responseInd=1:length(letterLocations)%tally number of incorrect trials (does not include correct trials)
%                         temp1=find(behavResponse==letterLocations(responseInd));
%                         temp2=intersect(temp1,condInds{setNo});
%                         uniqueResponsesTally{setNo}(responseInd)=length(temp2);
%                         total(setNo)=total(setNo)+uniqueResponsesTally{setNo}(responseInd);
%                     end
%                     if visualOnly==1
%                         uniqueResponsesTally(condNo,setNo)=length(corrIndsV{setNo});%tally number of correct trials
%                         total(setNo)=total(setNo)+length(corrIndsV{setNo});
%                     elseif visualOnly==0
%                         uniqueResponsesTally{setNo}(responseInd)=length(corrIndsM{setNo});%tally number of correct trials
%                         total(setNo)=total(setNo)+length(corrIndsM{setNo});
%                     end
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
%                 if numTargets==4
%                     b=bar([uniqueResponsesTally{1}(1)/total(1) uniqueResponsesTally{1}(2)/total(1) uniqueResponsesTally{1}(3)/total(1) uniqueResponsesTally{1}(4)/total(1);uniqueResponsesTally{2}(1)/total(2) uniqueResponsesTally{2}(2)/total(2) uniqueResponsesTally{2}(3)/total(2) uniqueResponsesTally{2}(4)/total(2);uniqueResponsesTally{3}(1)/total(3) uniqueResponsesTally{3}(2)/total(3) uniqueResponsesTally{3}(3)/total(3) uniqueResponsesTally{3}(4)/total(3);uniqueResponsesTally{4}(1)/total(4) uniqueResponsesTally{4}(2)/total(4) uniqueResponsesTally{4}(3)/total(4) uniqueResponsesTally{4}(4)/total(4)],'FaceColor','flat');
%                 elseif numTargets==2
%                     b=bar([uniqueResponsesTally{1}(1)/total(1) uniqueResponsesTally{1}(2)/total(1);uniqueResponsesTally{2}(1)/total(2) uniqueResponsesTally{2}(2)/total(2)],'FaceColor','flat');
%                 end
%                 b(1).FaceColor = 'flat';
%                 b(2).FaceColor = 'flat';
%                 if numTargets==4
%                     b(3).FaceColor = 'flat';
%                     b(4).FaceColor = 'flat';
%                 end
%                 %             b(1).FaceColor = [0 0.4470 0.7410];
%                 %             b(2).FaceColor = [1 0 0];
%                 set(gca, 'XTick',1:numTargets)
%                 if numTargets==4
%                     set(gca, 'XTickLabel', {[letters;letters;letters;letters]})
%                 elseif numTargets==2
%                     set(gca, 'XTickLabel', {[letters;letters]})
%                 end
%                 %             set(gca, 'XTickLabel', {[char(uniqueBehavResponses{1}(2)) char(uniqueBehavResponses{1}(3)) char(uniqueBehavResponses{1}(4))] [char(uniqueBehavResponses{2}(2)) char(uniqueBehavResponses{2}(3)) char(uniqueBehavResponses{2}(4))] [char(uniqueBehavResponses{3}(2)) char(uniqueBehavResponses{3}(3)) char(uniqueBehavResponses{3}(4))] [char(uniqueBehavResponses{4}(2)) char(uniqueBehavResponses{4}(3)) char(uniqueBehavResponses{4}(4))]})
%                 xLimits=get(gca,'xlim');
%                 hold on
%                 plot([xLimits(1) xLimits(2)],[1/(numTargets) 1/(numTargets)],'k:');
%                 ylim([0 1])
%                 if numTargets==4
%                     xlim([0.5 4.5])
%                 elseif numTargets==2
%                     xlim([0.5 2.5])
%                 end
                %             title('proportion of responses to various targets');
                %             xlabel('target selected');
                %             ylabel('proportion of trials for a given (correct target) condition');
                %             pathname=fullfile(rootdir,date,['confusion_matrix_',date]);
                % %             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                %             print(pathname,'-dtiff');
                
                %             figure;
                for setNo=3:4
                    if setNo==3
                        figure(figInd(ceil(condNo/10)));
                    elseif setNo==4
                        figure(figInd(ceil(condNo/10)+2));
                    end
                    figureSubPlotNum=mod(condNo,10);
                    if figureSubPlotNum==0
                        figureSubPlotNum=10;
                    end
                    if figureSubPlotNum<=5
                        subplot(4,5,figureSubPlotNum);
                    else
                        subplot(4,5,figureSubPlotNum+5);
                    end
                    if ~isempty(condInds{setNo})
                        for electrodeCount=1:length(setElectrodes{setNo})
                            electrode=setElectrodes{setNo}(electrodeCount);
                            array=setArrays{setNo}(electrodeCount);
                            load([dataDir,'\array',num2str(array),'.mat']);
                            electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode);%matching channel number
                            electrodeIndtemp2=find(goodArrays8to16(:,7)==array);%matching array number
                            electrodeInd=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                            RFx=goodArrays8to16(electrodeInd,1);
                            RFy=goodArrays8to16(electrodeInd,2);
                            plot(RFx,RFy,'o','Color',cols(array-7,:),'MarkerFaceColor',cols(array-7,:));hold on
                            currentThreshold=goodCurrentThresholds(electrodeInd);
                            labelElectrodes=0;
                            if labelElectrodes==1
                                if electrodeCount==1
                                    text(RFx-28,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                                    text(RFx-28,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                                else
                                    text(RFx+4,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                                    text(RFx+4,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                                end
                            end
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
                                plot([RFx1 RFx2],[RFy1 RFy2],'k--');
                            end
                        end
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
                    axis equal
                    xlim([-20 220]);
                    ylim([-160 20]);
                    if condNo==1
                        title([' RF locations, ',date,' letter task'], 'Interpreter', 'none');
                    end
                for arrayInd=1:length(arrays)
                    text(175,0-10*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
                end
                ax=gca;
                ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
                ax.XTickLabel={'0','2','4','6','8'};
                ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
                ax.YTickLabel={'-8','-6','-4','-2','0'};
                xlabel('x-coordinates (dva)')
                ylabel('y-coordinates (dva)')
                
                %            if numTargets==4
                if figureSubPlotNum<=5
                    subplot(4,5,figureSubPlotNum+5);
                else
                    subplot(4,5,figureSubPlotNum+10);
                end
                %            else
                %                subplot(2,4,3);
                %            end
                if numTargets==4
                    b=bar([perfV(1) perfM(1);perfV(2) perfM(2);perfV(3) perfM(3);perfV(4) perfM(4)],'FaceColor','flat');
                elseif numTargets==2
%                     b=bar([perfV(1) perfM(1);perfV(2) perfM(2)],'FaceColor','flat');
%                     b=bar([perfV(3) perfM(3);perfV(4) perfM(4)],'FaceColor','flat');
                    b=bar([perfV(setNo) perfM(setNo)],'FaceColor','flat');
                end
                b(1).FaceColor = 'flat';
                if visualOnly==1
                    b(1).FaceColor = [0 0.4470 0.7410];
                elseif visualOnly==0
                    b(1).FaceColor = [1 0 0];
                end
                set(gca, 'XTick',1:numTargets)
                if numTargets==4
                    set(gca, 'XTickLabel', {['left, ',allLetters(1)] ['right, ',allLetters(2)] ['up, ',allLetters(3)] ['down, ',allLetters(4)]})
                elseif numTargets==2
                    if LRorTB==1
                        set(gca, 'XTickLabel', {['left, ',allLetters(1)] ['right, ',allLetters(2)]})
                    elseif LRorTB==1
                        %set(gca, 'XTickLabel', {['up, ',allLetters(3)] ['down, ',allLetters(4)]})
                        if setInd==3
                            set(gca, 'XTickLabel', {['up, ',allLetters(3)]})
                        elseif setInd==4
                            set(gca, 'XTickLabel', {['down, ',allLetters(4)]})
                        end
                    end
                end
                xLimits=get(gca,'xlim');
%                 for setNo=1:length(setElectrodes)
                    if ~isnan(perfV(setNo))
                        txt=sprintf('%.2f',perfV(setNo));
                        text(setNo-0.3,0.95,txt,'Color','b')
                    end
                    if ~isnan(perfM(setNo))
                        txt=sprintf('%.2f',perfM(setNo));
                        text(setNo,0.95,txt,'Color','r')
                    end
%                 end
                ylim([0 1])
                hold on
                plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
                xlim([0 5])
                xlabel('target condition');
                ylabel('average performance across session');
                if condNo==1
                    title('mean performance, visual (blue) & microstim (red) trials');
                end
                %            pathname=fullfile('D:\data',date,['behavioural_performance_per_condition_',date]);
                %            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                %            print(pathname,'-dtiff');
                end            
            end
            figure;hold on%plot mean performance across electrode sets (excluding control)
            if visualOnly==0
                perfPlot=allPerfM(1:length(setInds),:);
            else
                perfPlot=allPerfV(1:length(setInds),:);
            end
            if lastControlCond==1%for last condition, the electrodes were randomly chosen
                perfPlot=perfPlot(1:end-1,:);
            end
            bar(1,mean(perfPlot(:,3)))
            errorbar(1,mean(perfPlot(:,3)),std(perfPlot(:,3)))
            bar(2,mean(perfPlot(:,4)))
            errorbar(2,mean(perfPlot(:,4)),std(perfPlot(:,4)))
            ylim([0 1])
            set(gca,'XTick',[1 2]);
            set(gca,'XTickLabels',[{'A'} {'L'}]);
            plot([0 2.5],[0.5 0.5],'k--');
            xlabel('letter')
            ylabel('mean performance')
            title(['performance across ',num2str(size(perfPlot,1)),' sets, error 1 SD'])
            tempPerf=perfPlot(1:size(perfPlot,1),3:4);
            tempPerf=tempPerf(:);
            [p,h,stats]=signrank(tempPerf,0.5)%for 160518_B3, Z=2.70, p=.007. for 150518_B8, Z=4.57, p<.001
            for figCount=1:numFigs
                figure(figInd(figCount));
                if labelElectrodes==1
                    pathname=fullfile(rootdir,date,['behavioural_performance_per_condition_',date,'_',num2str(figCount)]);
                else
                    pathname=fullfile(rootdir,date,['behavioural_performance_per_condition_',date,'_',num2str(figCount),'_no_labels']);
                end
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%                 print(pathname,'-dtiff','-r300');
            end
%             perfM(setNo)=length(corrIndsM{setNo})/(length(corrIndsM{setNo})+length(incorrIndsM{setNo}));
%             corrIndsV{setNo}=intersect(condInds{setNo},correctVisualTrialsInd);
%             incorrIndsV{setNo}=intersect(condInds{setNo},incorrectVisualTrialsInd);
%             perfV(setNo)=length(corrIndsV{setNo})/(length(corrIndsV{setNo})+length(incorrIndsV{setNo}));
%             allPerfM(condNo,setNo)=perfM(setNo);
%             allPerfV(condNo,setNo)=perfV(setNo);
            mean(allPerfM(1:19,3:4))%calculate mean across all conditions where a phosphene letter was presented; exclude last condition in which a control set of electrodes was used
            allPerfM(1:19,5:8)=[0.900000000000000,0.140000000000000,0,0;0.890000000000000,0.0800000000000000,0,0;0.810000000000000,0.950000000000000,0,0;1,0.890000000000000,0,0;0.880000000000000,0.780000000000000,0,0;0.640000000000000,0.930000000000000,0,0;0.800000000000000,0.0600000000000000,0,0;0.0300000000000000,0.590000000000000,0,0;0.0200000000000000,0.870000000000000,0,0;0.920000000000000,0.920000000000000,0.980000000000000,0;0.470000000000000,0.680000000000000,0,0.880000000000000;0.760000000000000,0.860000000000000,0.570000000000000,0;0.580000000000000,0.670000000000000,0,0.830000000000000;0.900000000000000,0.900000000000000,0.820000000000000,0;0.810000000000000,0.850000000000000,0,0;0.950000000000000,0.960000000000000,0.970000000000000,0;1,0.960000000000000,0,0.930000000000000;0.780000000000000,0.630000000000000,0.970000000000000,0;0.960000000000000,1,0,0.980000000000000;0,0,0,0];
            [h p]=ttest(allPerfM(1:19,3),0.5)
            [h p]=ttest(allPerfM(1:19,4),0.5)
            combinedAL=allPerfM(1:19,3:4);
            [h p]=ttest(combinedAL(:),0.5)
            figure;
            subplot(1,2,1);
            scatter(allPerfM(1:19,5),allPerfM(1:19,3));hold on
            scatter(allPerfM([10 12 14 16 18],5),allPerfM([10 12 14 16 18],7),'rx');
            title('performance on letter A');
            xlabel('previous uni-set task');
            ylabel('current multi-set task');
            axis square
            subplot(1,2,2);
            scatter(allPerfM(1:19,6),allPerfM(1:19,4));hold on
            scatter(allPerfM([11 13 15 17 19],6),allPerfM([11 13 15 17 19],8),'rx');
            title('performance on letter L');
            xlabel('previous uni-set task');
            ylabel('current multi-set task');
            axis square
            text(0.1,0.85,'red: older thresholds','Color','r')
            text(0.1,0.9,'blue: new thresholds','Color','b')
        end
        
        figInd1=figure;hold on
        if ~isempty(perfMicroBin)&&~isempty(perfVisualBin)
            subplot(4,4,9:12);
            ylim([0 1]);
            initialPerfTrials=50;%first set of trials are the most important
            hold on
            plot(perfMicroTrialNo,perfMicroBin,'rx-');
            xLimits=get(gca,'xlim');
            plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
            subplot(4,4,13:16);
            ylim([0 1]);
            plot(perfVisualTrialNo,perfVisualBin,'bx-');
            hold on
            xLimits=get(gca,'xlim');
            plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
        else
            subplot(2,4,5:8);
            ylim([0 1]);
            initialPerfTrials=50;%first set of trials are the most important
            hold on
            plot(perfMicroTrialNo,perfMicroBin,'rx-');
            plot(perfVisualTrialNo,perfVisualBin,'bx-');
            xLimits=get(gca,'xlim');
            plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
        end
        %         if ~isempty(perfMicroTrialNo)
        %             if initialPerfTrials-numTrialsPerBin+1<=length(perfMicroTrialNo)
        %                 firstTrialsM=perfMicroTrialNo(initialPerfTrials-numTrialsPerBin+1);
        %                 plot([firstTrialsM firstTrialsM],[0 1],'r:');
        %                 [pM hM statsM]=ranksum(perfMicroBin(1:50),0.5)
        %                 [hM pM ciM statsM]=ttest(perfMicroBin(1:50),0.5)
        %                 formattedpM=num2str(pM);
        %                 formattedpM=formattedpM(2:end);
        %                 text(xLimits(2)/11,0.14,'p','Color','r','FontAngle','italic');
        %                 text(xLimits(2)/10,0.14,['= ',formattedpM],'Color','r');
        %             end
        %         end
        if ~isempty(perfVisualTrialNo)
            firstTrialsV=perfVisualTrialNo(initialPerfTrials-numTrialsPerBin+1);
            plot([firstTrialsV firstTrialsV],[0 1],'b:');
            if length(perfVisualBin)>=50
                [pV hV statsV]=ranksum(perfVisualBin(1:50),0.5)
                [hV pV ciV statsV]=ttest(perfVisualBin(1:50),0.5)
            else
                [pV hV statsV]=ranksum(perfVisualBin(1:end),0.5)
                [hV pV ciV statsV]=ttest(perfVisualBin(1:end),0.5)
            end
            formattedpV=num2str(pV);
            formattedpV=formattedpV(2:end);
%             text(xLimits(2)/11,0.2,'p','Color','b','FontAngle','italic');
%             text(xLimits(2)/10,0.2,['= ',formattedpV],'Color','b');
        end
        title(['performance across the session, on visual (blue) & microstim (red) trials, ',num2str(numTrialsPerBin),' trials/bin']);
        xlabel('trial number (across the session)');
        ylabel('performance');
        pathname=fullfile(rootdir,date,['behavioural_performance_RF_locations_',date]);
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         print(pathname,'-dtiff');
    end
end
pause=1;