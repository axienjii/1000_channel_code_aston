function plot_letter_response_inset_rf
%Written by Xing 7/7/17, to generate plots of visually evoked actiivty
%during presentation of simulated phosphene letter stimuli, and draw inset
%plot of RF location relative to position of letters.

date='050717_B2';
smoothResponse=1;
downSampling=1;
downsampleFreq=30;

stimDurms=800;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;
allLetters='IUALTVSYJP';
for instanceInd=5:8%[1 3 4 6:8]
    instanceName=['instance',num2str(instanceInd)];
    switch(instanceInd)
        case(4)
            goodChannels=89:128;
        case(5)
            goodChannels=1:116;
        otherwise
            goodChannels=1:128;
    end
    for channelCount=1:length(goodChannels)
        channelInd=goodChannels(channelCount);
        [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd);
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_trialData.mat']);
        load(fileName);
        meanChannelMUA(channelInd,:)=mean(trialData,1);
        figLetters=figure;
        hold on
        letterYMin=[];
        letterYMax=[];
        letterYMaxLoc=[];
        for letterCond=1:10
            meanChannelMUA(letterCond,:)=mean(trialData(find(goodTrialCondsMatch(:,1)==letterCond),:),1);
            if sum(meanChannelMUA(letterCond,:))>0
                %                     subplot(5,2,letterCond)
                colind = hsv(10);
                if smoothResponse==1
                    smoothMUA = smooth(meanChannelMUA(letterCond,:),30);
                    plot(smoothMUA,'Color',colind(letterCond,:),'LineWidth',1);
                elseif smoothResponse==0
                    plot(meanChannelMUA(letterCond,:),'Color',colind(letterCond,:),'LineWidth',1);
                end
                hold on
                ax=gca;
                if downSampling==0
                    ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
                    ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
                elseif downSampling==1
                    ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
                    ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
                end
                %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
                %                     title([num2str(channelInd),' letter ',allLetters(letterCond)]);
                %set axis limits
                if smoothResponse==1
                    [maxResponse maxInd]=max(smoothMUA);
                    minResponse=min(smoothMUA);
                elseif smoothResponse==0
                    [maxResponse maxInd]=max(meanChannelMUA(letterCond,:));
                    minResponse=min(meanChannelMUA(letterCond,:));
                end
                diffResponse=maxResponse-minResponse;
                letterYMin=[letterYMin minResponse];
                letterYMax=[letterYMax maxResponse];
                letterYMaxLoc=[letterYMaxLoc maxInd];
            end
        end
        %draw dotted lines indicating stimulus presentation
        if smoothResponse==1
            minResponse=min(letterYMin);
            [maxResponse maxLetter]=max(letterYMax);
        end
        diffResponse=maxResponse-minResponse;
        if downSampling==0
            plot([sampFreq*preStimDur sampFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            plot([sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
        elseif downSampling==1
            plot([sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            plot([sampFreq/downsampleFreq*(preStimDur+stimDur) sampFreq/downsampleFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
        end
        for i=1:10
            text(letterYMaxLoc(i)+20,letterYMax(i),allLetters(i),'Color',colind(i,:),'FontSize',12,'FontWeight','bold')
            text(1450,maxResponse+diffResponse/10-i*diffResponse/40,allLetters(i),'Color',colind(i,:),'FontSize',8)
        end
        ylim([minResponse-diffResponse/10 maxResponse+diffResponse/10]);
        xlim([0 length(meanChannelMUA(letterCond,:))]);
        titleText=['instance ',num2str(instanceInd),', array ',num2str(arrayNum),', channel ',num2str(channelNum),' (#',num2str(channelInd),') letter-evoked responses'];
        title(titleText);
        axes('Position',[.72 .75 .12 .15])%left bottom width height: the left and bottom elements define the distance from the lower left corner of the container (typically a figure, uipanel, or uitab) to the lower left corner of the position boundary. The width and height elements are the position boundary dimensions.
        box on
        draw_rf_letters(instanceInd,channelInd,0)
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,[instanceName,'_','channel_',num2str(channelInd),'_visual_response_letters_smooth']);
        print(pathname,'-dtiff');
        % create smaller axes in top right, and plot on it
        close(figLetters)
    end
    close all
end