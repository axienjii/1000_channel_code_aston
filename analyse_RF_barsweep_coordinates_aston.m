function analyse_RF_barsweep_coordinates
%31/5/17
%Modified by Xing from ana_RF_barsweep_singlechannel.m, to obtain RF
%coordinates from 1000-channel data.
%Analyses data from bar sweeps using runstim_RF_barsweep


SNRthreshold=1;

% To plot dots on top of data:
%Useful for testing potential positions for stimuli
%Set to empty e.g. RFx = []; if you don't want this
RFx = [];
RFy = [];

%No logfile so have to hardcode
%Screen details (just pixperdeg required)
pixperdeg = 25.8601;
bardur = 1000; %duration in miliseconds

direct{1} = 'L 2 R';
direct{2} = 'D 2 U';
direct{3} = 'R 2 L';
direct{4} = 'U 2 D';

sampFreq=30000;
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;

date='260617_B1';
switch(date)%x & y co-ordinates of centre-point
    case '060617_B2'
        x0 = 70;
        y0 = -70;
        speed = 250/1000; %this is speed in pixels per ms
    case '060617_B4'
        x0 = 100;
        y0 = -100;
        speed = 250/1000; 
    case '260617_B1'
        x0 = 70;
        y0 = -70;
        speed = 500/1000; 
    case '280617_B1'
        x0 = 30;
        y0 = -30;
        speed = 100/1000; 
end
bardist = speed*bardur;

manualChannels=[];
doManualChecks=1;

colInd=jet(128);
for instanceInd=7
    instanceName=['instance',num2str(instanceInd)];
    Ons = zeros(1,4);
    Offs = zeros(1,4);
    for stimCond = 1:4
        %Get trials with this motion direction
        fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'cond',num2str(stimCond)','.mat']);
        load(fileName)
        meanChannelMUAconds{stimCond}=meanChannelMUA;
    end
    stimCondCol='rgbk';
    SigDif=[];
    channelSNR=[];
    for channelInd=[41];%[1:32 97:128]
        MUAmAllConds=[];
        for stimCond = 1:4
            MUAm=meanChannelMUAconds{stimCond}(channelInd,:);%each value corresponds to 1 ms
            %Get noise levels before smoothing
            BaseT = 1:sampFreq*preStimDur/downsampleFreq;
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
            MUAmAllConds=[MUAmAllConds mua2fit];%compile data across conditions in order to set axis limits later
            [m midpoint]=max(mua2fit);                        

            seedParams = [midpoint 800 Scale Base];%midpoint, std (in ms), difference between peak and baseline, and baseline
            px=1:length(mua2fit);
            [y,params] = gaussfit(px,mua2fit,seedParams);%perform fminsearch
            params(1)=params(1)-sampFreq*preStimDur/downsampleFreq;%remove offset caused by inclusion of preceding spontaneous activity
            paramsConds(stimCond,:)=params;
            
            %calculate SNR
            SNR=Scale/BaseS;
            channelSNR(channelInd,stimCond)=SNR;
            %Is the max significantly different to the base?
            SigDif(channelInd,stimCond) = mx > (Base+(1.*BaseS));
            
            %Onset and offset encompass 95% of the Gaussian
            Ons(1,stimCond) = params(1)-(1.65.*params(2));
            Offs(1,stimCond) = params(1)+(1.65.*params(2));
            
            figInd=ceil(channelInd/36);
            figure(figInd);hold on
            subplotInd=channelInd-((figInd-1)*36);
            subplot(6,6,subplotInd);
            plot(mua2fit,stimCondCol(stimCond));hold on
            plot(y,stimCondCol(stimCond),'Color',[0.5 0.5 0.5]);
            ax=gca;
            ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
            ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
            %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
            title(num2str(channelInd));
            if doManualChecks==1
                figCh=figure;hold on
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                plot(mua2fit,stimCondCol(stimCond));hold on
                plot(y,stimCondCol(stimCond),'Color',[0.5 0.5 0.5]);
                
                prompt = 'Manual selection?';
                manual = input(prompt)
                if manual==1
                    [xClick yClick]=ginput(4);
                    params(1)=xClick(1)-300;
                    params(2)=(xClick(3)-xClick(2))/2;
                    params(4)=yClick(4);
                    paramsConds(stimCond,:)=params;
                    figure(figInd);hold on
                    subplot(6,6,subplotInd);
                    plot(params(1)+300,yClick(1),'x','Color',[0.5 0.5 0.5]);
                    manualChannels=[manualChannels;instanceInd channelInd stimCond];%store identities of channels and conditions where manual selection used
                    
                    %Redo calculation of onset and offset:
                    Ons(1,stimCond) = params(1)-(1.65.*params(2));
                    Offs(1,stimCond) = params(1)+(1.65.*params(2));
                end
                close(figCh)
            end
        end
        %set axis limits
        maxResponse=max(MUAmAllConds);
        minResponse=min(MUAmAllConds);
        diffResponse=maxResponse-minResponse;
        ylim([-diffResponse/4 maxResponse+diffResponse/10]);
        xlim([0 length(MUAm)]);
        %draw dotted lines indicating stimulus presentation
        plot([sampFreq*preStimDur/downsampleFreq sampFreq*preStimDur/downsampleFreq],[[-diffResponse/4 maxResponse+diffResponse/10]],'k:')
        plot([sampFreq*(preStimDur+stimDur)/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq],[[-diffResponse/4 maxResponse+diffResponse/10]],'k:')
        
        figInd=4+ceil(channelInd/36);
        figure(figInd);hold on
        subplotInd=channelInd-((figInd-5)*36);
        subplot(6,6,subplotInd);
                
        %Now distance = speed*time
        %This gives distance travelled by bar in pixels before the onset and
        %offset
        onsdist = speed.*Ons(1,:);
        offsdist = speed.*Offs(1,:);
        
        %Stimuli 1-4 go
        %1 = horizontal left-to-right (180 deg),
        %2 = bottom to top
        %3 = right to left
        %4 = top to bottom
%         angles = [0 90 180 270];
        angles = [180 270 0 90];
        
        %Get starting position of bars
        sx = x0+(bardist./2).*cosd(angles);
        sy =y0+(bardist./2).*sind(angles);
        
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
        right = (onx(3)+offx(1))./2;
        top =   (ony(4)+offy(2))./2;
        left =   (onx(1)+offx(3))./2;
%         bottom = (ony(2)+offy(4))./2;
%         right = (onx(1)+offx(3))./2;
%         top =   (ony(4)+offy(2))./2;
%         left =   (onx(3)+offx(1))./2;
        
        RF.centrex(1) = (right+left)./2;
        RF.centrey(1) = (top+bottom)./2;
        
        RF.sz(1) = sqrt(abs(top-bottom).*abs(right-left));
        RF.szdeg(1) = sqrt(abs(top-bottom).*abs(right-left))./pixperdeg;
        
        XVEC1 = [left  right  right  left  left];
        YVEC1 = [bottom bottom  top top  bottom];
        
        RF.XVEC1(1,:) = XVEC1;
        RF.YVEC1(1,:) = YVEC1;
        
        %     h = line(XVEC1,YVEC1);
        ellipse(abs(right-left)/2,abs(top-bottom)/2,RF.centrex(1),RF.centrey(1));
        %     set(h,'Color','k')
        axis square
        hold on
        scatter(0,0,'r','f')
        if mean(channelSNR(channelInd,:))>SNRthreshold
            scatter(RF.centrex(1),RF.centrey(1),20,[0 1 0],'x')
        else
            scatter(RF.centrex(1),RF.centrey(1),20,[1 0 0],'x')
        end
        ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
        ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
        %     axis([-512 512 -384 384])
        %     hold on,scatter(sx,sy)
        %         disp(['channel: ' ,num2str(1), ' on array ', num2str(array(1))])
        disp(['centerx = ',num2str(RF.centrex(1))])
        disp(['centrey = ',num2str(RF.centrey(1))])
        %position in degrees
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
        
        %Save out centx
        
        if ~isempty(RFx)
            %SCatter on markers
            hold on,scatter(RFx,RFy,'MarkerFaceColor',[0.8 0.8 0.8])
            for i = 1:length(RFx)
                text(RFx(i),RFy(i),(['x=' num2str(RFx(i)) ', y=' num2str(RFy(i))]))
            end
        end        
        RF.horRad=abs(right-left)/2;
        RF.verRad=abs(top-bottom)/2;
        RFs{channelInd}=RF;
        channelRFs(channelInd,:)=[RF.centrex RF.centrey RF.sz RF.szdeg RF.ang RF.theta RF.ecc channelSNR(channelInd,:) abs(right-left)/2 abs(top-bottom)/2];
        
        %plot RFs on same graph
        figure(9)
        %     set(h,'Color','k')
        axis square
        hold on
        %Only plot channels where all directons were signifcant and the SNR is
        %high enough
        if mean(channelSNR(channelInd,:))>SNRthreshold&&sum(SigDif(channelInd,:))==4
%             scatter(RF.centrex(1),RF.centrey(1),20,'x','MarkerFaceColor',colInd(channelInd,:))
            scatter(RF.centrex(1),RF.centrey(1),20,'o','MarkerFaceColor',colInd(channelInd,:))
            plotAreas=1;
            if plotAreas==1
                ellipse(abs(right-left)/2,abs(top-bottom)/2,RF.centrex(1),RF.centrey(1),colInd(channelInd,:));
            end
            text(RF.centrex(1),RF.centrey(1),num2str(channelInd),'FontSize',8)
        else
%             scatter(RF.centrex(1),RF.centrey(1),20,[1 0 0],'x')
        end
        
        %calculate area of sweeping bar
        leftEdge=x0-bardist/2;
        rightEdge=x0+bardist/2;
        topEdge=y0+bardist/2;
        bottomEdge=y0-bardist/2;
        XVECbar = [leftEdge rightEdge rightEdge leftEdge leftEdge];
        YVECbar = [bottomEdge bottomEdge topEdge topEdge bottomEdge];
        h = line(XVECbar,YVECbar,'LineWidth',2);
        set(h,'Color','k')
    end
    figure(9)
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    axis equal
    scatter(0,0,'r','f')
    xlim([-100 200]);
    ylim([-150 50]);
    ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
    ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
    titleText=['instance ',num2str(instanceInd),' RFs'];
    title(titleText);
    switch(instanceInd)%x & y co-ordinates of centre-point
        case 1
            xlim([-200 300]);
            ylim([-350 300]);
        case 2
            xlim([-80 210]);
            ylim([-200 80]);
        case 7
            xlim([-100 250]);
            ylim([-200 60]);
        case 8
            xlim([-80 220]);
            ylim([-200 60]);
    end
    pathname=fullfile('D:\data',date,[instanceName,'_RFs_SNR',num2str(SNRthreshold)]);
    if plotAreas==0
        pathname=fullfile('D:\data',date,[instanceName,'_RFs_coords_only_SNR',num2str(SNRthreshold)]);
    end
    print(pathname,'-dtiff');
    
    printStimCondResponses=1;
    if printStimCondResponses==1
        for figInd=1:4
            figure(figInd)
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd)]);
            print(pathname,'-dtiff');
        end
    end
%     for figInd=1:4
%         figure(figInd)
%         set(gcf, 'Color', 'w');
%         pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd)]);
%         export_fig(pathname,'-png');
%     end
    
    meanChannelSNR=mean(channelSNR,2);
    countGoodSNR=find(meanChannelSNR>4);
    length(countGoodSNR)
    fileName=fullfile('D:\data',date,['RFs_',instanceName,'.mat']);
    saveFile=1;
    if saveFile==1
        save(fileName,'RFs','channelRFs','meanChannelSNR','manualChannels');
    end    
    
    close all
    pause=1;
end