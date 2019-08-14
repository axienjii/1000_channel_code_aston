goodChsTally=[];
electrodeNums=[1 2 3 5 6 9 11 13 15 18 22 25 28 29 34 35 36 38 41 46 49 52 57 59 60];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[1 3 4 7 8 15 16 18 22 23 25 28 29 30 38 45 49 50 54 57 58 59 62 6];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[2 5 8 16 23 40 46 48 52 54 55 56 60 63 64];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[2 9 11 17 25 26 28 33 39 42 44 45 46 48 49 52 54 55 57 58 59 60 61 62 63 64];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[6 7 13 16 23 26 28 33 47 52 53];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[1 3 9 10 13 17 18 19 25 27 28 30 31 33 34 35 36 38 39 40 41 42 43 44 48 49 50 51 52 53 54 55 56 57 59 60 61 62 63 64];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[1 9 12 16 21 24 30 35 38 50 59 63];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[4 16 24 40 44 46 48 49 56 57 63];
goodChsTally=[goodChsTally length(electrodeNums)];
electrodeNums=[30 31 34 36 40 41 43 48 49 51 53 54 55 56 58 60 61 64];
goodChsTally=[goodChsTally length(electrodeNums)];

%182 good channels
goodChs=[1 2 3 5 6 9 11 13 15 18 22 25 28 29 34 35 36 38 41 46 49 52 57 59 60 1 3 4 7 8 15 16 18 22 23 25 28 29 30 38 45 49 50 54 57 58 59 62 63 2 5 8 16 23 40 46 48 52 54 55 56 60 63 64 2 9 11 17 25 26 28 33 39 42 44 45 46 48 49 52 54 55 57 58 59 60 61 62 63 64 6 7 13 16 23 26 28 33 47 52 53 1 3 9 10 13 17 18 19 25 27 28 30 31 33 34 35 36 38 39 40 41 42 43 44 48 49 50 51 52 53 54 55 56 57 59 60 61 62 63 64 1 9 12 16 21 24 30 35 38 50 59 63 4 16 24 40 44 46 48 49 56 57 63 30 31 34 36 40 41 43 48 49 51 53 54 55 56 58 60 61 64]; 

badChsTally=[0 0 0];%arrays 8, 9 and 10 do not have bad channels
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

%69 bad channels

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

%redo with higher currents:
electrodeNums=[7 52];
arrayNums=[8 8];
electrodeNums=[2 6 9 10 11 14 17 18 19 21 24 32 34 37 41 47 60];
arrayNums=[arrayNums 9*ones(1,length(electrodeNums))];
electrodeNums=[2 3 14 21 22 23 24 29 31 32 33 37 38 39 46 47 50 51 62 64];
arrayNums=[arrayNums 10*ones(1,length(electrodeNums))];%(8, redo higher 120 uA) 10 (redo higher, 130) 13 (redo higher, 160) 
electrodeNums=[2 25 26 42 49];
arrayNums=[arrayNums 11*ones(1,length(electrodeNums))];%(60, redo w 130 uA)
electrodeNums=[7 47 53];
arrayNums=[arrayNums 12*ones(1,length(electrodeNums))];
electrodeNums=[4 12 19 25 36 39 54];%(23, redo w 120 uA) (58 start 100) (59 start 80)
arrayNums=[arrayNums 13*ones(1,length(electrodeNums))];
electrodeNums=[42 48];%59 (redo w 60 uA) 
arrayNums=[arrayNums 14*ones(1,length(electrodeNums))];
electrodeNums=[12 18 27 29 30 31 55 56 62 64];
arrayNums=[arrayNums 15*ones(1,length(electrodeNums))];
electrodeNums=[1 9 11 30 31 35 37 38 39 41 47 49 51 52 54 55 58 60 62 64];
arrayNums=[arrayNums 16*ones(1,length(electrodeNums))];

electrodeNums=[7 52 2 6 9 10 11 14 17 18 19 21 24 32 34 37 41 47 60 2 3 14 21 22 23 24 29 31 32 33 37 38 39 46 47 50 51 62 64 2 25 26 42 49 7 47 53 4 12 19 25 36 39 54 42 48 12 18 27 29 30 31 55 56 62 64 1 9 11 30 31 35 37 38 39 41 47 49 51 52 54 55 58 60 62 64];
arrayNums=[8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,12,12,12,13,13,13,13,13,13,13,14,14,15,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16];

electrodeNums=[8 10 13 60 23 58 59 59];
arrayNums=[10 10 10 11 13 13 13 14];
120 130 160 130 120 100 80 60