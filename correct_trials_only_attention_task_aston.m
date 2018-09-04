function correct_trials_only_attention_task(date)
%Written by Xing on 31/7/18 to process data from instance 2, neuronal
%channels 33 to 96, to remove incorrect trial data.

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end

load('D:\data\240718_B13\instance2_trialInfo.mat')
for blockInd=1:2
    [temp,indAMF{blockInd}]=intersect(attendMicroFirstNotInitial{blockInd},attendMicroFirstNotInitialC{blockInd});
    [temp,indAMS{blockInd}]=intersect(attendMicroSecondNotInitial{blockInd},attendMicroSecondNotInitialC{blockInd});
    [temp,indAVF{blockInd}]=intersect(attendVisualFirstNotInitial{blockInd},attendVisualFirstNotInitialC{blockInd});
    [temp,indAVS{blockInd}]=intersect(attendVisualSecondNotInitial{blockInd},attendVisualSecondNotInitialC{blockInd});
end

for neuronalCh=[34:75 77:96]%76%:96%1:128%1:128%length(neuronalChsV4)%analog input 8, records sync pulse from array 11
    for blockInd=1:2%length(goodBlocks)
        for includeIncorrect=2%1:2%1: include all trials; 2: exclude incorrect trials
            if includeIncorrect==1
                subFolderName='all_trials';
            elseif includeIncorrect==2%exclude incorrect trials
                subFolderName='correct_trials';
            end
            subFolderPath=fullfile(rootdir,date,subFolderName);
            if ~exist('subFolderPath','dir')
                mkdir(subFolderPath);
            end
            alignRawChFileName=fullfile(rootdir,date,subFolderName,['alignedRawCh',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            load(alignRawChFileName);
            
            AMF=AMF(indAMF{blockInd},:);%remove incorrect trials
            AVF=AVF(indAVF{blockInd},:);
            AMS=AMS(indAMS{blockInd},:);
            
            save(alignRawChFileName,'AMF','AVF','AMS','AMS');
            
            artifactRemovedFolder='AR';
            artifactRemovedChPathName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder);
            artifactRemovedChFileName=fullfile(artifactRemovedChPathName,['AR_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            load(artifactRemovedChFileName,'AMFAR','AVFAR','AMSAR','AVSAR')
            artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_neural_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            load(artifactRemovedFileName,'AMFARMUAe','AVFARMUAe','AMSARMUAe','AVSARMUAe','AMFARlfp','AVFARlfp','AMSARlfp','AVSARlfp','meanAVFARMUAe','meanAMFARMUAe','meanAVSARMUAe','meanAMSARMUAe')
            
            AMFAR=AMFAR(indAMF{blockInd},:);%remove incorrect trials
            AVFAR=AVFAR(indAVF{blockInd},:);
            AMSAR=AMSAR(indAMS{blockInd},:);
            
            AMFARlfp=AMFARlfp(indAMF{blockInd},:);%remove incorrect trials
            AVFARlfp=AVFARlfp(indAVF{blockInd},:);
            AMSARlfp=AMSARlfp(indAMS{blockInd},:);

            AMFARMUAe=AMFARMUAe(indAMF{blockInd},:);%remove incorrect trials
            AVFARMUAe=AVFARMUAe(indAVF{blockInd},:);
            AMSARMUAe=AMSARMUAe(indAMS{blockInd},:);
            
            %plot mean traces across trials in that block, removing
            %trials where no stimulus was presented (in reality, this only occurs for AVS condition)
            meanAVFARMUAe=(mean(AVFARMUAe,1));%attend-visual, deliver microstimulation in first interval
            meanAMFARMUAe=(mean(AMFARMUAe,1));%attend-micro, deliver microstimulation in first interval
            figure;
            subplot(1,2,1);hold on
            plot(meanAVFARMUAe,'b');
            plot(meanAMFARMUAe,'r');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            minVal=min([meanAVFARMUAe(2:end) meanAMFARMUAe(2:end)]);
            maxVal=max([meanAVFARMUAe(2:end) meanAMFARMUAe(2:end)]);
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            subplot(1,2,2);hold on
            plot(smooth(meanAVFARMUAe,20),'b');
            plot(smooth(meanAMFARMUAe,20),'r');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            title(['microstim in interval 1, red: attend-micro, N=',num2str(size(AMFARMUAe,1)),'; blue: attend-visual, N=',num2str(size(AVFARMUAe,1))])
            pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUAe_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval1']);
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            print(pathname,'-dtiff');
            
            meanAVSARMUAe=(mean(AVSARMUAe,1));%attend-visual, deliver microstimulation in second interval
            meanAMSARMUAe=(mean(AMSARMUAe,1));%attend-micro, deliver microstimulation in second interval
            figure;hold on
            subplot(1,2,1);hold on
            plot(meanAVSARMUAe,'b');
            plot(meanAMSARMUAe,'r');
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            minVal=min([meanAVSARMUAe(2:end) meanAMSARMUAe(2:end)]);
            maxVal=max([meanAVSARMUAe(2:end) meanAMSARMUAe(2:end)]);
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            subplot(1,2,2);hold on
            plot(smooth(meanAVSARMUAe,20),'b');
            plot(smooth(meanAMSARMUAe,20),'r');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            title(['microstim in interval 2, red: attend-micro, N=',num2str(size(AMSARMUAe,1)),'; blue: attend-visual, N=',num2str(size(AVSARMUAe,1))])
            pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUAe_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval2']);
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            print(pathname,'-dtiff');
            close all
            artifactRemovedChFileName=fullfile(artifactRemovedChPathName,['AR_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            save(artifactRemovedChFileName,'AMFAR','AVFAR','AMSAR','AVSAR')
            artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_neural_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            save(artifactRemovedFileName,'AMFARMUAe','AVFARMUAe','AMSARMUAe','AVSARMUAe','AMFARlfp','AVFARlfp','AMSARlfp','AVSARlfp','meanAVFARMUAe','meanAMFARMUAe','meanAVSARMUAe','meanAMSARMUAe')
            
        end
    end
end
           