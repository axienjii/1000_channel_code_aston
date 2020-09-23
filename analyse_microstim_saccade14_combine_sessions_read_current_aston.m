function calcThresholdList=analyse_microstim_saccade14_combine_sessions_read_current_aston(date,allInstanceInd,calcThresholdList)
%25/5/20
%Written by Xing, modified from analyse_microstim_saccade14_letter.m, reads in
%current amplitudes, for high and medium amplitude conditions.
close all
localDisk=0;
if localDisk==1
    rootdir='D:\aston_data\';
%     copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
    copyfile([rootdir,'\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\aston\';
end
% dataDir=[rootdir,date,'\',date(1:6),'_data'];
dataDir=[rootdir,date,'\',date,'_data'];
matFile=[dataDir,'\microstim_saccade_',date,'.mat'];
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

stimDurms=500;%in ms- min 0, max 500
preStimDur=300/1000;
stimDur=stimDurms/1000;%in seconds
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;
minCrossingTime=0;
analyseVisualOnly=1;
visualOnly=1;

minCrossingTime=preStimDur-0.166;
degPerVoltXFinal=0.0026;
degPerVoltYFinal=0.0024;

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

currentAmplitudeAllTrials=[];
processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=[rootdir,date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName,'overwrite');     
        
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
                
        if exist('allVisualTrial','var')%session(s) in which visual and microstim trials are interleaved
            if analyseVisualOnly==0
                microstimTrialsInd1=find(allCurrentLevel>0);
                microstimTrialsInd2=find(allVisualTrial==0);
                microstimTrialsInd=intersect(microstimTrialsInd1,microstimTrialsInd2);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            elseif analyseVisualOnly==1%note that in this code, trials with visually presented stimuli are read into the variable 'microstimTrialsInd'
                microstimTrialsInd1=find(cell2mat(allElectrodeNum)>0);
                microstimTrialsInd2=find(allVisualTrial==1);
                microstimTrialsInd=intersect(microstimTrialsInd1,microstimTrialsInd2);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            end
        else
            if visualOnly==0
                microstimTrialsInd=find(allCurrentLevel>0);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            elseif visualOnly==1%note that in this code, trials with visually presented stimuli are read into the variable 'microstimTrialsInd'
                microstimTrialsInd=find(cell2mat(allElectrodeNum)>0);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            end            
            incorrectTrialsInd=find(performance==-1);
            incorrectMicrostimTrialsInd=intersect(microstimTrialsInd,incorrectTrialsInd);
            visualTrialsInd=find(allCurrentLevel==0);
            correctVisualTrialsInd=intersect(visualTrialsInd,correctTrialsInd);
            incorrectTrialsInd=find(performance==-1);
            incorrectVisualTrialsInd=find(allFalseAlarms==1);
            perfM=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectMicrostimTrialsInd));
            perfV=length(correctVisualTrialsInd)/(length(correctVisualTrialsInd)+length(incorrectVisualTrialsInd));

        end
        saccadeEndAllTrials=[]; 
        electrodeAllTrials=[];
        timePeakVelocityXYsAllTrials=[];
        timePeakVelocityXYSecsAllTrials=[];
        arrayAllTrials=[];
        uniqueInd=unique([cell2mat(allElectrodeNum)' cell2mat(allArrayNum)'],'rows','stable');
        rowIsNan=[];
        for rowInd=1:size(uniqueInd,1)
            if isnan(uniqueInd(rowInd,:))
                rowIsNan=[rowIsNan rowInd];
            end
        end
        uniqueInd(rowIsNan,:)=[];
        electrodeNums=uniqueInd(:,1);
        arrayNums=uniqueInd(:,2);
        
        allMaxCurrentList=[];
        allMidCurrentList=[];
        thresholdList=[];
        allElectrodeNumsMax=[];
        allArrayNumsMax=[];
        allElectrodeNumsMid=[];
        allArrayNumsMid=[];
        for uniqueElectrode=1:length(electrodeNums)%15%16:30%1:15%
            array=arrayNums(uniqueElectrode);
            electrode=electrodeNums(uniqueElectrode);
            
            electrodeInd=find(cell2mat(allElectrodeNum)==electrode);
            arrayInd=find(cell2mat(allArrayNum)==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            incorrectmatchTrials=intersect(matchTrials,incorrectMicrostimTrialsInd);
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
            currentAmplitudeAllTrials=[currentAmplitudeAllTrials allCurrentLevel(matchTrials)];
            processData=0;
            currentAmplitudeMidMatchTrials=[];
            currentAmplitudeMaxMatchIncorrectTrials=[];
            maxCurrent=max(allCurrentLevel(matchTrials));
            if ~isempty(maxCurrent)
                currentAmplitudeMaxTrials=find(allCurrentLevel==maxCurrent);
                currentAmplitudeMaxMatchTrials=intersect(matchTrials,currentAmplitudeMaxTrials);
                currentAmplitudeMaxMatchIncorrectTrials=intersect(incorrectmatchTrials,currentAmplitudeMaxTrials);
                if isempty(currentAmplitudeMaxMatchIncorrectTrials)%&&length(matchTrials)>2%if only hits and no misses were obtained during trials at which the maximum current was delivered
                    %                 processData=1;
                    allMaxCurrentList=[allMaxCurrentList maxCurrent];
                    allElectrodeNumsMax=[allElectrodeNumsMax electrodeNums(uniqueElectrode)];
                    allArrayNumsMax=[allArrayNumsMax arrayNums(uniqueElectrode)];
                    if length(allMaxCurrentList)~=length(allElectrodeNumsMax)
                        pauseHere=1;
                    end
                end
            end
            %             if processData==1
            allCurrents=unique(allCurrentLevel(matchTrials));
            middleInd=[];
            if length(allCurrents)>1
                if length(allCurrents)==2
                    middleInd=1;
                else
                    middleInd=floor(length(allCurrents)/2);
                end
            end
            if ~isempty(middleInd)
                currentAmplitudeMidTrials=find(allCurrentLevel==allCurrents(middleInd));
                currentAmplitudeMidMatchTrials=intersect(matchTrials,currentAmplitudeMidTrials);
                currentAmplitudeMidMatchIncorrectTrials=intersect(incorrectmatchTrials,currentAmplitudeMidTrials);
            end
            if ~isempty(currentAmplitudeMidMatchTrials)%&&length(matchTrials)>2%if hits were obtained during trials at which the maximum current was delivered
                allMidCurrentList=[allMidCurrentList allCurrents(middleInd)];
                allElectrodeNumsMid=[allElectrodeNumsMid electrodeNums(uniqueElectrode)];
                allArrayNumsMid=[allArrayNumsMid arrayNums(uniqueElectrode)];
            end
        end
        %         end
        if ~isempty(allMaxCurrentList)
            save([rootdir,date,'\saccade_data_',date,'_fix_to_rew_max_amp_list.mat'],'allMaxCurrentList','allElectrodeNumsMax','allArrayNumsMax');
        end
        if ~isempty(allMidCurrentList)
            save([rootdir,date,'\saccade_data_',date,'_fix_to_rew_mid_amp_list.mat'],'allMidCurrentList','allElectrodeNumsMid','allArrayNumsMid');
        end
    end
end
