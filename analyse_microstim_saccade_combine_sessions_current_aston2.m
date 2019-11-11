function analyse_microstim_saccade_combine_sessions_current_aston2
%Written by Xing 11/10/19
%Calls function, 'analyse_microstim_saccade14_combine_sessions' to extract
%eye position data and calculate saccade end points, for current
%thresholding sessions. Calculates mean saccade end point across trials for
%each channel, and plots mean saccade end point in figure.
%Modified to run on office PC instead of lab PC.

dates={
    '110918_B3_aston';
    '110918_B5_aston';
    '110918_B6_aston';
    '110918_B7_aston';
    '110918_B8_aston';
    '120918_B1_aston';
    '130918_B1_aston';
    '140918_B1_aston';
    '140918_B2_aston';
    '190918_B1_aston';
    '190918_B2_aston';
    '200918_B1_aston';
    '210918_B1_aston';
    '240918_B1_aston';
    '250918_B1_aston';
    '260918_B1_aston';
    '270918_B1_aston';
    '280918_B1_aston';
    '081018_B1_aston';
    '161018_B1_aston';
    '171018_B1_aston';
    '181018_B1_aston';
    '191018_B1_aston';
    '191018_B2_aston';
    '221018_B1_aston';
    '231018_B1_aston';
    '241018_B2_aston';
    '261018_B1-B6_aston';
    '061118_B2_aston';
    '061118_B3_aston';
    '061118_B4_aston';
    '071118_B2_aston';
    '071118_B3_aston';
    '071118_B4_aston';
    '081118_B1_aston';
    '081118_B3_aston';
    '091118_B1_aston';
    '091118_B3_aston';
    '131118_B1_aston';
    '131118_B3_aston';
    '141118_B1_aston';
    '141118_B5_aston';
    '141118_B6-B9_aston';
    '151118_B1-B3_aston';
    '151118_B7_aston';
    '161118_B1-B2_aston';
    '161118_B8-B9_aston';
    '191118_B1-B4_aston';
    '191118_B8_aston';
    '191118_B10-B12_aston';
    '201118_B1-B8_aston';
    '201118_B10_aston';
    '211118_B1-B2_aston';
    '221118_B1-B3_aston';
    '221118_B6-B8_aston';
    '231118_B1-B3_aston';
    '261118_B1-B4_aston';
    '261118_B8-B9_aston';
    '261118_B15_aston';
    '271118_B4-B5_aston';
    '281118_B1-B4_aston';
    '291118_B5_aston';
    '291118_B7-B8_aston';
    '031218_B4_aston';
    '041218_B1_aston';
    '041218_B8_aston';
    '051218_B1-B2_aston';
    '061218_B1_aston';
    '061218_B3_aston';
    '071218_B4_aston';
    '101218_B1-B3_aston';
    '121218_B1-B2_aston';
    '121218_B5_aston';
    '121218_B11_aston';
    '141218_B1-B2_aston';
    '141218_B5_aston';
    '141218_B8-B10_aston';
    '171218_B1_aston';
    '171218_B5-B7_aston';
   };

suprathresholdCurrent=0;%set to 1 to use conditions with high current amplitudes, with no hits accrued. Set to 0 to use conditions with lower current amplitudes instead
differentCriteria=1;
if differentCriteria==1||suprathresholdCurrent==0
    ind=strfind(dates,'221018_B1_aston');
    removeInd=find(not(cellfun('isempty',ind)));
    dates=dates([1:removeInd-1 removeInd+1:end]);
    ind=strfind(dates,'241018_B2_aston');
    removeInd=find(not(cellfun('isempty',ind)));
    dates=dates([1:removeInd-1 removeInd+1:end]);
end

for dateInd=1:length(dates)
    date=dates{dateInd};
    astonInd=strfind(date,'_aston');
    date(astonInd:astonInd+5)=[];
    hyphenInd=find(date=='-');
    if ~isempty(hyphenInd)
        bInd=find(date=='B');
        firstSessionNum=str2num(date(bInd(1)+1:hyphenInd-1));
        lastSessionNum=str2num(date(bInd(2)+1:end));
        sessionNums=firstSessionNum:lastSessionNum;
        for sessionInd=1:length(sessionNums)
            dates{dateInd,sessionInd}=[date(1:bInd(1)),num2str(sessionNums(sessionInd))];
        end
    end
end
datesReshape=reshape(dates,1,size(dates,1)*size(dates,2));
dates=datesReshape(~cellfun('isempty',datesReshape));

readData=0;
if readData==1
    for dateInd=1:length(dates)
        try
            analyse_microstim_saccade14_combine_sessions_aston(dates{dateInd},1,suprathresholdCurrent);
            close all
        catch ME
            dates{dateInd}
        end
    end
end

localDisk=0;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='T:\aston\';
end

cols = hsv(16);
cols(8,:)=[139/255 69/255 19/255];
cols=cols([1 2 4 5 3 6 7 8 9 10 12 13 14 15 16 11],:);%rearrange to match locations of arrays on Lick's cortex (for paper)
cols(16,:)=[0 0 0];
arrays=8:16;
allPosIndXChs=[];
allPosIndYChs=[];
allElectrodeAllTrials=[];
allArrayAllTrials=[];
figure;hold on
for dateInd=1:length(dates)
    date=dates{dateInd};
    if suprathresholdCurrent==1
        fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_max_amp.mat'];
    elseif suprathresholdCurrent==0
        fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_mid_amp.mat'];
    end
    if exist(fileName,'file')
        load(fileName,'posIndXChs','posIndYChs','currentAmplitudeAllTrials','allElectrodeNumsList','allArrayNumsList');
        allPosIndXChs=[allPosIndXChs posIndXChs];
        allPosIndYChs=[allPosIndYChs posIndYChs];
        allElectrodeAllTrials=[allElectrodeAllTrials allElectrodeNumsList];
        allArrayAllTrials=[allArrayAllTrials allArrayNumsList];
    end
end


%Aston:
electrodeAllTrials=[];
arrayAllTrials=[];
saccadeEndAllTrials=[];
allEccentricityRFs=[];
allEccentricitySacs=[];
allPolarAngleRFs=[];
allPolarAngleSacs=[];
allEccentricityRFsMean=[];
allEccentricitySacsMean=[];
allPolarAngleRFsMean=[];
allPolarAngleSacsMean=[];
addCurrentThreshData=1;%set to 0 to only include data from saccade task with interleaved electrode identities and suprathreshold current amplitudes
%set to 1 to additionally include data from current thresholding sessions, for arrays 9 and 10


if differentCriteria==1
    %include all trials for sessions 221018_B1_aston and 241018_B2_aston (supra-threshold current
    %amplitude; electrode identity interleaved from trial to trial):
    date='221018_B1_aston';%first recording session, suprathreshold current amplitudes, electrode identities interleaved across trials
    localDisk=0;
    if localDisk==1
        rootdir='D:\data\';
        copyfile(['T:\aston\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
    elseif localDisk==0
        rootdir='T:\aston\';
    end
    load(['T:\aston\',date,'\saccade_endpoints_',date,'.mat'])
    electrodeAllTrials1=electrodeAllTrials;
    arrayAllTrials1=arrayAllTrials;
    saccadeEndAllTrials1=saccadeEndAllTrials;
    
    date2='241018_B2_aston';%second recording session, suprathreshold current amplitudes, electrode identities interleaved across trials
    localDisk=0;
    if localDisk==1
        rootdir='D:\data\';
        copyfile(['T:\aston\',date2(1:6),'_data'],[rootdir,date2,'\',date2(1:6),'_data']);
    elseif localDisk==0
        rootdir='T:\aston\';
    end
    load(['T:\aston\',date2,'\saccade_endpoints_',date2,'.mat'])
    electrodeAllTrials2=electrodeAllTrials;
    arrayAllTrials2=arrayAllTrials;
    saccadeEndAllTrials2=saccadeEndAllTrials;
    electrodeAllTrials=[electrodeAllTrials1;electrodeAllTrials2];
    arrayAllTrials=[arrayAllTrials1;arrayAllTrials2];
    saccadeEndAllTrials=[saccadeEndAllTrials1;saccadeEndAllTrials2];
    
    allElectrodeAllTrials=[allElectrodeAllTrials electrodeAllTrials'];
    allArrayAllTrials=[allArrayAllTrials arrayAllTrials'];
    allPosIndXChs=[allPosIndXChs num2cell(saccadeEndAllTrials(:,1))'];
    allPosIndYChs=[allPosIndYChs num2cell(saccadeEndAllTrials(:,2))'];
end

uniqueInd=unique([allElectrodeAllTrials' allArrayAllTrials'],'rows','stable');
electrodeNums=uniqueInd(:,1);
arrayNums=uniqueInd(:,2);
for uniqueElectrode=1:length(electrodeNums)
    temp1=find(allElectrodeAllTrials==electrodeNums(uniqueElectrode));
    temp2=find(allArrayAllTrials==arrayNums(uniqueElectrode));
    ind=intersect(temp1,temp2);
    uniqueElectrodeList(uniqueElectrode)=electrodeNums(uniqueElectrode);
    uniqueArrayList(uniqueElectrode)=arrayNums(uniqueElectrode);
    allPosIndXChsUnique(uniqueElectrode)={cell2mat(allPosIndXChs(ind))};
    allPosIndYChsUnique(uniqueElectrode)={cell2mat(allPosIndYChs(ind))};
end
indRemove=find(uniqueElectrodeList==0);
uniqueElectrodeList(indRemove)=[];
uniqueArrayList(indRemove)=[];
allPosIndXChsUnique(indRemove)=[];
allPosIndYChsUnique(indRemove)=[];
electrodeNums(indRemove)=[];
arrayNums(indRemove)=[];

for chNum=1:length(uniqueElectrodeList)
    if ~isempty(allPosIndXChsUnique{chNum})
        array=arrayNums(chNum);
        arrayColInd=find(arrays==array);
        meanX=nanmean(allPosIndXChsUnique{chNum});
        meanY=nanmean(allPosIndYChsUnique{chNum});
        plot(meanX,-meanY,'MarkerFaceColor',cols(array,:),'MarkerEdgeColor',cols(array,:),'Marker','o','MarkerSize',5);
    end
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
axis equal
xlim([-10 140]);
ylim([-120 20]);
title('saccade endpoints');
for arrayInd=1:length(arrays)
    text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrays(arrayInd),:));
end
xlabel('x-coordinates (dva)')
ylabel('y-coordinates (dva)')
ax=gca;
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pathname=fullfile(rootdir,date,['saccade_endpoints_dva_max_amp_',date]);
pathname=fullfile(rootdir,date,['saccade_endpoints_dva_mid_amp_',date]);
%         print(pathname,'-dtiff','-r600');
set(gca,'visible','off')

figure; 
hold on
for chNum=1:length(uniqueElectrodeList)
    if ~isempty(allPosIndXChsUnique{chNum})
        array=arrayNums(chNum);
        arrayColInd=find(arrays==array);
        for trialInd=1:length(allPosIndXChsUnique{chNum})
            plot(allPosIndXChsUnique{chNum}(trialInd),-allPosIndYChsUnique{chNum}(trialInd),'MarkerFaceColor',cols(array,:),'MarkerEdgeColor',cols(array,:),'Marker','o','MarkerSize',5);
        end
    end
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
axis equal
xlim([-20 220]);
ylim([-200 15]);
title('saccade endpoints');
for arrayInd=1:length(arrays)
    text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrays(arrayInd),:));
end
xlabel('x-coordinates (dva)')
ylabel('y-coordinates (dva)')
ax=gca;
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pause=1;