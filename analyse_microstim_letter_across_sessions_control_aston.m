function analyse_microstim_letter_across_sessions_control_aston(date)
%2/8/19
%Written by Xing, calculates behavioural performance during a
%control letter task, for both microstimulation and visual versions.
%Channels for each electrode set were selected randomly by function
%'generate_electrode_sets_control_microstim_letter_task.' Used familiar
%target letters (A and L or T and O), TB or LR targets.
allInstanceInd=1;

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
allSetsPerfMicroBin=[];
allSetsPerfVisualBin=[];
analyseConds=1;
setNos=1:10;
numSets=length(setNos);
visualOnly=1;
for calculateVisual=[0 1]
    for setInd=setNos%numSets%10 electrodes per letter
        perfNEV=[];
        timeInd=[];
        encodeInd=[];
        microstimTrialNEV=[];
        allLRorTB=[];
        allTargetLocation=[];
        corr=[];
        incorr=[];
        localDisk=1;
        if calculateVisual==0
            visualOnly=0;
            switch(setInd)
                %microstim task only:
                case 1
                    date='020819_B2_aston';%novel electrode combinations
                    setElectrodes=[{[16 55 9 16 35 2 32 40 44 51]} {[55 47 59 12 32 50 17 34 41 47]}];%
                    setArrays=[{[12 12 14 14 14 16 16 16 16 16]} {[16 12 13 14 14 14 16 16 16 16]}];
                case 2
                    date='050819_B2_aston';
                    setElectrodes=[{[16 47 59 12 32 50 17 34 41 47]} {[55 9 16 35 2 32 40 44 51 55]}];%
                    setArrays=[{[12 12 13 14 14 14 16 16 16 16]} {[12 14 14 14 16 16 16 16 16 16]}];
                case 3
                    date='050819_B5_aston';
                    setElectrodes=[{[9 16 35 2 32 40 44 51 55 47]} {[16 55 59 12 32 50 17 34 41 47]}];%
                    setArrays=[{[14 14 14 16 16 16 16 16 16 12]} {[12 12 13 14 14 14 16 16 16 16]}];
                case 4
                    date='060819_B2_aston';
                    setElectrodes=[{[16 55 9 12 32 50 17 34 41 47]} {[16 35 2 32 40 44 51 55 47 59]}];%
                    setArrays=[{[12 12 14 14 14 14 16 16 16 16]} {[14 14 16 16 16 16 16 16 12 13]}];
                case 5
                    date='060819_B4_aston';
                    setElectrodes=[{[35 2 32 40 44 51 55 47 59 12]} {[16 55 9 16 32 50 17 34 41 47]}];%
                    setArrays=[{[14 16 16 16 16 16 16 12 13 14]} {[12 12 14 14 14 14 16 16 16 16]}];
                case 6
                    date='060819_B6_aston';
                    setElectrodes=[{[16 55 9 16 35 50 17 34 41 47]} {[2 32 40 44 51 55 47 59 12 32]}];%
                    setArrays=[{[12 12 14 14 14 14 16 16 16 16]} {[16 16 16 16 16 16 12 13 14 14]}];
                case 7
                    date='070819_B2_aston';
                    setElectrodes=[{[32 40 44 51 55 47 59 12 32 50]} {[16 55 9 16 35 2 17 34 41 47]}];%
                    setArrays=[{[16 16 16 16 16 12 13 14 14 14]} {[12 12 14 14 14 16 16 16 16 16]}];
                case 8
                    date='070819_B4_aston';
                    setElectrodes=[{[16 55 9 16 35 2 32 34 41 47]} {[40 44 51 55 47 59 12 32 50 17]}];%
                    setArrays=[{[12 12 14 14 14 16 16 16 16 16]} {[16 16 16 16 12 13 14 14 14 16]}];
                case 9
                    date='080819_B1_aston';
                    setElectrodes=[{[44 51 55 47 59 12 32 50 17 34]} {[16 55 9 16 35 2 32 40 41 47]}];%
                    setArrays=[{[16 16 16 12 13 14 14 14 16 16]} {[12 12 14 14 14 16 16 16 16 16]}];
                case 10
                    date='080819_B3_aston';
                    setElectrodes=[{[16 55 9 16 35 2 32 40 44 47]} {[51 55 47 59 12 32 50 17 34 41]}];%
                    setArrays=[{[12 12 14 14 14 16 16 16 16 16]} {[16 16 12 13 14 14 14 16 16 16]}];                    
            end
        elseif calculateVisual==1
            visualOnly=1;
            switch(setInd)
                %visual task only:
                case 1
                    date='020819_B1_aston';%novel electrode combinations
                    setElectrodes=[{[16 55 9 16 35 2 32 40 44 51]} {[55 47 59 12 32 50 17 34 41 47]}];%
                    setArrays=[{[12 12 14 14 14 16 16 16 16 16]} {[16 12 13 14 14 14 16 16 16 16]}];
                case 2
                    date='050819_B1_aston';
                    setElectrodes=[{[16 47 59 12 32 50 17 34 41 47]} {[55 9 16 35 2 32 40 44 51 55]}];%
                    setArrays=[{[12 12 13 14 14 14 16 16 16 16]} {[12 14 14 14 16 16 16 16 16 16]}];
                case 3
                    date='050819_B3_aston';
                    setElectrodes=[{[9 16 35 2 32 40 44 51 55 47]} {[16 55 59 12 32 50 17 34 41 47]}];%
                    setArrays=[{[14 14 14 16 16 16 16 16 16 12]} {[12 12 13 14 14 14 16 16 16 16]}];
                case 4
                    date='060819_B1_aston';
                    setElectrodes=[{[16 55 9 12 32 50 17 34 41 47]} {[16 35 2 32 40 44 51 55 47 59]}];%
                    setArrays=[{[12 12 14 14 14 14 16 16 16 16]} {[14 14 16 16 16 16 16 16 12 13]}];
                case 5
                    date='060819_B3_aston';
                    setElectrodes=[{[35 2 32 40 44 51 55 47 59 12]} {[16 55 9 16 32 50 17 34 41 47]}];%
                    setArrays=[{[14 16 16 16 16 16 16 12 13 14]} {[12 12 14 14 14 14 16 16 16 16]}];
                case 6
                    date='060819_B5_aston';
                    setElectrodes=[{[16 55 9 16 35 50 17 34 41 47]} {[2 32 40 44 51 55 47 59 12 32]}];%
                    setArrays=[{[12 12 14 14 14 14 16 16 16 16]} {[16 16 16 16 16 16 12 13 14 14]}];
                case 7
                    date='070819_B1_aston';
                    setElectrodes=[{[32 40 44 51 55 47 59 12 32 50]} {[16 55 9 16 35 2 17 34 41 47]}];%
                    setArrays=[{[16 16 16 16 16 12 13 14 14 14]} {[12 12 14 14 14 16 16 16 16 16]}];
                case 8
                    date='070819_B3_aston';
                    setElectrodes=[{[16 55 9 16 35 2 32 34 41 47]} {[40 44 51 55 47 59 12 32 50 17]}];%
                    setArrays=[{[12 12 14 14 14 16 16 16 16 16]} {[16 16 16 16 12 13 14 14 14 16]}];
                case 9
                    date='070819_B5_aston';
                    setElectrodes=[{[44 51 55 47 59 12 32 50 17 34]} {[16 55 9 16 35 2 32 40 41 47]}];%
                    setArrays=[{[16 16 16 12 13 14 14 14 16 16]} {[12 12 14 14 14 16 16 16 16 16]}];
                case 10
                    date='080819_B2_aston';
                    setElectrodes=[{[16 55 9 16 35 2 32 40 44 47]} {[51 55 47 59 12 32 50 17 34 41]}];%
                    setArrays=[{[12 12 14 14 14 16 16 16 16 16]} {[16 16 12 13 14 14 14 16 16 16]}];  
            end
        end
        numTargets=2;
        electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
        currentThresholdChs=78;
        if localDisk==1
            rootdir='D:\aston_data\';
        elseif localDisk==0
            rootdir='X:\aston\';
        end
        matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
        dataDir=[rootdir,date,'\',date,'_data'];
%         if ~exist('dataDir','dir')
% %             copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
%             copyfile(['D:\aston_data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
%         end
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
%                         if find(trialEncodes==2^CorrectB)
%                             perfNEV(trialNo)=1;
%                         elseif find(trialEncodes==2^ErrorB)
%                             perfNEV(trialNo)=-1;
%                         end
%                         for trialCurrentLevelInd=1:length(allCurrentLevel)
%                             if sum(allCurrentLevel{trialCurrentLevelInd})>0
%                                 microstimTrialNEV(trialCurrentLevelInd)=1;
%                             else
%                                 microstimTrialNEV(trialCurrentLevelInd)=0;
%                             end
%                         end
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
                numTrialsPerBin=1;
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
                initialPerfTrials=100;%first set of trials are the most important
                if calculateVisual==0
                    perfMicroBin=perfMicroBin(1:initialPerfTrials);
                    if ~isempty(perfMicroBin)
                        allSetsPerfMicroBin=[allSetsPerfMicroBin;perfMicroBin];
                        save(['D:\aston_data\microPerf_',date,'.mat'],'perfMicroBin');
                    end
                elseif calculateVisual==1
                    perfVisualBin=perfVisualBin(1:initialPerfTrials);
                    %perfVisualBin=perfVisualBin(end-initialPerfTrials+1:end);
                    if ~isempty(perfVisualBin)
                        allSetsPerfVisualBin=[allSetsPerfVisualBin;perfVisualBin];
                        save(['D:\aston_data\visualPerf_',date,'.mat'],'perfVisualBin');
                    end
                end
                
                if analyseConds==1
                    figure;
                    uniqueResponsesTally={};
                    uniqueBehavResponses={};
                    total=zeros(1,length(setElectrodes));
                    allTargetLocation=[];
                    for trialInd=1:length(allElectrodeNum)
                        for electrodeCount=1:numTargets
                            if isequal(allElectrodeNum{trialInd}(:),setElectrodes{electrodeCount}(:))
                                allTargetLocation(trialInd)=electrodeCount;
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
                    end
                    figure;
                    for setNo=1:length(setElectrodes)
                        if setNo<=2
                            subplot(4,8,setNo*2-1:setNo*2);
                        elseif setNo>2
                            subplot(4,8,setNo*2+3:setNo*2+4);
                        end
                        for electrodeCount=1:length(setElectrodes{setNo})
                            electrode=setElectrodes{setNo}(electrodeCount);
                            array=setArrays{setNo}(electrodeCount);
                            electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode);%matching channel number
                            electrodeIndtemp2=find(goodArrays8to16(:,7)==array);%matching array number
                            electrodeInd=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                            RFx=goodArrays8to16(electrodeInd,1);
                            RFy=goodArrays8to16(electrodeInd,2);
                            plot(RFx,RFy,'o','Color',cols(array-7,:),'MarkerFaceColor',cols(array-7,:));hold on
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
                                plot([RFx1 RFx2],[RFy1 RFy2],'k--');
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
                        if setNo==1
                            title([' RF locations, ',date,' letter task'], 'Interpreter', 'none');
                        end
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
                    subplot(2,4,3:4);
                    %            else
                    %                subplot(2,4,3);
                    %            end
                    if numTargets==4
                        b=bar([perfV(1) perfM(1);perfV(2) perfM(2);perfV(3) perfM(3);perfV(4) perfM(4)],'FaceColor','flat');
                    elseif numTargets==2
                        if visualOnly==1
                            b=bar([perfV(1);perfV(2)],'FaceColor','flat');
                            b(1).FaceColor = 'flat';
                            b(1).FaceColor = [0 0.4470 0.7410];
                        elseif visualOnly==0
                            b=bar([perfM(1);perfM(2)],'FaceColor','flat');
                            b(1).FaceColor = 'flat';
                            b(1).FaceColor = [1 0 0];
                        end
                    end
                    set(gca, 'XTick',1:numTargets)
                    if numTargets==4
                        set(gca, 'XTickLabel', {['left, ',allLetters(1)] ['right, ',allLetters(2)] ['up, ',allLetters(3)] ['down, ',allLetters(4)]})
                    elseif numTargets==2
                        if LRorTB==1
                            set(gca, 'XTickLabel', {['left, ',allLetters(1)] ['right, ',allLetters(2)]})
                        elseif LRorTB==1
                            set(gca, 'XTickLabel', {['up, ',allLetters(3)] ['down, ',allLetters(4)]})
                        end
                    end
                    xLimits=get(gca,'xlim');
                    for setNo=1:length(setElectrodes)
                        if ~isnan(perfV(setNo))
                            txt=sprintf('%.2f',perfV(setNo));
                            text(setNo-0.3,0.95,txt,'Color','b')
                        end
                        if ~isnan(perfM(setNo))
                            txt=sprintf('%.2f',perfM(setNo));
                            text(setNo,0.95,txt,'Color','r')
                        end
                    end
                    ylim([0 1])
                    hold on
                    plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
                    xlim([0 5])
                    title('mean performance, visual (blue) & microstim (red) trials');
                    xlabel('target condition');
                    ylabel('average performance across session');
                    subplot(2,4,5:8);
                    ylim([0 1]);
                    hold on
                    smoothBins=10;
                    if visualOnly==1
                        for binInd=1:length(perfVisualBin)-smoothBins+1
                            binPerf(binInd)=mean(perfVisualBin(binInd:binInd+smoothBins-1));
                        end
                        plot(1:length(binPerf),binPerf,'bx-');
                    elseif visualOnly==0
                        for binInd=1:length(perfMicroBin)-smoothBins+1
                            binPerf(binInd)=mean(perfMicroBin(binInd:binInd+smoothBins-1));
                        end
                        plot(1:length(binPerf),binPerf,'rx-');
                    end
                    xLimits=get(gca,'xlim');
                    plot([0 xLimits(2)],[1/numTargets 1/numTargets],'k:');
                    pathname=fullfile('D:\aston_data',date,['behavioural_performance_per_condition_',date]);
                    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%                     print(pathname,'-dtiff');
                end
            end
        end
    end
    if calculateVisual==0
        acrossSessionFig=figure;
        meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
        subplot(2,1,1);
        hold on
        plot(meanAllSetsPerfMicroBin,'r');
        ylim([0 1]);
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
%         plot([10 10],[0 1],'k:');
        xlabel('trial number');
        ylabel('mean performance');
    end
    if calculateVisual==1
        figure(acrossSessionFig);
        subplot(2,1,2);
        hold on
        meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
        plot(meanAllSetsPerfVisualBin,'b');
        ylim([0 1]);
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
%         plot([10 10],[0 1],'k:');
        xlabel('trial number (from beginning of session)');
%         xlabel('trial number (from end of session)');
        ylabel('mean performance across electrode sets');
    end
end
title(['performance across the session, on visual (blue) trials']);
%histogram version:
figure;
subplot(1,2,1);
edges=0:0.1:1;
for setInd=1:numSets
    meanPerfAllSetsV(setInd)=mean(allSetsPerfVisualBin(setInd,:));
end
mean(meanPerfAllSetsV)%0.4990
h1=histogram(meanPerfAllSetsV,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
yLim=get(gca,'ylim');
plot([0.5 0.5],[0 yLim(2)+1],'k:');
xlim([0 1]);
% ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(meanPerfAllSetsV,0.5);
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = -0.025097, p = 0.9805

subplot(1,2,2);
edges=0:0.1:1;
for setInd=1:numSets
    meanPerfAllSetsM(setInd)=mean(allSetsPerfMicroBin(setInd,:));
end
mean(meanPerfAllSetsM)%0.4690
h1=histogram(meanPerfAllSetsM,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
yLim=get(gca,'ylim');
plot([0.5 0.5],[0 yLim(2)+1],'k:');
xlim([0 1]);
% ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(meanPerfAllSetsM,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = -0.95471, p = 0.3647

pathname=['D:\aston_data\control_letter_behavioural_performance_all_sets_',date,'_',num2str(initialPerfTrials),'trials'];
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff');

perfMat=['D:\aston_data\control_letter_behavioural_performance_all_sets_',date,'_',num2str(initialPerfTrials),'trials.mat'];
save(perfMat,'meanAllSetsPerfVisualBin','meanPerfAllSetsV','allSetsPerfVisualBin','meanAllSetsPerfMicroBin','meanPerfAllSetsM','allSetsPerfMicroBin');
pause=1;

significantByThisTrialVisual=0;
for trialInd=1:length(meanAllSetsPerfVisualBin)
    x=sum(meanAllSetsPerfVisualBin(1:trialInd))*size(allSetsPerfVisualBin,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfVisualBin,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialVisual(trialInd)=1;
    end
end
significantByThisTrialVisual

load('D:\aston_data\control_letter_behavioural_performance_all_sets_080819_B2_aston_100trials.mat')
load('D:\aston_data\letter_behavioural_performance_all_sets_190219_B7_aston_all_trials.mat')%data from original (non-control) task
load('D:\aston_data\letter_behavioural_performance_all_sets_190219_B7_aston_100trials.mat')
[h,p,ci,stats]=ttest2(meanPerfAllSetsV,goodSetsallSetsPerfVisualAllTrials)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)
[h,p,ci,stats]=ttest2(meanPerfAllSetsM,goodSetsallSetsPerfMicroAllTrials)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)

% %Plot data from 2 monkeys on the same figure:
% figure;
% load('D:\data\control_letter_behavioural_performance_all_sets_030719_B12_100trials.mat')
% subplot(1,2,1);
% edges=0:0.1:1;
% numSets=10;
% for setInd=1:numSets
%     meanPerfAllSets(setInd)=mean(allSetsPerfVisualBin(setInd,:));
% end
% h1=histogram(meanPerfAllSets,edges);
% h1(1).FaceColor = [0 0 1];
% h1(1).EdgeColor = [0 0 0];
% hold on
% yLim=get(gca,'ylim');
% plot([0.5 0.5],[0 yLim(2)+1],'k:');
% xlim([0 1]);
% % ylim([0 10]);
% set(gca,'Box','off');
% ax=gca;
% ax.YTick=[0 3 6];
% 
% load('D:\aston_data\control_letter_behavioural_performance_all_sets_160719_B6_aston_100trials.mat')
% subplot(1,2,2);
% edges=0:0.1:1;
% setNos=[1:7 9:13];
% numSets=length(setNos);
% for setInd=1:numSets
%     meanPerfAllSets(setInd)=mean(allSetsPerfVisualBin(setInd,:));
% end
% h1=histogram(meanPerfAllSets,edges);
% h1(1).FaceColor = [0 0 1];
% h1(1).EdgeColor = [0 0 0];
% hold on
% yLim=get(gca,'ylim');
% plot([0.5 0.5],[0 yLim(2)+1],'k:');
% xlim([0 1]);
% % ylim([0 10]);
% set(gca,'Box','off');
% ax=gca;
% ax.YTick=[0 2 4];
% 
% pathname=['D:\data\control_letter_behavioural_performance_all_sets_',date,'_',num2str(initialPerfTrials),'trials'];
% set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff');
