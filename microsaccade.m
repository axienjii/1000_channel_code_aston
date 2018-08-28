function [EYExd,EYEyd,Micro] = microsaccade(EYExd,EYEyd,eyeanaT,SF,thresh)

%Data should be in degrees

%MICRO-SACCADE detection
%===========================================
ntrials = size(EYExd,1);
smwin = round(0.02.*SF); %Smoothing window (20ms)

%Get maximum velocity in analysis window
maxv = zeros(ntrials,1);
for n = 1:ntrials
    %Convert to angular velocity (pythag)
    angvel = sqrt(EYExd(n,eyeanaT).^2+EYEyd(n,eyeanaT).^2);
    vel = smooth(diff(angvel),smwin);
    %Get maximum velocity, mulitply by SF to get in degs/s
    maxv(n) = max(abs(vel)).*SF;
end

%Does maximum velocity exceed micro-saccade threshold (15 degs/s)?
Micro = maxv>thresh;

if 0
    figure
    subplot(1,2,1),hist(maxv,200)
    subplot(1,2,2)
    f = find(Micro);
    for m = 1:length(f)
%         plot(eyeanaT,EYExd(Micro(m),eyeanaT),'b')
         hold on
        plot(eyeanaT,sqrt(EYEyd(f(m),eyeanaT).^2+EYExd(f(m),eyeanaT).^2),'g')
    end
end

% EYExd(Micro,:) = NaN;
% EYEyd(Micro,:) = NaN;

return


% %THE OLD WAY
% %OK - lets look for micro-saccades
% %This will be an index (Micro) containing the trials with micro-saccades in...
% %You coulfd then remove these and recalculate the mean, variance etc..
% 
% %Which trials have micro-saccades?
% 
% %First subtract off mean and take analysis period only
% 
% %Make step function and convolcve it with the eye signal of each
% %trial, this highlights changes in eye position
% step = [ones(1,10).*-1,ones(1,10)];
% clear bufferxd
% for u = 1:ntrials
%     bufferxd(u,:) = conv(bufferx(u,:),step);
% end
% 
% %exclude the first 20 and last 20 time bins as these have
% %edge effects
% inc = 21:1:(szeyeana-20);
% %Then take the maximum abs value
% bufferxd = max(abs(bufferxd(:,inc)'));
% %Now divide by the mean and look for large deviations
% %This is a bit arbitrary but it seems to work, could probably also
% %some Z-scoring or something similar here....
% Micro = find((bufferxd./mean(bufferxd))>5);
% 
% %Do the same for the Y direction
% for u = 1:ntrials
%     bufferyd(u,:) = conv(buffery(u,:),step);
% end
% %exclude the first 20 and last 20 time bins
% inc = 21:1:(szeyeana-20);
% bufferyd = max(abs(bufferyd(:,inc)'));
% %stitch it together with the micro-saccades idenitified from the y
% %data.
% Micro = [Micro,find((bufferyd./mean(bufferyd))>5)];
% 
% %OK we should now have identified the trials with micro-saccades on
% 
% %Lets have a look at these trials
% %xdata in blue, ydata in green
% if 1
%     figure
%     for m = 1:length(Micro)
%         plot(eyepx(eyeanatime),bufferx(Micro(m),:),'b')
%         hold on
%         plot(eyepx(eyeanatime),buffery(Micro(m),:),'g')
%     end
% end
% 
% %Remove micro-saccade trials
% EYExs(Micro,:) = NaN(length(Micro),size(EYExs,2));
% EYEys(Micro,:) = NaN(length(Micro),size(EYExs,2));
