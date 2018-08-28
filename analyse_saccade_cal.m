function analyse_saccade_cal(date,allInstanceInd)
%14/7/17
%Written by Xing, analyses eye data from a 2-phosphene task, in which
%saccades were made to visually presented targets, to calculate the pixels
%per volt for the eye traces (separately for X and Y). 

load('D:\data\110917_B3\110917_B3_data\PAR.mat')

degpervoltx=0.0027;
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
        StimB=1;
        TargetB=2;
        unknownB=4;
        CorrectB=7;
        RewardB=3;
        encodesCorrect=2.^[StimB TargetB unknownB CorrectB RewardB];%[2 4 16 128 8]
        
        temp=find(NEV.Data.SerialDigitalIO.UnparsedData==2^RewardB);
        goodRewInd=[];
        goodTargetInd=[];
        for rewInd=1:length(temp)
            if temp(rewInd)>=5
                trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(temp-4:temp);
                if sum(trialEncodes==encodesCorrect')==length(encodesCorrect)
                    goodRewInd=[goodRewInd temp(rewInd)];%indices of encodes for reward delivery
                    goodTargetInd=[goodTargetInd temp(rewInd)-3];%indices of encodes for target onset
                end
            end
        end
        timestampTrialRew=NEV.Data.SerialDigitalIO.TimeStamp(goodRewInd);
        timestampTrialTarg=NEV.Data.SerialDigitalIO.TimeStamp(goodTargetInd);
        posIndXvolt=[];
        posIndYvolt=[];
        for trialInd=1:length(goodRewInd)
%             figure
            trialDataX=NSch{1}(timestampTrialTarg(trialInd):timestampTrialRew(trialInd)+postRewDur*sampFreq);
            trialDataY=NSch{2}(timestampTrialTarg(trialInd):timestampTrialRew(trialInd)+postRewDur*sampFreq);
%             subplot(2,1,1)
%             plot(trialDataX);hold on
%             subplot(2,1,2)
%             plot(trialDataY);hold on
            baselineX=mean(trialDataX(1:2000));
            baselineY=mean(trialDataY(1:2000));
            timePeakVelocityX=calculateSaccadeEndpoint2([1:length(trialDataX)]',trialDataX',degpervoltx,PixPerDeg);%return the time at which peak velocity occurs
            timePeakVelocityX=timePeakVelocityX(find(timePeakVelocityX>minCrossingTime*sampFreq));%exclude spurious peaks that occur before stimulation
            if ~isempty(timePeakVelocityX)
                timePeakVelocityX=timePeakVelocityX(1);
            else
                timePeakVelocityX=NaN;
            end
            timePeakVelocityY=calculateSaccadeEndpoint2([1:length(trialDataY)]',trialDataY',degpervoltx,PixPerDeg);%return the time at which peak velocity occurs
            timePeakVelocityY=timePeakVelocityY(1);
            timePeakVelocityY=timePeakVelocityY(find(timePeakVelocityY>minCrossingTime*sampFreq));%exclude spurious peaks that occur before stimulation
            if ~isempty(timePeakVelocityY)
                timePeakVelocityY=timePeakVelocityY(1);
            else
                timePeakVelocityY=NaN;
            end
            if ~isnan(timePeakVelocityX)&&~isnan(timePeakVelocityY)
                figure;
                saccadeTimeAfterPeakVel=50/1000;%time interval following occurrence of peak velocity of eye movement, before saccade end point is calculated
                saccadeCalcWin=50/1000;%duration of window, for calculation of saccade end point
                subplot(2,1,1);
                plot(trialDataX);hold on
                startWin=timePeakVelocityX+saccadeTimeAfterPeakVel*sampFreq;
                endWin=timePeakVelocityX+(saccadeTimeAfterPeakVel+saccadeCalcWin)*sampFreq;
                ax=gca;
                yLims=get(gca,'ylim');
                plot([startWin startWin],[yLims(1) yLims(2)],'k:');
                plot([endWin endWin],[yLims(1) yLims(2)],'k:');
                if length(trialDataX)>=endWin
                    saccadeEndX=mean(trialDataX(startWin:endWin));
                    ax=gca;
                    xLims=get(gca,'xlim');
                    plot([xLims(1) xLims(2)],[saccadeEndX saccadeEndX],'r:');
                    posIndXvolts=-(saccadeEndX-baselineX)*PixPerDeg;
                    posIndXvolt(trialInd)=abs(posIndXvolts(1));
                end
                subplot(2,1,2);
                plot(trialDataY);hold on
                startWin=timePeakVelocityY+saccadeTimeAfterPeakVel*sampFreq;
                endWin=timePeakVelocityY+(saccadeTimeAfterPeakVel+saccadeCalcWin)*sampFreq;
                ax=gca;
                yLims=get(gca,'ylim');
                plot([startWin startWin],[yLims(1) yLims(2)],'k:');
                plot([endWin endWin],[yLims(1) yLims(2)],'k:');
                if length(trialDataY)>=endWin
                    saccadeEndY=mean(trialDataY(startWin:endWin));
                    ax=gca;
                    xLims=get(gca,'xlim');
                    plot([xLims(1) xLims(2)],[saccadeEndY saccadeEndY],'r:');
                    posIndYvolts=-(saccadeEndY-baselineY)*PixPerDeg;
                    posIndYvolt(trialInd)=abs(posIndYvolts(1));
                end
            end
        end
        figure;
        histogram(posIndXvolt)
        histogram(posIndYvolt)
        meanX=mean(posIndXvolt(find(posIndXvolt>=40000)));
        stdX=std(posIndXvolt(find(posIndXvolt>=40000)));
        meanY=mean(posIndYvolt(find(posIndYvolt>=40000)));
        stdY=std(posIndYvolt(find(posIndYvolt>=40000)));
        targetLocationPixels=200;%coded in the stimulus presentation runstim
        degPerVoltXFinal=targetLocationPixels/meanX;
        degPerVoltYFinal=targetLocationPixels/meanY;
    end
end
       