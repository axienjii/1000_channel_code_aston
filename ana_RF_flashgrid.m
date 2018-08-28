function ana_RF_flashgrid

%Analyses data from runstim_RF_GridMap
%Normally used for mapping V4
%Matt, May 2015

analysedata = 1;        %If data already analysed you can skip straight to the graphs
saveout = 0;            %Save out the data  at the end?
savename = 'FlashMap_Manny_20150527';   %Name of data file to save
tankname = 'Manny_20150527';            %Tank to analyse
blockno = [1,2,3,4];                            %Block to analyse, multiple blocks from the same day can ber added as a vector e.g. [2,3,4]
%the logfile stem - the block number will be added to the end e.g.
%'RF_GridMap_Manny_20150522_B'
logfilestem = 'RF_GridMap_Manny_20150527_B';
%Was the TDT project mapped? 1=yes, 0 = no
%If not it will use the standard channel mappings.
mapproject = 1;

%Directory of Tank
datadir = 'Z:\Jessy\Manny\tdtdata\';
% datadir = '\\vs01\VandC\Shared\Jessy\Manny\tdtdata\';
%Directory of stimulus logfile
logdir = 'Z:\Jessy\Manny\stimlogs\';
% logdir = '\\vs01\VandC\Shared\Jessy\Manny\stimlogs\';
% To plot dots on top of data:
%USeful for testing potential positions for stimuli
%Set to empty e.g. STIMx = []; if you don;t want this
%Manny grid results
STIMx = [12,     30,   71, 130,  14]; 
STIMy = [-110, -160, -126, -70, -67];
%Slightly adjusted for bar sweeps
STIMx = [12,     30,   71, 125,  14]; %V1, V4, V1, V1, V1
STIMy = [-110, -160, -126, -68, -67];

%Details of mapping: read in from logfile, just read first block
load([logdir,logfilestem,num2str(blockno(1))])
gridx = LOG.Grid_x;
gridy = LOG.Grid_y;
pixperdeg = LOG.Par.PixPerDeg;

%%%%%%%%%%%%%%%%%%%%%%%%
%Standard array to channel mapping
array = zeros(1,192);
array(1:24) = 1;
array(25:48) = 2;
array(49:72) = 3;
array(73:96) = 4;
array(97:120) = 5;
array(121:144) = 6;
array(145:168) = 7;
array(169:192) = 8;
%Array colors
%Red,green,blue,black,yellow,cyan,magenta,orange
arraycol = [1 0 0;0 1 0;0 0 1;0 0 0;1 1 0;0 1 1;1 0 1;1 0.5 0];

env1chns = [1:96];
env2chns = [1:96];

if analysedata
    
    if ~mapproject
        %If you use an unmapped TDT project the mapping has to be done here
        %This is the stanadrad mapping for Charlie, Duvel, Manny etc
        chnorder = [45 88 84 80 76 72 68 60 47 6 2 8 86 82 78 64 56 52 41 43 21 23 4 ...
            66 74 70 71 67 39 37 17 19 7 11 62 50 69 63 35 33 13 15 91 3 54 ...
            58 65 59 31 29 9 5 87 83 95 57 61 55 25 27 1 93 85 79 75 96 92 53 ...
            46 48 44 89 81 77 73 94 90 49 42 40 36 32 28 24 20 16 12 51 38 ...
            34 30 26 22 18 14 10];
        
        chnorder = [chnorder,chnorder+96];
    else
        chnorder = 1:192;
    end
    
    %Concatenate blocks
    Env = [];
    Word = [];
    for B = 1:length(blockno)
        
    %Extract the data from the tank
    blocknames = ['Block-',num2str(blockno(B))];
    clear EVENT
    EVENT.Mytank = [datadir,tankname];
    EVENT.Myblock = blocknames;
    %Extract aroujd target bit as these give the compkteted trials
    %If you don;t have this file it is available at:
    %Z:\Shared\MFILES\TDT2ML
    EVENT = Exinf4_targnew(EVENT);
    
    EVENT.Triallngth =  1.0;
    EVENT.Start =      -0.3;
    EVENT.type = 'strms';
    f = find(~isnan(EVENT.Trials.stim_onset));
    Trials = EVENT.Trials.stim_onset(f);
    SF = 762.9395;
    %Timebase
    px = ((1:(SF.*EVENT.Triallngth))./SF)+EVENT.Start;
    
    %Get ENV1
    EVENT.Myevent = 'ENV1';
    EVENT.CHAN = env1chns;
    Env1 = Exd4(EVENT, Trials);
    
    EVENT.Myevent = 'ENV2';
    EVENT.CHAN = env2chns;
    Env2 = Exd4(EVENT, Trials);
    
    %Now stitch them together
    Env(B).data = [Env1;Env2];
   
    %Word bit gives trial identity
    %IS word the right length?
    match = length(EVENT.Trials.word) == size(Env1{1},2)
    if ~match
        donkey
    end
    Word = [Word;EVENT.Trials.word];

    end
    
    %MAke the index into gridx which converts words to gridx and grid y
    %positions
    z = 0;
    for x = 1:length(gridx)
        for y = 1:length(gridy)
            z = z+1;
            details(z,:)= [x,y,z];
        end
    end
    
    %Go through trialtypes and get neural data
    for mapchn = chnorder
        
        %get data from different blocks
        MUA = [];
        for B = 1:length(blockno)
            MUA = [MUA;Env(B).data{chnorder(mapchn)}'];
        end
        
        %First remove any outliers
        %The peaks get chopped off unless z-scores are calculated down the
        %columns
        vz = (MUA-repmat(nanmean(MUA),size(MUA,1),1))./repmat(nanstd(MUA),size(MUA,1),1);
        vzv = reshape(vz,size(MUA,1).*size(MUA,2),1);
        v = reshape(MUA,size(MUA,1).*size(MUA,2),1);
        v(abs(vzv)>6) = NaN;
        MUA = reshape(v,size(MUA,1),size(MUA,2));
        
        %Overall z?
        v = reshape(MUA,size(MUA,1).*size(MUA,2),1);
        vz = (nanmean(v)-v)./nanstd(v);
        v(abs(vz)>8) = NaN;
        MUA = reshape(v,size(MUA,1),size(MUA,2));
        
        %Subtract off the overall baseline level
        baseT = find(px>-0.2 & px<0);
        base = mean(nanmean(MUA(:,baseT)));
        MUA = MUA-base;
        
        %activity vector
        anaT = find(px>0 & px<0.25);
        av = nanmean(MUA(:,anaT),2);
        
        %Now map activity to location
        for n = 1:length(unique(Word))
            
            %Get all trials with this wordbit (i.e. location)
            f = find(Word == n);
           %Look up coordinate index for this position
            xind = details(n,1);
            yind = details(n,2);
            N(yind,xind) = length(f);
            %Asssign data
            if length(f)>1
                MUAm(yind,xind,mapchn) = nanmean(av(f));
            elseif length(f) == 1
                MUAm(yind,xind,mapchn) = av(f);
            else
                MUAm(yind,xind,mapchn) = NaN;
            end
        end
        mapchn
    end
    if saveout
        save(savename,'MUAm','N','gridx','gridy','details','pixperdeg')
    end
else
    load(savename)
end



%SKIP TO HERE if not analysing
if 1
    %Basic plots,One figure per array
    %Not needed if plotting Gauss/Contour centers below
    ch = 0;
    for a = 1:8
        figure
        for z = 1:24
            ch = ch+1;
            subplot(5,5,z)
            imagesc(gridx,gridy,MUAm(:,:,ch))
            axis xy
        end
    end
end
     

%Fit Gaussians
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following code is very sensitive to incorrect guesses for the
%starting positions
%Best to estimate the peak point beforehand using the maximum response
ch = 0;
for a = 1:8
    for z = 1:24
        ch = ch+1;
        MM = MUAm(:,:,ch);
        v = reshape(MM,size(MM,1)*size(MM,2),1);
        [mx,my] = meshgrid(Grid_x,Grid_y);
        vx = reshape(mx,size(MM,1)*size(MM,2),1);
        vy = reshape(my,size(MM,1)*size(MM,2),1);
        [crap,ij] = max(v);
        mxx = vx(ij);
        mxy = vy(ij);
        Starting=[mxx,mxy,Par.PixPerDeg,Par.PixPerDeg,0];
        [y,params(ch,:)] =Gauss2D_RFfit4_MUA(MM,Grid_x,Grid_y,0,Starting);
        buf = corrcoef(reshape(MM,size(MM,1)*size(MM,2),1),reshape(y,size(MM,1)*size(MM,2),1));
        rs(ch) = buf(1,2);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Contour fits
%Useful for judging hotspots of V4 RFs

%2d smoothing filter
%Currently defined in grid spacing, could be improved
win = gausswin(4);
win = win*win';
win = win./sum(sum(win));
ch = 0;
h1 = figure; %Dummy figure for contour plots
for a = 1:8
    for z = 1:24
        ch = ch+1;
        MM = MUAm(:,:,ch);
        %Smooth with Gaussian filter
        MMS = filter2(win,MM);
        %Trim the egdes
        MMSc = MMS(2:end-1,2:end-1);
    
        [ct,f] = contourf(Grid_x(2:end-1),Grid_y(2:end-1),MMSc,10);
        
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
        ctx(ch) = mean(cth(1,:));
        cty(ch) = mean(cth(2,:));
    end
end
close(h1)
        

%Plot out everything and calculate array centers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ch = 0;
for a = 1:8
    %rs below 0.25 is generally rubbish
    ach = find(array == a & rs>0.25);
    nchans(a) = length(ach)
    xc(a) = mean(params(ach,1));
    yc(a) = mean(params(ach,2));
    cxc(a) = mean(ctx(ach));
    cyc(a) = mean(cty(ach));
    figure
    for z = 1:24
        ch = ch+1;
        subplot(5,5,z)
        imagesc(Grid_x,Grid_y,MUAm(:,:,ch)),axis xy
        axis square
        %2d Gauss centers (white)
        hold on,scatter(params(ch,1),params(ch,2),[],'w','filled')
        %Stimulus chouices (m)
        for s = 1:length(STIMx)
        hold on,scatter(STIMx(s),STIMy(s),[],'m','filled')
        end
        %Array centers (black = Gauss, yellow = Contour)
        hold on,scatter(xc(a),yc(a),[],'k','filled')
        hold on,scatter(cxc(a),cyc(a),[],'y','filled')
        colormap jet
    end
end
    
a = 1;
    

