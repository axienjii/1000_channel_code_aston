function ana_online_RF_flashgrid

%Online analysis for single channel spiking data
%Matt, May 2015

tankname = 'Bobo_20130919';            %Tank to analyse
blockno = 3;                            %Block to analyse, multiple blocks from the same day can ber added as a vector e.g. [2,3,4]
sortcode = 0;                           %sortcode of spikes

%Directory of Tank
datadir = 'D:\Mappings\Bobo_mappings\';

%Details of mapping:
%We need the positons of the stimuli here, but we don;t have a logfile
%So we just have to write in the grid co-ordinates here:
gridx = linspace(0,400,21);
gridy = linspace(0,400,21);

%Make the index into gridx which converts wordbits to gridx and grid y
%positions
z = 0;
for x = 1:length(gridx)
    for y = 1:length(gridy)
        z = z+1;
        details(z,:)= [x,y,z];
    end
end

%Extract the data from the tank
blocknames = ['Block-',num2str(blockno)];
clear EVENT
EVENT.Mytank = [datadir,tankname];
EVENT.Myblock = blocknames;
%Extract around stimulus bit, there is one per check/flash
EVENT = Exinf4_stimnew_sort(EVENT);
Trials = EVENT.Trials.stim_onset;

%Get ENV1
EVENT.Triallngth =  1.0;
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
EVENT.Myevent = 'SNP1';
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

%Subtract off the overall baseline level for ENV
baseT = find(px>-0.2 & px<0);
base = mean(nanmean(MUA(:,baseT)));
MUA = MUA-base;

%activity vector
anaT = find(px>0 & px<0.25);
avmua = nanmean(MUA(:,anaT),2);
avpsth = nanmean(PSTH(:,anaT),2);

%Now map activity to location
Word = EVENT.Trials.word;
for n = 1:length(unique(Word))
    
    %Get all trials with this wordbit (i.e. location)
    f = find(Word == n);
    %Look up coordinate index for this position
    xind = details(n,1);
    yind = details(n,2);
    N(yind,xind) = length(f);
    %Asssign data
    if length(f)>1
        MUAm(yind,xind) = nanmean(avmua(f));
        PSTHm(yind,xind) = nanmean(avpsth(f));
    elseif length(f) == 1
        MUAm(yind,xind) = avmua(f);
        PSTHm(yind,xind) = avpsth(f);
    else
        MUAm(yind,xind) = NaN;
        PSTHm(yind,xind) = NaN;
    end
end

%Figure 
figure,subplot(2,2,1),hold on
imagesc(gridx,gridy,MUAm)
title('Envelope')
axis xy
subplot(2,2,2),hold on
imagesc(gridx,gridy,PSTHm)
axis xy
title('SUA')

%Fit Gaussians
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,1)
%The following code is very sensitive to incorrect guesses for the
%starting positions
%Best to estimate the peak point beforehand using the maximum response
MM = MUAm;
v = reshape(MM,size(MM,1)*size(MM,2),1);
[mx,my] = meshgrid(gridx,gridy);
vx = reshape(mx,size(MM,1)*size(MM,2),1);
vy = reshape(my,size(MM,1)*size(MM,2),1);
[crap,ij] = max(v);
mxx = vx(ij);
mxy = vy(ij);
Starting=[mxx,mxy,100,100,0];
[y,params] =Gauss2D_RFfit4_MUA(MM,gridx,gridy,0,Starting);
buf = corrcoef(reshape(MM,size(MM,1)*size(MM,2),1),reshape(y,size(MM,1)*size(MM,2),1));
rs = buf(1,2);
scatter(params(1),params(2),'w','filled')
disp(['MUA RF center (Gaussian): x = ',num2str(round(params(1))),', y = ',num2str(round(params(2)))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Contour fits
%Useful for judging hotspots of V4 RFs
%2d smoothing filter
subplot(2,2,3),hold on
%Currently defined in grid spacing, could be improved
win = gausswin(4);
win = win*win';
win = win./sum(sum(win));

MM = MUAm;
%Smooth with Gaussian filter
MMS = filter2(win,MM);
%Trim the egdes
MMSc = MMS(2:end-1,2:end-1);
[ct,f] = contourf(gridx(2:end-1),gridy(2:end-1),MMSc,10);

%Go through and get levels
lvi = 1;
k = 1;
clear lvs,clear lvv,clear lvn
while lvi<length(ct)
    %The value
    lvv(k) = ct(1,lvi);
    %The number of contour segments
    lvn(k) = ct(2,lvi);
    %The index
    lvs(k) = lvi;
    lvi = lvi+lvn(k)+1;
    k = k+1;
end
%Unique levels (11)
lev = unique(lvv);
%FInd the highest level
m2 = lev(end);
f = find(lvv==m2);
%If there are more than one, take the largest
if length(f) > 1
    v = lvn(f);
    [i,j] = max(v);
    f = f(j);
end
%Get contours
cth = ct(:,lvs(f)+1:1:lvs(f)+lvn(f));
ctx = mean(cth(1,:));
cty = mean(cth(2,:));
scatter(ctx,cty,'w','filled')
disp(['MUA RF center (Contour): x = ',num2str(round(ctx)),', y = ',num2str(round(cty))])

%SAME for PSTH

%Fit Gaussians
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,2,2),hold on
%The following code is very sensitive to incorrect guesses for the
%starting positions
%Best to estimate the peak point beforehand using the maximum response
MM = PSTHm;
v = reshape(MM,size(MM,1)*size(MM,2),1);
[mx,my] = meshgrid(gridx,gridy);
vx = reshape(mx,size(MM,1)*size(MM,2),1);
vy = reshape(my,size(MM,1)*size(MM,2),1);
[crap,ij] = max(v);
mxx = vx(ij);
mxy = vy(ij);
Starting=[mxx,mxy,100,100,0];
[y,params] =Gauss2D_RFfit4_MUA(MM,gridx,gridy,0,Starting);
buf = corrcoef(reshape(MM,size(MM,1)*size(MM,2),1),reshape(y,size(MM,1)*size(MM,2),1));
rs = buf(1,2);
scatter(params(1),params(2),'w','filled')
disp(['SUA RF center (Gaussian): x = ',num2str(round(params(1))),', y = ',num2str(round(params(2)))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Contour fits
%Useful for judging hotspots of V4 RFs
%2d smoothing filter
subplot(2,2,4),hold on
%Currently defined in grid spacing, could be improved
win = gausswin(4);
win = win*win';
win = win./sum(sum(win));

MM = PSTHm;
%Smooth with Gaussian filter
MMS = filter2(win,MM);
%Trim the egdes
MMSc = MMS(2:end-1,2:end-1);
[ct,f] = contourf(gridx(2:end-1),gridy(2:end-1),MMSc,10);

%Go through and get levels
lvi = 1;
k = 1;
clear lvs,clear lvv,clear lvn
while lvi<length(ct)
    %The value
    lvv(k) = ct(1,lvi);
    %The number of contour segments
    lvn(k) = ct(2,lvi);
    %The index
    lvs(k) = lvi;
    lvi = lvi+lvn(k)+1;
    k = k+1;
end
%Unique levels (11)
lev = unique(lvv);
%FInd the highest level
m2 = lev(end);
f = find(lvv==m2);
%If there are more than one, take the largest
if length(f) > 1
    v = lvn(f);
    [i,j] = max(v);
    f = f(j);
end
%Get contours
cth = ct(:,lvs(f)+1:1:lvs(f)+lvn(f));
ctx = mean(cth(1,:));
cty = mean(cth(2,:));
scatter(ctx,cty,'w','filled')
disp(['SUA RF center (Contour): x = ',num2str(round(ctx)),', y = ',num2str(round(cty))])




