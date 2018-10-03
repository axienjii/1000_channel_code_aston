function analyse_microstim_attention(date,allInstanceInd,analyseEyeData)
%16/7/18
%Written by Xing, modified from analyse_microstim_letter.m, calculates behavioural performance during a
%microstimulation/visual attention task, in which monkey atends to one visual hemifield or the other.
%StimB encodes distractor onset, whlie TargetB encodes target onset.

interleaved=0;%set interleaved to 0, if trigger pulse was sent using microB. set interleaved to 1, if stimulation was sent by calling stimulator.play function
drummingOn=0;%for sessions after 9/4/18, drumming with only 2 targets was used 
localDisk=1;
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

trialsDesired=100;
trialsDesiredInitialBlock=20;

analyseConds=1;
if analyseConds==1
    switch(date)
        %microstim task only:
        case '130718_B1'
            setElectrodes=34;%0118_B & B?
            setArrays=11;
            setInd=[];
            numTargets=[];
            electrodePairs=[];
            currentThresholdChs=133;
            visualOnly=1;  
            syncPulseCh=136;%analog input 8, records sync pulse from array 11
            syncPulseThreshold=1000;
        case '130718_B3'
            setElectrodes=34;%0118_B & B?
            setArrays=11;
            setInd=[];
            numTargets=[];
            electrodePairs=[];
            currentThresholdChs=133;
            visualOnly=1;  
            syncPulseCh=136;%analog input 8, records sync pulse from array 11
            syncPulseThreshold=1000;
        case '240718_B13'
            setElectrodes=20;%0118_B & B?
            setArrays=16;
            setInd=[];
            numTargets=[];
            electrodePairs=[];
            currentThresholdChs=134;
            visualOnly=1;  
            syncPulseCh=141;%analog input 8, records sync pulse from array 16   
            syncPulseThreshold=24000;    
        case '310718_B1'
            setElectrodes=20;%0118_B & B?
            setArrays=16;
            setInd=[];
            numTargets=[];
            electrodePairs=[];
            currentThresholdChs=134;
            visualOnly=1;  
            syncPulseCh=141;%analog input 8, records sync pulse from array 16   
            syncPulseThreshold=1000;  
        case '290818_B1'
            setElectrodes=20;%0118_B & B?
            setArrays=16;
            setInd=[];
            numTargets=[];
            electrodePairs=[];
            currentThresholdChs=134;
            visualOnly=1;  
            syncPulseCh=141;%analog input 8, records sync pulse from array 16   
            syncPulseThreshold=1000;       

        %visual task only:
    end
end
load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);

processRaw=1;
if processRaw==1
    for instanceCount=1:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=[rootdir,date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        
        %read in eye data:
        recordedRaw=1;
        if recordedRaw==0%7/9/17
            eyeChannels=[1 2];
        elseif recordedRaw==1%11/9/17
            eyeChannels=[130 131];
        end
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
        eyeDataMat=['D:\data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
        if exist(eyeDataMat,'file')
            load(eyeDataMat,'NSch');
        else
            if recordedRaw==0
                NSchOriginal=openNSx(instanceNS6FileName);
                for channelInd=1:length(eyeChannels)
                    NSch{channelInd}=NSchOriginal.Data(channelInd,:);
                end
            elseif recordedRaw==1
                for channelInd=1:length(eyeChannels)
                    readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
                    NSchOriginal=openNSx(instanceNS6FileName,readChannel);
                    NSch{channelInd}=NSchOriginal.Data;
                end
            end
            save(eyeDataMat,'NSch');
        end
        
        %identify trials using encodes sent via serial port:
        trialNo=1;
        breakHere=0;
        distractorOns=[];
        targetOns=[];
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
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                elseif find(trialEncodes==2^ErrorB)
                    perfNEV(trialNo)=-1;
                end
                if length(find(trialEncodes==2^TargetB))>=1%target (onset of microstim during attend-microstim condition; onset of visual stimulus during attend-visual condition)
                    indTarget=find(trialEncodes==2^TargetB);
                    if length(find(trialEncodes==2^TargetB))>1
                        pauseHere=1;
                        if trialNo>1
                            targetOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+indTarget(1)-1);%timestamp corresponding to encode for target onset
                        else
                            targetOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(indTarget(1));
                        end
                    else
                        if trialNo>1
                            targetOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+find(trialEncodes==2^TargetB)-1);%timestamp corresponding to encode for target onset
                        else
                            targetOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(find(trialEncodes==2^TargetB));
                        end
                    end
                else
                    targetOns(trialNo)=NaN;
                end
                if length(find(trialEncodes==2^StimB))>=1%distractor (onset of microstim during attend-visual condition; onset of visual stimulus during attend-microstim condition)
                    indStim=find(trialEncodes==2^StimB);                    
                    if length(find(trialEncodes==2^StimB))>1%distractor (onset of microstim during attend-visual condition; onset of visual stimulus during attend-microstim condition)
                        pauseHere=1;
                        if trialNo>1
                            distractorOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+indStim(1)-1);%timestamp corresponding to encode for distractor onset
                        else
                            distractorOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(indStim(1));
                        end
                    end
                    if trialNo>1                        
                        distractorOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+find(trialEncodes==2^StimB)-1);%timestamp corresponding to encode for distractor onset
                    else
                        distractorOns(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(find(trialEncodes==2^StimB));
                    end
                else
                    distractorOns(trialNo)=NaN;
                end
                trialNo=trialNo+1;
            end
        end
        %1832031
        visualTarget=find(allAttentionCond==1);%attend left
        microTarget=find(allAttentionCond==0);%attend right
        distractorFirst=find(allDistractTrials==1);%distractor presented in the first interval, target in second
        targetFirst=find(allDistractTrials==0);%target presented in the first interval, distractor in second
        
        %analyse V4 activity that is evoked during microstimulation in
        %V1:
        attendMicroTrialsIndFirst=intersect(microTarget,targetFirst);%analyse first interval
        attendMicroTrialsIndSecond=intersect(microTarget,distractorFirst);%analyse second interval
        
        attendVisualTrialsIndSecond=intersect(visualTarget,targetFirst);%analyse second interval
        attendVisualTrialsIndFirst=intersect(visualTarget,distractorFirst);%analyse first interval
        
        correctTrialsInd=find(performance==1);
        %identify trials where incorrect response made, and hence drumming
        %imposed on trial immediately following this one:
        incorrectTrialsInd=find(performance==-1);
        responseTrialsInd=sort([correctTrialsInd incorrectTrialsInd]);
        
        %identify trials which are not part of the first 20 distractor-free
        %trials in a block:
        maxNumBlocks=max(allBlockNo);
        goodBlocks=[];
        for blockInd=1:maxNumBlocks
            if length(find(allBlockNo==blockInd))>1
                goodBlocks=[goodBlocks blockInd];
            end
        end
        for blockInd=1:length(goodBlocks)
            goodBlockInd=goodBlocks(blockInd);
            blockTrialsInd=find(allBlockNo==goodBlockInd);
            responseBlockInd=intersect(responseTrialsInd,blockTrialsInd);%trials were behavioural response made, for a given block
            
            goodCurrentLevel=mode(allCurrentLevel);
            goodCurrentLevelTrials=find(allCurrentLevel==goodCurrentLevel);%exclude trials where a different current level was used
            nonDrummingTrials=find(allDrummingTrials==0);%exclude trials where drumming was used
            
            attendMicroResponseBlockInd{blockInd}=intersect(responseBlockInd,microTarget);%attend-microstim condition during that block, where behavioural response was made
            attendMicroResponseBlockInd{blockInd}=intersect(attendMicroResponseBlockInd{blockInd},goodCurrentLevelTrials);%attend-microstim condition during that block, where behavioural response was made
            attendMicroResponseBlockInd{blockInd}=intersect(attendMicroResponseBlockInd{blockInd},nonDrummingTrials);%attend-microstim condition during that block, where behavioural response was made
            correctIndCondM=intersect(correctTrialsInd,attendMicroResponseBlockInd{blockInd});
            if length(correctIndCondM)>trialsDesiredInitialBlock%exclude first 20 distractor-free trials (and incorrect trials), and identify trial number 21
                firstNotInitialTrialM=correctIndCondM(trialsDesiredInitialBlock+1);
            end
            notInitialTrialIndM=find(attendMicroResponseBlockInd{blockInd}==firstNotInitialTrialM);
            notInitialTrialsM{blockInd}=attendMicroResponseBlockInd{blockInd}(notInitialTrialIndM:end);%all trials after the first distractor-free trials (i.e. 50% chance of distractor appearing)
            notInitialTrialsCorrectM{blockInd}=intersect(notInitialTrialsM{blockInd},correctIndCondM);%only correct trials after the first distractor-free trials
            
            attendVisualResponseBlockInd{blockInd}=intersect(responseBlockInd,visualTarget);%attend-visual condition during that block, where behavioural response was made
            attendVisualResponseBlockInd{blockInd}=intersect(attendVisualResponseBlockInd{blockInd},goodCurrentLevelTrials);%attend-visual condition during that block, where behavioural response was made
            attendVisualResponseBlockInd{blockInd}=intersect(attendVisualResponseBlockInd{blockInd},nonDrummingTrials);%attend-visual condition during that block, where behavioural response was made
            correctIndCondV=intersect(correctTrialsInd,attendVisualResponseBlockInd{blockInd});
            if length(correctIndCondV)>trialsDesiredInitialBlock%exclude first 20 distractor-free trials (and incorrect trials), and identify trial number 21
                firstNotInitialTrialV=correctIndCondV(trialsDesiredInitialBlock+1);
            end
            notInitialTrialIndV=find(attendVisualResponseBlockInd{blockInd}==firstNotInitialTrialV);
            notInitialTrialsV{blockInd}=attendVisualResponseBlockInd{blockInd}(notInitialTrialIndV:end);%all trials after the first distractor-free trials (i.e. 50% chance of distractor appearing)
            notInitialTrialsCorrectV{blockInd}=intersect(notInitialTrialsV{blockInd},correctIndCondV);%only correct trials after the first distractor-free trials
            
            attendMicroFirstNotInitial{blockInd}=intersect(attendMicroTrialsIndFirst,notInitialTrialsM{blockInd});%attend-micro, analyse V4 activity in first stimulus interval, exclude initial distractor-free trials
            attendMicroSecondNotInitial{blockInd}=intersect(attendMicroTrialsIndSecond,notInitialTrialsM{blockInd});%attend-micro, analyse V4 activity in second stimulus interval, exclude initial distractor-free trials
            attendMicroFirstNotInitialC{blockInd}=intersect(attendMicroTrialsIndFirst,notInitialTrialsCorrectM{blockInd});%attend-micro, analyse V4 activity in first stimulus interval, exclude initial distractor-free trials, and exclude incorrect trials
            attendMicroSecondNotInitialC{blockInd}=intersect(attendMicroTrialsIndSecond,notInitialTrialsCorrectM{blockInd});%attend-micro, analyse V4 activity in second stimulus interval, exclude initial distractor-free trials, and exclude incorrect trials
        
            attendVisualFirstNotInitial{blockInd}=intersect(attendVisualTrialsIndFirst,notInitialTrialsV{blockInd});%attend-visual, analyse V4 activity in first stimulus interval, exclude initial distractor-free trials
            attendVisualSecondNotInitial{blockInd}=intersect(attendVisualTrialsIndSecond,notInitialTrialsV{blockInd});%attend-visual, analyse V4 activity in second stimulus interval, exclude initial distractor-free trials
            attendVisualFirstNotInitialC{blockInd}=intersect(attendVisualTrialsIndFirst,notInitialTrialsCorrectV{blockInd});%attend-visual, analyse V4 activity in first stimulus interval, exclude initial distractor-free trials, and exclude incorrect trials
            attendVisualSecondNotInitialC{blockInd}=intersect(attendVisualTrialsIndSecond,notInitialTrialsCorrectV{blockInd});%attend-visual, analyse V4 activity in second stimulus interval, exclude initial distractor-free trials, and exclude incorrect trials
        end
        
        matFileName=fullfile(rootdir,date,[instanceName,'_trialInfo.mat']);
        save(matFileName,'targetOns','distractorOns','visualTarget','microTarget','distractorFirst','targetFirst','attendMicroTrialsIndFirst','attendMicroTrialsIndSecond','attendVisualTrialsIndFirst','attendVisualTrialsIndSecond','correctTrialsInd','incorrectTrialsInd','responseTrialsInd','attendMicroResponseBlockInd','notInitialTrialsM','notInitialTrialsCorrectM','attendVisualResponseBlockInd','notInitialTrialsV','notInitialTrialsCorrectV','attendMicroFirstNotInitial','attendMicroSecondNotInitial','attendMicroFirstNotInitialC','attendMicroSecondNotInitialC','attendVisualFirstNotInitial' ,'attendVisualSecondNotInitial' ,'attendVisualFirstNotInitialC','attendVisualSecondNotInitialC');
        
        %detect periods of stimulation using sync pulse:
        syncPulseMat=[rootdir,date,'\instance1_NSch_sync_pulse.mat'];%always recorded on instance 1
        if exist(syncPulseMat,'file')
            load(syncPulseMat,'NSchSync');
        else
            if recordedRaw==1
                readChannel=['c:',num2str(syncPulseCh),':',num2str(syncPulseCh)];
                NSchOriginalSync=openNSx(instanceNS6FileName,readChannel);
                NSchSync=NSchOriginalSync.Data;
            end
            save(syncPulseMat,'NSchSync');
        end
        if ~strcmp(instanceName,'instance1')%if data being analysed is not from instance 1, then have to align sync pulse data to this instance
            targetOnsOriginal=targetOns;
            matFileName=fullfile(rootdir,date,'instance1_trialInfo.mat');
            load(matFileName,'targetOns');
            timeDiffInstances=targetOnsOriginal-targetOns;%temporal offset between instances
            timeDiffInstances(isnan(timeDiffInstances))=[];
            uniqueTimeDiff=mode(timeDiffInstances);
            targetOns=targetOnsOriginal;
%             for tempInd=1:length(uniqueTimeDiff)
%                 temp=find(timeDiffInstances==uniqueTimeDiff(tempInd));
%                 length(temp)
%             end
        end
        belowThresholdInd=find(NSchSync<syncPulseThreshold);
        aboveThresholdInd=find(NSchSync>=syncPulseThreshold);
        binaryNSchSync=NSchSync;
        binaryNSchSync(belowThresholdInd)=0;
        binaryNSchSync(aboveThresholdInd)=1;
        diffBinaryNSchSync=diff(binaryNSchSync);
        thresholdCrossingsOn=find(diffBinaryNSchSync>0);%onset of microstimulation train
        thresholdCrossingsOff=find(diffBinaryNSchSync<0);%offset of microstimulation train
        if ~strcmp(instanceName,'instance1')%if data being analysed is not from instance 1, then have to align sync pulse data to this instance
            thresholdCrossingsOn=thresholdCrossingsOn+uniqueTimeDiff;
            thresholdCrossingsOff=thresholdCrossingsOff+uniqueTimeDiff;
        end
        %read in neuronal data, only for V4:
        if instanceInd==1
            neuronalChsV4=33:96;
            if strcmp(date,'130718_B1')||strcmp(date,'240718_B13')||strcmp(date,'310718_B1')
                neuronalChsV4=33:96;
            elseif strcmp(date,'130718_B3')
                neuronalChsV4=33:96;
            end
        elseif instanceInd==2
            neuronalChsV4=[1:32 97:128];
        end
%         analyseEyeData=0;%extract eye channel data, from instance 1
        if analyseEyeData==1&&instanceInd==1
            neuronalChsV4=eyeChannels;
            load(eyeDataMat,'NSch');
            NSchOriginal=NSch;
        end
        for neuronalChInd=1:length(neuronalChsV4)%analog input 8, records sync pulse from array 11
            if analyseEyeData==1&&instanceInd==1
                neuronalCh=eyeChannels(neuronalChInd);
                NSch=NSchOriginal{neuronalChInd};
            else
                neuronalCh=neuronalChsV4(neuronalChInd);
                neuronalMat=[rootdir,date,'\',instanceName,'_NSch',num2str(neuronalCh),'.mat'];
                if exist(neuronalMat,'file')
                    load(neuronalMat,'NSch');
                else
                    if recordedRaw==1
                        readChannel=['c:',num2str(neuronalCh),':',num2str(neuronalCh)];
                        NSchOriginal=openNSx(instanceNS6FileName,readChannel);
                        NSch=NSchOriginal.Data;
                    end
                    save(neuronalMat,'NSch');
                end
            end
            for blockInd=1:length(goodBlocks)
                for includeIncorrect=1:2%1: include all trials; 2: exclude incorrect trials
                    if includeIncorrect==1
                        subFolderName='all_trials';
                    elseif includeIncorrect==2%exclude incorrect trials
                        subFolderName='correct_trials';
                    end
                    subFolderPath=fullfile(rootdir,date,subFolderName);
                    if ~exist('subFolderPath','dir')
                        mkdir(subFolderPath);
                    end
                    alignRawChFileName=fullfile(rootdir,date,subFolderName,['alignedRawCh',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
%                     if exist(alignRawChFileName,'file')
%                         load(alignRawChFileName);
%                     else
                    AMF=[];%attend-micro, microstim occurs in first interval
                    AVF=[];%attend-visual, microstim occurs in first interval
                    AMS=[];%attend-micro, microstim occurs in second interval
                    AVS=[];%attend-visual, microstim occurs in second interval
                    %             blockInd=3;%for session 130718_B1, only 1 block
                    if includeIncorrect==1
                        attendMicroFirstNotInitialTargetTS=targetOns(attendMicroFirstNotInitial{blockInd});%get time stamps of target onset for trials during attend-micro block, excluding initial distractor-free trials, when microstim is in first interval
                        attendVisualFirstNotInitialDistractorTS=distractorOns(attendVisualFirstNotInitial{blockInd});%get time stamps of distractor onset for trials during attend-visual block, excluding initial distractor-free trials, when microstim is in first interval
                        
                        attendMicroSecondNotInitialTargetTS=targetOns(attendMicroSecondNotInitial{blockInd});%get time stamps of target onset for trials during attend-micro block, excluding initial distractor-free trials, when microstim is in second interval
                        attendVisualSecondNotInitialDistractorTS=distractorOns(attendVisualSecondNotInitial{blockInd});%get time stamps of distractor onset for trials during attend-visual block, excluding initial distractor-free trials, when microstim is in second interval
                    elseif includeIncorrect==2%exclude incorrect trials
                        attendMicroFirstNotInitialTargetTS=targetOns(attendMicroFirstNotInitialC{blockInd});%get time stamps of target onset for trials during attend-micro block, excluding initial distractor-free trials, when microstim is in first interval
                        attendVisualFirstNotInitialDistractorTS=distractorOns(attendVisualFirstNotInitialC{blockInd});%get time stamps of distractor onset for trials during attend-visual block, excluding initial distractor-free trials, when microstim is in first interval
                        
                        attendMicroSecondNotInitialTargetTS=targetOns(attendMicroSecondNotInitialC{blockInd});%get time stamps of target onset for trials during attend-micro block, excluding initial distractor-free trials, when microstim is in second interval
                        attendVisualSecondNotInitialDistractorTS=distractorOns(attendVisualSecondNotInitialC{blockInd});%get time stamps of distractor onset for trials during attend-visual block, excluding initial distractor-free trials, when microstim is in second interval
                    end
                    %identify nearest threshold crossing to event of interest:
                    eventOfInterest=attendMicroFirstNotInitialTargetTS;
                    [onCrossingIndTS_AMF offCrossingIndTS_AMF]=readThresholdCrossings(eventOfInterest,thresholdCrossingsOn,thresholdCrossingsOff);%attend-micro condition, microstim occurs in first interval
                    eventOfInterest=attendVisualFirstNotInitialDistractorTS;
                    [onCrossingIndTS_AVF offCrossingIndTS_AVF]=readThresholdCrossings(eventOfInterest,thresholdCrossingsOn,thresholdCrossingsOff);%attend-visual condition, microstim occurs in first interval
                    
                    eventOfInterest=attendMicroSecondNotInitialTargetTS;
                    [onCrossingIndTS_AMS offCrossingIndTS_AMS]=readThresholdCrossings(eventOfInterest,thresholdCrossingsOn,thresholdCrossingsOff);%attend-micro condition, microstim occurs in second interval
                    eventOfInterest=attendVisualSecondNotInitialDistractorTS;
                    [onCrossingIndTS_AVS offCrossingIndTS_AVS]=readThresholdCrossings(eventOfInterest,thresholdCrossingsOn,thresholdCrossingsOff);%attend-visual condition, microstim occurs in second interval
                    
                    for trialInd=1:length(onCrossingIndTS_AMF)
                        if onCrossingIndTS_AMF(trialInd)~=0
                            AMF(trialInd,:)=NSch(onCrossingIndTS_AMF(trialInd)-preStimDur*sampFreq:onCrossingIndTS_AMF(trialInd)-preStimDur*sampFreq+25989);
%                             AMF(trialInd,:)=NSch(onCrossingIndTS_AMF(trialInd):onCrossingIndTS_AMF(trialInd)-preStimDur*sampFreq+25989);
                            syncCheck(trialInd,:)=NSchSync(onCrossingIndTS_AMF(trialInd)-preStimDur*sampFreq:onCrossingIndTS_AMF(trialInd)-preStimDur*sampFreq+25989);
%                             syncCheck(trialInd,:)=NSchSync(onCrossingIndTS_AMF(trialInd):onCrossingIndTS_AMF(trialInd)-preStimDur*sampFreq+25989);
                            %                     AMF(trialInd,:,neuronalCh)=NSch(onCrossingIndTS_AMF(trialInd)-preStimDur*sampFreq:offCrossingIndTS_AMF(trialInd)+postStimDur*sampFreq);
                        end
                    end
%                     figure;
%                     plot(AMF(1,:));hold on;plot(syncCheck(1,:));
%                     ax = gca;
%                     ylims=get(ax,'ylim');
%                     line([onCrossingIndTS_AMF(1) onCrossingIndTS_AMF(1)],[ylims(1) ylims(2)]);
                    for trialInd=1:length(onCrossingIndTS_AVF)
                        if onCrossingIndTS_AVF(trialInd)~=0
                            AVF(trialInd,:)=NSch(onCrossingIndTS_AVF(trialInd)-preStimDur*sampFreq:onCrossingIndTS_AVF(trialInd)-preStimDur*sampFreq+25989);
                            %                     AVF(trialInd,:,neuronalCh)=NSch(onCrossingIndTS_AVF(trialInd)-preStimDur*sampFreq:offCrossingIndTS_AVF(trialInd)+postStimDur*sampFreq);
                        end
                    end
                    for trialInd=1:length(onCrossingIndTS_AMS)
                        if onCrossingIndTS_AMS(trialInd)~=0
                            AMS(trialInd,:)=NSch(onCrossingIndTS_AMS(trialInd)-preStimDur*sampFreq:onCrossingIndTS_AMS(trialInd)-preStimDur*sampFreq+25989);
                            %                     AMS(trialInd,:,neuronalCh)=NSch(onCrossingIndTS_AMS(trialInd)-preStimDur*sampFreq:offCrossingIndTS_AMS(trialInd)+postStimDur*sampFreq);
                        end
                    end
                    for trialInd=1:length(onCrossingIndTS_AVS)
                        if onCrossingIndTS_AVS(trialInd)~=0
                            AVS(trialInd,:)=NSch(onCrossingIndTS_AVS(trialInd)-preStimDur*sampFreq:onCrossingIndTS_AVS(trialInd)-preStimDur*sampFreq+25989);
                            %                     AVS(trialInd,:,neuronalCh)=NSch(onCrossingIndTS_AVS(trialInd)-preStimDur*sampFreq:offCrossingIndTS_AVS(trialInd)+postStimDur*sampFreq);
                        end
                    end
                    %         figure;
                    %         plot(NSch1(onCrossingIndTS_AMF(1):offCrossingIndTS_AMF(1)))
                    %         figure;
                    %         plot(NSch1(onCrossingIndTS_AMF(1)-preStimDur*sampFreq:offCrossingIndTS_AMF(1)+postStimDur*sampFreq))
                    %         figure;
                    %         plot(NSch1(onCrossingIndTS_AMF(2):offCrossingIndTS_AMF(2)))
                    %         figure;
                    %         plot(NSch1(onCrossingIndTS_AMF(2)-preStimDur*sampFreq:offCrossingIndTS_AMF(2)+postStimDur*sampFreq))
%                 end
                    save(alignRawChFileName,'AMF','AVF','AMS','AVS');
%                     figure;hold on
%                     for trialInd=1:size(AMF,1)
%                         plot(AMF(trialInd,:));
%                     end
%                     pathname=fullfile(rootdir,date,[instanceName,'_NSch',num2str(neuronalCh),'_block',num2str(blockInd)]);
%                     set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%                     print(pathname,'-dtiff');
                    
                    %plot mean traces across trials in that block, removing
                    %trials where no stimulus was presented (in reality, this only occurs for AVS condition)
                    meanAVF=(mean(AVF(any(AVF,2),:),1));%attend-visual, deliver microstimulation in first interval
                    meanAMF=(mean(AMF(any(AMF,2),:),1));%attend-micro, deliver microstimulation in first interval
                    figure;hold on
                    plot(meanAVF);
                    plot(meanAMF);
                    title(['microstim in interval 1, red: attend-micro, N=',num2str(size(AMF(any(AMF,2),:),1)),'; blue: attend-visual, N=',num2str(size(AVF(any(AVF,2),:),1))])
                    pathname=fullfile(rootdir,date,subFolderName,[instanceName,'_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval1']);
                    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                    print(pathname,'-dtiff');
                    meanAVS=(mean(AVS(any(AVS,2),:),1));%attend-visual, deliver microstimulation in first interval
                    meanAMS=(mean(AMS(any(AMS,2),:),1));%attend-micro, deliver microstimulation in first interval
                    figure;hold on
                    plot(meanAVS);
                    plot(meanAMS);
                    title(['microstim in interval 2, red: attend-micro, N=',num2str(size(AMS(any(AMS,2),:),1)),'; blue: attend-visual, N=',num2str(size(AVS(any(AVS,2),:),1))])
                    pathname=fullfile(rootdir,date,subFolderName,[instanceName,'_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval2']);
                    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                    print(pathname,'-dtiff');
                    close all
                end
            end
        end        
    end
end
pause=1;