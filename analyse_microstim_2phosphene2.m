function analyse_microstim_2phosphene(date,allInstanceInd)
%25/9/17
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual 2-phosphene task.

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
preStimDur=300/1000;
stimDur=stimDurms/1000;%in seconds
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
                if find(trialEncodes==2^ErrorB)
                    perfNEV(trialNo)=-1;
                elseif find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                end
                if length(find(trialEncodes==2^MicroB))==2
                    microstimTrialNEV(trialNo)=1;
                end
                trialNo=trialNo+1;
            end
        end
        tallyCorrect=length(find(perfNEV==1));
        tallyIncorrect=length(find(perfNEV==-1));
        meanPerf=tallyCorrect/(tallyCorrect+tallyIncorrect);
%         tallyCorrectVisual=length(find(perfNEV.*visualTrials==1));%correct response, visual trial
%         tallyIncorrectVisual=length(find(perfNEV.*visualTrials==-1));%incorrect response, visual trial
%         tallyCorrectMicrostim=length(find(perfNEV.*microstimTrials==1));%correct response, microstim trial
%         tallyIncorrectMicrostim=length(find(perfNEV.*microstimTrials==-1));%incorrect response, microstim trial
                
%         microstimTrialsInd=find(allCurrentLevel>0);
%         visualTrialsInd=find(allCurrentLevel==0);
        visualTrialsInd=find(microstimTrialNEV~=1);%not entirely correct- includes microstim trials where fix breaks happen before dasbit sent MicroB
        microstimTrialsInd=find(microstimTrialNEV==1);
        correctTrialsInd=find(perfNEV==1);
        incorrectTrialsInd=find(perfNEV==-1);
        correctVisualTrialsInd=intersect(visualTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
        incorrectVisualTrialsInd=intersect(visualTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
        correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
        meanPerfVisual=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectVisualTrialsInd));
        incorrectMicrostimTrialsInd=intersect(microstimTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
        meanPerfMicrostim=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectMicrostimTrialsInd));
        totalRespTrials=length(correctTrialsInd)+length(incorrectTrialsInd);%number of trials where a response was made
        indRespTrials=sort([correctTrialsInd incorrectTrialsInd]);%indices of trials where response was made
        for trialRespInd=1:totalRespTrials
            trialNo=indRespTrials(trialRespInd);
            corr(trialRespInd)=~isempty(find(correctTrialsInd==trialNo));
            incorr(trialRespInd)=~isempty(find(incorrectTrialsInd==trialNo));
            micro(trialRespInd)=microstimTrialNEV(trialNo);            
        end
        microInd=find(micro==1);
        visualInd=find(micro~=1);
        corrInd=find(corr==1);
        corrMicroInd=intersect(microInd,corrInd);
        corrVisualInd=intersect(visualInd,corrInd);
        perfMicroBin=[];
        perfVisualBin=[];
        perfMicroTrialNo=[];
        perfVisualTrialNo=[];
        for trialRespInd=1:totalRespTrials-10
            if micro(trialRespInd)==1
                firstMicroTrialInBin=find(microInd==trialRespInd);
                if firstMicroTrialInBin<=length(microInd)-9
                    binMicroTrials=microInd(firstMicroTrialInBin:firstMicroTrialInBin+9);
                    corrMicroInBin=intersect(binMicroTrials,corrMicroInd);
                    perfMicroBin=[perfMicroBin length(corrMicroInBin)/10];
                    perfMicroTrialNo=[perfMicroTrialNo trialRespInd];
                end
            elseif micro(trialRespInd)==0
                firstVisualTrialInBin=find(visualInd==trialRespInd);
                if firstVisualTrialInBin<=length(visualInd)-9
                    binVisualTrials=visualInd(firstVisualTrialInBin:firstVisualTrialInBin+9);
                    corrVisualInBin=intersect(binVisualTrials,corrVisualInd);
                    perfVisualBin=[perfVisualBin length(corrVisualInBin)/10];
                    perfVisualTrialNo=[perfVisualTrialNo trialRespInd];
                end
            end
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
        
        figInd2=figure;hold on
        figInd3=figure;hold on
        figInd4=figure;hold on
        figInd5=figure;hold on
        figInd6=figure;hold on
        figInd8=figure;hold on
        figInd10=figure;hold on
        saccadeEndAllTrials=[]; 
        electrodeAllTrials=[];
        timePeakVelocityXYsAllTrials=[];
        timePeakVelocityXYSecsAllTrials=[];
        arrayAllTrials=[];
        for uniqueElectrode=1:size(goodArrays8to16,1)
            figInd9(uniqueElectrode)=figure;hold on
            array=goodArrays8to16(uniqueElectrode,7);
            arrayColInd=find(arrays==array);
            electrode=goodArrays8to16(uniqueElectrode,8);
            impedance=goodArrays8to16(uniqueElectrode,6);
            RFx=goodArrays8to16(uniqueElectrode,1);
            RFy=goodArrays8to16(uniqueElectrode,2);
            if RFy<-500
                RFy=NaN;
            end
            
            electrodeInd=find(cell2mat(allElectrodeNum)==electrode);
            arrayInd=find(cell2mat(allArrayNum)==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
        
            trialDataXY={};
            degPerVoltXFinal=0.0024;
            degPerVoltYFinal=0.0022;
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
            saccadeEndTrials=[];
            electrodeTrials=[];
            timePeakVelocityXYs=[];
            timePeakVelocityXYSecs=[];
            for trialCounter=1:length(matchTrials)%for each correct microstim trial
                trialNo=matchTrials(trialCounter);%trial number, out of all trials from that session  
                %identify time of reward delivery:
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^4);
                timeTrialStartInd=temp(end);%index in NEV file that appears in trial- though not necessarily the start (I think)
                timeTrialStart=NEV.Data.SerialDigitalIO.TimeStamp(timeTrialStartInd);%timestamp in NEV file corresponding to something
                corrBit=7;
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^corrBit);
                timeRewardInd=temp(end);%index in NEV file corresponding to reward delivery
                timeReward=NEV.Data.SerialDigitalIO.TimeStamp(timeRewardInd);%timestamp in NEV file corresponding to reward delivery
                codeMicrostimOn=2;%sent at the end of microstimulation train
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:timeRewardInd)==2^codeMicrostimOn);%(two encodes before reward encode)
                timeMicrostimInd=temp(end);%index in NEV file corresponding to end of microstim train
                timeMicrostim=NEV.Data.SerialDigitalIO.TimeStamp(timeMicrostimInd);%timestamp in NEV file corresponding to reward delivery
                timeMicrostimToReward=timeMicrostim:timeReward;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                trialDataX{trialCounter}=NSch{1}(timeMicrostimToReward);
                trialDataY{trialCounter}=NSch{2}(timeMicrostimToReward);
                timeSmooth=timeMicrostim-preStimDur*sampFreq:timeReward;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                trialDataXSmooth{trialCounter}=double(NSch{1}(timeSmooth));
                trialDataYSmooth{trialCounter}=double(NSch{2}(timeSmooth));
                numDataPointsAfterStim=timeReward-timeMicrostim;
                eyepx=-0.15*sampFreq:double(numDataPointsAfterStim);
                eyepx=eyepx/sampFreq;
                figure(figInd2)
                subplot(2,1,1)
                plot(trialDataXSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                subplot(2,1,2)
                plot(trialDataYSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                baselineX=mean(trialDataXSmooth{trialCounter}(1:5000));
                baselineY=mean(trialDataYSmooth{trialCounter}(1:5000));
            end
        end        
    end
end
pause=1;