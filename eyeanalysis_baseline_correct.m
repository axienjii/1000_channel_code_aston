function [EYExs,EYEys] = eyeanalysis_baseline_correct(EYEX,EYEY,eyepx,SF,usetrials)

%Returns the cleaned up eye data in degrees
%Data must include at least 150ms of pre-stimulus time (eyepx<0)
%Removes the baseline, correcting for 'Z' presses
% EYEX is a matrix of x positions, trials on the rows, time on the cols
% EYEY is the y positions
% eyepx the time index.
% SF - sample freq
% usetrials, use only these trials for estimating the baseline

%For the eye analysis we need to estimate the baseline eye position, i.e.
%we need to correct for 'Z' presses.
%We can't just subtract a pre-stimulus baseline as then your eye
%position would always be centred on (0,0) and you would hide the
%variability in eye position.
%Instead we subtract off an estimate of the 'Z-ed' eye position.
%This approaches uses lowess regresion over trials

%Lets first have a look at our data
[ntrials,samples] = size(EYEX);

if nargin<5
    usetrials = 1:ntrials;
end

if 0
%     figure,subplot(1,2,1)
%     imagesc(eyepx,1:ntrials,EYEX)
%     subplot(1,2,2),imagesc(eyepx,1:ntrials,EYEY)
end

%LOWESS approach
ew = find(eyepx>-0.15 & eyepx<0);
x = mean(EYEX(usetrials,ew),2)';
y = mean(EYEY(usetrials,ew),2)';
%20 trial smoothing
xs = smooth(usetrials,x,20,'lowess');
ys = smooth(usetrials,y,20,'lowess');
%Interpolate back in any bad trials
xs(1:ntrials) = interp1(usetrials,xs,1:ntrials);
ys(1:ntrials) = interp1(usetrials,ys,1:ntrials);
%Fill any Nans at start and end
xs(1:usetrials(1)) = xs(usetrials(1));
xs(usetrials(end):ntrials) = xs(usetrials(end));
ys(1:usetrials(1)) = ys(usetrials(1));
ys(usetrials(end):ntrials) = ys(usetrials(end));

%Subtract from eye data
EYExs = EYEX-repmat(xs,1,samples);
EYEys = EYEY-repmat(ys,1,samples);


if 0
    %Lets relook at the data after the subtraction
%     figure,subplot(1,2,1)
%     imagesc(eyepx,1:ntrials,EYExs)
%     subplot(1,2,2),imagesc(eyepx,1:ntrials,EYEys)
end
