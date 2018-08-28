function analyse_RF_barsweep

nevfile = 'D:\data\060617_B2\instance8.nev'
NEV=openNEV(nevfile);
nsfile = 'D:\data\060617_B2\instance8.ns6'
NS=openNSx(nsfile);

Fs=NS.MetaTags.SamplingFreq;
%Get bits
bits = round(log2(double(NEV.Data.SerialDigitalIO.UnparsedData)));
bitsamps = double(NEV.Data.SerialDigitalIO.TimeStamp);
bittimes = bitsamps./Fs; %Convert to milliseconds (not necessary - just for checking)


%Correct trials have a stimulus bit (1) followed by a correct bit(2)
follow = [bits(2:end);NaN];
correct = find(bits==1&follow==2); %index into correct trials
%Trial identity immediately follows correct bit
trialident = bits(correct(1:end-1)+2)-2;
trialident = [trialident;NaN];


%Load log file
load('Z:\060617_B2_sample\RF_barsweep_20170606_B2')
%We have 470 trials in MAT file, 469 correct stimuli in bits

%Find problem
[[1:length(trialident)]',trialident,MAT(1:length(trialident),1),trialident==MAT(1:length(trialident),1)]
%Somthing weird happened around bit 4648, correct trial 340
%Lots of extra bits - probably a missed stimulus bit here
%Remove MAT(341,:) and everything should be synced again
MAT(341,:) = [];
[[1:length(trialident)]',trialident,MAT(1:length(trialident),1),trialident==MAT(1:length(trialident),1)]
%It works, but there are occasional mismatches - use MAT

%USe MAT file
TI = MAT(:,1); %Trial Ident
stimon = bitsamps(correct); %Stimon sample

%NOw extract ENV from the correct trials
ntrials = length(correct);

%Number of samples to extract pre/post bit
prestim = round(0.5.*Fs);
dur = round(3.*Fs);
nchans = length(NS.ElectrodesInfo);
downsampleFreq=30;
ENV = zeros(nchans,dur./downsampleFreq,ntrials);
FiltOrder  = 2;    % filter order
for N = 1:ntrials
    Raw = NS.Data(:,(stimon(N)-prestim+1):(stimon(N)-prestim+dur));
    for C = 1:nchans
        %BANDPASS
        Fbp=[500,5000];
        Fn = Fs/2; % Nyquist frequency
        [B, A] = butter(FiltOrder, [min(Fbp)/Fn max(Fbp)/Fn]); % compute filter coefficients
        dum = filtfilt(B, A, double(Raw(C,:))); % apply filter to the data
        %RECTIFY
        dum = abs(dum);
        %LOW-PASS
        Fl=200;
        Fn = Fs/2; % Nyquist frequency
        [B, A] = butter(FiltOrder,Fl/Fn,'low'); % compute filter coefficients
        dum = filtfilt(B, A, dum);
        %Downsample
        ENV(C,:,N) = downsample(dum,downsampleFreq); % apply filter to the data and downsample
    end
end

%NOw run standard bar-sweep analysis
%Go through trialtypes and get neural data
t = (1:(dur/Fs).*(Fs/downsampleFreq))-(1000*prestim/Fs);
ModS = zeros(nchans,4);
ModM = zeros(nchans,4);
Ons = zeros(nchans,4);
Offs = zeros(nchans,4);

fig = 1;
if fig
    figure,hold on
    colind = jet(nchans);
end

for chn = 1:nchans
    
    for n = 1:4
        %Get trials with this motion direction
        f = find(TI == n);
        
        %Average them
        MUAm(n,:) = nanmean(ENV(chn,:,f),3);
        MUAs(n,:) = nanstd(ENV(chn,:,f),[],3)./sqrt(length(f));
        
        %Get noise levels before smoothing
        BaseT = find(t >-300 & t < 0);
        Base = nanmean(MUAm(n,BaseT));
        BaseS = nanstd(MUAm(n,BaseT));
        
        %Smooth it to get a maximum...
        gt = find(t>0 & t<1000);
        sm = smooth(MUAm(n,gt),30);
        [mx,mi] = max(sm);
        Scale = mx-Base;
        
        %Is the max significantly different to the base?
        SigDif(chn,n) = mx > (Base+(1.*BaseS));
        
        %Now fit a Gaussian to the signal
        %Starting guesses are based on the location and height of the
        %maximum value
        ts = t(t>0 & t<LOG.BarDur*1000);
        mua2fit = MUAm(n,t>0 & t<LOG.BarDur*1000)-Base;
        starting = [t(gt(mi)) 200 Scale 0];
        [y,params] = gaussfit(ts,mua2fit,starting,0);
        
        if fig
            subplot(2,2,n),plot(ts,mua2fit,'b',ts,y,'r')
        end
        
        %Onset and offset encompass 95% of the Gaussian
        Ons(chn,n) = params(1)-(1.65.*params(2));
        Offs(chn,n) = params(1)+(1.65.*params(2));
        if fig
            h = line([Ons(chn,n),Ons(chn,n)],get(gca,'YLim'));
            set(h,'Color',[1 0 1])
            h = line([Offs(chn,n),Offs(chn,n)],get(gca,'YLim'));
            set(h,'Color',[1 0 1])
        end
        
        SNR(chn)=Scale/BaseS;
    end
    %PAUse here to see each graph
    chn
%     drawnow
%     pause
end

if saveout
    save('FirstResult','Ons','Offs','SigDif','SNR')
else
    load(savename)
end

%SKIP TO HERE
figure
speed = LOG.BarSpeed;
xo = LOG.RFx;
yo = LOG.RFy;
bardist = LOG.BarDist;
SNRcutoff = 3;
for chn = 1:nchans
    %ONly plot channels where all directon were signifcant and teh SNR is
    %high enough
    if sum(SigDif(chn,:)) == 4 && SNR(chn)>SNRcutoff
        %Now distance = speed*time
        %This gives distanbce travelled by bar in pixels before the onset and
        %offset
        onsdist = speed.*(Ons(chn,:)/1000);
        offsdist = speed.*(Offs(chn,:)/1000);
        
        %Stimuli 1-4 go
        %1 = horizontal left-to-right (180 deg),
        %2 = bottom to top
        %3 = right to left
        %4 = top to bottom
        angles = [180 270 0 90];
        
        %Get starting position of bars
        sx = xo+(bardist./2).*cosd(angles);
        sy =yo+(bardist./2).*sind(angles);
        
        %Angular distance moved
        %(direction is opposite to angle of starting
        %position)
        on_angx = onsdist.*cosd(180-angles);
        on_angy = onsdist.*sind(angles);
        off_angx = offsdist.*cosd(180-angles);
        off_angy = offsdist.*sind(angles);
        
        %So the on and off points are starting position + angular distance...
        onx = sx+on_angx;
        ony = sy-on_angy;
        offx = sx+off_angx;
        offy = sy-off_angy;
        
        %get RF vboundaries
        bottom = (ony(2)+offy(4))./2;
        right = (onx(1)+offx(3))./2;
        top =   (ony(4)+offy(2))./2;
        left =   (onx(3)+offx(1))./2;
        
        RF.centrex(chn) = (right+left)./2;
        RF.centrey(chn) = (top+bottom)./2;
        
        RF.sz(chn) = sqrt(abs(top-bottom).*abs(right-left));
        RF.szdeg(chn) = sqrt(abs(top-bottom).*abs(right-left))./LOG.Par.PixPerDeg;
        
        XVEC1 = [left  right  right  left  left];
        YVEC1 = [bottom bottom  top top  bottom];
        
        RF.XVEC1(chn,:) = XVEC1;
        RF.YVEC1(chn,:) = YVEC1;
        
        h = line(XVEC1,YVEC1);
        set(h,'Color',colind(chn,:))
        axis square
        hold on
        scatter(0,0,'r','f')
        scatter(RF.centrex(chn),RF.centrey(chn),36,colind(chn,:),'f')
        axis([-512 512 -384 384])
        hold on,scatter(sx,sy)
        disp(['channel: ' ,num2str(chn)])
        disp(['centerx = ',num2str(RF.centrex(chn))])
        disp(['centrey = ',num2str(RF.centrey(chn))])
        %position in degrees
        RF.ang(chn)= atand(RF.centrey(chn)./RF.centrex(chn));
        
        %pix2deg conversion
        RF.ecc(chn) = sqrt(RF.centrex(chn).^2+RF.centrey(chn).^2)./LOG.Par.PixPerDeg;
        
        % disp(['Angle = ',num2str(RF_ang(chn))])
        disp(['Ecc = ',num2str(RF.ecc(chn))])
        disp(' ')
        
        text(RF.centrex(chn),RF.centrey(chn),num2str(chn))
        %Save out centx
    else
        RF.centrex(chn)=0;
        RF.centrey(chn)=0;
    end
end

save('RFresult','RF','Ons','Offs','SigDif','speed','SNR')
% if ~isempty(RFx)
%     %SCatter on markers
%     hold on,scatter(RFx,RFy,'MarkerFaceColor',[0.8 0.8 0.8])
%     for i = 1:length(RFx)
%         text(RFx(i),RFy(i),(['x=' num2str(RFx(i)) ', y=' num2str(RFy(i))]))
%     end
% end