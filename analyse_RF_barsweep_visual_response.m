function analyse_RF_barsweep_visual_response
%28/7/17
%Written by Xing to visualise responses to bar sweeps using 1000-channel data.

SNRthreshold=1;

pixperdeg = 25.8601;
bardur = 1000; %duration in miliseconds

direct{1} = 'L to R';
direct{2} = 'D to U';
direct{3} = 'R to L';
direct{4} = 'U to D';

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
doManualChecks=0;

colInd=jet(128);
normalisedResponse=cell(1,4);
for instanceInd=1:8
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
    for channelInd=1:128
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
            normalisedResponse{stimCond}=[normalisedResponse{stimCond};mua2fit/(max(mua2fit))];%each cell contains channels in rows and time in columns, for entire trial
        end
    end
end
fileName=fullfile('D:\data',date,['normalised_visual_response_all_conds','.mat']);
save(fileName,'normalisedResponse')

fileName=fullfile('D:\data',date,['normalised_visual_response_all_conds','.mat']);
load(fileName,'normalisedResponse')

%combine RF data across the instances:
allChannelRFs=[];
for instanceInd=1:8
    loadDate='best_260617-280617';
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
    load(fileName)
    allChannelRFs=[allChannelRFs;channelRFs];
end
for stimCond=1:4
    for timePoint=1:size(normalisedResponse{stimCond},2)  
        figure;hold on
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        set(gca,'Color',[0.7 0.7 0.7]);
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250 200],'r:')
        plot([-200 300],[0 0],'r:')
        plot([-200 300],[200 -300],'r:')
        ellipse(50,50,0,0,[1 1 1]);
        ellipse(100,100,0,0,[1 1 1]);
        ellipse(150,150,0,0,[1 1 1]);
        ellipse(200,200,0,0,[1 1 1]);
        text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.5 0.5 0.5]);
        text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.5 0.5 0.5]);
        text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.5 0.5 0.5]);
        text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.5 0.5 0.5]);

        col=normalisedResponse{stimCond}(:,timePoint);
        scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
        
        %Draw bar
        if timePoint>preStimDur*1000&&timePoint<=preStimDur*1000+stimDurms
            if stimCond==1
                plot([x0-(speed*1000)/2+timePoint-preStimDur*1000 x0-(speed*1000)/2+timePoint-preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'w-')
            elseif stimCond==2
                plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0-(speed*1000)/2+timePoint-preStimDur*1000 y0-(speed*1000)/2+timePoint-preStimDur*1000],'w-')
            elseif stimCond==3
                plot([x0+(speed*1000)/2-timePoint+preStimDur*1000 x0+(speed*1000)/2-timePoint+preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'w-')
            elseif stimCond==4
                plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0+(speed*1000)/2-timePoint+preStimDur*1000 y0+(speed*1000)/2-timePoint+preStimDur*1000],'w-')
            end
        end
        xlim([0 200]);
        ylim([-200 0]);
        axis square
        title(['visual responses to bar sweeping ',direct{stimCond}]);
        framesResponse(timePoint)=getframe;
        close all
    end
    pathname=fullfile('D:\data',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
    save(pathname,'framesResponse','-v7.3')
%     movieFig=figure;
%     movie(movieFig,framesResponse,1,50);  
    moviename=fullfile('D:\data',date,['1024-channel responses to  bar sweeping ',direct{stimCond},'.avi']);
    v = VideoWriter(moviename);
    v.FrameRate=500;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
    open(v)
    for timePoint=1:length(framesResponse)
        writeVideo(v,framesResponse(timePoint))
    end
    close(v)
end