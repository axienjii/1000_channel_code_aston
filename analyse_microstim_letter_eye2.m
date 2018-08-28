function analyse_microstim_letter_eye2(date,allInstanceInd)
%7/3/18
%Written by Xing, modified from analyse_microstim_letter.m, extracts eye data during a
%microstimulation/visual 'letter' task.
%Used on recording 150518_B8: analyse_microstim_letter_eye2('150518_B8',1)

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

stimDurms=167;%in ms- min 0, max 500
preStimDur=300/1000;
stimDur=stimDurms/1000;%in seconds
postStimDur=600/1000;%length of post-stimulus-offset period, in s
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
            
        %visual task only:
            
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
            eyeChannels=[130 131];
        end
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        instanceNS6FileName=[rootdir,date,'\',instanceName,'.ns6'];
        eyeDataMat=[rootdir,date,'\',instanceName,'_NSch_eye_channels.mat'];
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
        figure;
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
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                elseif find(trialEncodes==2^ErrorB)
                    perfNEV(trialNo)=-1;
                else
                    perfNEV(trialNo)=0;
                end       
                if perfNEV(trialNo)~=0
                    stimOnInd=find(trialEncodes==2^MicroB);
                    if length(stimOnInd)>1
                        stimOnInd=stimOnInd(end);
                    end                    
                    if trialNo>1
                        trialEncodesStimOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+stimOnInd);
                    else
                        trialEncodesStimOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo)+stimOnInd);
                    end
                    targOnInd=find(trialEncodes==2^TargetB);
                    if length(targOnInd)>1
                        temp=find(targOnInd==stimOnInd+1);
                        if ~isempty(temp)
                            targOnInd=targOnInd(temp);
                        else
                            targOnInd=targOnInd(end);
                        end
                    end
                    if trialNo>1
                        trialEncodesTargOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+targOnInd);
                    else
                        trialEncodesTargOn(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo)+targOnInd);
                    end
%                     interval(trialNo)=trialEncodesTargOn(trialNo)-trialEncodesStimOn(trialNo);
%                     eyeDataX{trialNo}=NSch{1}(trialEncodesStimOn(trialNo):trialEncodesTargOn(trialNo));
%                     eyeDataY{trialNo}=NSch{2}(trialEncodesStimOn(trialNo):trialEncodesTargOn(trialNo));
                    eyeDataX{trialNo}=NSch{1}(trialEncodesTargOn(trialNo)-1.067*sampFreq:trialEncodesTargOn(trialNo)+400/1000*sampFreq);
                    eyeDataY{trialNo}=NSch{2}(trialEncodesTargOn(trialNo)-1.067*sampFreq:trialEncodesTargOn(trialNo)+400/1000*sampFreq);
%                     eyeDataX{trialNo}=NSch{1}(trialEncodesStimOn(trialNo)-preStimDur*sampFreq:trialEncodesStimOn(trialNo)+1167/1000*sampFreq);
%                     eyeDataY{trialNo}=NSch{2}(trialEncodesStimOn(trialNo)-preStimDur*sampFreq:trialEncodesStimOn(trialNo)+1167/1000*sampFreq);
                    subplot(2,1,1);
                    plot(eyeDataX{trialNo});
                    hold on
                    ax=gca;
                    ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
                    ax.XTickLabel={'-300','0','167','767'};
                    subplot(2,1,2);
                    plot(eyeDataY{trialNo});
                    hold on
                    ax=gca;
                    ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
                    ax.XTickLabel={'-300','0','167','767'};
                else
                    eyeDataX{trialNo}=[];
                    eyeDataY{trialNo}=[];
                end
                if visualOnly==0
                    if interleaved==0%stimulation sent using trigger pulse from dasbit(microB,1)
                        if length(find(trialEncodes==2^MicroB))>=1
                            microstimTrialNEV(trialNo)=1;
                        end
                    elseif interleaved==1%stimulation sent using stimulator.play function
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
        goodTrialsInd=find(~cellfun(@isempty,eyeDataX));
        targetLocationsFinal=allTargetLocation(goodTrialsInd);
        eyeDataXFinal=eyeDataX(goodTrialsInd);
        eyeDataYFinal=eyeDataY(goodTrialsInd);
        perfNEVFinal=perfNEV(goodTrialsInd);
        figure
        for trialIndFinal=1:length(targetLocationsFinal)
            if perfNEVFinal(trialIndFinal)==1
                subplot(2,4,targetLocationsFinal(trialIndFinal));
                plot(eyeDataXFinal{trialIndFinal});
                hold on
                subplot(2,4,targetLocationsFinal(trialIndFinal)+4);
                plot(eyeDataYFinal{trialIndFinal});
                hold on
            end
        end
        allX=cell(1,4);
        allY=cell(1,4);
        for targetInd=1:4
            figure
            targetLocTrials=find(targetLocationsFinal==targetInd);
%             length(targetLocTrials)
            for targetLocTrialInd=1:length(targetLocTrials)
                if perfNEVFinal(targetLocTrials(targetLocTrialInd))==1
                    subplot(2,1,1);
                    plot(eyeDataXFinal{targetLocTrials(targetLocTrialInd)});
                    hold on
                    subplot(2,1,2);
                    plot(eyeDataYFinal{targetLocTrials(targetLocTrialInd)});
                    hold on
                    allX{targetInd}=[allX{targetInd} eyeDataXFinal{targetLocTrials(targetLocTrialInd)}(34700)-eyeDataXFinal{targetLocTrials(targetLocTrialInd)}(17980)];
                    allY{targetInd}=[allY{targetInd} eyeDataYFinal{targetLocTrials(targetLocTrialInd)}(34700)-eyeDataYFinal{targetLocTrials(targetLocTrialInd)}(17980)];
                end
            end
            subplot(2,1,1);
            ax=gca;
            ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
            ax.XTickLabel={'-300','0','167','767'};
            subplot(2,1,2);
            ax=gca;
            ax.XTick=[0 preStimDur*sampFreq (preStimDur+stimDur)*sampFreq (preStimDur+stimDur+postStimDur)*sampFreq];
            ax.XTickLabel={'-300','0','167','767'};
        end
        trimmean(allX{1},95);
        trimmean(allX{2},95);
        trimmean(allY{3},95);
        trimmean(allY{4},95);
        allArrayNumFinal=allArrayNum(goodTrialsInd);
        allElectrodeNumFinal=allElectrodeNum(goodTrialsInd);
        save([rootdir,date,'\eye_data.mat'],'eyeDataXFinal','eyeDataYFinal','perfNEVFinal','targetLocationsFinal','allArrayNumFinal','allElectrodeNumFinal');
    end
end
pause=1;