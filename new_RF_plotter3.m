function new_RF_plotter3
%Written by Xing 17/5/18 to plot RF centres for new set of electrodes on
%which stimulation is delivered, for new combinations of electrodes, as
%well as a higher number of electrodes. Forms the letters T and O.

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
for setInd=64:67
    switch(setInd)
        case 64%begin with new combinations
            setElectrodes=[{[4 54 13 21 46 31 32 49 1 32 29 47 41 9 28]} {[52 21 21 31 32 29 4 23 20 39 30 17 9 34 31]} {[]} {[]}];%170518_B & B?
            setArrays=[{[14 14 14 14 14 14 14 15 15 13 12 13 13 10 10]} {[12 12 14 14 14 15 15 13 13 10 10 10 10 10 10]} {[]} {[]}];
        case 65
            setElectrodes=[{[40 6 7 56 22 43 50 22 53 20 15 12 21 20 61]} {[7 4 16 34 60 9 27 64 63 30 10 61 19 35 15]} {[]} {[]}];%170518_B & B?
            setArrays=[{[16 16 16 16 8 8 8 16 16 16 14 14 12 12 12]} {[12 16 16 16 16 8 8 14 12 12 12 12 12 12 12]} {[]} {[]}];
        case 66
            setElectrodes=[{[39 38 31 15 30 52 9 49 1 27 63 28 56 31 52]} {[16 39 37 44 7 56 62 11 19 30 64 23 36 18 12]} {[]} {[]}];%170518_B & B?
            setArrays=[{[16 16 16 16 16 8 8 10 8 16 14 14 12 12 12]} {[12 12 16 16 16 16 16 8 8 14 12 12 12 12 12]} {[]} {[]}];
        case 67
            setElectrodes=[{[37 58 36 59 55 11 27 46 28 30 64 30 26 31 34]} {[50 58 55 53 30 10 49 46 24 38 42 28 1 27 5]} {[]} {[]}];%170518_B & B?
            setArrays=[{[16 16 16 16 16 8 8 15 15 14 12 12 12 10 10]} {[12 14 14 16 16 8 10 15 13 10 10 10 10 9 9]} {[]} {[]}];
        case 68
            setElectrodes=[{[9 10 16 63 62 10 19 48 8 21 46 20 22 10 56]} {[44 29 13 20 1 8 28 49 32 53 55 46 4 60 56]} {[]} {[]}];%170518_B & B?
            setArrays=[{[16 16 16 16 16 8 8 15 15 16 14 14 12 12 9]} {[12 14 14 16 8 15 15 15 13 13 10 10 10 10 9]} {[]} {[]}];
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
% shape=imresize(originalOutline,[60,60]);
shape=imresize(originalOutline,[100,100]);
whiteMask=shape==1;
whiteMask=whiteMask*255;
shapeRGB=[];
shapeRGB(:,:,1)=whiteMask+shape*255*colind(1);
shapeRGB(:,:,2)=whiteMask+shape*255*colind(2);
shapeRGB(:,:,3)=whiteMask+shape*255*colind(3);
if strcmp(targetLetter,'A')||strcmp(targetLetter,'I')
%     h=image(10,-75,flip(shapeRGB,1));
%     h=image(13,-115,flip(shapeRGB,1));
%     h=image(95,-110,flip(shapeRGB,1));
%     h=image(20,-80,flip(shapeRGB,1));
%     h=image(13,-90,flip(shapeRGB,1));
%     h=image(17,-80,flip(shapeRGB,1));
%     h=image(90,-120,flip(shapeRGB,1));
%     h=image(18,-85,flip(shapeRGB,1));
%     h=image(5,-78,flip(shapeRGB,1));
%     h=image(85,-125,flip(shapeRGB,1));
%     h=image(60,-120,flip(shapeRGB,1));
%     h=image(27,-122,flip(shapeRGB,1));
%     h=image(13,-112,flip(shapeRGB,1));
    h=image(55,-125,flip(shapeRGB,1));
elseif strcmp(targetLetter,'O')
%     h=image(10,-83,flip(shapeRGB,1));
%     h=image(13,-80,flip(shapeRGB,1));
%     h=image(30,-88,flip(shapeRGB,1));
%     h=image(40,-120,flip(shapeRGB,1));
%     h=image(12,-85,flip(shapeRGB,1));
    h=image(30,-130,flip(shapeRGB,1));
elseif strcmp(targetLetter,'T')
%     h=image(13,-80,flip(shapeRGB,1));
%     h=image(90,-135,flip(shapeRGB,1));
%     h=image(13,-90,flip(shapeRGB,1));
%     h=image(37,-130,flip(shapeRGB,1));
%     h=image(15,-80,flip(shapeRGB,1));
    h=image(10,-105,flip(shapeRGB,1));
elseif strcmp(targetLetter,'L')
%     h=image(20,-75,flip(shapeRGB,1));
%     h=image(30,-95,flip(shapeRGB,1));
%     h=image(115,-110,flip(shapeRGB,1));
%     h=image(18,-78,flip(shapeRGB,1));
%     h=image(17,-78,flip(shapeRGB,1));
%     h=image(30,-88,flip(shapeRGB,1));
%     h=image(110,-115,flip(shapeRGB,1));
%     h=image(30,-65,flip(shapeRGB,1));
%     h=image(30,-85,flip(shapeRGB,1));
%     h=image(108,-110,flip(shapeRGB,1));
%     h=image(40,-62,flip(shapeRGB,1));
%     h=image(40,-95,flip(shapeRGB,1));
%     h=image(90,-110,flip(shapeRGB,1));
    h=image(90,-105,flip(shapeRGB,1));
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