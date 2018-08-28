function analyse_eyedata_attention_task(date)
%Written by Xing 30/7/18.
%Load and analyse eye movement data, identifying time at which eye movement
%was made, on each trial.

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
switch(date)
    case '240718_B13'
        goodBlocks=[1 2];
    case '310718_B1'
        goodBlocks=1;
end
eyeChannels=131;%[130 131];
extractSaccadeTimes=1;
if extractSaccadeTimes==1
    for neuronalChInd=1:length(eyeChannels)
        neuronalCh=eyeChannels(neuronalChInd);
        for blockInd=1%1:length(goodBlocks)
            for includeIncorrect=2%1:2%1: include all trials; 2: exclude incorrect trials
                if includeIncorrect==1
                    subFolderName='all_trials';
                elseif includeIncorrect==2%exclude incorrect trials
                    subFolderName='correct_trials';
                end
                alignRawChFileName=fullfile(rootdir,date,subFolderName,['alignedRawCh',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                load(alignRawChFileName)
                dataType=[{'AMF'} {'AVF'} {'AMS'} {'AVS'}];
                for dataTypeInd=1:length(dataType)
                    evalStr=['eval(''dataTemp=',dataType{dataTypeInd},';'');'];
                    eval(evalStr);
                    figure;hold on
                    ax = gca;
                    for trialNo=1:size(dataTemp,1)
                        plot(dataTemp(trialNo,:));
                        smwin=1;
                        vel = smooth(diff(dataTemp(trialNo,:)),7,'lowess');
                        [pks,loc,w,prom] = findpeaks(abs(vel));
                        [temp locMostProminent]=sort(prom,1,'descend');
                        findFinalPoint=0;
                        tempInd=1;
                        while findFinalPoint==0
                            if tempInd>50
                                findFinalPoint=1;
                            end
                            if loc(locMostProminent(tempInd))<=(0.3+0.167+0.25)*30000&&loc(locMostProminent(tempInd))>0.3*30000
                                finalPoint=locMostProminent(tempInd);
                                preLoc=mean(dataTemp(trialNo,loc(finalPoint)-100:loc(finalPoint)));%mean voltage signal before change
                                postLoc=mean(dataTemp(trialNo,loc(finalPoint):loc(finalPoint)+100));%mean voltage signal after change
                                if neuronalCh==131
                                    if preLoc<postLoc%for y-data, should be a positive inflection
                                        findFinalPoint=1;
                                    else
                                        tempInd=tempInd+1;
                                    end
                                elseif neuronalCh==130
                                    if preLoc>postLoc%for x-data, should be a negative inflection
                                        findFinalPoint=1;
                                    else
                                        tempInd=tempInd+1;
                                    end
                                end
                            else
                                tempInd=tempInd+1;
                            end
                        end
                        saccadeLoc{dataTypeInd}(trialNo)=loc(finalPoint);
                        ylims=get(ax,'ylim');
                        plot([saccadeLoc{dataTypeInd}(trialNo) saccadeLoc{dataTypeInd}(trialNo)],[ylims(1) ylims(2)],'k:');
                    end
                    ax = gca;
                    ylims=get(ax,'ylim');
                    plot([0.3*30000 0.3*30000],[ylims(1) ylims(2)],'k:');
                    plot([(0.3+0.167)*30000 (0.3+0.167)*30000],[ylims(1) ylims(2)],'k:');
                end
                saccadeOnsetFileName=fullfile(rootdir,date,subFolderName,['saccadeOnset',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                save(saccadeOnsetFileName,'saccadeLoc');
            end
        end
    end
end

%analyse MUA data:
generateMeanTraces=1;
if generateMeanTraces==1
    postSaccadeTime=40;%time duration to include following saccade onset, in ms. use 40 ms because it takes about 50 ms for activity to propagate to V4
    postSaccadeDatapoints=postSaccadeTime/1000*30000;
    for neuronalCh=[1:75 77:128]%[1:33 35:75 77:128]
        for blockInd=1:length(goodBlocks)
            for includeIncorrect=2%1:2%1: include all trials; 2: exclude incorrect trials
                if includeIncorrect==1
                    subFolderName='all_trials';
                elseif includeIncorrect==2%exclude incorrect trials
                    subFolderName='correct_trials';
                end
                artifactRemovedFolder='AR';
                artifactRemovedChPathName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder);
                artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_neural_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                load(artifactRemovedFileName)
                saccadeOnsetFileName=fullfile(rootdir,date,subFolderName,['saccadeOnset131_block',num2str(blockInd),'.mat']);
                load(saccadeOnsetFileName);
                dataType=[{'AMF'} {'AVF'} {'AMS'} {'AVS'}];
                AMF_MUA_final=[];
                AVF_MUA_final=[];
                AMS_MUA_final=[];
                AVS_MUA_final=[];
                for dataTypeInd=1:length(dataType)
                    if dataTypeInd==1%do this for conditions where he had to saccade to the phosphene, and not for conditions where he had to maintain fixation
                        evalStr=['eval(''dataTemp=',dataType{dataTypeInd},'ARMUAe;'');'];
                        eval(evalStr);
                        if ~isempty(dataTemp)
                            newDataTemp=[];
                            for trialNo=1:size(dataTemp,1)
                                excludeData=saccadeLoc{dataTypeInd}(trialNo)+postSaccadeDatapoints;%include data up to
                                excludeDataMUA=floor(excludeData/30000*700);%convert sampling freq for raw eye trace to sampling freq for MUA data
                                nanFill=zeros(1,size(dataTemp,2)-excludeDataMUA)*nan;%set all data points after the onset of eye saccade to NaN
                                newDataTemp(trialNo,:)=[dataTemp(trialNo,1:excludeDataMUA) nanFill];
                                %                         figure;
                                %                         plot(dataTemp(trialNo,:));hold on;
                                %                         plot(newDataTemp(trialNo,:));
                            end
                            evalStr=['eval(''',dataType{dataTypeInd},'_MUA_final=newDataTemp;'');'];
                            eval(evalStr);
                        end
                    else
                        evalStr=['eval(''',dataType{dataTypeInd},'_MUA_final=',dataType{dataTypeInd},'ARMUAe;'');'];
                        eval(evalStr);
                    end
                end
                %plot mean traces across trials in that block, for each channel
                mean_AVF_MUA=(mean(AVF_MUA_final,1));%attend-visual, deliver microstimulation in first interval
                mean_AMF_MUA=(mean(AMF_MUA_final,1));%attend-micro, deliver microstimulation in first interval
                mean_AVF_MUA=mean_AVF_MUA(~isnan(mean_AVF_MUA));
                mean_AMF_MUA=mean_AMF_MUA(~isnan(mean_AMF_MUA));
                figure;
                subplot(1,2,1);hold on
                plot(mean_AVF_MUA(2:end),'b');
                plot(mean_AMF_MUA(2:end),'r');
                ax = gca;
                ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
                ax.XTickLabel={'-300','0','167','400'};
                minVal=min([mean_AVF_MUA(2:end) mean_AMF_MUA(2:end)]);
                maxVal=max([mean_AVF_MUA(2:end) mean_AMF_MUA(2:end)]);
                ylim([floor(minVal)-1 ceil(maxVal)+1]);
                ylims=get(ax,'ylim');
                plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
                plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
                subplot(1,2,2);hold on
                smoothed_AVF_MUA=smooth(mean_AVF_MUA,20);
                smoothed_AMF_MUA=smooth(mean_AMF_MUA,20);
                plot(smoothed_AVF_MUA(15:end-5),'b');%the smoothing process creates an unwanted dip at the beginning of the trial, and an unwanted change at the end of the data
                plot(smoothed_AMF_MUA(15:end-5),'r');
                ax = gca;
                ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
                ax.XTickLabel={'-300','0','167','400'};
                ylim([floor(minVal)-1 ceil(maxVal)+1]);
                ylims=get(ax,'ylim');
                plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
                plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
                title(['microstim in interval 1, red: attend-micro, N=',num2str(size(AMFARMUAe,1)),'; blue: attend-visual, N=',num2str(size(AVFARMUAe,1))])
                pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUAe_presaccade_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval1']);
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                print(pathname,'-dtiff');
                
                mean_AVS_MUA=(mean(AVS_MUA_final,1));%attend-visual, deliver microstimulation in second interval
                mean_AMS_MUA=(mean(AMS_MUA_final,1));%attend-micro, deliver microstimulation in second interval
                mean_AVS_MUA=mean_AVS_MUA(~isnan(mean_AVS_MUA));
                mean_AMS_MUA=mean_AMS_MUA(~isnan(mean_AMS_MUA));
                figure;hold on
                subplot(1,2,1);hold on
                plot(mean_AVS_MUA(2:end),'b');
                plot(mean_AMS_MUA(2:end),'r');
                ylim([floor(minVal)-1 ceil(maxVal)+1]);
                ylims=get(ax,'ylim');
                ax = gca;
                ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
                ax.XTickLabel={'-300','0','167','400'};
                minVal=min([mean_AVS_MUA(2:end) mean_AMS_MUA(2:end)]);
                maxVal=max([mean_AVS_MUA(2:end) mean_AMS_MUA(2:end)]);
                plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
                plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
                subplot(1,2,2);hold on
                smoothed_AVS_MUA=smooth(mean_AVS_MUA,20);
                smoothed_AMS_MUA=smooth(mean_AMS_MUA,20);
                plot(smoothed_AVS_MUA(15:end-5),'b');
                plot(smoothed_AMS_MUA(15:end-5),'r');
                ax = gca;
                ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
                ax.XTickLabel={'-300','0','167','400'};
                ylim([floor(minVal)-1 ceil(maxVal)+1]);
                ylims=get(ax,'ylim');
                plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
                plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
                title(['microstim in interval 2, red: attend-micro, N=',num2str(size(AMSARMUAe,1)),'; blue: attend-visual, N=',num2str(size(AVSARMUAe,1))])
                pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUAe_presaccade_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval2']);
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                print(pathname,'-dtiff');
                close all
                
                finalMUAFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUA_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                save(finalMUAFileName,'AMF_MUA_final','AVF_MUA_final','AMS_MUA_final','AVS_MUA_final','mean_AMF_MUA','mean_AVF_MUA','mean_AMS_MUA','mean_AVS_MUA');
            end
        end
    end
end

%identify channels with 'visually evoked' response to microstimulation:
identifyVisRespChs=1;
if identifyVisRespChs==1    
    baselinePeriod=1:0.3*700;%MUA sampling frequency is 700 Hz
    stimOnset=(0.3+0.05)*700+1;%MUA sampling frequency is 700 Hz.
    stimOffset=(0.3+0.167)*700;%MUA sampling frequency is 700 Hz.
    visuallyResponsiveChannels=[];
    for blockInd=1:length(goodBlocks)
        for neuronalCh=[1:75 77:128]%[1:33 35:75 77:128]
            for includeIncorrect=2%1:2%1: include all trials; 2: exclude incorrect trials
                if includeIncorrect==1
                    subFolderName='all_trials';
                elseif includeIncorrect==2%exclude incorrect trials
                    subFolderName='correct_trials';
                end
                artifactRemovedFolder='AR';
                finalMUAFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUA_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                load(finalMUAFileName,'AMF_MUA_final','AVF_MUA_final','AMS_MUA_final','AVS_MUA_final','mean_AMF_MUA','mean_AVF_MUA','mean_AMS_MUA','mean_AVS_MUA');
                
                dataType=[{'AMF'} {'AVF'} {'AMS'} {'AVS'}];
                for dataTypeInd=1:length(dataType)
                    if dataTypeInd==1||dataTypeInd==2
                        %                     evalStr=['eval(''baselineAct(neuronalCh)=mean(',dataType{dataTypeInd},'_MUA_final(baselinePeriod));'');'];
                        %                     eval(evalStr);
                        %                     evalStr=['eval(''baselineStd(neuronalCh)=std(',dataType{dataTypeInd},'_MUA_final(baselinePeriod));'');'];
                        %                     eval(evalStr);
                        %                     evalStr=['eval(''stimAct(neuronalCh)=mean(',dataType{dataTypeInd},'_MUA_final(stimPeriod));'');'];
                        %                     eval(evalStr);
                        evalStr=['eval(''baselineAct(neuronalCh,dataTypeInd)=mean(mean_',dataType{dataTypeInd},'_MUA(baselinePeriod));'');'];
                        eval(evalStr);
                        evalStr=['eval(''baselineStd(neuronalCh,dataTypeInd)=std(mean_',dataType{dataTypeInd},'_MUA(baselinePeriod));'');'];
                        eval(evalStr);
                        if dataTypeInd==1%this data is truncated soon after saccade onset
                            evalStr=['eval(''stimAct(neuronalCh,dataTypeInd)=max(mean_',dataType{dataTypeInd},'_MUA(stimOnset:end-5));'');'];%exclude the last data points
                            eval(evalStr);
                        elseif dataTypeInd==2
                            evalStr=['eval(''stimAct(neuronalCh,dataTypeInd)=max(mean_',dataType{dataTypeInd},'_MUA(stimOnset:stimOffset));'');'];
                            eval(evalStr);
                        end
                        if stimAct(neuronalCh,dataTypeInd)>baselineAct(neuronalCh,dataTypeInd)+baselineStd(neuronalCh,dataTypeInd)%if visually evoked response is present
                            visuallyResponsiveChannels(neuronalCh,dataTypeInd)=1;%1: include channel
                        else
                            visuallyResponsiveChannels(neuronalCh,dataTypeInd)=0;%0: exclude channel
                        end
                    end
                end
            end
        end
        visuallyResponsiveMV=sum(visuallyResponsiveChannels,2);
        visuallyResponsiveMV=find(visuallyResponsiveMV==2);%identify channels where visually evoked response occurred for both attend-micro and attend-visual conditions
        includeChannelsFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['visually_responsive_chs_block',num2str(blockInd),'.mat']);
        save(includeChannelsFileName,'visuallyResponsiveMV','visuallyResponsiveChannels');
    end
end

%normalize activity to baseline and maximum response:
generateNormAct=1;
if generateNormAct==1
    baselinePeriod=1:0.3*700;%MUA sampling frequency is 700 Hz
    stimOnset=(0.3+0.05)*700+1;%MUA sampling frequency is 700 Hz.
    stimOffset=(0.3+0.167)*700;%MUA sampling frequency is 700 Hz.
    for blockInd=1:length(goodBlocks)
        for includeIncorrect=2%1:2%1: include all trials; 2: exclude incorrect trials
            if includeIncorrect==1
                subFolderName='all_trials';
            elseif includeIncorrect==2%exclude incorrect trials
                subFolderName='correct_trials';
            end
            artifactRemovedFolder='AR';
            includeChannelsFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['visually_responsive_chs_block',num2str(blockInd),'.mat']);
            load(includeChannelsFileName);
            
            figure;hold on
            [handles]=tight_subplot(ceil(length(visuallyResponsiveMV)/8),8,0.02,0.05,0.05);
            for neuronalChInd=1:length(visuallyResponsiveMV)
                neuronalCh=visuallyResponsiveMV(neuronalChInd);
                finalMUAFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUA_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                load(finalMUAFileName,'AMF_MUA_final','AVF_MUA_final','AMS_MUA_final','AVS_MUA_final','mean_AMF_MUA','mean_AVF_MUA','mean_AMS_MUA','mean_AVS_MUA');
                baselinecorrect_AMF=mean_AMF_MUA-mean(mean_AMF_MUA(baselinePeriod));%subtract baseline activity level for that attention condition
                baselinecorrect_AVF=mean_AVF_MUA-mean(mean_AVF_MUA(baselinePeriod));%subtract baseline activity level for that attention condition
                respAMF=baselinecorrect_AMF(stimOnset:end);%subtract baseline activity level for that attention condition
                respAVF=baselinecorrect_AVF(stimOnset:stimOffset);%subtract baseline activity level for that attention condition
                %             figure;hold on;
                %             plot(baselinecorrect_AMF,'r')
                %             plot(baselinecorrect_AVF,'b')
                maxResp=max([respAMF respAVF]);%find peak activity level during response period, for data that is combined across attend-micro and attend-visual conditions
                normAMF=baselinecorrect_AMF/maxResp;%normalize to peak response
                normAVF=baselinecorrect_AVF/maxResp;%normalize to peak response
                %             figure;hold on
                axes(handles(neuronalChInd));
                smoothedNormAMF_MUA=smooth(normAMF,20);
                smoothedNormAVF_MUA=smooth(normAVF,20);
                smoothingOffset=10;
                plot(smoothedNormAVF_MUA(smoothingOffset:end-5),'b');hold on
                plot(smoothedNormAMF_MUA(smoothingOffset:end-5),'r');
                ax = gca;
                ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
                ax.XTickLabel={'-300','0','167','400'};
                maxGraph=max([smoothedNormAMF_MUA(smoothingOffset:end-5);smoothedNormAVF_MUA(smoothingOffset:end-5)]);
                minGraph=min([smoothedNormAMF_MUA(smoothingOffset:end-5);smoothedNormAVF_MUA(smoothingOffset:end-5)]);
                ylim([minGraph maxGraph]);
                ylims=get(ax,'ylim');
                plot([0.3*700-smoothingOffset+1 0.3*700-smoothingOffset+1],[ylims(1) ylims(2)],'k:');
                plot([(0.3+0.167)*700-smoothingOffset+1 (0.3+0.167)*700-smoothingOffset+1],[ylims(1) ylims(2)],'k:');
                set(gca,'Visible','off')
                normDataFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['normalized_MUA_Ch',num2str(neuronalCh),'_',num2str(blockInd),'_Minterval1.mat']);
                save(normDataFileName,'normAMF','normAVF');
                %             title(['ch ',num2str(neuronalCh),', microstim in interval 1, red: attend-micro; blue: attend-visual'])
                title(['ch ',num2str(neuronalCh)])
                %             pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['normalized_MUA_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval1']);
                %             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                %             print(pathname,'-dtiff');
                %             close all
            end
        end
        pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['normalized_MUA_all_Chs','_block',num2str(blockInd),'_Minterval1']);
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        close all
    end
end

%obtain average activity over good channels:
baselinePeriod=1:0.3*700;%MUA sampling frequency is 700 Hz
stimOnset=(0.3+0.05)*700+1;%MUA sampling frequency is 700 Hz.
stimOffset=(0.3+0.167)*700;%MUA sampling frequency is 700 Hz.
for blockInd=1:length(goodBlocks)
    for includeIncorrect=2%1:2%1: include all trials; 2: exclude incorrect trials
        if includeIncorrect==1
            subFolderName='all_trials';
        elseif includeIncorrect==2%exclude incorrect trials
            subFolderName='correct_trials';
        end
        artifactRemovedFolder='AR';
        includeChannelsFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['visually_responsive_chs_block',num2str(blockInd),'.mat']);
        load(includeChannelsFileName);
        
        allChActAMF=zeros(length(visuallyResponsiveMV),607)*nan;
        allChActAVF=zeros(length(visuallyResponsiveMV),607)*nan;
        for neuronalChInd=1:length(visuallyResponsiveMV)
            neuronalCh=visuallyResponsiveMV(neuronalChInd);
            normDataFileName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['normalized_MUA_Ch',num2str(neuronalCh),'_',num2str(blockInd),'_Minterval1.mat']);
            load(normDataFileName,'normAMF','normAVF');
            allChActAMF(neuronalChInd,1:length(normAMF))=normAMF;
            allChActAVF(neuronalChInd,1:length(normAVF))=normAVF;
        end
        meanAllChAMF=nanmean(allChActAMF,1);
        meanAllChAVF=nanmean(allChActAVF,1);
        meanAllChAMF(isnan(meanAllChAMF))=[];
        smoothedMeanAllChAMF=smooth(meanAllChAMF,20);
        smoothedMeanAllChAVF=smooth(meanAllChAVF,20);
        figure;hold on        
        smoothingOffset=10;
        plot(smoothedMeanAllChAMF(smoothingOffset:end-5),'r')
        plot(smoothedMeanAllChAVF(smoothingOffset:end-5),'b')
               
        maxGraph=max([smoothedMeanAllChAMF;smoothedMeanAllChAVF]);
        ylim([-0.1 maxGraph]);
        ax = gca;
        ax.XTick=[0-smoothingOffset+1 0.3*700-smoothingOffset+1 (0.3+0.167)*700-smoothingOffset+1 (0.3+0.167+0.4)*700-smoothingOffset+1];
        ax.XTickLabel={'-300','0','167','400'};
        ylims=get(ax,'ylim');
        plot([0.3*700-smoothingOffset+1 0.3*700-smoothingOffset+1],[ylims(1) ylims(2)],'k:');
        plot([(0.3+0.167)*700-smoothingOffset+1 (0.3+0.167)*700-smoothingOffset+1],[ylims(1) ylims(2)],'k:');
        title(['mean activity, microstim in interval 1, red: attend-micro; blue: attend-visual, N=',num2str(length(visuallyResponsiveMV))])
        pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['mean_MUA_across_all_chs','_block',num2str(blockInd),'_Minterval1']);
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        close all  
    end
end