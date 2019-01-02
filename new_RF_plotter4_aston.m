function new_RF_plotter4_aston
%Written by Xing 3/9/18 to plot RF centres for new set of electrodes on
%which stimulation is delivered, for new combinations of electrodes, as
%well as a higher number of electrodes. Forms the letters I, O, U and N.

% date='280818';
% date='041018';
% date='211218';
date='281218';
colind = hsv(16);
colind(8,:)=[1 0 0];
colind(10,:)=[139/255 69/255 19/255];
colind(11,:)=[50/255 205/255 50/255];
colind(12,:)=[0 0 1];
colind(13,:)=[0 0 0];
colind(14,:)=[1 20/255 147/255];
colind(15,:)=[230/255 230/255 0];
colind(16,:)=[139/255 0 139/255];

colindImp = hsv(1000);%colour-code impedances

% load('X:\aston\290818_B1_aston\currentThresholdChs1.mat')
% load('X:\aston\231018_data\currentThresholdChs9.mat')
% load('X:\aston\211218_data\currentThresholdChs37.mat')
load('X:\aston\281218_data\currentThresholdChs39.mat')

if strcmp(date,'041018')
    goodArrays8to16New=[];
    goodCurrentThresholdsNew=[];
    goodChs=[1,2,3,5,6,7,9,11,13,15,18,22,25,28,29,34,35,36,38,41,46,49,52,57,59,60,1,3,4,7,8,15,16,22,23,25,28,29,30,38,45,49,50,54,57,58,59,62,63,2,5,8,16,23,40,46,48,52,54,55,56,60,63,64,2,9,11,17,25,26,28,33,39,42,44,45,46,48,49,52,54,55,57,58,59,60,61,62,63,64,6,7,13,16,23,26,28,33,47,52,53,1,3,9,10,13,17,18,19,25,27,28,30,31,33,34,35,36,38,39,40,41,42,43,44,48,49,50,51,52,53,54,55,56,57,59,60,61,62,63,64,1,9,12,16,21,24,30,35,38,50,59,63,4,16,24,40,44,46,48,49,56,57,63,30,31,34,36,40,41,43,48,49,51,53,54,55,56,58,60,61,64];
    arrayNums=[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16];
    for chInd=1:length(goodChs)
        temp1=find(goodArrays8to16(:,7)==arrayNums(chInd));
        temp2=find(goodArrays8to16(:,8)==goodChs(chInd));
        rowInd=intersect(temp1,temp2);
        goodArrays8to16New=[goodArrays8to16New;goodArrays8to16(rowInd,:)];
        goodCurrentThresholdsNew=[goodCurrentThresholdsNew;goodCurrentThresholds(rowInd,:)];
    end
    goodArrays8to16=goodArrays8to16New(:,1:8);
    goodCurrentThresholds=goodCurrentThresholdsNew;
end

if strcmp(date,'211218')
    load('X:\aston\211218_data\currentThresholdChs38.mat')
    goodArrays8to16New=goodArrays8to16;
    goodCurrentThresholdsNew=goodCurrentThresholds;
    excludeChs=find(goodCurrentThresholds==210);
    goodArrays8to16New(excludeChs,:)=[];
    goodCurrentThresholdsNew(excludeChs,:)=[];
    goodArrays8to16=goodArrays8to16New(:,1:8);
    goodCurrentThresholds=goodCurrentThresholdsNew;
end

if strcmp(date,'281218')
    load('X:\aston\281218_data\currentThresholdChs39.mat')
    goodArrays8to16New=goodArrays8to16;
    goodCurrentThresholdsNew=goodCurrentThresholds;
    excludeChs=find(goodCurrentThresholds==210);
    goodArrays8to16New(excludeChs,:)=[];
    goodCurrentThresholdsNew(excludeChs,:)=[];
    goodArrays8to16=goodArrays8to16New(:,1:8);
    goodCurrentThresholds=goodCurrentThresholdsNew;
end

figure;hold on
% impThreshold=300;
impThreshold=200;
for candidateInd=1:size(goodArrays8to16,1)
    array=goodArrays8to16(candidateInd,7);
    channel=goodArrays8to16(candidateInd,8);
    if array~=8
        plot(goodArrays8to16(candidateInd,1),goodArrays8to16(candidateInd,2),'MarkerEdgeColor',colind(array,:),'Marker','o','MarkerSize',12);
        text(goodArrays8to16(candidateInd,1)-0.5,goodArrays8to16(candidateInd,2),num2str(channel),'FontSize',7,'Color',colind(array,:));
    end
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
axis equal
xlim([0 200]);
ylim([-140 0]);
% title('RF centres, based on 28/8/18 impedances');
% title('RF centres, based on 4/10/18 impedances');
% title('RF centres, based on 18/12/18 impedances and current thresholding');
title('RF centres, based on 18/12/18 impedances and current thresholding');
for ind=8:16
    text(160,-ind*5+30,num2str(ind),'FontSize',14,'Color',colind(ind,:));
end
pathname=fullfile('X:\aston\aston_impedance_values\',date,['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals']);
if strcmp(date,'281218')
    pathname=fullfile('X:\aston\aston_impedance_values\','181218',['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals']);
end
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff','-r600');
setElectrodesUsed=[];
setArraysUsed=[];
letterInd=2;
% for setInd=1:1
%     switch(setInd)
%         case 1%begin with new combinations
%             setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]} {[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
%             setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]} {[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
%     end
%     setElectrodesUsed=[setElectrodesUsed cell2mat(setElectrodes(letterInd))];
%     setArraysUsed=[setArraysUsed cell2mat(setArrays(letterInd))];
% end
% uniqueInd=unique([setElectrodesUsed' setArraysUsed'],'rows','stable');
% setElectrodesUsed=uniqueInd(:,1);
% setArraysUsed=uniqueInd(:,2);
setElectrodesUsed=[];
setArraysUsed=[];

figure;hold on
impThreshold=300;
for candidateInd=1:size(goodArrays8to16,1)
    array=goodArrays8to16(candidateInd,7);
    channel=goodArrays8to16(candidateInd,8);
    usedCh=[];%check whether channel has already been used for letter task
    temp1=find(setElectrodesUsed==channel);
    temp2=find(setArraysUsed==array);
    usedCh=intersect(temp1,temp2);
    if isempty(usedCh)
        plot(goodArrays8to16(candidateInd,1),goodArrays8to16(candidateInd,2),'MarkerEdgeColor',colind(array,:),'Marker','o','MarkerSize',12);
        text(goodArrays8to16(candidateInd,1)-0.5,goodArrays8to16(candidateInd,2),num2str(channel),'FontSize',7,'Color',colind(array,:));
    end
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
axis equal
xlim([0 200]);
ylim([-120 20]);
title('RF centres, new list based on 28/8/18 impedances');
for ind=8:16
    text(160,-ind*5+30,num2str(ind),'FontSize',14,'Color',colind(ind,:));
end
pathname=fullfile('X:\aston\aston_impedance_values\',date,['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals']);
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff','-r600');
    
%To plan out electrode sets for a given letter:
if letterInd==1
%     targetLetter='T';
    targetLetter='I';
elseif letterInd==2
%     targetLetter='O';
    targetLetter='U';
elseif letterInd==3
%     targetLetter='A';
    targetLetter='D';
elseif letterInd==4
%     targetLetter='L';
    targetLetter='N';
end
letterPath=['D:\data\letters\',targetLetter,'.bmp'];
originalOutline=imread(letterPath);
% shape=imresize(originalOutline,[60,60]);
shape=imresize(originalOutline,[50,50]);
whiteMask=shape==1;
whiteMask=whiteMask*255;
shapeRGB=[];
shapeRGB(:,:,1)=whiteMask+shape*255*colind(1);
shapeRGB(:,:,2)=whiteMask+shape*255*colind(2);
shapeRGB(:,:,3)=whiteMask+shape*255*colind(3);
if strcmp(targetLetter,'A')||strcmp(targetLetter,'I')
    h=image(50,-40,flip(shapeRGB,1));
elseif strcmp(targetLetter,'O')||strcmp(targetLetter,'U')
    h=image(50,-40,flip(shapeRGB,1));
elseif strcmp(targetLetter,'T')||strcmp(targetLetter,'D')
    h=image(15,-125,flip(shapeRGB,1));
elseif strcmp(targetLetter,'L')||strcmp(targetLetter,'N')
    h=image(15,-125,flip(shapeRGB,1));
end
set(h, 'AlphaData', 0.1);
            
% %load values generated by impedance_plotter4.m, for electrodes with impedance values of up to 10,000 kOhms:
% allRemainingArrays=[];
% for arrayInd=1:16
%    load(['C:\Users\User\Documents\impedance_values\280218\max10000kohms_array',num2str(arrayInd),'.mat'],['array',num2str(arrayInd)]); 
%    temp1=find(goodArrays8to16(:,7)==arrayInd);
%    eval(['remainingArray=array',num2str(arrayInd),';']);
%    for rowInd=1:length(temp1)
%        channel=goodArrays8to16(temp1(rowInd),8);
%        eval(['temp2=find(remainingArray(:,8)==channel);']);
%        remainingArray(temp2,:)=[];
%    end
%    allRemainingArrays=[allRemainingArrays;remainingArray];
% end
% 
% strict=1;%set to 1 to exclude all channels where RFs are above horizontal meridian
% %set to 0 to include channels with RFs that are within 1 degree from
% %horizontal meridian.
% if strict==1
%     badRow=[];
%     for rowInd=1:size(allRemainingArrays,1)
%         if allRemainingArrays(rowInd,1)<0||allRemainingArrays(rowInd,1)>250||allRemainingArrays(rowInd,2)<-200||allRemainingArrays(rowInd,2)>0||allRemainingArrays(rowInd,3)>250
%             badRow=[badRow;rowInd];
%         end
%     end
%     a=allRemainingArrays(badRow,:);
%     allRemainingArrays(badRow,:)=[];
% elseif strict==0
%     %less conservative version:
%     badRow=[];
%     for rowInd=1:size(allRemainingArrays,1)
%         if allRemainingArrays(rowInd,1)<0||allRemainingArrays(rowInd,1)>250||allRemainingArrays(rowInd,2)<-200||allRemainingArrays(rowInd,2)>26||allRemainingArrays(rowInd,3)>250
%             badRow=[badRow;rowInd];
%         end
%     end
%     a=allRemainingArrays(badRow,:);
%     allRemainingArrays(badRow,:)=[];
% end

% load('C:\Users\User\Documents\impedance_values\280218\allRemainingArrays','allRemainingArrays');
% deleteArrays=find(allRemainingArrays(:,7)<8);
% allRemainingArrays(deleteArrays,:)=[];
% [dummy ind]=sort(allRemainingArrays(:,6));
% allRemainingArraysSorted=allRemainingArrays(ind,:);
% excludeElectrodes=[19 57 5];%manually exclude these channels, for which good current thresholds could not be obtained previously
% excludeArrays=[13 13 16];
% for excludeInd=1:length(excludeElectrodes)
%     temp1=find(allRemainingArraysSorted(:,7),excludeArrays(excludeInd));
%     temp2=find(allRemainingArraysSorted(:,8),excludeElectrodes(excludeInd));
%     intersectInd=intersect(temp1,temp2);
%     if ~isempty(intersectInd)
%         allRemainingArraysSorted(intersectInd,:)=[];
%     end
% end
% hist(allRemainingArraysSorted(:,6));
% oddArray=[];
% evenArray=[];
% for rowInd=1:size(allRemainingArraysSorted,1)
%     if mod(rowInd,2)==1
%         oddArray=[oddArray;allRemainingArraysSorted(rowInd,:)];
%     elseif mod(rowInd,2)==0
%         evenArray=[evenArray;allRemainingArraysSorted(rowInd,:)];
%     end
% end