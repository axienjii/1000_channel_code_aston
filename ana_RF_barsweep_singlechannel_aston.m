function ana_RF_barsweep

%Analyses data from bar sweeps using runstim_RF_barsweep
%Will also work on older files with a bit of tweaking.

tankname = 'Martin_20170516';            %Tank to analyse
blockno = 11;                            %Block to analyse, multiple blocks from the same day can ber added as a vector e.g. [2,3,4]
sortcode = 3;                           %sortcode of spikes
anamua = 3;

% pixperdeg = 24.6187;
%x/y co-ords of centre-point
% xo = 300;
% yo = 0;
xo = 0;
yo = 0;


%Directory of Tank
datadir = 'Z:\Anne\Martin\';

% To plot dots on top of data:
%USeful fo rtesting potential positions for stimuli
%Set to empty e.g. RFx = []; if you don;t want this
RFx = []; %Duvel
RFy = []; % Duvel

% make figures or not:
%Makes a figure for each RF
fig = 1;

%No logfile so have to hardcode
speed = 407.2958; %this is speed in pixels per second
% speed = 338.2609%; based on 13.75 speed
% speed = 407.2958;
% speed=433.1559;
% speed = 355.5757;
bardur = 1.25; %duration in seconds
bardist = 509.1198;
% bardist = 444.4697;
% bardist = 541.4449;
% speed = 277.99;
% speed = 2523.1355;
% bardist = 347.49;
% bardist = 315.1694;
%Screen details (just pixperdeg required)
pixperdeg = 25.8601;

%Extract the data from the tank
blocknames = ['Block-',num2str(blockno)];
clear EVENT
EVENT.Mytank = [datadir,tankname];
EVENT.Myblock = blocknames;
%Extract around stimulus bit, there is one per check/flash
EVENT = Exinf4_stimnew_sort(EVENT);
Trials = EVENT.Trials.stim_onset;

%Get ENV1
EVENT.Triallngth =  1.9;
EVENT.Start =      -0.3;
EVENT.type = 'strms';
EVENT.Myevent = 'ENV1';
EVENT.CHAN = 1;
MUA = Exd4(EVENT, Trials);
MUA = MUA{1}';

%Timebase
SF = 762.9395;
px = ((0:(SF.*EVENT.Triallngth))./SF)+EVENT.Start;

%Get Spikes
EVENT.Myevent = 'EA__';
EVENT.type = 'snips';   %must be a stream event
Snip = Exsniptimes2(EVENT, Trials); %Makes also the sort code

clear SnipT
for g = 1:length(Snip)
    %Extract all the snip times on this trial to a
    %structure
    times = Snip{g}(:,1);
    codes = Snip{g}(:,2);
    %get only those that have the right sortcode
    buf = times(codes == sortcode);
    try
        SnipT(g).Times = buf;
    catch
        SnipT(g).Times = [];
    end
end

%For MAking spike PSTHs
winsz = 21; %Should be odd numbered (i.e. 21)
winstd = 3; %In down-sampled samples(i.e. 3)
halfwin = (winsz-1)./2;
gwin = normpdf(linspace(-halfwin,halfwin,winsz),0,winstd);
gwin = gwin./sum(gwin);

if ~isempty(SnipT)
    %Get the spikes if they exist
    PSTH = NaN(length(SnipT),length(px));
    for t = 1:length(SnipT)
        %Make convolved spiketrain
        %Get spikes belonging to this trial
        spktime = SnipT(t).Times;
        
        if ~isempty(spktime)
            %MAke stick function and convolve with a Gaussian
            %USe px for the time bin so the MUAs and MUAe are diretcly
            %compatible.
            %Given the way histc works we have to include one extra sample
            %at the end to capture spikes that fall in the last bin, then
            %trim this.
            stick = histc(spktime,[px';px(end)+(1/SF)]);
            stick(end) = [];
            %Convolve with a Gaussian window to make PSTH
            buf = conv(stick,gwin);
            %Trim the convolved data
            buf = buf(halfwin+1:(length(px)+halfwin));
            %Convert to Hz and store
            PSTH(t,:) = buf'.*SF;
        end
    end
end


%RF
%details%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ModS = zeros(1,4);
ModM = zeros(1,4);
Ons = zeros(1,4);
Offs = zeros(1,4);

figure,hold on
colind = jet(96);

Word = EVENT.Trials.word;
direct{1} = 'L 2 R';
direct{2} = 'D 2 U';
direct{3} = 'R 2 L';
direct{4} = 'U 2 D';

for n = 1:4
    %Get trials with this motion direction
    f = find(Word == n);
    
    if anamua
    %Average them
    MUAm = nanmean(MUA(f,:));
%     MUAs = nanstd(MUA(f,:))./sqrt(length(f));
    else
         MUAm = nanmean(PSTH(f,:));
    end
    
    %Get noise levels before smoothing
    BaseT = find(px >-0.2 & px < 0.0);
    Base = nanmean(MUAm(BaseT));
    BaseS = nanstd(MUAm(BaseT));
    
    %Smooth it to get a maximum...
    sm = smooth(MUAm,20);
    [mx,mi] = max(sm);
    Scale = mx-Base;
    
    
    %Now fit a Gaussian to the signal
    %Starting guesses are based on the location and height of the
    %maximum value
    mua2fit = MUAm-Base;
    %time, std, peak, 0
    [y,params] = gaussfit(px,mua2fit,starting);
    
    if fig
        subplot(2,2,n),plot(px,mua2fit,'b',px,y,'r')
        title(direct{n})
    end
    
    %Onset and offset encompass 95% of the Gaussian
    Ons(1,n) = params(1)-(1.65.*params(2));
    Offs(1,n) = params(1)+(1.65.*params(2));
    if fig
        h = line([Ons(1,n),Ons(1,n)],get(gca,'YLim'));
        set(h,'Color',[1 0 1])
        xlim([-0.3 1.7])
        h = line([Offs(1,n),Offs(1,n)],get(gca,'YLim'));
        set(h,'Color',[1 0 1])
         xlim([-0.3 1.7])
    end
    
    SNR(1)=Scale/BaseS
end


%SKIP TO HERE
figure

    %ONly plot channels where all directon were signifcant and teh SNR is
    %high enough
  
        %Now distance = speed*time
        %This gives distanbce travelled by bar in pixels before the onset and
        %offset
        onsdist = speed.*Ons(1,:);
        offsdist = speed.*Offs(1,:);
        
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
        
        RF.centrex(1) = (right+left)./2;
        RF.centrey(1) = (top+bottom)./2;
        
        RF.sz(1) = sqrt(abs(top-bottom).*abs(right-left));
        RF.szdeg(1) = sqrt(abs(top-bottom).*abs(right-left))./pixperdeg;
        
        XVEC1 = [left  right  right  left  left];
        YVEC1 = [bottom bottom  top top  bottom];
        
        RF.XVEC1(1,:) = XVEC1;
        RF.YVEC1(1,:) = YVEC1;
        
        h = line(XVEC1,YVEC1);
        set(h,'Color',[1 0 0])
        axis square
        hold on
        scatter(0,0,'r','f')
        scatter(RF.centrex(1),RF.centrey(1),36,[1 0 0],'f')
        axis([-512 512 -384 384])
        hold on,scatter(sx,sy)
%         disp(['channel: ' ,num2str(1), ' on array ', num2str(array(1))])
        disp(['centerx = ',num2str(RF.centrex(1))])
        disp(['centrey = ',num2str(RF.centrey(1))])
        %positio0n in degrees
        RF.ang(1)= atand(RF.centrey(1)./RF.centrex(1));
        theta = RF.ang(1);
        if RF.centrex(1)<0
            theta = 180+theta;
        elseif RF.centrey(1)<0
            theta = 360+theta;
        end
        RF.theta = theta
%         theta = 180+RF.ang(1);      
%         theta = 360+RF.ang(1);
    
        
        %pix2deg conversion
        RF.ecc(1) = sqrt(RF.centrex(1).^2+RF.centrey(1).^2);
        
        % disp(['Angle = ',num2str(RF_ang(1))])
        disp(['Ecc = ',num2str(RF.ecc(1))])
        disp(' ')
        
        text(RF.centrex(1),RF.centrey(1),num2str(1))
        %Save out centx
    


if ~isempty(RFx)
    %SCatter on markers
    hold on,scatter(RFx,RFy,'MarkerFaceColor',[0.8 0.8 0.8])
    for i = 1:length(RFx)
        text(RFx(i),RFy(i),(['x=' num2str(RFx(i)) ', y=' num2str(RFy(i))]))
    end
end
