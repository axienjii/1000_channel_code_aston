function analyse_microstim_saccade14_letter_aston(date,allInstanceInd)
%%23/10/18
%Written by Xing, modified from Lick's analyse_microstim_saccade14_letter.m, extracts eye data during a
%saccade task during microstimulation of individual electrodes 
%(runstim_microstim_saccade_endpoints_aston.m). Three electrodes
%per array were selected (for which good current thresholds were previously obtained). 
%The goal is the check whether the saccade endpoints correspond roughly to 
%the expected phosphene locations, based on RF mapping. 50% catch trials.
%Uses serial port data to identify trial number. 
%Finds saccade end point using function calculateSaccadeEndpoint2,
%which calculates velocity of eye movements in dva per s, and identifies
%time points corresponding to peak velocities.
%Also generates data for Feng, to create movie of eye movements.

date=[date,'_aston'];
localDisk=0;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end
% dataDir=[rootdir,date,'\',date(1:6),'_data'];
dataDir=[rootdir,date,'\',date,'_data'];
matFile=[dataDir,'\microstim_saccade_',date,'.mat'];
if ~exist('dataDir','dir')
    copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);    
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
minCrossingTime=0;
switch date
    case '250918_B1_aston'
        electrodeNums1=[45 25 57];
        arrayNums1=9*ones(1,length(electrodeNums1));
        electrodeNums2=[23 52 64 51 5 16 56 46 63 38 40 48 55];
        arrayNums2=10*ones(1,length(electrodeNums2));
        electrodeNums3=[6 16 47 26 23 52 28 7 33 13 53];
        arrayNums3=12*ones(1,length(electrodeNums3));
        electrodeNums=[electrodeNums1 56 electrodeNums2 electrodeNums3];
        arrayNums=[arrayNums1 13 arrayNums2 arrayNums3];
        visualOnly=0;
        degPerVoltXFinal=0.0025;%guess- not measured on same day
        degPerVoltYFinal=0.0025;
    case '260918_B1_aston'
        electrodeNums3=53;
        arrayNums3=12;
        electrodeNums4=[21 16 48 59 30 64 63 35 9 51 62 12 24 56 50 42];
        arrayNums4=14*ones(1,length(electrodeNums4));
        electrodeNums5=[6 24 16 8 15 7 27 44 32 63 1 3 21 39 40 46 13 55 33 64 4 62 56 23 14 22 48 38 49];
        arrayNums5=15*ones(1,length(electrodeNums5));
        electrodeNums6=[56 41 17 33 19 22 23 32 55 64 45 49 46 3 50 42 40 44 26 7 58 60 52 43];
        arrayNums6=16*ones(1,length(electrodeNums6));
        electrodeNums=[electrodeNums3 electrodeNums4 electrodeNums5 electrodeNums6];
        arrayNums=[arrayNums3 arrayNums4 arrayNums5 arrayNums6];
        visualOnly=0;
        degPerVoltXFinal=0.0025;%guess- not measured on same day
        degPerVoltYFinal=0.0025;
    case '270918_B1_aston'
        electrodeNums=[43 34 36 62 48];
        arrayNums=16*ones(1,length(electrodeNums));
        electrodeNums=[electrodeNums 17 25 26 42 49 12 13 36 39 59 51 28 25 54 58 30 12 19 49 60 61 4 27 35];
        arrayNums=[arrayNums 11 11 11 11 11 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13];
        electrodeNums=[electrodeNums 15 51 23 38 40 46 55 56 63 28 52 16];
        electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
        arrayNums=[arrayNums 9 10 10 10 10 10 10 10 10 12 12 10];
        arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
        visualOnly=0;
        degPerVoltXFinal=0.0025;%guess- not measured on same day
        degPerVoltYFinal=0.0025;
    case '280918_B1_aston'
        electrodeNums=[55 56 63 28 52 16];
        arrayNums=[10 10 10 12 12 10];
        electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
        arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
        visualOnly=0;
        degPerVoltXFinal=0.0025;%guess- not measured on same day
        degPerVoltYFinal=0.0025;
    case '221018_B1_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[1 3 13 1 3 8 16 40 48 44 46 55 26 33 53 33 62 57 9 12 16 16 48 63 34 36 56];
        arrayNums=[8 8 8 9 9 9 10 10 10 11 11 11 12 12 12 13 13 13 14 14 14 15 15 15 16 16 16];
        currentThresholdChs=8;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%guess- not measured on same day
        degPerVoltYFinal=0.0025;
    case '241018_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[1 3 13 1 3 8 16 40 48 44 46 55 26 33 53 33 62 57 9 12 16 16 48 63 34 36 56];
        arrayNums=[8 8 8 9 9 9 10 10 10 11 11 11 12 12 12 13 13 13 14 14 14 15 15 15 16 16 16];
        currentThresholdChs=8;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%
        degPerVoltYFinal=0.0024;
    case '061118_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[9 64 49 16];
        arrayNums=[13 10 16 14];
        currentThresholdChs=12;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '061118_B4_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[57 58 49];
        arrayNums=[11 11 11];
        currentThresholdChs=12;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '071118_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[56 16 16 12 1 33 9];
        arrayNums=[16 14 15 14 8 13 13];
        currentThresholdChs=12;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '071118_B3_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[46 63 44];
        arrayNums=[15 15 15];
        currentThresholdChs=12;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '071118_B4_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[57 35 22 38 48 40 56 55];
        arrayNums=[13 8 8 8 15 15 15 13];
        currentThresholdChs=12;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '081118_B1_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[35 16 56 57 47 52 53 59 64 63];
        arrayNums=[8 14 16 13 12 12 12 13 13 13];
        currentThresholdChs=13;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '081118_B3_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[35 57 56];
        arrayNums=[8 13 16];
        currentThresholdChs=13;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '141118_B6_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[38 22 12 35 55 64 53 52];
        arrayNums=[8 8 14 14 16 16 12 12];
        currentThresholdChs=17;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '141118_B8_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[16];
        arrayNums=[12];
        currentThresholdChs=17;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;
    case '141118_B9_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[55 57 59 60 61 63 64];
        arrayNums=[13 13 13 13 13 11 11];
        currentThresholdChs=17;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;    
    case '151118_B1_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[55];
        arrayNums=[16];
        currentThresholdChs=17;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;    
    case '151118_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[12 16];
        arrayNums=[14 12];
        currentThresholdChs=17;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;   
    case '151118_B3_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[22];
        arrayNums=[8];
        currentThresholdChs=17;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;   
    case '161118_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[29];
        arrayNums=[8];
        currentThresholdChs=17;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;  
    case '161118_B1_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[57 58 64 9 35 60 61];
        arrayNums=[11 11 11 14 14 16 16];
        currentThresholdChs=18;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;    
    case '191118_B1_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[3];
        arrayNums=[8];
        currentThresholdChs=19;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;   
    case '191118_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[43 41 16 21 60];
        arrayNums=[16 16 14 14 11];
        currentThresholdChs=19;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;  
    case '191118_B4_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[35 61 57];
        arrayNums=[14 16 11];
        currentThresholdChs=19;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;  
    case '201118_B1_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[2 16 43 63 55 57 49 3 50 62];
        arrayNums=[8 14 16 11 13 13 13 9 9 9];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;  
    case '201118_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[35 28 38 50 59 21 30 43 41 49 54 63 2 26 42];
        arrayNums=[8 8 8 14 14 14 14 16 16 16 9 9 11 11 11];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;  
    case '201118_B3_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[2 16 43 63 3 50 62];
        arrayNums=[8 14 16 11 9 9 9];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024;  
    case '201118_B4_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[1 25 33 54 55];
        arrayNums=[13 13 13 11 11];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 
    case '201118_B5_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[2 35 28 21 43 54 63 2 26 42];
        arrayNums=[8 8 8 14 16 9 9 11 11 11];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 
    case '201118_B6_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[40 51 31 48 56 64 55];
        arrayNums=[16 16 16 16 16 16 16];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 
    case '201118_B7_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[40 56 63 48 46 44 4];
        arrayNums=[15 15 15 15 15 15 15];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 
    case '201118_B8_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[31 42 55];
        arrayNums=[16 11 11];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 
    case '201118_B10_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[6];
        arrayNums=[8];
        currentThresholdChs=20;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 
    case '211118_B1_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[1 50 43 59 25 59 56 57 33];
        arrayNums=[13 14 16 14 13 14 16 13 13];
        currentThresholdChs=21;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 
    case '211118_B2_aston'
        minCrossingTime=preStimDur-0.166;
        electrodeNums=[21 48 63 6 48 40 25];
        arrayNums=[14 16 11 8 16 16 13];
        currentThresholdChs=21;
        visualOnly=0;
        degPerVoltXFinal=0.0025;%estimated from previous time
        degPerVoltYFinal=0.0024; 


end

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

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
            if NEV.ElectrodesInfo(130).ConnectorPin==2
                eyeChannels=[130 131];
            elseif NEV.ElectrodesInfo(130).ConnectorPin==3
                eyeChannels=[129 130];
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
                    NSch{channelInd}=NSchOriginal.Data;
                end
            end
            save(eyeDataMat,'NSch');
        end       
        
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
        figInd1=figure;hold on
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
        if ~exist('goodArrays8to16','var')
            load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
        end
        for uniqueElectrode=1:length(electrodeNums)
            figInd9(uniqueElectrode)=figure;hold on
            array=arrayNums(uniqueElectrode);
            arrayColInd=find(arrays==array);
            electrode=electrodeNums(uniqueElectrode);
            electrodeIndTemp1=find(goodArrays8to16(:,8)==electrode);
            electrodeIndTemp2=find(goodArrays8to16(:,7)==array);
            electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
            impedance=goodArrays8to16(electrodeInd,6);
            RFx=goodArrays8to16(electrodeInd,1);
            RFy=goodArrays8to16(electrodeInd,2);
            if RFy<-500
                RFy=NaN;
            end
            
            electrodeInd=find(cell2mat(allElectrodeNum)==electrode);
            arrayInd=find(cell2mat(allArrayNum)==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
        
            trialDataXY={};
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
            saccadeEndTrials=[];
            electrodeTrials=[];
            timePeakVelocityXYs=[];
            timePeakVelocityXYSecs=[];
            trialNoTrials=[];
            trialDataX=[];
            trialDataY=[];
            trialDataXSmooth={};
            trialDataYSmooth={};
            trialDataXSmoothFix={};
            trialDataYSmoothFix={};
            startMicrostim=[];
            endMicrostim=[];
            posIndXTrials=[];
            posIndYTrials=[];
            baselineXChs=[];
            baselineYChs=[];
            for trialCounter=1:length(matchTrials)%for each correct microstim trial
                trialNo=matchTrials(trialCounter);%trial number, out of all trials from that session  
                trialNoTrials(trialCounter)=trialNo;
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
                timeSmoothFix=timeMicrostim-(166.7+allFixT(trialNo))*sampFreq/1000:timeReward;%timestamps from acquisition of fixation to reward delivery 
                trialDataXSmoothFix{trialCounter}=double(NSch{1}(timeSmoothFix));
                trialDataYSmoothFix{trialCounter}=double(NSch{2}(timeSmoothFix));
                startMicrostim(trialCounter)=allFixT(trialNo)*sampFreq/1000;
                endMicrostim(trialCounter)=(166.7+allFixT(trialNo))*sampFreq/1000;
%                 figure;
%                 plot(trialDataXSmoothFix{trialCounter});
%                 hold on
%                 yLims=get(gca,'ylim');
%                 plot([startMicrostim(trialCounter) startMicrostim(trialCounter)],[yLims(1) yLims(2)],'k:');
%                 plot([endMicrostim(trialCounter) endMicrostim(trialCounter)],[yLims(1) yLims(2)],'k:');
% %                 trialDataArtefactFix{trialCounter}=double(NSch{1}(timeSmoothFix));
% %                 plot(trialDataArtefactFix{trialCounter}+mean(trialDataXSmoothFix{trialCounter}));
                numDataPointsAfterStim=timeReward-timeMicrostim;
                eyepx=-0.15*sampFreq:double(numDataPointsAfterStim);
                eyepx=eyepx/sampFreq;
%                 [EYExs,EYEys] = eyeanalysis_baseline_correct(double(trialDataXSmooth{trialCounter}),double(trialDataYSmooth{trialCounter}),eyepx,sampFreq,1:size(trialDataX{1},1));
%                 figure(figInd1)
%                 subplot(2,1,1)
%                 plot(trialDataX{trialCounter});hold on
%                 subplot(2,1,2)
%                 plot(trialDataY{trialCounter});hold on
                figure(figInd2)
                subplot(2,1,1)
                plot(trialDataXSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                subplot(2,1,2)
                plot(trialDataYSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                baselineX=mean(trialDataXSmooth{trialCounter}(1:5000));
                baselineY=mean(trialDataYSmooth{trialCounter}(1:5000));
                baselineXTrials(trialCounter)=baselineX;
                baselineYTrials(trialCounter)=baselineY;
                %quick-and-dirty estimate of saccade end position:
                if length(trialDataXSmooth{trialCounter})>=10460
                    roughPosIndX=(trialDataXSmooth{trialCounter}(10460)-baselineX)*degPerVoltXFinal*Par.PixPerDeg;%position during saccade, very rough calculation
                    roughPosIndY=(trialDataYSmooth{trialCounter}(10460)-baselineY)*degPerVoltYFinal*Par.PixPerDeg;
                end
                %scatter(-roughPosIndX,-roughPosIndY,[],cols(arrayColInd,:),'MarkerFaceColor',cols(arrayColInd,:));
                %accurate calculation of saccade end position:
                numHistBins=50;
                posIndX=NaN;
                posIndY=NaN;
                posIndXs=[];
                posIndYs=[];
                posIndXSec=NaN;
                posIndYSec=NaN;
                timePeakVelocityXY=NaN;
                timePeakVelocityXYSec=NaN;
%                 if min(trialDataXSmooth{trialCounter})>5500&&max(trialDataYSmooth{trialCounter})<1500%exclude extreme outliers
%                     try
                        figInd7=figure;  
                        saccadeTimeAfterPeakVel=50/1000;%time interval following occurrence of peak velocity of eye movement, before saccade end point is calculated
                        saccadeCalcWin=50/1000;%duration of window, for calculation of saccade end point
                        trialDataXYSmooth{trialCounter}=sqrt((trialDataXSmooth{trialCounter}*degPerVoltXFinal).^2+(trialDataYSmooth{trialCounter}*degPerVoltYFinal).^2);%calculate displacement
                        timePeakVelocityXY=calculateSaccadeEndpoint3([1:length(trialDataXYSmooth{trialCounter})]',trialDataXYSmooth{trialCounter}',Par.PixPerDeg);%return the midpoints of the peaks of the bimodal distribution, relative to histogram bins
                        timePeakVelocityXY=timePeakVelocityXY(find(timePeakVelocityXY>minCrossingTime*sampFreq));%exclude spurious peaks that occur before stimulation
                        for peakVelInd=1:length(timePeakVelocityXY)
                            startWin=timePeakVelocityXY(peakVelInd)+saccadeTimeAfterPeakVel*sampFreq;
                            endWin=timePeakVelocityXY(peakVelInd)+(saccadeTimeAfterPeakVel+saccadeCalcWin)*sampFreq;
                            ax=gca;
                            yLims=get(gca,'ylim');
                            plot([startWin startWin],[yLims(1) yLims(2)],'k:');
                            plot([endWin endWin],[yLims(1) yLims(2)],'k:');
                            if length(trialDataXYSmooth{trialCounter})>=endWin
                                saccadeEndX(peakVelInd)=mean(trialDataXSmooth{trialCounter}(startWin:endWin));
                                ax=gca;
                                xLims=get(gca,'xlim');
                                plot([xLims(1) xLims(2)],[saccadeEndX(peakVelInd) saccadeEndX(peakVelInd)],'r:');
                                posIndXs(peakVelInd)=-(saccadeEndX(peakVelInd)-baselineX)*degPerVoltXFinal*Par.PixPerDeg;
                                posIndX=posIndXs(1);
                                saccadeEndY(peakVelInd)=mean(trialDataYSmooth{trialCounter}(startWin:endWin));
                                ax=gca;
                                xLims=get(gca,'xlim');
                                plot([xLims(1) xLims(2)],[saccadeEndY(peakVelInd) saccadeEndY(peakVelInd)],'r:');
                                posIndYs(peakVelInd)=(saccadeEndY(peakVelInd)-baselineY)*degPerVoltYFinal*Par.PixPerDeg;
                                posIndY=posIndYs(1);
                            end
                        end
                        subplot(2,1,1);
                        plot(trialDataXSmooth{trialCounter});hold on
                        if ~isempty(posIndXs)
                            if length(posIndXs)>1&&abs(posIndXs(2))>abs(posIndXs(1))
                                posIndXSec=posIndXs(2);%second saccade
                                timePeakVelocityXYSec=timePeakVelocityXY(2);
                            end
                        end
                        subplot(2,1,2);
                        plot(trialDataYSmooth{trialCounter});hold on
                        if ~isempty(posIndYs)
                            if length(posIndYs)>1&&abs(posIndYs(2))>abs(posIndYs(1))
                                posIndYSec=posIndYs(2);%second saccade
                            end
                        end
                            close(figInd7);
%                     catch ME
%                     end
%                 end
                cleanUp=1;%remove datapoints that are too close to fixation?
                if cleanUp==1
                    if posIndX<5||posIndY<5&&array~=16
                        manualCheck=1;
                        posIndX=NaN;
                        posIndY=NaN;
                    end
                end
                cleanUp2=1;%remove datapoints that are too far away?
                if cleanUp2==1
                    if posIndX>200||posIndY>200
                        manualCheck=1;
                        posIndX=NaN;
                        posIndY=NaN;
                    end
                end
                posIndXTrials(trialCounter)=posIndX;
                posIndYTrials(trialCounter)=posIndY;
                saccadeEndTrials(trialCounter,:)=[posIndX posIndY];
                electrodeTrials(trialCounter)=electrode;
                freqMicrostim=300;%microstimulation frequency in Hz
                pulseDuration=1000/freqMicrostim;%duration of each pulse in ms
                numPulsesTrain=50;%number of pulses delivered in a train on every trial
                if ~isempty(timePeakVelocityXY)
                    if strcmp(date,'110917_B3')%for monopolar stimulation, dasbit for target occurred at the end of stimulation
                        timePeakVelocityXYs(trialCounter)=(timePeakVelocityXY(1)/sampFreq-preStimDur+0.166)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity relative to end of microstimulation delivery, in ms
                        timePeakVelocityXYSecs(trialCounter)=(timePeakVelocityXYSec/sampFreq-preStimDur+0.166)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity for 2nd saccade, relative to end of microstimulation delivery, in ms
                    else %strcmp(date,'110917_B1')||strcmp(date,'110917_B2')%for bipolar stimulation, dasbit for target occurred at the beginning of stimulation
                        timePeakVelocityXYs(trialCounter)=(timePeakVelocityXY(1)/sampFreq-preStimDur)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity relative to end of microstimulation delivery, in ms
                        timePeakVelocityXYSecs(trialCounter)=(timePeakVelocityXYSec/sampFreq-preStimDur)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity for 2nd saccade, relative to end of microstimulation delivery, in ms
                    end
                else
                    timePeakVelocityXYs(trialCounter)=NaN;
                    timePeakVelocityXYSecs(trialCounter)=NaN;
                end
                figure(figInd3)
                scatter(posIndX,-posIndY,[],cols(arrayColInd,:),'MarkerFaceColor',cols(arrayColInd,:));
                
                figure(figInd4)    
                plot(posIndX,-posIndY,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                impCol=impedance*0.9/300+0.05;
                text(posIndX-0.05,-posIndY,num2str(electrode),'FontSize',6,'Color',[impCol impCol 1]);
                
                figure(figInd9(uniqueElectrode))%plot the saccade end points for an individual electrode, with the mean 
%                 subplot(11,10,uniqueElectrode);
                hold on
                plot(posIndX,-posIndY,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                impCol=impedance*0.9/300+0.05;
                text(posIndX-0.05,-posIndY,num2str(electrode),'FontSize',6,'Color',[impCol impCol 1]);
                
%                 close(figHistogram);
                figure(figInd8)
                plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                text(RFx+0.2,RFy,num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                if ~isnan(posIndXSec)&&~isnan(posIndYSec)
                    plot(posIndX,-posIndY,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                    plot(posIndXSec,-posIndYSec,'x:','Color',cols(arrayColInd,:));
                    plot([posIndX posIndXSec],[-posIndY -posIndYSec],':','Color',cols(arrayColInd,:));
                    text(posIndXSec+0.2,-posIndYSec,['(',num2str(electrode),')'],'FontSize',6,'Color',[0 0 0]);
                end
            end
            saccadeEndAllTrials=[saccadeEndAllTrials;saccadeEndTrials];
            electrodeAllTrials=[electrodeAllTrials;electrodeTrials'];
            arrayTrials=repmat(array,1,length(electrodeTrials));
            arrayAllTrials=[arrayAllTrials;arrayTrials'];
            timePeakVelocityXYsAllTrials=[timePeakVelocityXYsAllTrials;timePeakVelocityXYs'];
            timePeakVelocityXYSecsAllTrials=[timePeakVelocityXYSecsAllTrials;timePeakVelocityXYSecs'];
            meanSaccadeXY=[];
            stdSaccadeXY=[];
            if ~isempty(matchTrials)
                figure(figInd4)
                trialsIndElectrode=find(electrodeTrials==electrode);%identify trials where stimulation was delivered on a given electrode
                trialsXYElectrode=saccadeEndTrials(trialsIndElectrode,:);
                meanSaccadeXY=nanmean(trialsXYElectrode,1);%calculate mean of saccade end points
                stdSaccadeXY=nanstd(trialsXYElectrode,0,1);%calculate std of saccade end points
                for trialElectrodeInd=1:length(trialsIndElectrode)
                    plot([meanSaccadeXY(1) trialsXYElectrode(trialElectrodeInd,1)],[-meanSaccadeXY(2) -trialsXYElectrode(trialElectrodeInd,2)],'-','Color',[impCol impCol 1]);
                end
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                %             ellipse(stdSaccadeXY(1),stdSaccadeXY(2),meanSaccadeXY(1),-meanSaccadeXY(2),cols(arrayColInd,:));
                %             plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',mean(stdSaccadeXY));
                text(meanSaccadeXY(1)-0.05,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                
                figure(figInd9(uniqueElectrode))%plot the saccade end points for an individual electrode, with the mean
                for trialElectrodeInd=1:length(trialsIndElectrode)
                    plot([meanSaccadeXY(1) trialsXYElectrode(trialElectrodeInd,1)],[-meanSaccadeXY(2) -trialsXYElectrode(trialElectrodeInd,2)],'-','Color',[impCol impCol 1]);
                end
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                %             ellipse(stdSaccadeXY(1),stdSaccadeXY(2),meanSaccadeXY(1),-meanSaccadeXY(2),cols(arrayColInd,:));
                %             plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',mean(stdSaccadeXY));
                text(meanSaccadeXY(1)-0.05,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);

                save([rootdir,date,'\mean_saccade_endpoints_',date,'_ch',num2str(electrode),'_array',num2str(array),'.mat'],'meanSaccadeXY');
                
                figure(figInd10)%plot only the RF centres
                greenCol=[0 1 0;0 0.7 0;0 0.5 0;0 0.4 0];
                numGoodTrials=sum(~isnan(trialsXYElectrode(:,1)));
                if numGoodTrials>4
                    numGoodTrials=4;
                end
                stdCutoff=25;
                if numGoodTrials>0&&stdSaccadeXY(1)<stdCutoff&&stdSaccadeXY(2)<stdCutoff
                    plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',4,'MarkerFaceColor',greenCol(numGoodTrials,:));
                    text(RFx+0.15,RFy,num2str(electrode),'FontSize',7,'Color',[0 0 0]);
                    ellipse(stdSaccadeXY(1),stdSaccadeXY(2),RFx,RFy,cols(arrayColInd,:));
                end
                
                figure(figInd5)
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                ellipse(stdSaccadeXY(1),stdSaccadeXY(2),meanSaccadeXY(1),-meanSaccadeXY(2),cols(arrayColInd,:));
                plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                text(meanSaccadeXY(1)-0.07,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                text(RFx-0.07,RFy,num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                plot([meanSaccadeXY(1) RFx],[-meanSaccadeXY(2) RFy],'-','Color',cols(arrayColInd,:));
                
                figure(figInd6)
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                text(meanSaccadeXY(1)+0.2,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                text(RFx+0.2,RFy,num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                plot([meanSaccadeXY(1) RFx],[-meanSaccadeXY(2) RFy],'-','Color',cols(arrayColInd,:));
                
                figure(figInd8)
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                text(meanSaccadeXY(1)+0.2,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                plot([meanSaccadeXY(1) RFx],[-meanSaccadeXY(2) RFy],'-','Color',cols(arrayColInd,:));
            
                figure(figInd9(uniqueElectrode))
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
                title('saccade endpoints');
                for arrayInd=1:length(arrays)
                    text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
                end
                ax=gca;
                ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
                ax.XTickLabel={'0','2','4','6','8'};
                ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
                ax.YTickLabel={'-8','-6','-4','-2','0'};
                xlabel('x-coordinates (dva)')
                ylabel('y-coordinates (dva)')
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                pathname=fullfile(rootdir,date,['saccade_endpoints_dva_array_',num2str(array),'_electrode_',num2str(electrode),'_',date]);
                print(pathname,'-dtiff');
                close(figInd9(uniqueElectrode))
                baselineXChs{uniqueElectrode}=baselineXTrials;
                baselineYChs{uniqueElectrode}=baselineYTrials;
                trialDataXSmoothChs{uniqueElectrode}=trialDataXSmooth;
                trialDataYSmoothChs{uniqueElectrode}=trialDataYSmooth;
                trialNoChs{uniqueElectrode}=trialNoTrials;
                posIndXChs{uniqueElectrode}=posIndXTrials;
                posIndYChs{uniqueElectrode}=posIndYTrials;
                trialDataXSmoothFixChs{uniqueElectrode}=trialDataXSmoothFix;
                trialDataYSmoothFixChs{uniqueElectrode}=trialDataYSmoothFix;
                startMicrostimChs{uniqueElectrode}=startMicrostim;
                endMicrostimChs{uniqueElectrode}=endMicrostim;
            end
        end
        save([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'baselineXChs','baselineYChs','trialDataXSmoothFixChs','trialDataYSmoothFixChs','trialNoChs','posIndXChs','posIndYChs','startMicrostimChs','endMicrostimChs');
        
% %         
        figure(figInd10)
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
        title(['RF locations, SD saccade end points, max SD = ',num2str(stdCutoff)]);
        for arrayInd=1:length(arrays)
            text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
        end
        ax=gca;
        ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
        ax.XTickLabel={'0','2','4','6','8'};
        ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
        ax.YTickLabel={'-8','-6','-4','-2','0'};
        xlabel('x-coordinates (dva)')
        ylabel('y-coordinates (dva)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(rootdir,date,['RF_centres_dva_',date,'_std',num2str(stdCutoff)]);
        print(pathname,'-dtiff','-r600');
        
        figure;
        subplot(2,1,1)
        histogram(timePeakVelocityXYsAllTrials)
        hold on
        yLims=get(gca,'ylim');
        plot([-165 -165],[yLims(1) yLims(2)],'k:')
        plot([0 0],[yLims(1) yLims(2)],'k:')
        ylabel('counts')
        plot([-165 -165],[yLims(1) yLims(2)],'k:')
        plot([0 0],[yLims(1) yLims(2)],'k:')
%         xlim([0 400])
        xlabel('time (ms)')
        ylabel('counts')
        subplot(2,1,2)
        histogram(timePeakVelocityXYSecsAllTrials)
        hold on
        yLims=get(gca,'ylim');
        plot([-165 -165],[yLims(1) yLims(2)],'k:')
        plot([0 0],[yLims(1) yLims(2)],'k:')
        ylabel('counts')
        pathname=fullfile(rootdir,date,['all_saccade_latencies_relative_to_end_microstim_',date]);
        print(pathname,'-dtiff','-r600'); 
        
        figure;
        histogram(timePeakVelocityXYsAllTrials)
        hold on
        histogram(timePeakVelocityXYSecsAllTrials)
        ylabel('counts')
        yLims=get(gca,'ylim');
        plot([-165 -165],[yLims(1) yLims(2)],'k:')
        plot([0 0],[yLims(1) yLims(2)],'k:')
        pathname=fullfile(rootdir,date,['saccade_latencies_blue_second_red_relative_to_end_microstim_',date]);
        print(pathname,'-dtiff','-r600');
        
        save([rootdir,date,'\saccade_endpoints_',date,'.mat'],'saccadeEndAllTrials','electrodeAllTrials','arrayAllTrials','timePeakVelocityXYsAllTrials','timePeakVelocityXYSecsAllTrials');
        
%         figure(figInd2)
%         subplot(2,1,1)
%         switch date
%             case '070917_B13'
%                 ylim([-1000 500])
%             case '110917_B1'
%                 ylim([6000 11000])
%             case '110917_B2'
%                 ylim([6000 11500])
%             case '110917_B3'
%                 ylim([7000 11500])
%         end
%         ylim([7000 11500])
%         xlabel('time')
%         ylabel('raw X trace')
%         subplot(2,1,2)
%         switch date
%             case '070917_B13'
%                 ylim([-500 500])
%             case '110917_B1'
%                 ylim([-2500 100])
%             case '110917_B2'
%                 
%             case '110917_B3'
%                 ylim([-2600 0])
%         end
%         ylim([-2600 0])
%         xlabel('time')
%         ylabel('raw Y trace')
%         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         pathname=fullfile('D:\data',date,['instance1_eye_traces_align_to_end_microstim_pulsetrain_',date]);
%         print(pathname,'-dtiff','-r600'); 
        
        figure(figInd3)
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
        title('saccade endpoints'); 
        for arrayInd=1:length(arrays)
            text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
        end
        xlabel('x-coordinates (pixels)')
        ylabel('y-coordinates (pixels)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(rootdir,date,['saccade_endpoints_pixels_',date]);
        if cleanUp==1
            pathname=[pathname,'_cleaned'];
        end
        print(pathname,'-dtiff','-r600');   
        
        ax=gca;
        ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
        ax.XTickLabel={'0','2','4','6','8'};
        ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
        ax.YTickLabel={'-8','-6','-4','-2','0'};
        xlabel('x-coordinates (dva)')
        ylabel('y-coordinates (dva)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(rootdir,date,['saccade_endpoints_dva_',date]);
        if cleanUp==1
            pathname=[pathname,'_cleaned'];
        end
        print(pathname,'-dtiff','-r600');   
        
        figure(figInd4)
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
        title('saccade endpoints');
        for arrayInd=1:length(arrays)
            text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
        end
        xlabel('x-coordinates (pixels)')
        ylabel('y-coordinates (pixels)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(rootdir,date,['saccade_endpoints_pixels_mean_filled_',date]);
        print(pathname,'-dtiff','-r600');

        figure(figInd5)
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
        title('saccade endpoints and RF centres');
        for arrayInd=1:length(arrays)
            text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
        end
        xlabel('x-coordinates (pixels)')
        ylabel('y-coordinates (pixels)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(rootdir,date,['saccade_endpoints_RFs_std_',date]);
        print(pathname,'-dtiff','-r600');
        
        figure(figInd6)
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250 200],'k:');
        plot([-200 300],[0 0],'k:');
%         plot([-200 300],[200 -300],'k:');
%         ellipse(50,50,0,0,[0.1 0.1 0.1]);
%         ellipse(100,100,0,0,[0.1 0.1 0.1]);
%         ellipse(150,150,0,0,[0.1 0.1 0.1]);
%         ellipse(200,200,0,0,[0.1 0.1 0.1]);
        text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
        axis equal
        xlim([-20 220]);
        ylim([-160 20]);
        title('saccade endpoints (filled) and RF centres');
        for arrayInd=1:length(arrays)
            text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
        end
        ax=gca;
        ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
        ax.XTickLabel={'0','2','4','6','8'};
        ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
        ax.YTickLabel={'-8','-6','-4','-2','0'};
        xlabel('x-coordinates (dva)')
        ylabel('y-coordinates (dva)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(rootdir,date,['saccade_endpoints_RFs_',date]);
        print(pathname,'-dtiff','-r600');
        
        figure(figInd8)
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250 200],'k:');
        plot([-200 380],[0 0],'k:');
%         plot([-200 300],[200 -300],'k:');
%         ellipse(50,50,0,0,[0.1 0.1 0.1]);
%         ellipse(100,100,0,0,[0.1 0.1 0.1]);
%         ellipse(150,150,0,0,[0.1 0.1 0.1]);
%         ellipse(200,200,0,0,[0.1 0.1 0.1]);
        text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
        axis equal
        xlim([-20 360]);
        ylim([-220 20]);
        title('saccade endpoints (filled), second saccade endpoints (X), and RF centres');
        for arrayInd=1:length(arrays)
            text(260,0-6*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
        end
        ax=gca;
        ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8 Par.PixPerDeg*10 Par.PixPerDeg*12];
        ax.XTickLabel={'0','2','4','6','8','10','12'};
        ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
        ax.YTickLabel={'-8','-6','-4','-2','0'};
        xlabel('x-coordinates (dva)')
        ylabel('y-coordinates (dva)')
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(rootdir,date,['saccade_endpoints_RFs_second_saccade_',date]);
        print(pathname,'-dtiff','-r600');      
        
    end
end
pause=1;