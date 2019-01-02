goodChs=[];
goodChsTally=[];
electrodeNums=[1 2 3 5 6 7 9 11 13 15 18 22 25 28 29 34 35 36 38 41 46 49 52 57 59 60];
goodChsTally=[goodChsTally length(electrodeNums)];%array 8
goodChs=[goodChs electrodeNums];
arrayNums=8*ones(1,length(electrodeNums));
electrodeNums=[1 3 4 7 8 15 16 22 23 25 28 29 30 38 45 49 50 54 57 58 59 62 63];
goodChsTally=[goodChsTally length(electrodeNums)];%array 9
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 9*ones(1,length(electrodeNums))];
electrodeNums=[2 5 8 16 23 40 46 48 52 54 55 56 60 63 64];
goodChsTally=[goodChsTally length(electrodeNums)];%array 10
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 10*ones(1,length(electrodeNums))];
electrodeNums=[2 9 11 17 25 26 28 33 39 42 44 45 46 48 49 52 54 55 57 58 59 60 61 62 63 64];
goodChsTally=[goodChsTally length(electrodeNums)];%array 11
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 11*ones(1,length(electrodeNums))];
electrodeNums=[6 7 13 16 23 26 28 33 47 52 53];
goodChsTally=[goodChsTally length(electrodeNums)];%array 12
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 12*ones(1,length(electrodeNums))];
electrodeNums=[1 3 9 10 13 17 18 19 25 27 28 30 31 33 34 35 36 38 39 40 41 42 43 44 48 49 50 51 52 53 54 55 56 57 59 60 61 62 63 64];
goodChsTally=[goodChsTally length(electrodeNums)];%array 13
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 13*ones(1,length(electrodeNums))];
electrodeNums=[1 9 12 16 21 24 30 35 38 50 59 63];
goodChsTally=[goodChsTally length(electrodeNums)];%array 14
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 14*ones(1,length(electrodeNums))];
electrodeNums=[4 16 24 40 44 46 48 49 56 57 63];
goodChsTally=[goodChsTally length(electrodeNums)];%array 15
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 15*ones(1,length(electrodeNums))];
electrodeNums=[30 31 34 36 40 41 43 48 49 51 53 54 55 56 58 60 61 64];
goodChsTally=[goodChsTally length(electrodeNums)];%array 16
goodChs=[goodChs electrodeNums];
arrayNums=[arrayNums 16*ones(1,length(electrodeNums))];

%182 good channels
goodChs=[1,2,3,5,6,7,9,11,13,15,18,22,25,28,29,34,35,36,38,41,46,49,52,57,59,60,1,3,4,7,8,15,16,22,23,25,28,29,30,38,45,49,50,54,57,58,59,62,63,2,5,8,16,23,40,46,48,52,54,55,56,60,63,64,2,9,11,17,25,26,28,33,39,42,44,45,46,48,49,52,54,55,57,58,59,60,61,62,63,64,6,7,13,16,23,26,28,33,47,52,53,1,3,9,10,13,17,18,19,25,27,28,30,31,33,34,35,36,38,39,40,41,42,43,44,48,49,50,51,52,53,54,55,56,57,59,60,61,62,63,64,1,9,12,16,21,24,30,35,38,50,59,63,4,16,24,40,44,46,48,49,56,57,63,30,31,34,36,40,41,43,48,49,51,53,54,55,56,58,60,61,64]; 
arrayNums=[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16];

badChsTally=0;%array 8 does not have bad channels
electrodeNums=[2 6 9 10 11 14 17 18 19 21 24 32 34 37 41 47 60];
arrayNums=9*ones(1,length(electrodeNums));
badChsTally=[badChsTally length(electrodeNums)];
electrodeNums=[2 3 14 21 22 23 24 29 31 32 37 38]; 
arrayNums=10*ones(1,length(electrodeNums));
badChsTally=[badChsTally length(electrodeNums)];
electrodeNums=[28];
arrayNums=11;
badChsTally=[badChsTally length(electrodeNums)];
electrodeNums=[2 3 4 5 6 7 8 12 13 15 16 21 24 29 30];
badChsTally=[badChsTally 0];%array 12 does not have bad channels
arrayNums=[arrayNums 13*ones(1,length(electrodeNums))];
badChsTally=[badChsTally length(electrodeNums)];
electrodeNums=[8 36 42 48 51 55 56 57 62 63 64];
arrayNums=[arrayNums 14*ones(1,length(electrodeNums))];
badChsTally=[badChsTally length(electrodeNums)];
electrodeNums=[1 3 4 6 7 8 12 13 14 15 21 22 23 24 27 29 30 32 33 38 39 44 55 56 62 64];
arrayNums=[arrayNums 15*ones(1,length(electrodeNums))];
badChsTally=[badChsTally length(electrodeNums)];
electrodeNums=[3 7 17 19 22 23 26 32 33 42 43 44 45 46 50 52];
arrayNums=[arrayNums 16*ones(1,length(electrodeNums))];
badChsTally=[badChsTally length(electrodeNums)];

%98 bad channels

%all channels:
figure;
allChs=[goodChsTally' badChsTally'];
b=bar(allChs,'stacked')
set(gca,'XTick',1:9);
set(gca,'XTickLabel',8:16);
title('tally of good/bad channels per array, Aston 19/10/19');
xlabel('array number');
ylabel('tally of good (blue) & bad (yellow) channels');

electrodeNums=[1 3 13 1 3 8 16 40 48 44 46 55 26 33 53 33 62 57 9 12 16 48 63 34 36 56];
arrayNums=[8 8 8 9 9 9 10 10 10 11 11 11 12 12 12 13 13 13 14 14 14 15 15 16 16 16];

%redo with higher currents, according to aston_thresholds_221018.m:
electrodeNums=[39,46,47,50,51,62,64,2,25,26,42,49,7,47,53,4,12,19,25,36,39,54,42,48,12,18,27,29,30,31,55,56,62,64,1,9,11,30,31,35,37,38,39,41,47,49,51,52,54,55,58,60,62,64];
arrayNums=[10,10,10,10,10,10,10,11,11,11,11,11,12,12,12,13,13,13,13,13,13,13,14,14,15,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16];

%could try again with these currents:
electrodeNums=[8 10 13 60 23 58 59 59];
arrayNums=[10 10 10 11 13 13 13 14];
120 130 160 130 120 100 80 60


%15/11/18 Plot figure showing RF centres of good channels (same figure as in new_RF_plotter4_aston.m):
colind = hsv(16);
colind(8,:)=[1 0 0];
colind(10,:)=[139/255 69/255 19/255];
colind(11,:)=[50/255 205/255 50/255];
colind(12,:)=[0 0 1];
colind(13,:)=[0 0 0];
colind(14,:)=[1 20/255 147/255];
colind(15,:)=[230/255 230/255 0];
colind(16,:)=[139/255 0 139/255];
load('X:\aston\151118_data\currentThresholdChs18.mat')
goodChs=[1,2,3,5,6,7,9,11,13,15,18,22,25,28,29,34,35,36,38,41,46,49,52,57,59,60,1,3,4,7,8,15,16,22,23,25,28,29,30,38,45,49,50,54,57,58,59,62,63,2,5,8,16,23,40,46,48,52,54,55,56,60,63,64,2,9,11,17,25,26,28,33,39,42,44,45,46,48,49,52,54,55,57,58,59,60,61,62,63,64,6,7,13,16,23,26,28,33,47,52,53,1,3,9,10,13,17,18,19,25,27,28,30,31,33,34,35,36,38,39,40,41,42,43,44,48,49,50,51,52,53,54,55,56,57,59,60,61,62,63,64,1,9,12,16,21,24,30,35,38,50,59,63,4,16,24,40,44,46,48,49,56,57,63,30,31,34,36,40,41,43,48,49,51,53,54,55,56,58,60,61,64]; 
arrayNums=[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16];
figure;hold on
for chInd=1:size(goodArrays8to16,1)
    array=goodArrays8to16(chInd,7);
    channel=goodArrays8to16(chInd,8);
    plot(goodArrays8to16(chInd,1),goodArrays8to16(chInd,2),'MarkerEdgeColor',colind(array,:),'Marker','o','MarkerSize',12);
    text(goodArrays8to16(chInd,1)-0.5,goodArrays8to16(chInd,2),num2str(channel),'FontSize',7,'Color',colind(array,:));

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
axis square
xlim([0 120]);
ylim([-120 20]);
title('');
pathname=fullfile('X:\aston\aston_impedance_values\',date,['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals']);
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff','-r300');
    