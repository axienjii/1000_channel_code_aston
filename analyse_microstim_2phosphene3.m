function analyse_microstim_2phosphene3(date,allInstanceInd)
%29/9/17
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual 2-phosphene task.
%Sends 3 encodes for microB (two for the 'fake' stimulation triggers, and 1
%for the real stimulation trigger).

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
matFile=['D:\data\',date,'\',date,'_data\microstim_saccade_',date,'.mat'];
dataDir=['D:\data\',date,'\',date,'_data'];
if ~exist('dataDir','dir')
    copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);    
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
        case '031017_B11'
            setElectrodes=[50 55 37 51;25 8 63 42];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10;12 10 15 13];
            setInd=1;
            numTargets=2;
        case '031017_B13'
            setElectrodes=[50 55 37 51;25 8 63 42];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 11 13 10;12 10 15 13];
            setInd=1;
            numTargets=4;
        case '091017_B13'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=2;
        case '091017_B15'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=2;
        case '091017_B16'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=2;
        case '091017_B17'
            setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
            setArrays=[13 10 13 10;12 13 15 10];
            setInd=2;
            numTargets=4;
    end
end
    
processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
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
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                elseif find(trialEncodes==2^ErrorB)
                    perfNEV(trialNo)=-1;
                end
                if length(find(trialEncodes==2^MicroB))==3
                    microstimTrialNEV(trialNo)=1;
                end
                %analyse individual conditions:
                if analyseConds==1&&length(allElectrodeNum)>=trialNo
                    electrode=allElectrodeNum(trialNo);
                    array=allArrayNum(trialNo);
                    electrode2=allElectrodeNum2(trialNo);
                    array2=allArrayNum2(trialNo);
                    electrodeMatch=find(setElectrodes(setInd,:)==electrode);
                    arrayMatch=find(setArrays(setInd,:)==array);
                    matchingCh=intersect(electrodeMatch,arrayMatch);%one electrode of a pair
                    electrodeMatch2=find(setElectrodes(setInd,:)==electrode2);
                    arrayMatch2=find(setArrays(setInd,:)==array2);
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
        meanPerfVisual=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectVisualTrialsInd))
        incorrectMicrostimTrialsInd=intersect(microstimTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
        meanPerfMicrostim=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectMicrostimTrialsInd))
        totalRespTrials=length(correctTrialsInd)+length(incorrectTrialsInd);%number of trials where a response was made
        indRespTrials=sort([correctTrialsInd incorrectTrialsInd]);%indices of trials where response was made
        for trialRespInd=1:totalRespTrials
            trialNo=indRespTrials(trialRespInd);
            corr(trialRespInd)=~isempty(find(correctTrialsInd==trialNo));
            incorr(trialRespInd)=~isempty(find(incorrectTrialsInd==trialNo));
            if length(microstimTrialNEV)>=trialNo
                micro(trialRespInd)=microstimTrialNEV(trialNo);
            end
        end
        visualInd=find(micro~=1);
        corrInd=find(corr==1);
        corrVisualInd=intersect(visualInd,corrInd);
        microInd=find(micro==1);
        corrMicroInd=intersect(microInd,corrInd);
        perfMicroBin=[];
        perfVisualBin=[];
        perfMicroTrialNo=[];
        perfVisualTrialNo=[];
        numTrialsPerBin=20;
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
           LRTBInd1=find(allLRorTB==1);
           LRTBInd2=find(allLRorTB==2);
           targetInd1=find(allTargetLocation==1);
           targetInd2=find(allTargetLocation==2);  
           
           condInds=intersect(LRTBInd1,targetInd1);
           corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
           incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
           leftPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
           corrIndsV=intersect(condInds,correctVisualTrialsInd);
           incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
           leftPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
           
           condInds=intersect(LRTBInd1,targetInd2);
           corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
           incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
           rightPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
           corrIndsV=intersect(condInds,correctVisualTrialsInd);
           incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
           rightPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
           
           condInds=intersect(LRTBInd2,targetInd1);
           corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
           incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
           topPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
           corrIndsV=intersect(condInds,correctVisualTrialsInd);
           incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
           topPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
           
           condInds=intersect(LRTBInd2,targetInd2);
           corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
           incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
           bottomPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
           corrIndsV=intersect(condInds,correctVisualTrialsInd);
           incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
           bottomPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
           
           figure;
           b=bar([leftPerfV leftPerfM;rightPerfV rightPerfM;topPerfV topPerfM;bottomPerfV bottomPerfM],'FaceColor','flat');
           b(1).FaceColor = 'flat';
           b(2).FaceColor = 'flat';
           b(1).FaceColor = [0 0.4470 0.7410];
           b(2).FaceColor = [1 0 0];
           set(gca, 'XTick',1:4)
           set(gca, 'XTickLabel', {'left' 'right' 'top' 'bottom'})
           xLimits=get(gca,'xlim');
           hold on
           plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
           title('performance on visual (blue) and microstim (red) trials');
           xlabel('target condition');
           ylabel('average performance across session');
           pathname=fullfile('D:\data',date,['behavioural_performance_per_condition_',date]);
           set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
           print(pathname,'-dtiff');
        end
        
        figInd1=figure;hold on
        plot(perfMicroTrialNo,perfMicroBin,'rx-');
        plot(perfVisualTrialNo,perfVisualBin,'bx-');
        ylim([0 1]);
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
        title('performance on visual (blue) and microstim (red) trials');
        xlabel('trial number (across the session)');
        ylabel('performance'); 
        pathname=fullfile('D:\data',date,['behavioural_performance_',date,'_',num2str(numTrialsPerBin),'trialsperbin']);
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
    end
end
pause=1;