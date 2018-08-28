function [degpervolty,saccRT] = eyeanalysis_calibration(EYExs,EYEys,eyepx,eyert,SF,figy)

%takes baseline corrected eye data and returns the degreespervolt
%data must come from one condition
%Also returns saccRT into the bargain
%eyert is time window is which a saccade could be made (index into eyepx)
%figy is position for correct response in degrees

%SET-UP for vertical saccades at the moment

%Calibration
%========================================================================
%In the N/U task the targets
%reaction time period
if 0
%     figure,subplot(2,1,1),plot(eyepx,EYExs)
%     subplot(2,1,2),plot(eyepx,EYEys)
end

%Work out the saccadic RT
%Use peak velocity
ntrials = size(EYEys,1);
saccRT = zeros(ntrials,1);
smwin = round(20e-3*SF);
for n = 1:ntrials
    vel = smooth(diff(EYEys(n,eyert)),smwin,'lowess');
    [pks,loc,w,prom] = findpeaks(abs(vel));
%      figure,plot(abs(vel)),hold on,scatter(loc,prom,'r'),scatter(loc,pks,'g')
    promz = zscore(prom);
    promi = find(abs(promz)>1.5,1,'first');
    saccRTix = loc(promi);
    if saccRTix == 1
        saccRT(n) = NaN;
    else
        saccRT(n) = eyepx(eyert(saccRTix));
    end
end

%Take the mean eye position for a period of 50ms after the peak VEL
delay = 0.03; %s after peak velocity
dur = 0.05; %sec to average position
yvolt = NaN(ntrials,1);
for n = 1:ntrials
    f = find((eyepx>(saccRT(n)+delay))&(eyepx<(saccRT(n)+delay+dur)));
    %         xvolt(n) = mx(n,sacct(n));
    yvolt(n) = nanmean(EYEys(n,f));
end


yvoltm = nanmedian(yvolt);

%Lets have a look at some trials to see how accurate we were
%The red line shows our estimate (its hard to see for x because this was a
%condition with a near vertical saccade)
if 0
%     figure,subplot(2,1,1),plot(eyepx(eyert),EYExs(:,eyert))
%     hold on,h = line([eyepx(eyert(1)) eyepx(eyert(end))],[xvoltm xvoltm])
%     set(h,'Color',[1 0 0])
%     figure,plot(eyepx(eyert),EYEys(:,eyert))
%     hold on,h = line([eyepx(eyert(1)) eyepx(eyert(end))],[yvoltm yvoltm])
%     set(h,'Color',[1 0 0])
end

%Looks good, so lets get the multiplication factor for this
%eye data
%BEcause this condition is a vertical saccade I only use it for the y
%calibration,
%     degpervoltx = figx./xvoltm; %NOT USED
degpervolty = figy./yvoltm;


if 0
    %Now multiply up the eye data
    %USE EYEDATAY
    EYExd = EYExs.*degpervolty;
    EYEyd = EYEys.*degpervolty;
    
    %Now your eye data is uin degrees and ready to go...
    %Y looks good, x doesn't, but if you repeat for another condition it should
    %be fine...
    imageT = find(eyepx > 0 & eyepx < 0.6);
%     figure,subplot(1,2,1),imagesc(eyepx(imageT),1:size(EYEyd,1),EYExd(:,imageT)),colorbar
%     subplot(1,2,2),imagesc(eyepx(imageT),1:size(EYEyd,1),EYEyd(:,imageT)),colorbar
end

return

