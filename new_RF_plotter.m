function new_RF_plotter
%Written by Xing 6/3/18 to plot RF centres for new set of electrodes on
%which stimulation is delivered. Based on impedance values measured on
%28/2/18.

date='280218';
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

load('D:\data\currentThresholdChs87.mat')

figure;hold on
impThreshold=150;
for candidateInd=1:size(goodArrays8to16,1)
    array=goodArrays8to16(candidateInd,7);
    channel=goodArrays8to16(candidateInd,8);
    plot(goodArrays8to16(candidateInd,1),goodArrays8to16(candidateInd,2),'MarkerEdgeColor',colind(array,:),'Marker','o','MarkerSize',12);
    text(goodArrays8to16(candidateInd,1)-0.5,goodArrays8to16(candidateInd,2),num2str(channel),'FontSize',7,'Color',colind(array,:));
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
title('RF centres, new list based on 28/2/18 impedances');
for ind=8:16
    text(160,-ind*5+30,num2str(ind),'FontSize',14,'Color',colind(ind,:));
end
pathname=fullfile('C:\Users\User\Documents\impedance_values\',date,['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals']);
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff','-r600');
setElectrodesUsed=[];
setArraysUsed=[];
letterInd=2;
for setInd=37:43
    switch(setInd)
        case 37
            setElectrodes=[{[39 34 56 52 55 3 41 13 20 23]} {[44 39 58 15 30 27 32 63 10 19]} {[41 44 19 23 7 15 21 21 23 47]} {[39 37 39 17 41 34 6 11 20 23]}];%I, O, A, L. 080319
            setArrays=[{[16 16 16 8 14 14 12 12 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[12 14 16 16 16 16 16 14 12 14]} {[16 16 12 9 12 12 12 12 12 12]}];
        case 38
            setElectrodes=[{[9 16 32 15 62 9 55 3 5 36]} {[6 61 22 62 10 64 64 23 31 5]} {[34 15 6 64 48 55 49 30 15 54]} {[40 10 7 16 33 12 42 32 31 30]}];%T, O, A, L. 20/3/18
            setArrays=[{[16 16 16 16 16 8 14 14 12 12]} {[14 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 16 16 14 12 16 14]} {[16 16 12 12 12 12 12 12 12 12]}];
        case 39
            setElectrodes=[{[45 43 22 55 19 59 63 13 21 61]} {[45 19 55 11 30 30 52 36 6 15]} {[18 58 55 22 62 1 46 64 28 21]} {[6 16 19 6 15 35 19 22 64 63]}];%T, O, A, L. 28/1/18
            setArrays=[{[16 16 16 16 8 16 14 14 12 12]} {[14 16 16 8 14 12 12 12 12 12]} {[12 14 14 16 16 8 14 12 12 12]} {[16 16 16 14 12 12 12 12 12 12]}];
        case 40
            setElectrodes=[{[4 58 53 1 10 27 12 54 29 44]} {[16 7 4 32 1 16 20 20 2 12]} {[33 17 4 6 34 36 13 22 45 40]} {[46 4 45 14 50 2 44 10 27 28]}];%290118_B & B?
            setArrays=[{[16 16 16 8 8 8 16 14 14 12]} {[12 12 16 16 8 14 14 12 12 12]} {[12 9 16 16 16 16 14 12 14 14]} {[16 16 14 12 12 12 12 12 12 12]}];
        case 41
            setElectrodes=[{[40 6 22 50 48 63 11 31 30 31]} {[20 49 46 1 53 43 42 34 56 58]} {[1 31 37 31 8 29 48 39 58 41]} {[27 60 24 59 56 34 9 42 44 51]}];%030418_B & B?
            setArrays=[{[16 16 8 8 15 15 8 14 12 10]} {[16 10 15 15 13 10 10 10 9 12]} {[10 10 12 14 15 15 13 10 10 13]} {[16 14 12 12 9 10 10 10 10 10]}];
        case 42
            setElectrodes=[{[46 64 30 49 46 28 30 63 28 34]} {[19 62 49 38 46 35 9 31 61 60]} {[27 57 12 27 22 27 64 47 42 25]} {[40 56 20 12 61 52 14 41 49 55]}];%030418_B & B?
            setArrays=[{[16 16 16 10 15 15 14 12 12 10]} {[8 15 15 13 10 10 10 10 12 14]} {[9 12 14 16 8 8 14 13 10 12]} {[8 16 16 14 12 12 13 13 13 13]}];
        case 43
            setElectrodes=[{[49 28 55 53 8 16 46 51 25 50]} {[27 20 8 6 21 34 25 36 30 40]}];%030418_B & B?
            setArrays=[{[13 13 13 13 11 11 10 10 10 10]} {[13 13 11 11 10 11 10 10 10 10]}];
    end
    setElectrodesUsed=[setElectrodesUsed cell2mat(setElectrodes(letterInd))];
    setArraysUsed=[setArraysUsed cell2mat(setArrays(letterInd))];
end
uniqueInd=unique([setElectrodesUsed' setArraysUsed'],'rows','stable');
setElectrodesUsed=uniqueInd(:,1);
setArraysUsed=uniqueInd(:,2);

figure;hold on
impThreshold=150;
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
ylim([-140 0]);
title('RF centres, new list based on 28/2/18 impedances');
for ind=8:16
    text(160,-ind*5+30,num2str(ind),'FontSize',14,'Color',colind(ind,:));
end
pathname=fullfile('C:\Users\User\Documents\impedance_values\',date,['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals']);
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff','-r600');
    
%To plan out electrode sets for a given letter:
if letterInd==1
    % targetLetter='I';
    targetLetter='T';
elseif letterInd==2
    targetLetter='O';
elseif letterInd==3
    targetLetter='A';
elseif letterInd==4
    targetLetter='L';
end
letterPath=['D:\data\letters\',targetLetter,'.bmp'];
originalOutline=imread(letterPath);
shape=imresize(originalOutline,[50,50]);
% shape=imresize(originalOutline,[90,90]);
whiteMask=shape==1;
whiteMask=whiteMask*255;
shapeRGB=[];
shapeRGB(:,:,1)=whiteMask+shape*255*colind(1);
shapeRGB(:,:,2)=whiteMask+shape*255*colind(2);
shapeRGB(:,:,3)=whiteMask+shape*255*colind(3);
if strcmp(targetLetter,'A')||strcmp(targetLetter,'I')
%     h=image(10,-75,flip(shapeRGB,1));
%     h=image(13,-115,flip(shapeRGB,1));
    h=image(95,-110,flip(shapeRGB,1));
elseif strcmp(targetLetter,'O')
%     h=image(10,-83,flip(shapeRGB,1));
    h=image(93,-128,flip(shapeRGB,1));
elseif strcmp(targetLetter,'T')
%     h=image(13,-80,flip(shapeRGB,1));
    h=image(90,-135,flip(shapeRGB,1));
elseif strcmp(targetLetter,'L')
%     h=image(20,-75,flip(shapeRGB,1));
%     h=image(30,-95,flip(shapeRGB,1));
    h=image(115,-110,flip(shapeRGB,1));
end
set(h, 'AlphaData', 0.1);
            
%load values generated by impedance_plotter4.m, for electrodes with impedance values of up to 10,000 kOhms:
allRemainingArrays=[];
for arrayInd=1:16
   load(['C:\Users\User\Documents\impedance_values\280218\max10000kohms_array',num2str(arrayInd),'.mat'],['array',num2str(arrayInd)]); 
   temp1=find(goodArrays8to16(:,7)==arrayInd);
   eval(['remainingArray=array',num2str(arrayInd),';']);
   for rowInd=1:length(temp1)
       channel=goodArrays8to16(temp1(rowInd),8);
       eval(['temp2=find(remainingArray(:,8)==channel);']);
       remainingArray(temp2,:)=[];
   end
   allRemainingArrays=[allRemainingArrays;remainingArray];
end

strict=1;%set to 1 to exclude all channels where RFs are above horizontal meridian
%set to 0 to include channels with RFs that are within 1 degree from
%horizontal meridian.
if strict==1
    badRow=[];
    for rowInd=1:size(allRemainingArrays,1)
        if allRemainingArrays(rowInd,1)<0||allRemainingArrays(rowInd,1)>250||allRemainingArrays(rowInd,2)<-200||allRemainingArrays(rowInd,2)>0||allRemainingArrays(rowInd,3)>250
            badRow=[badRow;rowInd];
        end
    end
    a=allRemainingArrays(badRow,:);
    allRemainingArrays(badRow,:)=[];
elseif strict==0
    %less conservative version:
    badRow=[];
    for rowInd=1:size(allRemainingArrays,1)
        if allRemainingArrays(rowInd,1)<0||allRemainingArrays(rowInd,1)>250||allRemainingArrays(rowInd,2)<-200||allRemainingArrays(rowInd,2)>26||allRemainingArrays(rowInd,3)>250
            badRow=[badRow;rowInd];
        end
    end
    a=allRemainingArrays(badRow,:);
    allRemainingArrays(badRow,:)=[];
end

load('C:\Users\User\Documents\impedance_values\280218\allRemainingArrays','allRemainingArrays');
deleteArrays=find(allRemainingArrays(:,7)<8);
allRemainingArrays(deleteArrays,:)=[];
[dummy ind]=sort(allRemainingArrays(:,6));
allRemainingArraysSorted=allRemainingArrays(ind,:);
excludeElectrodes=[19 57 5];%manually exclude these channels, for which good current thresholds could not be obtained previously
excludeArrays=[13 13 16];
for excludeInd=1:length(excludeElectrodes)
    temp1=find(allRemainingArraysSorted(:,7),excludeArrays(excludeInd));
    temp2=find(allRemainingArraysSorted(:,8),excludeElectrodes(excludeInd));
    intersectInd=intersect(temp1,temp2);
    if ~isempty(intersectInd)
        allRemainingArraysSorted(intersectInd,:)=[];
    end
end
hist(allRemainingArraysSorted(:,6));
oddArray=[];
evenArray=[];
for rowInd=1:size(allRemainingArraysSorted,1)
    if mod(rowInd,2)==1
        oddArray=[oddArray;allRemainingArraysSorted(rowInd,:)];
    elseif mod(rowInd,2)==0
        evenArray=[evenArray;allRemainingArraysSorted(rowInd,:)];
    end
end