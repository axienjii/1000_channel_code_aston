function analyse_microstim_saccade_eccentricity_polar_angle_aston
%8/1/19
%Written by Xing, modified from analyse_microstim_saccade14_letter.m, reads
%in saccade end location for each trial on a given date (e.g. 110917_B3)
%and calculates eccentricity and polar angle of saccade end point. Compares
%the values obtained for saccade end points with eccentricity and polar
%angle of RF locations, and generates figures for paper.

date='221018_B1_aston';
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\aston\';
end
load(['X:\aston\',date,'\saccade_endpoints_',date,'.mat'])
electrodeAllTrials1=electrodeAllTrials;
arrayAllTrials1=arrayAllTrials;
saccadeEndAllTrials1=saccadeEndAllTrials;

date2='241018_B2_aston';
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\aston\',date2(1:6),'_data'],[rootdir,date2,'\',date2(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\aston\';
end
load(['X:\aston\',date2,'\saccade_endpoints_',date2,'.mat'])
electrodeAllTrials=[electrodeAllTrials1;electrodeAllTrials];
arrayAllTrials=[arrayAllTrials1;arrayAllTrials];
saccadeEndAllTrials=[saccadeEndAllTrials1;saccadeEndAllTrials];

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

figure;hold on
if ~exist('goodArrays8to16','var')
    currentThresholdChs=126;
%     dataDir2=['X:\best\180518_B2','\180518_data'];
%     load([dataDir2,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
    load('X:\aston\221018_B1_aston\221018_data\currentThresholdChs8.mat')
end
pixperdeg=25.8601;
for trialInd=1:length(electrodeAllTrials)
    array=arrayAllTrials(trialInd);
    arrayColInd=find(arrays==array);
    electrode=electrodeAllTrials(trialInd);
    electrodeIndTemp1=find(goodArrays8to16(:,8)==electrode);
    electrodeIndTemp2=find(goodArrays8to16(:,7)==array);
    electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
    impedance=goodArrays8to16(electrodeInd,6);
    %             RFx=goodArrays8to16(electrodeInd,1);
    %             RFy=goodArrays8to16(electrodeInd,2);
    RFx=goodArrays8to16(electrodeInd,1);
    RFy=goodArrays8to16(electrodeInd,2);
    
%     electrodeNumsAll=load('D:\data\channel_area_mapping.mat','channelNums');
%     electrodeNumsAll=electrodeNumsAll.channelNums;
%     arrayNumsAll=load('D:\data\channel_area_mapping.mat','arrayNums');
%     arrayNumsAll=arrayNumsAll.arrayNums;
%     electrodeIndTemp1=find(electrodeNumsAll(:)==electrode);
%     electrodeIndTemp2=find(arrayNumsAll(:)==array);
%     electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
%     instance=ceil(electrodeInd/128);
%     chInd128=mod(electrodeInd,128);
%     if chInd128==0
%         chInd128=128;
%     end
%     load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat'])
%     
%     if RFy<-500
%         RFy=NaN;
%     end
    polarAngleRF=atan2(RFy,RFx);
    eccentricityRF=sqrt(RFx^2+RFy^2)/pixperdeg;
    polarAngleSac=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
    eccentricitySac=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    allPolarAngleRFs(trialInd)=polarAngleRF;
    allEccentricityRFs(trialInd)=eccentricityRF;
    allPolarAngleSacs(trialInd)=polarAngleSac;
    allEccentricitySacs(trialInd)=eccentricitySac;
end

%remove outliers:
outliers1=find(allPolarAngleRFs<-2);
outliers2=find(allPolarAngleSacs<-2);
outliers=union(outliers1,outliers2);
allPolarAngleRFs(outliers)=[];
allPolarAngleSacs(outliers)=[];

outliers1=find(allEccentricityRFs>10);
outliers2=find(allEccentricitySacs>10);
outliers=union(outliers1,outliers2);
allEccentricityRFs(outliers)=[];
allEccentricitySacs(outliers)=[];

ax1=subplot(1,2,1);
%     plot(polarAngleRF,polarAngleSac,'ko','MarkerSize',2,'MarkerFaceColor','k');hold on
scatter(allPolarAngleRFs,allPolarAngleSacs,2,'ko');hold on
ax2=subplot(1,2,2);
%     plot(eccentricityRF,eccentricitySac,'ko','MarkerSize',2,'MarkerFaceColor','k');hold on
scatter(allEccentricityRFs,allEccentricitySacs,2,'ko');hold on
subplot(1,2,1);
axis equal
axis square
xlabel('RF polar angle (rad)');
ylabel('Saccade end point polar angle');
ylabel('Saccade polar angle (rad)');
h1 = lsline(ax1);
h1.Color = 'r';

subplot(1,2,2);
xlim([0 5])
axis equal
axis square
xlabel('RF eccentricity (dva)');
ylabel('Saccade end point eccentricity');
ylabel('Saccade eccentricity (dva)');
ax=gca;
ax.XTick=[0 5];
ax.XTickLabel={'0','5'};
ax.YTick=[0 5];
ax.YTickLabel={'0','5'};
h2 = lsline(ax2);
h2.Color = 'r';
[rhoPA,pPA]=corrcoef([allPolarAngleRFs',allPolarAngleSacs'],'rows','pairwise')%r=0.74; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFs',allEccentricitySacs'],'rows','pairwise')%r=0.63; p<.001
%         axis equal
%         xlim([-20 360]);
%         ylim([-220 15]);
%         title('saccade endpoints (filled), second saccade endpoints (X), and RF centres');
%         for arrayInd=1:length(arrays)
%             text(260,0-6*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
%         end
%         ax=gca;
%         ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8 Par.PixPerDeg*10 Par.PixPerDeg*12];
%         ax.XTickLabel={'0','2','4','6','8','10','12'};
%         ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
%         ax.YTickLabel={'-8','-6','-4','-2','0'};
%         xlabel('x-coordinates (dva)')
%         ylabel('y-coordinates (dva)')
%         set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%         pathname=fullfile(rootdir,date,['saccade_endpoints_RFs_second_saccade_',date]);
%         print(pathname,'-dtiff','-r600');      
        
pause=1;