function analyse_fix_cal_25conds_aston(date,allInstanceInd)
%24/10/18
%Written by Xing, analyses eye data from a fixation task, in which
%fixation was maintained at 1 of 25 possible positions, to calculate the pixels
%per volt for the eye traces (separately for X and Y). 

date=[date,'_aston'];
localDisk=1;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end

% copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
load([rootdir,date,'\',date(1:6),'_data\PAR.mat'])
load([rootdir,date,'\',date(1:6),'_data\microstim_saccade_',date,'.mat'])
timestampCell2=0;%data recording was briefly paused at beginning of recording; hence, use the second cell of data in NSchOriginal and account for the temporal offset when reading out timestamps
switch(date)
    case '241018_B1_aston'
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '270619_B1_aston'%degpervolty=0.003
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '280619_B1_aston'%degpervolty=0.0024
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '010719_B1_aston'%degpervoltx=0.0026; degpervolty=0.0028
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '020719_B1_aston'%degpervoltx=0.00; degpervolty=0.00
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '030719_B1_aston'%degpervoltx=0.00; degpervolty=0.00
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '080719_B1_aston'%degpervoltx=0.0022; degpervolty=0.00
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '090719_B1_aston'%degpervoltx=0.0022; degpervolty=0.00
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '100719_B1_aston'%
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '160719_B1_aston'%degpervoltx=0.0024; degpervolty=0.0026
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '170719_B1_aston'%degpervoltx=0.0025; degpervolty=0.0026
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '190719_B1_aston'%degpervoltx=0.0025; degpervolty=0.0026
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
    case '310719_B1_aston'%degpervoltx=0.0025; degpervolty=0.0026
        sampleDist=40;%distance between adjacent fix spot positions, in pixels
end
dvaSampleDist=sampleDist/Par.PixPerDeg;%%distance between adjacent fix spot positions, in degrees of visual angle

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
        elseif recordedRaw==1
            if NEV.ElectrodesInfo(130).ConnectorPin==2%31/1/18
                eyeChannels=[130 131];
            elseif NEV.ElectrodesInfo(130).ConnectorPin==3
                eyeChannels=[129 130];
                if strcmp(date,'140819_B1')
                    eyeChannels=[2 3];
                end
            end
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
                    if iscell(NSchOriginal.Data)
                        if size(NSchOriginal.Data,2)>=2
%                             NSch{channelInd}=[NSchOriginal.Data{1} NSchOriginal.Data{2}];
                            NSch{channelInd}=[NSchOriginal.Data{end}];
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
        meanPosX=cell(1,25);
        meanPosY=cell(1,25);
        fig1=figure
        fig2=figure
        for trialInd=1:length(goodStimOffInd)
            if timestampTrialStimOff(trialInd)<=size(NSch{1},2)&&timestampTrialStimOff(trialInd)<=size(NSch{2},2)
                trialDataX=NSch{1}(timestampTrialStimOn(trialInd)-timestampCell2:timestampTrialStimOff(trialInd)-timestampCell2);
                trialDataY=NSch{2}(timestampTrialStimOn(trialInd)-timestampCell2:timestampTrialStimOff(trialInd)-timestampCell2);
                condNo=allCondNo(trialInds(trialInd));
                figure(fig1)
                subplot(5,5,condNo)
                plot(trialDataX);hold on
                figure(fig2)
                subplot(5,5,condNo)
                plot(trialDataY);hold on
                baselineX=mean(trialDataX);
                baselineY=mean(trialDataY);
                meanPosX{condNo}=[meanPosX{condNo};baselineX];
                meanPosY{condNo}=[meanPosY{condNo};baselineY];
            end
        end
        for condNoInd=1:25
            allMeanPosX(condNoInd)=mean(meanPosX{condNoInd}(:));
            allMeanPosY(condNoInd)=mean(meanPosY{condNoInd}(:));
            percentOutliers=80;%
            allMeanPosXexcludeOutliers(condNoInd)=trimmean(meanPosX{condNoInd}(:),percentOutliers);
            allMeanPosYexcludeOutliers(condNoInd)=trimmean(meanPosY{condNoInd}(:),percentOutliers);
        end
        figure;
        scatter(allMeanPosX,allMeanPosY);
        title('including outliers')
        axis equal
        row1X=mean([allMeanPosX(1) allMeanPosX(6) allMeanPosX(11) allMeanPosX(16) allMeanPosX(21)])
        row2X=mean([allMeanPosX(2) allMeanPosX(7) allMeanPosX(12) allMeanPosX(17) allMeanPosX(22)]);
        row3X=mean([allMeanPosX(3) allMeanPosX(8) allMeanPosX(13) allMeanPosX(18) allMeanPosX(23)]);
        row4X=mean([allMeanPosX(4) allMeanPosX(9) allMeanPosX(14) allMeanPosX(19) allMeanPosX(24)]);
        row5X=mean([allMeanPosX(5) allMeanPosX(10) allMeanPosX(15) allMeanPosX(20) allMeanPosX(25)]);
        col1Y=mean([allMeanPosY(1) allMeanPosY(2) allMeanPosY(3) allMeanPosY(4) allMeanPosY(5)])
        col2Y=mean([allMeanPosY(6) allMeanPosY(7) allMeanPosY(8) allMeanPosY(9) allMeanPosY(10)]);
        col3Y=mean([allMeanPosY(11) allMeanPosY(12) allMeanPosY(13) allMeanPosY(14) allMeanPosY(15)]);
        col4Y=mean([allMeanPosY(16) allMeanPosY(17) allMeanPosY(18) allMeanPosY(19) allMeanPosY(20)]);
        col5Y=mean([allMeanPosY(21) allMeanPosY(22) allMeanPosY(23) allMeanPosY(24) allMeanPosY(25)]);
        voltsPerDegreeX=nanmean([row1X-row2X row2X-row3X row3X-row4X row4X-row5X])/dvaSampleDist;
        voltsPerDegreeY=nanmean([col5Y-col4Y col4Y-col3Y col3Y-col2Y col2Y-col1Y])/dvaSampleDist;
        degpervoltxAll=1/voltsPerDegreeX;
        degpervoltyAll=1/voltsPerDegreeY;
        figure;
        scatter(allMeanPosXexcludeOutliers,allMeanPosYexcludeOutliers);
        title('excluding outliers')
        axis equal
        row1X=nanmean([allMeanPosXexcludeOutliers(1) allMeanPosXexcludeOutliers(6) allMeanPosXexcludeOutliers(11) allMeanPosXexcludeOutliers(16) allMeanPosXexcludeOutliers(21)])
        row2X=nanmean([allMeanPosXexcludeOutliers(2) allMeanPosXexcludeOutliers(7) allMeanPosXexcludeOutliers(12) allMeanPosXexcludeOutliers(17) allMeanPosXexcludeOutliers(22)]);
        row3X=nanmean([allMeanPosXexcludeOutliers(3) allMeanPosXexcludeOutliers(8) allMeanPosXexcludeOutliers(13) allMeanPosXexcludeOutliers(18) allMeanPosXexcludeOutliers(23)]);
        row4X=nanmean([allMeanPosXexcludeOutliers(4) allMeanPosXexcludeOutliers(9) allMeanPosXexcludeOutliers(14) allMeanPosXexcludeOutliers(19) allMeanPosXexcludeOutliers(24)]);
        row5X=nanmean([allMeanPosXexcludeOutliers(5) allMeanPosXexcludeOutliers(10) allMeanPosXexcludeOutliers(15) allMeanPosXexcludeOutliers(20) allMeanPosXexcludeOutliers(25)]);
        col1Y=nanmean([allMeanPosYexcludeOutliers(1) allMeanPosYexcludeOutliers(2) allMeanPosYexcludeOutliers(3) allMeanPosYexcludeOutliers(4) allMeanPosYexcludeOutliers(5)])
        col2Y=nanmean([allMeanPosYexcludeOutliers(6) allMeanPosYexcludeOutliers(7) allMeanPosYexcludeOutliers(8) allMeanPosYexcludeOutliers(9) allMeanPosYexcludeOutliers(10)]);
        col3Y=nanmean([allMeanPosYexcludeOutliers(11) allMeanPosYexcludeOutliers(12) allMeanPosYexcludeOutliers(13) allMeanPosYexcludeOutliers(14) allMeanPosYexcludeOutliers(15)]);
        col4Y=nanmean([allMeanPosYexcludeOutliers(16) allMeanPosYexcludeOutliers(17) allMeanPosYexcludeOutliers(18) allMeanPosYexcludeOutliers(19) allMeanPosYexcludeOutliers(20)]);
        col5Y=nanmean([allMeanPosYexcludeOutliers(21) allMeanPosYexcludeOutliers(22) allMeanPosYexcludeOutliers(23) allMeanPosYexcludeOutliers(24) allMeanPosYexcludeOutliers(25)]);
        voltsPerDegreeX=nanmean([row1X-row2X row2X-row3X row3X-row4X row4X-row5X])/dvaSampleDist;
        voltsPerDegreeY=nanmean([col5Y-col4Y col4Y-col3Y col3Y-col2Y col2Y-col1Y])/dvaSampleDist;
        degpervoltx=1/voltsPerDegreeX;
        degpervolty=1/voltsPerDegreeY;
        save([rootdir,date,'\volts_per_dva.mat'],'voltsPerDegreeX','voltsPerDegreeY')
        save([rootdir,date,'\',date(1:6),'_data\cal_vals.mat'],'xConds','yConds','allMeanPosX','allMeanPosY')
        save([rootdir,date,'\',date(1:6),'_data\cal_vals_no_outliers.mat'],'xConds','yConds','allMeanPosXexcludeOutliers','allMeanPosYexcludeOutliers')
    end
end
       