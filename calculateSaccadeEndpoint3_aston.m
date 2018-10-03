function timePeakVelocity=calculateSaccadeEndpoint3(x,y,tempPixPerDeg)
%Written by Xing 15/9/17
%Takes in velocity of the saccadic movement in dva/s as second input arg, and the bin number as the first input arg.
%Identifies time points
%at which peak velocities occur. Averages eye position within 50-ms window,
%starting 50 ms after peak velocity occurs, to generate saccade end point
%coordinates.

sampFreq=30000;
binDur=10;%in ms
binWidth=binDur/1000*sampFreq;%number of samples within bin of duration binDur
bins=1:binWidth:length(x);
velocity=[];
for binInd=1:length(bins)-2
    velocity(binInd)=abs((mean(y(binInd*binWidth+1:(binInd+1)*binWidth))-mean(y((binInd-1)*binWidth+1:binInd*binWidth))))*tempPixPerDeg;
end
% figure
% plot(velocity)
% hold on
peakVelocity=max(velocity);
higherInds=find(velocity>=peakVelocity/4);
lowerInds=find(velocity<peakVelocity/4)+1;
binMaxVelocity=intersect(higherInds,lowerInds)%find first bin where velocity crosses threshold
timePeakVelocity=binMaxVelocity*binWidth;

% plot([binMaxVelocity binMaxVelocity],[-10 15],'k:');

% ax=gca;
% yLims=get(gca,'ylim');
% for i=1:length(timePeakVelocity)
%     plot([timePeakVelocity(i) timePeakVelocity(i)],[yLims(1) yLims(2)],'r:');
% end

% for binInd=1:length(x)-1
%     velocity(binInd)=y(binInd+1)-y(binInd);
% end