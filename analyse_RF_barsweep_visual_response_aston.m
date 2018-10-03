function analyse_RF_barsweep_visual_response_aston
%6/9/18
%Written by Xing to visualise responses to bar sweeps using 1000-channel data- new version.

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
pixperdeg = 25.8601;

date='280818_B2_aston';
switch(date)%x & y co-ordinates of centre-point
    case '280818_B2_aston'
        x0 = 70;
        y0 = -70;
        speed = 20*pixperdeg/1000; %this is speed in pixels per ms
end
bardist = speed*bardur;

manualChannels=[];
doManualChecks=0;

colInd=jet(128);
normalisedResponse=cell(1,4);
processRaw=0;
if processRaw==1
    for instanceInd=1:8
        instanceName=['instance',num2str(instanceInd)];
        Ons = zeros(1,4);
        Offs = zeros(1,4);
        for stimCond = 1:4
            %Get trials with this motion direction
            fileName=fullfile('X:\aston',date,['mean_MUA_',instanceName,'cond',num2str(stimCond)','.mat']);
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
    fileName=fullfile('X:\aston',date,['normalised_visual_response_all_conds','.mat']);
    save(fileName,'normalisedResponse')
end

drawFrames=0;
if drawFrames==1
    fileName=fullfile('X:\aston',date,['normalised_visual_response_all_conds','.mat']);
    load(fileName,'normalisedResponse')
    %combine RF data across the instances:
    allChannelRFs=[];
    for instanceInd=1:8
        loadDate='best_aston_280818-290818';
        fileName=['X:\aston\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
        load(fileName)
        allChannelRFs=[allChannelRFs;channelRFs];
    end
    for stimCond=1:4
        frameNo=1;
        for timePoint=preStimDur*1000:preStimDur*1000+stimDurms+299%size(normalisedResponse{stimCond},2)
            figure;hold on
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            set(gca,'Color',[0.7 0.7 0.7]);
            s=scatter(0,0,'r','o','filled');%fix spot
            s.SizeData=150;
            %draw dotted lines indicating [0,0]
            %         ellipse(50,50,0,0,[1 1 1]);
            %         ellipse(100,100,0,0,[1 1 1]);
            %         ellipse(150,150,0,0,[1 1 1]);
            %         ellipse(200,200,0,0,[1 1 1]);
            %         text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.5 0.5 0.5]);
            %         text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.5 0.5 0.5]);
            %         text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.5 0.5 0.5]);
            %         text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.5 0.5 0.5]);
            
            col=normalisedResponse{stimCond}(:,timePoint);
            scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col,'filled');
            %         scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
            
            %Draw bar
            plot([sampFreq*preStimDur/downsampleFreq sampFreq*preStimDur/downsampleFreq],[[-diffResponse/4 maxResponse+diffResponse/10]],'k:')
            plot([sampFreq*(preStimDur+stimDur)/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq],[[-diffResponse/4 maxResponse+diffResponse/10]],'k:')

            if timePoint>preStimDur*1000&&timePoint<=preStimDur*1000+stimDurms
                if stimCond==1
                    rectangle('Position',[x0-(speed*1000)/2+timePoint-preStimDur*1000-3 y0-(speed*1000)/2+100 6 500],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0-(speed*1000)/2+timePoint-preStimDur*1000 x0-(speed*1000)/2+timePoint-preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'r-')
                elseif stimCond==2
                    rectangle('Position',[x0-(speed*1000)/2+100 y0-(speed*1000)/2+timePoint-preStimDur*1000-3 500 6],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0-(speed*1000)/2+timePoint-preStimDur*1000 y0-(speed*1000)/2+timePoint-preStimDur*1000],'r-')
                elseif stimCond==3
                    rectangle('Position',[x0+(speed*1000)/2-timePoint+preStimDur*1000-3 y0-(speed*1000)/2+100 6 500],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0+(speed*1000)/2-timePoint+preStimDur*1000 x0+(speed*1000)/2-timePoint+preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'r-')
                elseif stimCond==4
                    rectangle('Position',[x0-(speed*1000)/2+100 y0+(speed*1000)/2-timePoint+preStimDur*1000-3 500 6],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0+(speed*1000)/2-timePoint+preStimDur*1000 y0+(speed*1000)/2-timePoint+preStimDur*1000],'r-')
                end
            end
            axis equal
            xlim([-20 200]);
            %         xlim([-100 280]);
            ylim([-180 40]);
            %         ylim([-260 120]);
            plot([10; 35], [-135; -135], '-k', 'LineWidth', 2)
            text(23,-140, '1 dva', 'HorizontalAlignment','center','FontSize',14)
            %         plot([10; 10], [-150; -125], '-k',  [10; 35], [-150; -150], '-k', 'LineWidth', 2)
            %         text(7,-138, '1 dva', 'HorizontalAlignment','right')
            %         text(23,-153, '1 dva', 'HorizontalAlignment','center')
            
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            set(gca,'xticklabel',[])
%             set(gca,'visible','off')
            %         title(['visual responses to bar sweeping ',direct{stimCond}]);
            framesResponse(frameNo)=getframe;
            frameNo=frameNo+1;
            close all
        end
        pathname=fullfile('X:\aston',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
        save(pathname,'framesResponse','-v7.3')
    end
end

makeIndividualMovies=0;
if makeIndividualMovies==1
    for stimCond=1:4
        pathname=fullfile('X:\aston',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
        load(pathname)
        
        %     moviename=fullfile('X:\aston',date,['1024-channel responses to  bar sweeping ',direct{stimCond},'.avi']);
        %     v = VideoWriter(moviename);
        %     v.Quality=100;
        %     v.FrameRate=500;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
        %     open(v)
        %     for timePoint=1:length(framesResponse)-100
        %         if size(framesResponse(timePoint).cdata,1)~=771||size(framesResponse(timePoint).cdata,2)~=995
        %             framesResponse(timePoint).cdata=framesResponse(timePoint-1).cdata;
        %             timePoint
        %         end
        %         writeVideo(v,framesResponse(timePoint))
        %     end
        %     close(v)
        
        moviename=fullfile('X:\aston',date,['1024-channel responses to  bar sweeping 2',direct{stimCond}]);
        v = VideoWriter(moviename,'MPEG-4');
        v.Quality=100;
        v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
        sampleFactor=600/v.FrameRate;
        open(v)
        for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
            if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
                framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
                timePoint
            end
            writeVideo(v,framesResponse(timePoint*sampleFactor))
        end
    end
end

% %create combined AVI video across conditions:
% moviename=fullfile('X:\aston',date,['1024-channel responses to sweeping bar.avi']);
% v = VideoWriter(moviename);
% v.Quality=100;
% v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
% sampleFactor=600/v.FrameRate;
% open(v)
% for stimCond=1:4
%     pathname=fullfile('X:\aston',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
%     load(pathname)
%     
%     for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
%         if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
%             framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
%             timePoint
%         end
%         writeVideo(v,framesResponse(timePoint*sampleFactor))
%     end
% end
% close(v)

%create combined MP4 video across conditions:
moviename=fullfile('X:\aston',date,['1024-channel responses to sweeping bar']);
v = VideoWriter(moviename,'MPEG-4');
v.Quality=100;
v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
sampleFactor=600/v.FrameRate;
open(v)
for stimCond=1:4
    pathname=fullfile('X:\aston',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
    load(pathname)
    
    for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
        if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
            timePoint
        end
        writeVideo(v,framesResponse(timePoint*sampleFactor))
    end
end
close(v)