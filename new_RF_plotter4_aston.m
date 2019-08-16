function new_RF_plotter4_aston
%Written by Xing 3/9/18 to plot RF centres for new set of electrodes on
%which stimulation is delivered, for new combinations of electrodes, as
%well as a higher number of electrodes. Forms the letters I, O, U and N.

% date='280818';
% date='041018';
% date='211218';
% date='281218';
date='100719';
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
% load('X:\aston\281218_data\currentThresholdChs39.mat')
load('D:\aston_data\currentThresholdChs77.mat')

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

if strcmp(date,'100719')
%     load('D:\aston_data\currentThresholdChs77.mat')
%     goodArrays8to16New=goodArrays8to16;
%     goodCurrentThresholdsNew=goodCurrentThresholds;
%     excludeChs=find(goodCurrentThresholds==210);
%     goodArrays8to16New(excludeChs,:)=[];
%     goodCurrentThresholdsNew(excludeChs,:)=[];
%     goodArrays8to16=goodArrays8to16New(:,1:8);
%     goodCurrentThresholds=goodCurrentThresholdsNew;
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
% print(pathname,'-dtiff','-r600');
setElectrodesUsed=[];
setArraysUsed=[];
letterInd=1;
% for setInd=5:7%3:3
%     switch(setInd)
%         case 1%begin with new combinations
%             setElectrodes=[{[51 40 53 32 61 9 16 50 2 17]} {[51 55 52 34 17 54 52 61 35 55]}];%020119_B & B?
%             setArrays=[{[16 16 13 14 13 14 14 14 16 16]} {[16 16 16 16 16 13 13 13 14 12]}];
%         case 2
%             setElectrodes=[{[51 53 32 61 16 9 12 47 50 34]} {[32 47 44 41 34 17 32 59 12 47]}];%020119_B & B?        
%             setArrays=[{[16 13 14 13 12 14 14 12 14 16]} {[16 16 16 16 16 16 14 13 14 12]}];
%         case 3
%             setElectrodes=[{[32 62 52 51 50 56 64 53 55 27]} {[40 48 62 27 2 51 50 56 64 53]}];%280119_B2 & 290119B3
%             setArrays=[{[16 13 13 13 13 11 11 12 12 16]} {[16 16 16 16 16 13 13 11 11 12]}];
%         case 4
%             setElectrodes=[{[40 53 32 30 21 49 57 47 50 9]} {[51 55 52 9 17 54 30 16 16 55]}];%040119_B2 & B4
%             setArrays=[{[16 13 14 14 14 13 13 12 14 16]} {[16 16 16 16 16 13 14 12 14 12]}];
%         case 5
%             setElectrodes=[{[]} {[31 55 62 52 34 24 56 49]} {[51 32 62 52 30 24 9 53]} {[]}];%05119_B & B?
%             setArrays=[{[]} {[16 16 16 16 16 14 11 13]} {[16 16 13 13 14 14 14 12]} {[]}];
%         case 6
%             setElectrodes=[{[]} {[32 47 41 27 2 35 9 64]} {[31 40 53 51 50 16 64 47]} {[]}];%060219_B & B?
%             setArrays=[{[]} {[16 16 16 16 16 14 14 11]} {[16 16 13 13 13 12 11 12]} {[]}];
%         case 7
%             setElectrodes=[{[]} {[40 48 44 9 17 8 12 57]} {[48 47 32 60 59 8 57 55]} {[]}];%00219_B & B?
%             setArrays=[{[]} {[16 16 16 16 16 14 14 13]} {[16 16 14 13 13 14 14 12]} {[]} ];
%     end
%     setElectrodesUsed=[setElectrodesUsed cell2mat(setElectrodes(letterInd))];
%     setArraysUsed=[setArraysUsed cell2mat(setArrays(letterInd))];
% end

for setInd=1:10
    switch(setInd)
        case 1
            setElectrodes=[{[44 37 59 21 32 25 14 10 14 55]} {[6 18 40 40 59 4 37 9 25 19]}];%J and P
            setArrays=[{[16 8 13 14 11 13 11 13 12 13]} {[13 15 15 8 8 15 8 15 8 8]}];
        case 2
            setElectrodes=[{[4 48 30 55 8 32 60 53 18 58]} {[47 37 60 61 7 51 34 19 44 48]}];%%P and J
            setArrays=[{[13 15 8 8 16 16 13 13 8 8]} {[16 8 13 13 12 13 13 13 13 13]}];
        case 3
            setElectrodes=[{[17 2 42 16 12 16 7 63 62 17]} {[31 25 17 32 51 64 61 5 27 37]}];%J and P
            setArrays=[{[16 16 14 14 14 12 12 13 13 8]} {[13 8 8 16 16 16 16 16 16 8]}];
        case 4
            setElectrodes=[{[54 62 41 4 14 31 56 62 43 9]} {[34 27 50 57 35 59 61 32 53 41]}];%%P and J
            setArrays=[{[13 13 8 15 16 16 16 16 16 16]} {[16 16 14 14 14 13 13 14 13 8]}];
        case 5
            setElectrodes=[{[15 24 22 28 38 61 6 56 50 55]} {[12 16 30 34 21 63 50 48 24 26]}];%J and P
            setArrays=[{[15 9 9 9 9 9 10 10 12 12]} {[10 9 11 13 14 11 12 10 10 11]}];
        case 6
            setElectrodes=[{[7 15 9 54 61 35 59 8 60 22]} {[52 8 47 43 34 41 11 11 3 16]}];%%P and J
            setArrays=[{[9 15 13 13 13 14 9 10 11 11]} {[12 10 10 10 9 9 10 9 9 9]}];
        case 7
            setElectrodes=[{[59 34 48 62 49 18 3 31 14 56]} {[15 8 1 56 7 23 12 40 59 25]}];%J and P
            setArrays=[{[9 12 10 9 9 10 10 9 9 9]} {[9 8 13 13 12 12 12 10 11 11]}];
        case 8
            setElectrodes=[{[6 17 11 64 59 16 47 2 58 33]} {[12 16 40 51 26 37 2 23 6 17]}];%%P and J
            setArrays=[{[9 11 11 13 13 14 12 12 11 11]} {[12 10 10 9 10 9 10 9 9 11]}];
        case 9
            setElectrodes=[{[53 11 7 42 25 17 9 20 15 8]} {[14 56 40 63 24 12 53 11 57 28]}];%J and P
            setArrays=[{[12 12 10 10 9 10 10 11 9 8]} {[9 9 11 13 14 14 12 12 11 11]}];
        case 10
            setElectrodes=[{[3 24 12 52 16 9 52 56 49 38]} {[47 2 46 53 44 57 25 1 12 7]}];%%P and J
            setArrays=[{[9 9 11 13 12 14 12 10 11 11]} {[12 12 10 10 10 9 10 10 10 9]}];
    end
    setElectrodesUsed=[setElectrodesUsed cell2mat(setElectrodes(letterInd))];
    setArraysUsed=[setArraysUsed cell2mat(setArrays(letterInd))];
end
uniqueInd=unique([setElectrodesUsed' setArraysUsed'],'rows','stable');
setElectrodesUsed=uniqueInd(:,1);
setArraysUsed=uniqueInd(:,2);
% setElectrodesUsed=[];
% setArraysUsed=[];

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
    targetLetter='O';
%     targetLetter='U';
    targetLetter='J';
%     targetLetter='P';
elseif letterInd==2
    targetLetter='T';
%     targetLetter='I';
elseif letterInd==3
    targetLetter='L';
%     targetLetter='N';
elseif letterInd==4
%     targetLetter='A';
    targetLetter='D';
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
if strcmp(targetLetter,'A')||strcmp(targetLetter,'I')||strcmp(targetLetter,'J')||strcmp(targetLetter,'P')
%     h=image(50,-40,flip(shapeRGB,1));
%     h=image(50,-45,flip(shapeRGB,1));
    h=image(40,-85,flip(shapeRGB,1));
elseif strcmp(targetLetter,'O')||strcmp(targetLetter,'U')
%     h=image(50,-40,flip(shapeRGB,1));
    h=image(50,-49.2,flip(shapeRGB,1));
elseif strcmp(targetLetter,'T')||strcmp(targetLetter,'D')
%     h=image(50,-43,flip(shapeRGB,1));
%     h=image(52,-43,flip(shapeRGB,1));
    h=image(52,-45,flip(shapeRGB,1));
elseif strcmp(targetLetter,'L')||strcmp(targetLetter,'N')
%     h=image(50,-40,flip(shapeRGB,1));
    h=image(52,-35,flip(shapeRGB,1));
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