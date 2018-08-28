function analyse_fix_cal(date,allInstanceInd)
%31/1/18
%Written by Xing, analyses eye data from a fixation task, in which
%fixation was maintained at 1 of 9 possible positions, to calculate the pixels
%per volt for the eye traces (separately for X and Y). 

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end

load([rootdir,date,'\',date(1:6),'_data\PAR.mat'])
% load('X:\best\310118_data\microstim_saccade_test_310118_3.mat')
load([rootdir,date,'\',date(1:6),'_data\microstim_saccade_',date,'.mat'])
timestampCell2=289409-1;%data recording was briefly paused at beginning of recording; hence, use the second cell of data in NSchOriginal and account for the temporal offset when reading out timestamps
sampleDist=300;%distance between adjacent fix spot positions, in pixels
dvaSampleDist=300/Par.PixPerDeg;%%distance between adjacent fix spot positions, in degrees of visual angle

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
        elseif recordedRaw==1
            if NEV.ElectrodesInfo(130).ConnectorPin==2%31/1/18
                eyeChannels=[130 131];
            elseif NEV.ElectrodesInfo(130).ConnectorPin==3
                eyeChannels=[129 130];
            end
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
                    if iscell(NSchOriginal.Data)
                        if size(NSchOriginal.Data,2)==2
%                             NSch{channelInd}=[NSchOriginal.Data{1} NSchOriginal.Data{2}];
                            NSch{channelInd}=[NSchOriginal.Data{2}];
                        end
                    else%if isdouble(NSchOriginal.Data)
                        NSch{channelInd}=NSchOriginal.Data;
                    end
                end
            end
            save(eyeDataMat,'NSch');
        end       
        
        %identify trials using encodes sent via serial port: 
        StimB=1;
        TargetB=2;
        unknownB=4;
        CorrectB=7;
        RewardB=3;
        encodesCorrect=[32 2 4 128];%
        
        trialNo=1;
        perfNEV=[];
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
                if find(trialEncodes==2^CorrectB)
                    perfNEV(trialNo)=1;
                else
                    perfNEV(trialNo)=0;
                end
                trialNo=trialNo+1;
            end
        end
        
        goodStimOffInd=[];
        goodStimOnInd=[];
        trialInds=[];
        for rewInd=1:length(encodeInd)-1
            stimOff=[];
            stimOnInd=[];
            trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(encodeInd(rewInd):encodeInd(rewInd+1)-1);
            stimOnInd=find(trialEncodes==2);
            if ~isempty(stimOnInd)    
                stimOnInd=stimOnInd(1);
                stimOff=trialEncodes(stimOnInd+1);
            end
            if ~isempty(stimOff)&&stimOff==4
                goodStimOffInd=[goodStimOffInd encodeInd(rewInd)+stimOnInd];%indices of encodes for reward delivery
                goodStimOnInd=[goodStimOnInd encodeInd(rewInd)+stimOnInd-1];%indices of encodes for target onset
                trialInds=[trialInds rewInd];
            end
        end
        for rewInd=length(encodeInd)%do this for last trial
            stimOff=[];
            stimOnInd=[];
            trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(encodeInd(rewInd):end);
            stimOnInd=find(trialEncodes==2);
            if ~isempty(stimOnInd)    
                stimOnInd=stimOnInd(1);
                stimOff=trialEncodes(stimOnInd+1);
            end
            if ~isempty(stimOff)&&stimOff==4
                goodStimOffInd=[goodStimOffInd encodeInd(rewInd)+stimOnInd];%indices of encodes for reward delivery
                goodStimOnInd=[goodStimOnInd encodeInd(rewInd)+stimOnInd-1];%indices of encodes for target onset
                trialInds=[trialInds rewInd];
            end
        end
        timestampTrialStimOff=NEV.Data.SerialDigitalIO.TimeStamp(goodStimOffInd);
        timestampTrialStimOn=NEV.Data.SerialDigitalIO.TimeStamp(goodStimOnInd);
        posIndXvolt=[];
        posIndYvolt=[];
        meanPosX=cell(1,9);
        meanPosY=cell(1,9);
        fig1=figure
        fig2=figure
        for trialInd=1:length(goodStimOffInd)
            if timestampTrialStimOff(trialInd)<=size(NSch{1},2)&&timestampTrialStimOff(trialInd)<=size(NSch{2},2)
                trialDataX=NSch{1}(timestampTrialStimOn(trialInd)-timestampCell2:timestampTrialStimOff(trialInd)-timestampCell2);
                trialDataY=NSch{2}(timestampTrialStimOn(trialInd)-timestampCell2:timestampTrialStimOff(trialInd)-timestampCell2);
                condNo=allCondNo(trialInds(trialInd));
                figure(fig1)
                subplot(3,3,condNo)
                plot(trialDataX);hold on
                figure(fig2)
                subplot(3,3,condNo)
                plot(trialDataY);hold on
                baselineX=mean(trialDataX);
                baselineY=mean(trialDataY);
                meanPosX{condNo}=[meanPosX{condNo};baselineX];
                meanPosY{condNo}=[meanPosY{condNo};baselineY];
            end
        end
        for condNoInd=1:9
            allMeanPosX(condNoInd)=mean(meanPosX{condNoInd}(:));
            allMeanPosY(condNoInd)=mean(meanPosY{condNoInd}(:));
            percentOutliers=80;%
            allMeanPosXexcludeOutliers(condNoInd)=trimmean(meanPosX{condNoInd}(:),percentOutliers);
            allMeanPosYexcludeOutliers(condNoInd)=trimmean(meanPosY{condNoInd}(:),percentOutliers);
        end
        figure;
        scatter(allMeanPosX,allMeanPosY);
        figure;
        scatter(allMeanPosXexcludeOutliers,allMeanPosYexcludeOutliers);
        row1X=mean([allMeanPosXexcludeOutliers(1) allMeanPosXexcludeOutliers(4) allMeanPosXexcludeOutliers(7)])
        row2X=mean([allMeanPosXexcludeOutliers(2) allMeanPosXexcludeOutliers(5) allMeanPosXexcludeOutliers(8)]);
        row3X=mean([allMeanPosXexcludeOutliers(3) allMeanPosXexcludeOutliers(6) allMeanPosXexcludeOutliers(9)]);
        col1Y=mean([allMeanPosYexcludeOutliers(1) allMeanPosYexcludeOutliers(2) allMeanPosYexcludeOutliers(3)])
        col2Y=mean([allMeanPosYexcludeOutliers(4) allMeanPosYexcludeOutliers(5) allMeanPosYexcludeOutliers(6)]);
        col3Y=mean([allMeanPosYexcludeOutliers(7) allMeanPosYexcludeOutliers(8) allMeanPosYexcludeOutliers(9)]);
        voltsPerDegreeX=mean([row1X-row2X row2X-row3X])/dvaSampleDist;
        voltsPerDegreeY=mean([col3Y-col2Y col2Y-col1Y])/dvaSampleDist;
        degpervoltx=1/voltsPerDegreeX;
        degpervolty=1/voltsPerDegreeY;
        save(['D:\data\',date,'\volts_per_dva.mat'],'voltsPerDegreeX','voltsPerDegreeY')
    end
end
       