function analyse_microstim_2phosphene_RFs_across_sessions_aston(date)
%23/11/18
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual line orientation task, for 2 phosphenes, as well
%as distance of separation between pair of electrodes on the cortex. 
%Converts RF locations into cortical coordinates, using function 
%calculate_cortical_coords_from_RFs.m.
%Output is saved in .mat file, 040118_2phosphene_cortical_coords_perf.mat,
%which is combined with 220118_2phosphene_cortical_coords_perf.mat
%and further processed by the function
%analyse_2phosphene_correlation_cortical_distance.m. 
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
setNos=1:12;

for calculateVisual=[0 1]
    allSetsPerfMicro=[];
    allSetsPerfVisual=[];
    for setNo=setNos
        perfNEV=[];
        timeInd=[];
        encodeInd=[];
        microstimTrialNEV=[];
        allLRorTB=[];
        allTargetLocation=[];
        corr=[];
        incorr=[];
        localDisk=0;
        if calculateVisual==0
            %microstim task:
            switch(setNo)
                case 1
                    date='151118_B6_aston';
                    setElectrodes=[22 12 55 16];%TB task
                    setArrays=[8 14 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=18;
                    visualOnly=0;
                case 2
                    date='161118_B7_aston';
                    setElectrodes=[29 9 60 64];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=0;
                case 3
                    date='191118_B7_aston';
                    setElectrodes=[3 35 61 57];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=0;
                case 4
                    date='211118_B5_aston';
                    setElectrodes=[1 50 43 59];%
                    setArrays=[13 14 16 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 5
                    date='211118_B6_aston';
                    setElectrodes=[25 59 56 57];%
                    setArrays=[13 14 16 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 6
                    date='211118_B7_aston';
                    setElectrodes=[33 21 48 63];%
                    setArrays=[13 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                case 7
                    date='221118_B11_aston';
                    setElectrodes=[3 57 50 63];%
                    setArrays=[13 13 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 8
                    date='221118_B12_aston';
                    setElectrodes=[10 63 16 57];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 9
                    date='221118_B13_aston';
                    setElectrodes=[1 57 9 58];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                case 10
                    date='231118_B6_aston';
                    setElectrodes=[6 49 59 36];%
                    setArrays=[12 11 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=0;
                case 11
                    date='231118_B11_aston';
                    setElectrodes=[36 60 53 9];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=0;
                    localDisk=0;
                case 12
                    date='261118_B14_aston';
                    setElectrodes=[9 59 60 41];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=0;
                    localDisk=0;
                case 13
                    date='';
                case 14
                    date='';
                case 15
                    date='';
                case 16
                    date='';
                case 17
                    date='';
                case 18
                    date='';
                case 19
                    date='';
                case 20
                    date='';
                case 21
                    date='';
                case 22
                    date='';
                case 23
                    date='';
                case 24
                    date='';
                case 25
                    date='';
                case 26
                    date='';
                case 27
                    date='';
                case 28
                    date='';
                case 29
                    date='';
                case 30
                    date='';
                case 31
                    date='';
                case 32
                    date='';
                case 33
                    date='';
                case 34
                    date='';
                case 35
                    date='';
                case 36
                    date='';
                case 37
                    date='';
                case 38
                    date='';
                case 39
                    date='';
                case 40
                    date='';
                case 41
                    date='';
                case 42
                    date='';
                case 43
                    date='';
                case 44
                    date='';
                case 45
                    date='';
                case 46
                    date='';
            end 
            %visual task only:
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='151118_B4_aston';
                    setElectrodes=[22 12 55 16];%TB task
                    setArrays=[8 14 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=18;
                    visualOnly=1;
                case 2
                    date='161118_B4_aston';
                    setElectrodes=[29 9 60 64];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=1;
                case 3
                    date='191118_B5_aston';
                    setElectrodes=[3 35 61 57];%
                    setArrays=[8 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=1;
                case 4
                    date='211118_B3_aston';
                    setElectrodes=[1 50 43 59];%
                    setArrays=[13 14 16 14];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                case 5
                    date='211118_B9_aston';
                    setElectrodes=[25 59 56 57];%
                    setArrays=[13 14 16 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                case 6
                    date='211118_B10_aston';
                    setElectrodes=[33 21 48 63];%
                    setArrays=[13 14 16 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                case 7
                    date='221118_B5_aston';
                    setElectrodes=[3 57 50 63];%
                    setArrays=[13 13 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 8
                    date='221118_B10_aston';
                    setElectrodes=[10 63 16 57];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 9
                    date='221118_B14_aston';
                    setElectrodes=[1 57 9 58];%
                    setArrays=[13 11 14 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                case 10
                    date='231118_B5_aston';
                    setElectrodes=[6 49 59 36];%
                    setArrays=[12 11 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=1;
                    localDisk=0;
                case 11
                    date='231118_B10_aston';
                    setElectrodes=[36 60 53 9];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=1;
                    localDisk=0;
                case 12
                    date='261118_B13_aston';
                    setElectrodes=[9 59 60 41];%
                    setArrays=[13 11 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=1;
                    localDisk=0;
            end
        end
        
        if localDisk==1
            rootdir='D:\aston_data\';
        elseif localDisk==0
            rootdir='X:\aston\';
        end
        matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
        dataDir=[rootdir,date,'\',date,'_data'];
        load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
        if ~exist('matFile','file')
            copyfile([rootdir,date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
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
                        if setNo<=0
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
                            if find(trialEncodes==2^CorrectB)
                                perfNEV(trialNo)=1;
                            elseif find(trialEncodes==2^ErrorB)
                                perfNEV(trialNo)=-1;
                            end
                            if strcmp(date,'231017_B45')
                                if length(find(trialEncodes==2^MicroB))==3
                                    microstimTrialNEV(trialNo)=1;
                                end
                                if length(find(trialEncodes==2^MicroB))==2
                                    microstimTrialNEV(trialNo)=1;
                                else
                                    microstimTrialNEV(trialNo)=0;
                                end
                            else
                                microstimTrialNEV=allCurrentLevel>0;
                            end
                        elseif setNo>0
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
                            if find(trialEncodes==2^CorrectB)
                                perfNEV(trialNo)=1;
                            elseif find(trialEncodes==2^ErrorB)
                                perfNEV(trialNo)=-1;
                            end
                            for trialCurrentLevelInd=1:length(allCurrentLevel)
                                if sum(allCurrentLevel{trialCurrentLevelInd})>0
                                    microstimTrialNEV(trialCurrentLevelInd)=1;
                                else
                                    microstimTrialNEV(trialCurrentLevelInd)=0;
                                end
                            end
                        end
                        %analyse individual conditions:
                        if length(allElectrodeNum)>=trialNo
                            electrode=allElectrodeNum{trialNo}(1);
                            array=allArrayNum{trialNo}(1);
                            electrode2=allElectrodeNum{trialNo}(2);
                            array2=allArrayNum{trialNo}(2);
                            electrodeMatch=find(cell2mat(setElectrodes)==electrode);
                            arrayMatch=find(cell2mat(setArrays)==array);
                            matchingCh=intersect(electrodeMatch,arrayMatch);%one electrode of a pair
                            electrodeMatch2=find(cell2mat(setElectrodes)==electrode2);
                            arrayMatch2=find(cell2mat(setArrays)==array2);
                            matchingCh2=intersect(electrodeMatch2,arrayMatch2);%the other electrode of a pair
                            if isequal(sort([matchingCh matchingCh2]),[1 2])
                                LRorTB=2;
                                targetLocation=1;
                            elseif isequal(sort([matchingCh matchingCh2]),[3 4])
                                LRorTB=2;
                                targetLocation=2;
                            elseif isequal(sort([matchingCh matchingCh2]),[1 4])
                                LRorTB=1;
                                targetLocation=1;
                            elseif isequal(sort([matchingCh matchingCh2]),[2 4])
                                LRorTB=1;
                                targetLocation=2;
                            end
                            allLRorTB(trialNo)=LRorTB;
                            allTargetLocation(trialNo)=targetLocation;
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
                %further divide trials by target location:
                targetLocation1TrialsInd=find(allTargetLocation==1);
                targetLocation2TrialsInd=find(allTargetLocation==2);
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
                %divide trials by target location and calculate the distance between electrodes
                correctMicrostimTrialsStimCondTarget1=intersect(correctMicrostimTrialsInd,targetLocation1TrialsInd);
                correctMicrostimTrialsStimCondTarget2=intersect(correctMicrostimTrialsInd,targetLocation2TrialsInd);
                incorrectMicrostimTrialsStimCondTarget1=intersect(incorrectMicrostimTrialsInd,targetLocation1TrialsInd);
                incorrectMicrostimTrialsStimCondTarget2=intersect(incorrectMicrostimTrialsInd,targetLocation2TrialsInd);
                meanPerfMicrostimCondTarget{setNo}(1,1)=length(correctMicrostimTrialsStimCondTarget1)/(length(correctMicrostimTrialsStimCondTarget1)+length(incorrectMicrostimTrialsStimCondTarget1));%mean performance for that condition
                numTrialsCondMicrostimTarget{setNo}(1,1)=length(correctMicrostimTrialsStimCondTarget1)+length(incorrectMicrostimTrialsStimCondTarget1);%tally number of trials present for each condition
                meanPerfMicrostimCondTarget{setNo}(1,2)=length(correctMicrostimTrialsStimCondTarget2)/(length(correctMicrostimTrialsStimCondTarget2)+length(incorrectMicrostimTrialsStimCondTarget2));%mean performance for that condition
                numTrialsCondMicrostimTarget{setNo}(1,2)=length(correctMicrostimTrialsStimCondTarget2)+length(incorrectMicrostimTrialsStimCondTarget2);%tally number of trials present for each condition
                for targetCondInd=1:2
                    if targetCondInd==1
                        electrodeTemp=setElectrodes{3};%horizontal orientation
                        arrayTemp=setArrays{3};
                    elseif targetCondInd==2
                        electrodeTemp=setElectrodes{4};%vertical orientation
                        arrayTemp=setArrays{4};
                    end
                    electrodeInd=[];
                    arrayInd=[];
                    for electrodeSequence=1:length(electrodeTemp)
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrodeTemp(electrodeSequence));%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==arrayTemp(electrodeSequence));%matching array number
                        electrodeInd(electrodeSequence)=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        arrayInd(electrodeSequence)=find(arrays==arrayTemp(electrodeSequence));
                        instance(electrodeSequence)=ceil(arrayTemp(electrodeSequence)/2);
                        %                             load([dataDir,'\array',num2str(arrayTemp(electrodeSequence)),'.mat']);
                        %                             eval(['arrayRFs=array',num2str(arrayTemp(electrodeSequence)),';']);
                        RFx=goodArrays8to16(electrodeInd(electrodeSequence),1);
                        RFy=goodArrays8to16(electrodeInd(electrodeSequence),2);
                        w(electrodeSequence)=calculate_cortical_coords_from_RFs([RFx RFy]);
                        %this function returns the cortical distance in
                        %mm, for the x- and y-axes, in the variable
                        %'w,' with the x and y values contained in the
                        %real and imaginary parts of w, respectively
                        eccentricity(electrodeSequence)=sqrt(RFx^2+RFy^2);
                    end
                    corticalDistance{setNo}(targetCondInd)=sqrt((real(w(1))-real(w(2)))^2+(imag(w(1))-imag(w(2)))^2);
                    eccentricities{setNo}(targetCondInd)=mean(eccentricity);
                    dvaEccentricities{setNo}(targetCondInd)=mean(eccentricity)/26;%approximately 26 pixels per degree
                end
                initialPerfTrials=10;%first set of trials are the most important
                if calculateVisual==0
                    if sum(cell2mat(numTrialsCondMicrostimTarget)>=initialPerfTrials)==length(cell2mat(numTrialsCondMicrostimTarget))%if each condition has minimum number of trials present
                        allSetsPerfMicro=[allSetsPerfMicro;meanPerfMicrostimCondTarget{setNo}];
                        save(['D:\aston_data\microPerf_',date,'.mat'],'allSetsPerfMicro');
                    end
                elseif calculateVisual==1
                    if sum(cell2mat(numTrialsCondVisualTarget)>=initialPerfTrials)==length(cell2mat(numTrialsCondVisualTarget))%if each condition has minimum number of trials present
                        allSetsPerfVisual=[allSetsPerfVisual;meanPerfVisualCond{setNo}];
                        save(['D:\aston_data\visualPerf_',date,'.mat'],'allSetsPerfVisual');
                    end
                end
            end
        end
    end
    if calculateVisual==0
        %cortical distance between electrodes:
        figure;
        hold on
        for setNo=setNos
            for targetCondInd=1:2
                plot(corticalDistance{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
            end
        end
        %only include sets where a certain minimum number of trials was
        %presented:
        figure;
        hold on
        for setNo=setNos
            for targetCondInd=1:2
                if numTrialsCondMicrostimTarget{setNo}(targetCondInd)>=initialPerfTrials
                    plot(corticalDistance{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
                end
            end
        end
        xlabel('cortical distance between electrode pair (mm)');
        ylabel('performance (proportion correct)');
        title('performance with cortical distance for 2-phosphene task');
        
        %eccentricity:
        figure;
        hold on
        for setNo=setNos
            for targetCondInd=1:2
                plot(dvaEccentricities{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
            end
        end
        %only include sets where a certain minimum number of trials was
        %presented:
        figure;
        hold on
        for setNo=setNos
            for targetCondInd=1:2
                if numTrialsCondMicrostimTarget{setNo}(targetCondInd)>=initialPerfTrials
                    plot(dvaEccentricities{setNo}(targetCondInd),meanPerfMicrostimCondTarget{setNo}(targetCondInd),'ko');
                end
            end
        end
        xlabel('mean eccentricity');
        ylabel('performance (proportion correct)');
        title('performance with eccentricity for 2-phosphene task');

        save('D:\aston_data\261118_2phosphene_cortical_coords_perf.mat','corticalDistance','numTrialsCondMicrostimTarget','meanPerfMicrostimCondTarget','eccentricities');
    end
    if calculateVisual==1
        subplot(1,2,2);
        hold on
        meanAllSetsPerfVisual=mean(allSetsPerfVisual,1);
        b=bar(meanAllSetsPerfVisual,'FaceColor','flat');
        b(1).FaceColor = 'flat';
        if visualOnly==0
            b(1).FaceColor = [1 0 0];
        elseif visualOnly==1
            b(1).FaceColor = [0 0.4470 0.7410];
        end
        set(gca, 'XTick',1:12)
        set(gca, 'XTickLabel',1:12)
        xLimits=get(gca,'xlim');
        if visualOnly==1
            colText='b';
        elseif visualOnly==0
            colText='r';
        end
        for stimPatternInd=1:12
            if ~isnan(meanPerfVisualCond(stimPatternInd))
                txt=sprintf('%.2f',meanAllSetsPerfVisual(stimPatternInd));
                text(stimPatternInd-0.25,0.95,txt,'Color',colText)
            end
        end
        ylim([0 1])
        hold on
        plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
        xlim([0 13])
        title('mean performance, visual (blue) trials');
        xlabel('target condition');
        ylabel('average performance across session');
    end
end
title(['performance across the session, on visual (blue) & microstim (red) trials']);
pathname=['D:\aston_data\behavioural_performance_first_sets_261118_',num2str(initialPerfTrials),'trials__12patterns'];
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff');

perfMat=['D:\aston_data\behavioural_performance_first_sets_261118_',num2str(initialPerfTrials),'trials_12patterns.mat'];
save(perfMat,'meanAllSetsPerfVisual','meanAllSetsPerfMicro');
pause=1;

significantByThisTrialMicro=0;
for trialInd=1:length(meanAllSetsPerfMicro)
    x=sum(meanAllSetsPerfMicroBin(1:trialInd))*size(allSetsPerfMicro,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfMicro,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialMicro(trialInd)=1;
    end
end
significantByThisTrialMicro

significantByThisTrialVisual=0;
for trialInd=1:length(meanAllSetsPerfVisual)
    x=sum(meanAllSetsPerfVisualBin(1:trialInd))*size(allSetsPerfVisual,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfVisual,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialVisual(trialInd)=1;
    end
end
significantByThisTrialVisual