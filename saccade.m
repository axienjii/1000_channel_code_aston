function [SaccT,SaccM,SaccA] = saccade(EYExd,EYEyd,eyeanaT,SF,thresh)

%Data should be in degrees, time in milliseconds, already baseline
%corrected

%MICRO-SACCADE detection
%===========================================
ntrials = size(EYExd,1);
smwin = round(0.02.*SF); %Smoothing window (20ms)

%50ms windows
win = round(0.05.*SF);

% figure

%Get maximum velocity in analysis window
SaccT = NaN(ntrials,1);
SaccM = NaN(ntrials,1);
SaccA = NaN(ntrials,1);
for n = 1:ntrials
    %Convert to angular velocity (pythag)
    angvel = sqrt(EYExd(n,eyeanaT).^2+EYEyd(n,eyeanaT).^2);
    vel = smooth(diff(angvel),smwin);
    %Get first saccade, mulitply by SF to get in degs/s
    absvel = abs(vel).*SF;
    f = find(absvel>thresh,1,'first');
    
    if ~isempty(f)
        if f>(win+1) && f<(length(eyeanaT)-2*win)-1
            
            %Get 50ms before/after
            prex = nanmean(EYExd(n,eyeanaT(f-win):eyeanaT(f-1)));
            prey = nanmean(EYEyd(n,eyeanaT(f-win):eyeanaT(f-1)));
            postx = nanmean(EYExd(n,eyeanaT(f+win):eyeanaT(f+2.*win)));
            posty = nanmean(EYEyd(n,eyeanaT(f+win):eyeanaT(f+2.*win)));
            
            %Details
            SaccT(n) = eyeanaT(f);
            SaccM(n) = hypot((postx-prex),(posty-prey));
            SaccA(n) = atan2d((posty-prey),(postx-prex));
        end
    end
    
%     plot(EYEyd(n,eyeanaT)),hold on
%     plot(EYExd(n,eyeanaT),'r')
%     if ~isempty(f)
%     scatter(f,SaccM(n),'m','filled')
%     end
%     title(num2str(SaccA(n)))
%     drawnow
%     pause
%     hold off
    
    
end

return

