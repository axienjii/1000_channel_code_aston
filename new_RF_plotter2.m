function new_RF_plotter2
%Written by Xing 17/4/18 to plot RF centres for new set of electrodes on
%which stimulation is delivered, for new combinations of electrodes. Based on impedance values measured on
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
letterInd=4;
for setInd=44:61
    switch(setInd)
        case 44%begin with new combinations
            setElectrodes=[{[9 46 24 22 62 11 36 40 5 43]} {[37 16 15 1 48 56 57 6 15 7]} {[34 14 44 58 34 22 63 20 23 3]} {[39 10 7 16 41 12 42 43 31 23]}];%170418_B & B?
            setArrays=[{[16 16 16 16 16 8 16 14 12 12]} {[16 16 16 8 14 12 12 12 12 12]} {[12 12 14 16 16 16 14 14 12 14]} {[16 16 12 12 12 12 12 12 12 12]}];
        case 45
            setElectrodes=[{[35 16 32 15 30 61 47 58 19 2]} {[39 50 23 22 16 20 24 60 42 14]} {[12 6 61 56 55 27 48 30 3 13]} {[40 46 4 44 15 35 6 57 22 30]}];%180418_B & B?
            setArrays=[{[16 16 16 16 16 16 14 14 12 12]} {[12 16 16 16 14 14 12 12 12 12]} {[12 14 16 16 16 16 14 12 14 14]} {[16 16 16 14 12 12 12 12 12 12]}];
        case 46
            setElectrodes=[{[40 6 48 22 43 53 63 13 21 61]} {[16 18 61 23 64 19 22 48 6 10]} {[9 45 28 32 48 62 1 16 28 12]} {[6 16 19 45 14 18 11 56 64 29]}];%180418_B & B?
            setArrays=[{[16 16 16 8 8 16 14 14 12 12]} {[12 12 12 12 14 8 8 16 16 16]} {[12 14 16 16 16 16 8 14 12 14]} {[16 16 16 14 12 12 12 12 12 12]}];
        case 47
            setElectrodes=[{[39 38 34 56 52 50 21 54 29 44]} {[17 35 38 60 9 32 64 31 32 13]} {[2 5 5 59 45 27 31 29 47 49]} {[38 19 45 14 50 2 44 10 27 28]}];%180418_B & B?
            setArrays=[{[16 16 16 16 8 8 16 14 14 12]} {[9 16 16 16 8 14 12 12 12 12]} {[12 12 14 16 8 8 14 12 13 14]} {[16 16 14 12 12 12 12 12 12 12]}];    
        case 48
            setElectrodes=[{[3 44 64 55 9 27 59 12 20 52]} {[59 45 19 7 56 11 31 60 44 19]} {[64 13 58 36 15 30 28 64 33 21]} {[35 39 17 33 9 34 1 58 52 26]}];%180418_B & B?
            setArrays=[{[16 16 16 16 8 8 16 14 12 12]} {[14 14 16 16 16 8 14 12 12 12]} {[9 12 14 16 16 16 14 12 13 12]} {[16 12 9 12 12 12 12 12 12 12]}];    
        case 49
            setElectrodes=[{[]} {[]} {[35 40 21 60 22 10 30 63 14 21]} {[23 11 7 6 59 13 19 60 24 63]}];%180418_B & B?
            setArrays=[{[]} {[]} {[12 14 16 16 8 8 14 12 13 14]} {[16 16 14 14 14 12 12 12 12 12]}];
        case 50
            setElectrodes=[{[]} {[]} {[50 4 53 40 57 52 19 64 41 60]} {[48 22 12 13 29 61 25 33 41 34]}];%300418_B & B
            setArrays=[{[]} {[]} {[12 14 16 8 8 8 8 14 13 14]} {[16 16 16 14 14 12 12 13 13 13]}];
        case 51
            setElectrodes=[{[]} {[]} {[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
            setArrays=[{[]} {[]} {[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
        case 52
            setElectrodes=[{[]} {[]} {[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]}];%010518_B & B
            setArrays=[{[]} {[]} {[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]}];
        case 53
            setElectrodes=[{[]} {[]} {[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
            setArrays=[{[]} {[]} {[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
        case 54
            setElectrodes=[{[]} {[]} {[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
            setArrays=[{[]} {[]} {[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
        case 55
            setElectrodes=[{[]} {[]} {[48 15 39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
            setArrays=[{[]} {[]} {[9 12 14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
        case 56
            setElectrodes=[{[]} {[]} {[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
            setArrays=[{[]} {[]} {[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
        case 57
            setElectrodes=[{[]} {[]} {[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
            setArrays=[{[]} {[]} {[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
        case 58
            setElectrodes=[{[]} {[]} {[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
            setArrays=[{[]} {[]} {[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
        case 59
            setElectrodes=[{[]} {[]} {[27 19 20 46 11 44 34 5 42 25]} {[7 28 30 10 40 43 56 15 3 21]}];%010518_B & B
            setArrays=[{[]} {[]} {[9 12 12 14 8 8 13 10 10 12]} {[15 15 13 13 10 10 10 10 11 11]}];
        case 60
            setElectrodes=[{[]} {[]} {[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
            setArrays=[{[]} {[]} {[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
        case 61
            setElectrodes=[{[]} {[]} {[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]}];%010518_B & B
            setArrays=[{[]} {[]} {[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]}];
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
shape=imresize(originalOutline,[105,105]);
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
    h=image(30,-88,flip(shapeRGB,1));
elseif strcmp(targetLetter,'T')
%     h=image(13,-80,flip(shapeRGB,1));
%     h=image(90,-135,flip(shapeRGB,1));
    h=image(13,-90,flip(shapeRGB,1));
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