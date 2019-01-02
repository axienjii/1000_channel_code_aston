function analyse_microstim_artefact4_aston(date,allInstanceInd,allGoodChannels)
%05/11/18
%Written by Xing. Plots profile of stimulation artefact across V4 channels,
%while microstimulation delivered on V1 channels.
%Uses serial port encodes to identify trials.

matFile=['D:\aston_data\',date,'\',date,'_data\microstim_saccade_',date,'.mat'];
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

downSampling=1;
downsampleFreq=30;

sampFreq=30000;
switch date
    case '051118_B3_aston'
        minCrossingTime=preStimDur-0.166;
end

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\aston_data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);        
        
        %read in V4 neuronal data:
        recordedRaw=1;
        if instanceInd==1
            neuronalChannels=33:96;%V4 array 2 on instance 1
        elseif instanceInd==3
            neuronalChannels=[1:32 97:128];%V4 array 5 on instance 3
        end
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6']; 
        neuronalDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_channels.mat'];
        if exist(neuronalDataMat,'file')
            load(neuronalDataMat,'NSch');
        else
            if recordedRaw==0
                NSchOriginal=openNSx(instanceNS6FileName);
                for channelInd=1:length(neuronalChannels)
                    NSch{channelInd}=NSchOriginal.Data(channelInd,:);
                end
            elseif recordedRaw==1
                for channelInd=1%:length(neuronalChannels)
                    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
                    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
                    NSch{channelInd}=NSchOriginal.Data;
                end
            end
            save(neuronalDataMat,'NSch');
        end     
        syncPulseDataMat=['D:\aston_data\',date,'\',instanceName,'_NSchSyncCh_channels.mat'];
        syncPulseAnalogInputs=[7 8 10]+128;%analog input 7 (Cerestim 14173), array 10; analog input 8 (Cerestim 14174), array 11; analog input 10 (Cerestim 14176), array 13
        colInd='m c g';
%         if exist(syncPulseDataMat,'file')
%             load(syncPulseDataMat,'NSch');
%         else
%             for syncChInd=1:length(syncPulseAnalogInputs)
%                 readChannel=['c:',num2str(syncPulseAnalogInputs(syncChInd)),':',num2str(syncPulseAnalogInputs(syncChInd))];
%                 NSchOriginal=openNSx(instanceNS6FileName,readChannel);
%                 NSchSyncCh{syncChInd}=NSchOriginal.Data;
%             end
%             save(syncPulseDataMat,'NSch');
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
                trialNo=trialNo+1;
            end
        end
                
        microstimTrialsInd=find(microstimTrialNEV==1);
        correctTrialsInd=find(performance==1);
        correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
        fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset

        figInd1=figure;hold on
        figInd2=figure;hold on
        figInd3=figure;hold on
        figInd4=figure;hold on
        figInd5=figure;hold on
        figInd6=figure;hold on
        figInd8=figure;hold on
        saccadeEndAllTrials=[]; 
        electrodeAllTrials=[];
        timePeakVelocityXYsAllTrials=[];
        timePeakVelocityXYSecsAllTrials=[];
        arrayAllTrials=[];
        if ~exist('goodArrays8to16','var')
            load('D:\aston_data\241018_B2_aston\241018_data\currentThresholdChs8.mat')
        end
        for uniqueElectrode=1:size(goodArrays8to16,1)
            array=goodArrays8to16(uniqueElectrode,7);
            arrayColInd=find(arrays==array);
            electrode=goodArrays8to16(uniqueElectrode,8);
            impedance=goodArrays8to16(uniqueElectrode,6);
            RFx=goodArrays8to16(uniqueElectrode,1);
            RFy=goodArrays8to16(uniqueElectrode,2);
            if RFy<-500
                RFy=NaN;
            end
            
            electrodeInd=find(allElectrodeNum==electrode);
            arrayInd=find(allArrayNum==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
        
            trialDataXY={};
            degPerVoltXFinal=0.0025;
            degPerVoltYFinal=0.0025;
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
            saccadeEndTrials=[];
            electrodeTrials=[];
            timePeakVelocityXYs=[];
            timePeakVelocityXYSecs=[];
            for trialCounter=1:length(matchTrials)%for each correct microstim trial
                trialNo=matchTrials(trialCounter);%trial number, out of all trials from that session  
                corrBit=7;
                microB=6;
                targetB=2;
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^corrBit);
                timeRewardInd=temp(end);%index in NEV file corresponding to reward delivery
                timeReward=NEV.Data.SerialDigitalIO.TimeStamp(timeRewardInd);%timestamp in NEV file corresponding to reward delivery
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^targetB);
                timeTargetInd=temp(end);%index in NEV file corresponding to reward delivery
                timeTarget=NEV.Data.SerialDigitalIO.TimeStamp(timeTargetInd);%timestamp in NEV file corresponding to reward delivery
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:timeTargetInd)==2^microB);%(two encodes before reward encode)
                timeMicrostimInd=temp(end);%index in NEV file corresponding to end of microstim train
                timeMicrostim=NEV.Data.SerialDigitalIO.TimeStamp(timeMicrostimInd);%timestamp in NEV file corresponding to reward delivery
                preStimDur=300;
                postStimDur=100;
                stimDur=167;
                timeMicrostimToReward=timeMicrostim-(preStimDur)/1000*sampFreq:timeMicrostim+(stimDur+postStimDur)/1000*sampFreq;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                trialData{trialCounter}=NSch{1}(timeMicrostimToReward);
                figure;
                plot(trialData{trialCounter})
                xlabel('sample points')
                ylabel('voltage')
                hold on
                yLims=get(gca,'ylim');
                plot([preStimDur/1000*sampFreq preStimDur/1000*sampFreq],[yLims(1) yLims(2)],'k:')
                plot([(preStimDur+166)/1000*sampFreq (preStimDur+166)/1000*sampFreq],[yLims(1) yLims(2)],'k:')
                title(['V4 channel stimulation artefact'])
%                 for syncChInd=1:length(syncPulseAnalogInputs)
%                     syncPulseData1{trialCounter}=NSchSyncCh{syncChInd}(timeMicrostimToReward);
%                     plot(syncPulseData1{trialCounter},colInd(syncChInd));
%                 end
                pauseHere=1;
            end
        end
    end
end
