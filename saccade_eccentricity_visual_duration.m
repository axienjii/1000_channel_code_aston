function saccade_eccentricity_visual_duration
%Written by Xing on 31/7/19
%Run on control visual task, in which visual stimulus (simulated phosphene)
%is presented for a given duration (ranging from 50 to 450 ms), and eye
%data is analysed to check whether a relationship exists between saccade
%eccentricity and stimulus duration.

date='310719_B2_aston';
uniqueElectrodeNums=[1 1 3 16 44 26 33 9 63 34];
uniqueArrayNums=[8 9 9 10 11 12 13 14 15 16];
pixperdeg=26;
for i=1:size(saccadeEndAllTrials,1)
    eccentricityAllTrials(i)=sqrt(saccadeEndAllTrials(i,1)^2+saccadeEndAllTrials(i,2)^2)/pixperdeg;
end
figure;
for electrodeInd=1:length(uniqueElectrodeNums)
    subplot(2,ceil(length(uniqueElectrodeNums)/2),electrodeInd)
    electrode=uniqueElectrodeNums(electrodeInd);
    array=uniqueArrayNums(electrodeInd);
    temp1=find(electrodeAllTrials==electrode);
    temp2=find(arrayAllTrials==array);
    inds=intersect(temp1,temp2);
    eccentricityElectrode=eccentricityAllTrials(inds);
    stimDursElectrode=stimDurAllTrials(inds);
    stimDurs=unique(stimDursElectrode);
    for condInd=1:length(stimDurs)
        trialInd=find(stimDursElectrode==stimDurs(condInd));
        eccentricityCond=eccentricityElectrode(trialInd);
        eccentricityCondMean(condInd)=nanmean(eccentricityCond);
        eccentricityCondSD(condInd)=nanstd(eccentricityCond);
    end
    errorbar(stimDurs,eccentricityCondMean,eccentricityCondSD);
    title(['e',num2str(electrode),' a',num2str(array)])
end
