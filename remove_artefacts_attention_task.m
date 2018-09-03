function remove_artefacts_attention_task(date)
%Written by Xing 19/7/18, based on Feng's testdata.m code to remove
%microstimulation artefacts from data collected during an attention task
%(attend to a phosphene percept that is evoked by microstimulation, or
%attend to a visually presented stimulus).

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
for neuronalCh=1:128%[34:75 77:96]%76%:96%1:128%1:128%length(neuronalChsV4)%analog input 8, records sync pulse from array 11
    for blockInd=1%:2%length(goodBlocks)
        for includeIncorrect=1:2%1: include all trials; 2: exclude incorrect trials
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
            
            StimulationParam.numberofStimPulses = 50;
            StimulationParam.PulsesFrequency = 300; %Hz
            StimulationParam.stimulationwaveformwidth = 0.4; % ms
            StimulationParam.WaveDPbefore = 20; %number of datapoints, relative to peak of artifact waveform
            StimulationParam.WaveDPafter = 20; %number of datapoints, relative to peak of artifact waveform
            
            LFPparameters.LFPsamplingrate = 500; % Hz
            LFPparameters.LFPlowpassFreq = 150; % Hz
            
            MUAparameters.MUAeSamplingrate = 700; % Hz
            MUAparameters.MUAeBandpassFreq = [500 5000]; % Hz
            MUAparameters.MUAeLowpassFreq = 200; % Hz
            
            SampleRate = 30000;
            SupersamplingRatio = 16;
            debug = 1;
            
            AMF = AMF(any(AMF,2),:);%remove trials where no microstimulation delivered (zero values throughout whole trial). Actually only needed for AVS variable
            AVF = AVF(any(AVF,2),:);
            AMS = AMS(any(AMS,2),:);
            AVS = AVS(any(AVS,2),:);
            AMFAR = AMF;
            AVFAR = AVF;
            AMSAR = AMS;
            AVSAR = AVS;
            
            NumElec = size(AMF,3);
            
            for ElecID = 1:NumElec
                
                RawTrace = AMF(:,:,ElecID);
                RawTrace = RawTrace';
                AlignedMeanTrace = squeeze(mean(mean(AMF,1),3));
                ARTrace = RemoveArtifacts4(RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                AMFAR(:,:,ElecID) = ARTrace';
                
                RawTrace = AVF(:,:,ElecID);
                RawTrace = RawTrace';
                AlignedMeanTrace = squeeze(mean(mean(AVF,1),3));
                ARTrace = RemoveArtifacts4(RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                AVFAR(:,:,ElecID) = ARTrace';
                
                RawTrace = AMS(:,:,ElecID);
                RawTrace = RawTrace';
                AlignedMeanTrace = squeeze(mean(mean(AMS,1),3));
                ARTrace = RemoveArtifacts4(RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                AMSAR(:,:,ElecID) = ARTrace';
                
                if ~isempty(AVS)%for analysis that includes only correct trials, the variable AVS will be empty
                    RawTrace = AVS(:,:,ElecID);
                    RawTrace = RawTrace';
                    AlignedMeanTrace = squeeze(mean(mean(AVS,1),3));
                    ARTrace = RemoveArtifacts4(RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                    AVSAR(:,:,ElecID) = ARTrace';
                end
            end
            
            AMFARMUAe=[];
            AMFARlfp=[];
            AVFARMUAe=[];
            AVFARlfp=[];
            AMSARMUAe=[];
            AMSARlfp=[];
            AVSARMUAe=[];
            AVSARlfp=[];
            
            for ElecID = 1:NumElec
                RawData = AMFAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
%                 MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                AMFARMUAe(:,:,ElecID) = MUAe.data';
                AMFARlfp(:,:,ElecID) = LFP.data';
                
                RawData = AVFAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
%                 MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                AVFARMUAe(:,:,ElecID) = MUAe.data';
                AVFARlfp(:,:,ElecID) = LFP.data';
                
                RawData = AMSAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
%                 MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                AMSARMUAe(:,:,ElecID) = MUAe.data';
                AMSARlfp(:,:,ElecID) = LFP.data';
                
                if ~isempty(AVS)%for analysis that includes only correct trials, the variable AVS will be empty
                    RawData = AVSAR(:,:,ElecID);
                    RawData = RawData';
                    [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
%                     MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                    AVSARMUAe(:,:,ElecID) = MUAe.data';
                    AVSARlfp(:,:,ElecID) = LFP.data';
                end
            end
            
            artifactRemovedFolder='AR';
            artifactRemovedChPathName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder);
            if ~exist(artifactRemovedChPathName,'dir')
                mkdir(artifactRemovedChPathName);
            end
                     
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
            %combine data across channels:
            if includeIncorrect==1%all trials
                allMeanAMFARMUAe_all{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAVFARMUAe_all{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAMSARMUAe_all{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAVSARMUAe_all{blockInd}(neuronalCh,:)=meanAMSARMUAe;
            elseif includeIncorrect==2%only correct trials
                allMeanAMFARMUAe_cor{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAVFARMUAe_cor{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAMSARMUAe_cor{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAVSARMUAe_cor{blockInd}(neuronalCh,:)=meanAMSARMUAe;
            end
        end
    end
end
artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_all mean_chs_block',num2str(blockInd),'.mat']);
save(artifactRemovedFileName,'allMeanAMFARMUAe_all','allMeanAVFARMUAe_all','allMeanAMSARMUAe_all','allMeanAVSARMUAe_all','allMeanAMFARMUAe_cor','allMeanAVFARMUAe_cor','allMeanAMSARMUAe_cor','allMeanAVSARMUAe_cor')
