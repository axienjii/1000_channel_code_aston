function [onCrossingIndTS offCrossingIndTS]=readThresholdCrossings(eventOfInterest,thresholdCrossingsOn,thresholdCrossingsOff);
%Written by Xing 16/7/18
%Short piece of code to read out time stamps of onest and offset of
%microstimulation, according to signal in Sync Pulse.

onCrossingIndTS=[];
offCrossingIndTS=[];
for eventInd=1:length(eventOfInterest)
    tempInd=find(thresholdCrossingsOn>=eventOfInterest(eventInd));
    if ~isempty(tempInd)
        onCrossingInd=tempInd(1);
        intervalOn=thresholdCrossingsOn(onCrossingInd)-eventOfInterest(eventInd);%time elapsed between event bit and onset of sync pulse which indicates start of microstimulation train
        if intervalOn>100
            pauseHere=1;
        end
        onCrossingIndTS(eventInd)=thresholdCrossingsOn(onCrossingInd);
        tempInd=find(thresholdCrossingsOff>=eventOfInterest(eventInd));
        offCrossingInd=tempInd(1);
        intervalOff=thresholdCrossingsOff(offCrossingInd)-eventOfInterest(eventInd);%time elapsed between event bit and onset of sync pulse which indicates start of microstimulation train
        if intervalOff>5100%should be around 5031, i.e. time interval between data points is 1/30000, and number of data points that correspond to duration of 167 ms (microstimulation train) is 0.167/(1/30000)
            pauseHere=1;
        end
        offCrossingIndTS(eventInd)=thresholdCrossingsOff(offCrossingInd);
    end
end