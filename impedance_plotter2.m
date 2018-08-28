function impedance_plotter2
%Written by Xing 29/06/17 to draw plots of impedance values from txt files,
%generated from Central's impedance tester function.
%Also checks channels with lowest impedances, looks up RF centre locations
%and positions of electrodes on array, and identifies good candidate
%channels for microstimulation (and for early testing, for simultaneous
%recording).
%Corrected the indexing of RF coordinate data, which was previously incorrect in 
%impedance_plotter.m
date='260617';
date='110717';
date='170717';
% date='200717';
colind = hsv(16);
colindImp = hsv(1000);%colour-code impedances

figure
hold on

switch(date)
    case('260617')
        load('C:\Users\User\Documents\impedance_values\260617\impedanceAllChannels.mat','impedanceAllChannels');
        %column 1: impedance with hand-tightening
        %column 2: impedance with torque wrench
        %column 3: array number
        %column 4: electrode number (out of 1024)
        xLabelsConds={'hand-tightening','torque wrench'};
        titleText='hand-tightening vs torque wrench 260617';
        
    case('110717')
        load('C:\Users\User\Documents\impedance_values\110717\impedanceAllChannels.mat','impedanceAllChannels');
        %column 1: impedance on previous date, 26/6/17
        %column 2: impedance on 11/7/17
        %column 3: array number
        %column 4: electrode number (out of 1024)
        xLabelsConds={'260617','110717'};
        titleText='red: 260617; blue: 110717';
        
    case('170717')
%         load('C:\Users\User\Documents\impedance_values\170717\impedanceAllChannels.mat','impedanceAllChannels');
        load('C:\Users\User\Documents\impedance_values\170717\impedanceAllChannels_260617_vs_170717.mat','impedanceAllChannels');
        %column 1: impedance on previous date, 11/7/17
        %column 2: impedance on 17/7/17
        %column 3: array number
        %column 4: electrode number (out of 1024)
        xLabelsConds={'110717 TW','170717 HT'};
        titleText='red: 110717; blue: 170717';
        xLabelsConds={'260617 TW','170717 HT'};
        titleText='red: 260617; blue: 170717';
        
    case('200717')
%         load('C:\Users\User\Documents\impedance_values\170717\impedanceAllChannels.mat','impedanceAllChannels');
        load('C:\Users\User\Documents\impedance_values\200717\impedanceAllChannels_170717_vs_200717.mat','impedanceAllChannels');
        %column 1: impedance on previous date, 17/7/17
        %column 2: impedance on 20/7/17
        %column 3: array number
        %column 4: electrode number (out of 1024)
        xLabelsConds={'170717 HT','200717 HT'};
        titleText='red: 170717; blue: 200717';
%         xLabelsConds={'260617 TW','170717 HT'};
%         titleText='red: 260617; blue: 170717';

    case('080817')
%         load('C:\Users\User\Documents\impedance_values\170717\impedanceAllChannels.mat','impedanceAllChannels');
        load('C:\Users\User\Documents\impedance_values\080817\impedanceAllChannels_200717_vs_080817.mat','impedanceAllChannels');
        %column 1: impedance on previous date, 17/7/17
        %column 2: impedance on 20/7/17
        %column 3: array number
        %column 4: electrode number (out of 1024)
        xLabelsConds={'200717 HT','080817 HT'};
        titleText='red: 200717; blue: 080817';
end
figure;hold on
length(find(impedanceAllChannels(:,1)>800))%number of channels with too-high impedances values during hand-tightening, 485
length(find(impedanceAllChannels(:,2)>800))%number of channels with too-high impedances values using a torque wrench, 111
for i=1:size(impedanceAllChannels,1)
    plot([1 2],[impedanceAllChannels(i,1),impedanceAllChannels(i,2)]);
end
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',xLabelsConds)
xlim([0.5 2.5]);

figure;hold on
bins=0:50:7000; 
hist(impedanceAllChannels(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'EdgeColor','none') 
set(h,'FaceColor','r','facealpha',0.5) 
hold on 
hist(impedanceAllChannels(:,2),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'facealpha',0.5,'EdgeColor','none') 
xlim([0 7000]); 
set(gca,'box','off'); 
title(titleText)

%zoom in on cluster of lower impedance values
figure;hold on
bins=0:10:7000;
hist(impedanceAllChannels(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'EdgeColor','none') 
set(h,'FaceColor','r','facealpha',0.5) 
hold on 
hist(impedanceAllChannels(:,2),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'facealpha',0.5,'EdgeColor','none') 
xlim([0 7000]); 
set(gca,'box','off'); 
xlim([0 1400]); 
ylim([0 70]); 

%identify electrodes with lowest impedance values:
for instanceInd=1:8%determine the electrode number on a given array
    if instanceInd<5
        channelOrder=[33:128 1:32];%BCDA
    else
        channelOrder=[65:96 33:64 1:32 97:128];%CBAD
    end
    impedanceAllChannels((instanceInd-1)*128+1:(instanceInd-1)*128+128,5)=channelOrder;
end
[dummy ind]=sort(impedanceAllChannels(:,2));
sortImpedanceAllChannels=impedanceAllChannels(ind,:);%column 3: array number; column 5: electrode number (out of 128). column 1: old/previous impedance; column 2: latest impedance; column 4: electrode number (out of 1024)
%identify electrodes with low impedance values that are situated along
%middle rows of arrays, i.e. electrode numbers 25:40 (not inclusive, as
%those electrodes are on the edge of the array, and hence have only 2
%neighbouring electrodes from which recordings can be made, whereas the
%others have 3 neighbours from which recordings can be made)
%Note that 32 and 33 are also positioned along the edge of the array.
a=find(sortImpedanceAllChannels(:,5)>25);
b=find(sortImpedanceAllChannels(:,5)<40);
goodLocationInd=intersect(a,b);
goodLocationImpedances=sortImpedanceAllChannels(goodLocationInd,:);
save('C:\Users\User\Documents\impedance_values\170717\goodLocationImpedances.mat','goodLocationImpedances')

%candidate channels for simultaneous stimulation and recording:
% instance 7, array 13, electrode 34: RF x, RF y, size (pix), size (dva):
%[101.373182692835,-87.1965720730945,30.6314285392835,1.18450541719806]
%SNR 20.7, impedance 13
%record from 25, 26, 27

% instance 7, array 13, electrode 35: RF x, RF y, size (pix), size (dva):
%[101.419820931771,-86.8574476383865,38.9826040277579,1.50744212233355]
%SNR 20.8, impedance 13
%record from 26, 27, 28

%According to wiring diagram on page 10 of 1024-channel Omnetics to LGA
%Adapter manual, these two channels are located on Omnetics connector J26,
%and correspond to CH-802 and CH-803.
%Doublecheck channel numbering for above two channels:
[channelNum,arrayNum,area]=electrode_mapping(7,mod(802,128))
[channelNum,arrayNum,area]=electrode_mapping(7,mod(803,128))

% instance 3, array 5, electrode 31: RF x, RF y, size (pix), size (dva):
%[9.35463857442747,-9.91935483870969,38.3226146663019,1.48192059065131]
%SNR 3.6, impedance 26
%record from 38, 39, 40

% instance 3, array 5, electrode 39: RF x, RF y, size (pix), size (dva):
%[25.6824436959512,-8.99879647765852,48.0327164758739,1.85740644761134]
%SNR 5.9, impedance 32
%record from 30, 31, 32

figure;hold on
impThreshold=100;
goodChImps=[];
goodChV1SimRec=[];%candidate V1 channels for simultaneous microstimulation and recording 
for candidateInd=1:size(sortImpedanceAllChannels,1)
    array=sortImpedanceAllChannels(candidateInd,3);
    channel=sortImpedanceAllChannels(candidateInd,5);
    instance=ceil(array/2);
    if instance<=2
        loadDate='best_260617-280617';
    else
        loadDate='best_260617-280617';
    end
%     fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instance),'.mat'];
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instance),'_array',num2str(array),'.mat'];
%     if instance==6||instance==8
%         fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instance),'_retry.mat'];
%     end
    load(fileName)
    if channel>64
        channel=channel-64;
    end
    chInfo(candidateInd,1:4)=channelRFs(channel,1:4);%RF.centrex RF.centrey RF.sz RF.szdeg
    chInfo(candidateInd,5)=meanChannelSNR(channel);%SNR
    chInfo(candidateInd,6)=sortImpedanceAllChannels(candidateInd,2);%impedance
    chInfo(candidateInd,7)=array;
    chInfo(candidateInd,8)=channel;
    if chInfo(candidateInd,1)>0&&chInfo(candidateInd,2)<0%RF coordinates are in correct quadrant
        if chInfo(candidateInd,6)<impThreshold%impedance is below cutoff, e.g. 100 kOhms
            impCol=chInfo(candidateInd,6)*0.9/100+0.05;
            goodChImps=[goodChImps;chInfo(candidateInd,:)];
            if array~=2&&array~=3
%                 plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',colind(array,:),'Marker','x');
                if channel>25&&channel<40&&channel~=32&&channel~=33%channels positioned along middle of array, with 3 close neighbours from which recordings can be made
                    plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[1 impCol impCol],'Marker','o','MarkerSize',10,'MarkerFaceColor',[0.8 1 0.8]);
                    goodChV1SimRec=[goodChV1SimRec;chInfo(candidateInd,:)];
                else
                    plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[1 impCol impCol],'Marker','o','MarkerSize',10);
                end
                text(chInfo(candidateInd,1)-1,chInfo(candidateInd,2),num2str(chInfo(candidateInd,6)),'FontSize',6,'Color',[1 impCol impCol]);
            else
%                 plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',colind(array,:),'Marker','o');
                if channel>25&&channel<40&&channel~=32&&channel~=33%channels positioned along middle of array, with 3 close neighbours from which recordings can be made
                    plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[impCol impCol 1],'Marker','o','MarkerSize',10,'MarkerFaceColor',[0.8 0.8 1]);
                else
                    plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[impCol impCol 1],'Marker','o','MarkerSize',10);
                end
                text(chInfo(candidateInd,1)-1,chInfo(candidateInd,2),num2str(chInfo(candidateInd,6)),'FontSize',6,'Color',[impCol impCol 1]);
            end
        end
    end
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:')
plot([-200 300],[0 0],'k:')
plot([-200 300],[200 -300],'k:')
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
axis square
xlim([0 200]);
ylim([-200 0]);
title('low-high impedance: dark-light; V1: red; V4: blue');

%Note: the following RFs may be incorrect:
%candidate channels for stimulation:
% instance 4, array 8, electrode 117: RF x, RF y, size (pix), size (dva):
%[18.9191954998266,-18.1188925426432,41.1144261886403,1.58987885540428]
%SNR 16.6, impedance 7

%These are correct:
% instance 5, array 10: RF x, RF y, size (pix), size (dva), SNR, impedance, array number, electrode number (out of 64):
[119.701744766328,-114.902061945310,148.407519394543,5.73886100187327,8.55946739176848,23,10,58;
    107.469065110580,-92.5349426896800,94.5179974107760,3.65497416524979,24.0787991767124,27,10,39;
    120.498566663956,-96.0902879547491,120.435796995545,4.65720538573110,26.0532252659700,27,10,48;
    113.242437418102,-120.191022943488,157.634217633635,6.09565383094556,22.4494946497284,27,10,57;
    120.948840957758,-130.685637209769,104.447223178057,4.03893346035232,8.28530816496006,29,10,59;
    126.224705050819,-96.3022802669606,125.985208239135,4.87179895820726,27.5326674055054,33,10,56]

array15=chInfo(chInfo(:,7)==15,:);
%minimum impedance for array 15 starts at 50 kOhms
array9=chInfo(chInfo(:,7)==9,:);
%minimum impedance for array 15 after first channel starts at 41 kOhms
array6=chInfo(chInfo(:,7)==6,:);
%minimum impedance for array 6 starts at 33 kOhms
array11=chInfo(chInfo(:,7)==11,:);
%minimum impedance for array 11 after first channel starts at 71 kOhms
array10=chInfo(chInfo(:,7)==10,:);
%minimum impedance for array 10 starts at 23 kOhms
array12=chInfo(chInfo(:,7)==12,:);
%many channels with low impedance on array 12
array13=chInfo(chInfo(:,7)==13,:);
%many channels with low impedance on array 13

figure;plot(array12(1:12,1),array12(1:12,2),'ko')
hold on
for ind=1:12
    plot(array12(ind,1),array12(ind,2),'go')
    text(array12(ind,1),array12(ind,2),num2str(ind))
    pause(2);
end
a=[1 6 10 12 8 4 9];a=sort(a);
array12selectedChs=array12(a,:);
save('C:\Users\User\Documents\impedance_values\170717\array12selectedChs.mat','array12selectedChs')
pauseHere=1;