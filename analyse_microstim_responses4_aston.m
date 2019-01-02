function analyse_microstim_responses4_aston
%Written by Xing 11/9/18 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
localDisk=0;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end

% date='110918_B3';
% electrodeNums=[33];
% arrayNums=[13];
% date='110918_B5';
% electrodeNums=[24];
% arrayNums=[13];
% date='110918_B6';
% electrodeNums=[62];
% arrayNums=[13];
% date='110918_B7';
% electrodeNums=[7];
% arrayNums=[13];
% date='110918_B8';
% electrodeNums=[57];
% arrayNums=[13];
% date='110918_B9';
% electrodeNums=[33];
% arrayNums=[13];
% date='120918_B1';
% electrodeNums=[40 55 44 43 16 6 48 32 15 17 20 51];
% arrayNums=13*ones(1,length(electrodeNums));
% date='130918_B1';
% electrodeNums=[51 28 5];
% arrayNums=13*ones(1,length(electrodeNums));
% date='140918_B1';
% electrodeNums=[25];
% arrayNums=13*ones(1,length(electrodeNums));
% date='140918_B2';
% electrodeNums=[51 28 5 56 58 25 46 54 30 3 60 61];
% arrayNums=13*ones(1,length(electrodeNums));
% date='180918_B1';
% electrodeNums=[56 58 46 54];
% arrayNums=13*ones(1,length(electrodeNums));
% date='180918_B2';
% electrodeNums=[58 46 54 30];
% arrayNums=13*ones(1,length(electrodeNums));
% date='180918_B3';
% electrodeNums=[30];
% arrayNums=13*ones(1,length(electrodeNums));
% date='190918_B1';
% electrodeNums=[60 61 30 3 35 4 1 27 49 19 12 10 50 36 39 13 59 52];
% arrayNums=13*ones(1,length(electrodeNums));
% date='190918_B2';
% electrodeNums=[60 61 30 3 35 4 1 27 49 19 12 10 50 36 39 13 59 52];
% arrayNums=13*ones(1,length(electrodeNums));
% date='200918_B1';
% electrodeNums1=[12 10 50 36 39 13 59 52];
% arrayNums1=13*ones(1,length(electrodeNums1));
% electrodeNums2=[57 59 44 55 25 61 49 42 62 2 64 52 48 58 46 26 9 17 1 51 47 50 13 10 18 43 41];
% arrayNums2=11*ones(1,length(electrodeNums2));
% electrodeNums=[electrodeNums1 electrodeNums2];
% arrayNums=[arrayNums1 arrayNums2];
% date='210918_B1';
% electrodeNums1=[17 1 51 47 50 13 10 18 43 41];
% arrayNums1=11*ones(1,length(electrodeNums1));
% electrodeNums2=[3 49 23 50 58 63 8 4 16 30 29 15 1 62 28 22 38 7 54 59 45 25 57];
% arrayNums2=9*ones(1,length(electrodeNums2));
% electrodeNums=[electrodeNums1 electrodeNums2 56];
% arrayNums=[arrayNums1 arrayNums2 13];
% date='240918_B1';
% electrodeNums1=[62 28 22 38 7 54 59 45 25 57];
% arrayNums1=9*ones(1,length(electrodeNums1));
% date='250918_B1';
% electrodeNums1=[45 25 57];
% arrayNums1=9*ones(1,length(electrodeNums1));
% electrodeNums2=[23 52 64 51 5 16 56 46 63 38 40 48 55];
% arrayNums2=10*ones(1,length(electrodeNums2));
% electrodeNums3=[6 16 47 26 23 52 28 7 33 13 53];
% arrayNums3=12*ones(1,length(electrodeNums3));
% electrodeNums=[electrodeNums1 56 electrodeNums2 electrodeNums3];
% arrayNums=[arrayNums1 13 arrayNums2 arrayNums3];
% date='260918_B1';
% electrodeNums3=53;
% arrayNums3=12;
% electrodeNums4=[21 16 48 59 30 64 63 35 9 51 62 12 24 56 50 42];
% arrayNums4=14*ones(1,length(electrodeNums4));
% electrodeNums5=[6 24 16 8 15 7 27 44 32 63 1 3 21 39 40 46 13 55 33 64 4 62 56 23 14 22 48 38 49];
% arrayNums5=15*ones(1,length(electrodeNums5));
% electrodeNums6=[56 41 17 33 19 22 23 32 55 64 45 49 46 3 50 42 40 44 26 7 58 60 52 43];
% arrayNums6=16*ones(1,length(electrodeNums6));
% electrodeNums=[electrodeNums3 electrodeNums4 electrodeNums5 electrodeNums6];
% arrayNums=[arrayNums3 arrayNums4 arrayNums5 arrayNums6];
% date='270918_B1';
% electrodeNums=[43 34 36 62 48];
% arrayNums=16*ones(1,length(electrodeNums));
% electrodeNums=[electrodeNums 17 25 26 42 49 12 13 36 39 59 51 28 25 54 58 30 12 19 49 60 61 4 27 35];
% arrayNums=[arrayNums 11 11 11 11 11 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13 13];
% electrodeNums=[electrodeNums 15 51 23 38 40 46 55 56 63 28 52 16];
% electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
% arrayNums=[arrayNums 9 10 10 10 10 10 10 10 10 12 12 10];
% arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='280918_B1';
% electrodeNums=[55 56 63 28 52 16];
% arrayNums=[10 10 10 12 12 10];
% electrodeNums=[electrodeNums 12 21 30 42 48 50 51 56 59 62 63 64 1 3 4 6 7 8 13 14 15 21 22 23 24 27 32 33 38 39 40 44 46 49 55 56 62 64 3 7 17 19 22 23 26 32 33 40 41 42 43 44 45 46 49 50 52 55 58 64];
% arrayNums=[arrayNums 14 14 14 14 14 14 14 14 14 14 14 14 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='081018_B1';
% electrodeNums=[13 46 3 9 1 38 41 52 36 49 34 35 28 57 6 11 18 29 7];
% arrayNums=8*ones(1,length(electrodeNums));
% date='161018_B1';
% electrodeNums=[36 49 34 35 28 57 6 11 18 29 7 25 15 5 2 59 60 22 34 6 18 32 21 19 47 24 9 11 14 2 60 10 41 37 17 33 2 22 29 50 24 62 14 21 39 3 8 13 32 10 37 47 54 31 60 63 54 33 39 11 60 28 45 53 23 38 34 42 53 1 8 57 38 36 55 29 30 12 57 31 18 38 30 31 39 53 54 11 47 51 35 61 9 1 37];
% arrayNums=[8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 11 11 11 11 11 11 11 11 12 13 13 13 13 13 14 14 14 14 14 14 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='171018_B1';
% electrodeNums=[14 21 39 3 8 13 32 10 37 47 54 31 60 63 54 33 39 11 60 28 45 53 23 38 34 42 53 1 8 57 38 36 55 29 30 12 57 31 18 38 30 31 39 53 54 11 47 51 35 61 9 1 37];
% arrayNums=[10 10 10 10 10 10 10 10 10 10 10 10 10 11 11 11 11 11 11 11 11 12 13 13 13 13 13 14 14 14 14 14 14 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='181018_B1';
% electrodeNums=[54 33 39 11 60 28 45 53 23 38 34 42 53 1 8 57 38 36 55 29 30 12 57 31 18 38 30 31 39 53 54 11 47 51 35 61 9 1 37];
% arrayNums=[11 11 11 11 11 11 11 12 13 13 13 13 13 14 14 14 14 14 14 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='191018_B1';
% electrodeNums=[8 57 38 36 55 29 30 12 57 31 18 38 30 31 39 53 54 11 47 51 35 61 9 1 37];
% arrayNums=[14 14 14 14 14 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='191018_B2';
% electrodeNums=[8 57 38 36 55 29 30 12 57 31 18 38 30 31 39 53 54 11 47 51 35 61 9 1 37];
% arrayNums=[14 14 14 14 14 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='231018_B1';
% electrodeNums=[7 52 2 6 9 10 11 14 17 18 19 21 24 32 34 37 41 47 60 2 3 14 21 22 23 24 29 31 32 33 37 38 39 46 47 50 51 62 64 2 25 26 42 49 7 47 53 4 12 19 25 36 39 54 42 48 12 18 27 29 30 31 55 56 62 64 1 9 11 30 31 35 37 38 39 41 47 49 51 52 54 55 58 60 62 64];
% arrayNums=[8 8 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 9 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 11 11 11 11 11 12 12 12 13 13 13 13 13 13 13 14 14 15 15 15 15 15 15 15 15 15 15 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
% date='261018_B1';
% electrodeNums=[9 63 16 45 1 64 35 38];
% arrayNums=[13 10 14 9 13 10 14 9];
% date='261018_B2';
% electrodeNums=[8 10 13 60 23 58 59 59];
% arrayNums=[10 10 10 11 13 13 13 14];
% date='261018_B3';
% electrodeNums=[63 35 38 45];
% arrayNums=[10 14 9 9];
% date='261018_B4';
% electrodeNums=[54 25 49 57];
% arrayNums=[9 9 9 9];
% date='261018_B5';
% electrodeNums=[45 38 54 25 49 57];
% arrayNums=[9 9 9 9 9 9];
% date='261018_B6';
% electrodeNums=[57 58 49 41 49];
% arrayNums=[11 11 11 16 16];
% date='061118_B2';
% electrodeNums=[9 64 49 16];
% arrayNums=[13 10 16 14];
% date='061118_B3';
% electrodeNums=[55 63 54 56 8 48];
% arrayNums=[10 10 10 10 10 10];
% date='061118_B4';
% electrodeNums=[57 58 49];
% arrayNums=[11 11 11];
% date='071118_B2';
% electrodeNums=[56 16 16 12 1 33 9];
% arrayNums=[16 14 15 14 8 13 13];
% date='071118_B3';
% electrodeNums=[46 63 44];
% arrayNums=[15 15 15];
% date='071118_B4';
% electrodeNums=[57 35 22 38 48 40 56 55];
% arrayNums=[13 8 8 8 15 15 15 13];
% date='081118_B1';
% electrodeNums=[35 16 56 57 47 52 53 59 64 63];
% arrayNums=[8 14 16 13 12 12 12 13 13 13];
% date='081118_B3';
% electrodeNums=[35 57 56];
% arrayNums=[8 13 16];
% date='091118_B1';
% electrodeNums=[35 16 56 47];
% arrayNums=[8 14 16 12];
% date='091118_B3';
% electrodeNums=[47 16 56];
% arrayNums=[12 14 16];
% date='091118_B4';
% electrodeNums=[55 64 48 51 40];
% arrayNums=[16 16 16 16 16];
% date='131118_B1';
% electrodeNums=[35 16 56 47];
% arrayNums=[8 14 16 12];
% date='131118_B3';
% electrodeNums=[35];
% arrayNums=[8];
% date='141118_B1';
% electrodeNums=[35 16 56 47];
% arrayNums=[8 14 16 12];
% date='141118_B6';
% electrodeNums=[38 22 12 35 55 64 53 52];
% arrayNums=[8 8 14 14 16 16 12 12];
% date='141118_B7';
% electrodeNums=[23 28 26 13];
% arrayNums=[12 12 12 12];
% date='141118_B8';
% electrodeNums=[7 16 13];
% arrayNums=[12 12 12];
% date='141118_B9';
% electrodeNums=[55 57 59 60 61 63 64];
% arrayNums=[13 13 13 13 13 11 11];
% date='151118_B1';
% electrodeNums=[22 12 55 16];
% arrayNums=[8 14 16 12];
% date='151118_B2';
% electrodeNums=[12 16];
% arrayNums=[14 12];
% date='151118_B3';
% electrodeNums=[22];
% arrayNums=[8];
% date='151118_B7';
% electrodeNums=[6 29 13 35 9 61 60 48 64 62 61];
% arrayNums=[8 8 8 14 14 16 16 16 11 11 11];
% date='161118_B1';
% electrodeNums=[6 9 60 64 35 61 57 58 49];
% arrayNums=[8 14 16 11 14 16 11 11 11];
% date='161118_B2';
% electrodeNums=[29];
% arrayNums=[8];
% date='191118_B1';
% electrodeNums=[44 46 3 34 13];
% arrayNums=[11 11 8 8 8];
% date='191118_B2';
% electrodeNums=[43 41 16 21 59 60];
% arrayNums=[16 16 14 14 11 11];
% date='191118_B3';
% electrodeNums=[60 13 34 44 46];
% arrayNums=[11 8 8 11 11];
% date='191118_B4';
% electrodeNums=[35 61 57];
% arrayNums=[14 16 11];
% date='191118_B8';
% electrodeNums=[58 59 29 1 2];
% arrayNums=[11 11 8 8 8];
% date='191118_B10';
% electrodeNums=[46 63 44];
% arrayNums=[15 15 15];
% date='191118_B11';
% electrodeNums=[1 2 29];
% arrayNums=[8 8 8];
% date='191118_B12';
% electrodeNums=[60 49 46];
% arrayNums=[11 11 11];
% date='201118_B1';
% electrodeNums=[2 16 43 63 55 57 49 3 50 62];
% arrayNums=[8 14 16 11 13 13 13 9 9 9];
% date='201118_B2';
% electrodeNums=[35 28 38 50 59 21 30 43 41 49 54 63 2 26 42];
% arrayNums=[8 8 8 14 14 14 14 16 16 16 9 9 11 11 11];
% date='201118_B3';
% electrodeNums=[2 16 43 63 3 50 62];
% arrayNums=[8 14 16 11 9 9 9];
% date='201118_B4';
% electrodeNums=[1 25 33 54 55];
% arrayNums=[13 13 13 11 11];
% date='201118_B5';
% electrodeNums=[2 35 28 21 43 54 63 2 26 42];
% arrayNums=[8 8 8 14 16 9 9 11 11 11];
% date='201118_B6';
% electrodeNums=[40 51 31 48 56 64 55];
% arrayNums=[16 16 16 16 16 16 16];
% date='201118_B7';
% electrodeNums=[40 56 63 48 46 44 4];
% arrayNums=[15 15 15 15 15 15 15];
% date='201118_B8';
% electrodeNums=[31 42 55];
% arrayNums=[16 11 11];
% date='201118_B10';
% electrodeNums=[6 7 52 46 15 13 41 25 18 1 36 38 57 59];
% arrayNums=8*ones(1,length(electrodeNums));
% date='211118_B1';
% electrodeNums=[1 50 43 59 25 59 56 57 33];
% arrayNums=[13 14 16 14 13 14 16 13 13];
% date='211118_B2';
% electrodeNums=[21 48 63 6 48 40 25];
% arrayNums=[14 16 11 8 16 16 13];
% date='221118_B1';
% electrodeNums=[3 13 43 63 56 33 48 25 16 57 50 59 48 43 25 63 1 57];
% arrayNums=[13 13 16 11 16 13 16 13 14 13 14 14 16 16 13 11 13 13];
% date='221118_B2';
% electrodeNums=[51 31 41 49 34];
% arrayNums=16*ones(1,length(electrodeNums));
% date='221118_B6';
% electrodeNums=[10 17 57 58 49];
% arrayNums=[13 13 11 11 11];
% date='221118_B8';
% electrodeNums=[9];
% arrayNums=[14];
% date='231118_B1';
% electrodeNums=[9 49 41 17 59 6 60 53 62 41 2 9 17 25 26 59 61 60 59 11 60 8 6];
% arrayNums=[13 11 8 13 8 8 13 13 13 13 11 11 11 11 11 13 13 11 11 8 8 9 12];
% date='231118_B2';
% electrodeNums=[30 36 28];
% arrayNums=[13 13 13];
% date='231118_B3';
% electrodeNums=[41 17 53 17 61 60 8];
% arrayNums=[8 13 13 11 13 8 9];
% date='261118_B1';
% date='261118_B2';
% date='261118_B3';
% date='261118_B4';
% date='271118_B4';
% electrodeNums=[59 64 1];
% arrayNums=[14 11 13];
% date='271118_B5';
% electrodeNums=[50 16 35 63 63 64 52 61 3 36 9 10 3 12 9];
% arrayNums=[14 14 14 11 13 13 13 13 13 13 13 13 8 14 14];
% date='281118_B1';
% electrodeNums=[59 60 63];
% arrayNums=[13 13 13];
% date='281118_B2';
% electrodeNums=[64 13 9];
% arrayNums=[13 13 13];
% date='281118_B3';
% electrodeNums=[36 10 63 12 57 58 49 33 41];
% arrayNums=[13 13 11 14 11 11 11 13 13];
% date='281118_B4';
% electrodeNums=[16 35 9];
% arrayNums=[14 14 14];
% date='291118_B5';
% electrodeNums=[58 41 9 49 41 36];
% arrayNums=[11 13 13 11 13 13];
% date='291118_B7';
% electrodeNums=[57 33 10];
% arrayNums=[11 13 13];
% date='291118_B8';
% date='301118_B1';
% electrodeNums=[1 50 43 59 25 59 56 57];
% arrayNums=[13 14 16 14 13 14 16 13];
% date='031218_B4';
% electrodeNums=[16 9 57 12 63 58 35 49 61 60 43 48 56 55];
% arrayNums=[14 14 11 14 11 11 14 11 16 16 16 16 16 16];
% date='041218_B1';
% electrodeNums=[16 9 57 12 63 58 35 49];
% arrayNums=[14 14 11 14 11 11 14 11];
% date='041218_B8';
% electrodeNums=[54 56];
% arrayNums=[13 13];
% date='051218_B1';
% electrodeNums=[56 48 54 56 63 25 9 11 1 39 50 48 60 41];
% arrayNums=[16 16 13 13 13 13 13 11 13 11 13 11 13 13];
% date='051218_B2';
% electrodeNums=[59];
% arrayNums=[13];
% date='061218_B1';
% electrodeNums=[53 25 9 63 25 1 56 60 50 60 50 48 59 50 41];
% arrayNums=[13 13 13 13 13 13 16 13 13 13 13 11 13 13 13];
% date='061218_B3';
% electrodeNums=[53];
% arrayNums=[13];
% date='071218_B4';
% electrodeNums=[56 60 50 60 50 48 59 50 41];
% arrayNums=[16 13 13 13 13 11 13 13 13];
% date='101218_B1';
% electrodeNums=[59 50 41];
% arrayNums=[13 13 13];
% date='101218_B2';
% electrodeNums=[7 52 59 29 43 56 55 41 34];
% arrayNums=[8 8 8 8 16 16 16 16 16];
% date='101218_B3';
% electrodeNums=[16 50 57 57 35 58];
% arrayNums=[14 14 13 11 14 11];
% date='121218_B1';
% electrodeNums=[34 12 49 43 56];
% arrayNums=[16 14 11 16 16];
% date='121218_B2';
% electrodeNums=[41 58 49 60 61 64 31 40 51];
% arrayNums=[16 16 16 16 16 16 16 16 16];
% date='121218_B5';
% electrodeNums=[12 49 35 58];
% arrayNums=[14 11 14 11];
% date='141218_B1';
% electrodeNums=[16 50 60 59 57 40 54 9 51 62 53 10];
% arrayNums=[14 14 11 11 13 16 13 13 16 13 13 13];
% date='141218_B2';
% electrodeNums=[60 40 54 9];
% arrayNums=[16 16 13 13];
% date='141218_B5';
% electrodeNums=[40];
% arrayNums=[16];
% date='141218_B8';
% electrodeNums=[51 62 17 10 53];
% arrayNums=[16 13 13 13 13];
% date='141218_B9';
% electrodeNums=[17];
% arrayNums=[13];
% date='141218_B10';
% electrodeNums=[8 3 23 30 25 45 50 57 58 62];
% arrayNums=9*ones(1,length(electrodeNums));
% date='171218_B1';
% electrodeNums=[51 62 17 31 61 64 18 53 24 45 44];
% arrayNums=[16 13 13 16 16 16 13 13 14 11 11];
% date='171218_B5';
% electrodeNums=[8 3 23 30 25 45 50 57 58 62];
% arrayNums=9*ones(1,length(electrodeNums));
% date='171218_B6';
% electrodeNums=[8 40 56 23 60 64 63];
% arrayNums=10*ones(1,length(electrodeNums));
% date='171218_B7';
% electrodeNums=[2 9 11 39 48 33 25 26 28 55 54 44 45 52 46 59 60 63 64];
% arrayNums=11*ones(1,length(electrodeNums));
% date='191218_B1';%100 pulses (previous recordings used 50 pulses)
% electrodeNums=[41 50 4 6 59 22 56 14 34 26 7 24 52 1 38 36 35 40 29 15 16 11 17 64 12 33 32 43 51 63 9 48 37 28 31 54 60 49 61];
% arrayNums=9*ones(1,length(electrodeNums));
% date='191218_B2';%100 pulses
% electrodeNums=[52 59 26 34 51 50 9 24 3 56 48 4 62 39 15 16 55 32 47 5 35 25 7 30 31 1 36 54 14 17 6 13 20 43 61 12 42 49 29 44 57 2 11 38 22 46 18 53];
% arrayNums=10*ones(1,length(electrodeNums));
% date='191218_B3';%100 pulses
% electrodeNums=[53 31 45 34 38 39 6 14 15 62 51 48 20 56 61 58 47 43 2 24 16 8 57 7 63 59 32 12 28 40 30 17 1 22];
% arrayNums=11*ones(1,length(electrodeNums));
% date='201218_B1';%300 Hz, 100 pulses, bipolar (previous recordings used monopolar stimulation)
% electrodeNums=[58 14 15 62 51 48 20 56 61 47 43 2 24 16 8 57 7 63 59 32 12 28 40 30 17 1 22];
% arrayNums=11*ones(1,length(electrodeNums));
% date='201218_B2';%300 Hz, 100 pulses, bipolar
% electrodeNums=[41 50 4 6 59 22 56 14 34 26 7 24 52 1 38 36 35 40 29 15 16 11 17 64 12 33 32 43 51 63 9 48 37 28 31 54 60 49 61];
% arrayNums=9*ones(1,length(electrodeNums));
% date='201218_B3';%300 Hz, 100 pulses, bipolar
% electrodeNums=[52 59 26 34 51 50 9 24 3 56 48 4 62 39 15 16 55 32 47 5 35 25 7 30 31 1 36 54 14 17 6 13 20 43 61 12 42 49 29 44 57 2 11 38 22 46 18 53];
% arrayNums=10*ones(1,length(electrodeNums));
% date='201218_B4';%200 Hz, 100 pulses, bipolar (previous recordings used 300 Hz)
% electrodeNums=[52 59 26 34 51 50 9 24 3 56 48 4 62 39 15 16 55 32 47 5 35 25 7 30 31 1 36 54 14 17 6 13 20 43 61 12 42 49 29 44 57 2 11 38 22 46 18 53];
% arrayNums=10*ones(1,length(electrodeNums));
% date='211218_B1';%300 Hz, 100 pulses, bipolar
% electrodeNums1=[19 6 34 50 33 12 1 11 55 2 14];
% arrayNums1=12*ones(1,length(electrodeNums1));
% electrodeNums2=[16 30 63 24 47 57 21 58 64 48 42 50 49 8 32 59 1 51];
% arrayNums2=14*ones(1,length(electrodeNums2));
% electrodeNums=[electrodeNums1 electrodeNums2];
% arrayNums=[arrayNums1 arrayNums2];
% date='211218_B2';%300 Hz, 50 pulses, group stimulation (4 electrodes simultaneously)
% electrodeNums=[1 3 5 7 17 19 21 23 33 35 37 39 49 51 53 55];
% arrayNums=9*ones(1,length(electrodeNums));
% date='271218_B1';
% electrodeNums=[1 15 33 17 47 6 25 52 29 39 32 38 2 8 5 45 22 14 46 62 9 27 44 37 30 31 34 36 40 41 43 48 49 51 53 54 55 56 58 60 61 64];
% arrayNums=16*ones(1,length(electrodeNums));
% date='271218_B2';
% electrodeNums=[4 16 24 40 44 46 48 49 56 57 63 1 26 14 6 58 42 13 7 62 8 9 15 3 11 2 10 32 18 33 64 60 22 17 55 37 34];
% arrayNums=15*ones(1,length(electrodeNums));
% date='281218_B1';
% electrodeNums=[19 55 58 17 63 18 62 60 61 11 25 10 2 13 1 36 12 21 34 9 30 29 14 5 20 57 3 22 4 28 26 64 8 27 33 38 23 41 6 35 46 56 37 59 7 45 40 44 15 31 39 42];
% arrayNums=8*ones(1,length(electrodeNums));
% date='281218_B2';
% electrodeNums=[10 13 15 34 37 39 50 53 55];
% arrayNums=9*ones(1,length(electrodeNums));
% date='281218_B3';
% electrodeNums=[48 49 56 57 63 1 26 14 6 58 42 13 7 62 8 9 15 3 11 2 10 32 18 33 64 60 22 17 55 37 34];
% arrayNums=15*ones(1,length(electrodeNums));
% date='020119_B1';
% electrodeNums=[51 32 53 32 61 9 16 51 2 17 51 22 61 49 17 56 63 59 35 47];
% arrayNums=[16 16 13 14 13 14 14 14 16 16 16 16 16 16 16 13 13 13 14 12];
% date='020119_B5';
% electrodeNums=[16 35 51 17 55 55 52 9];
% arrayNums=[14 14 14 16 12 16 16 16];
% date='020119_B6';
% electrodeNums=[51 55];
% arrayNums=[14 12];
% date='020119_B8';
% date='020119_B9';
% electrodeNums=[42];
% arrayNums=[14];
% date='020119_B10';
% electrodeNums=[32 2];
% arrayNums=[16 16];
% date='020119_B11';
% electrodeNums=[40 54 52 55];
% arrayNums=[16 13 13 12];
% date='020119_B12';
% electrodeNums=[59 56 63 47];
% arrayNums=[13 13 13 12];
% date='020119_B13';
% electrodeNums=[54 55 2];
% arrayNums=[13 12 16];
date='020119_B14';
electrodeNums=[55 53];
arrayNums=[12 12];

date=[date,'_aston'];
finalCurrentValsFile=7;
% copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\aston_data\microstim_saccade_261118_B3_aston'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
setFalseAlarmZero=1;
if setFalseAlarmZero==1
    falseAlarms=0;
end
allElectrodeNums=cell2mat(allElectrodeNum);
allArrayNums=cell2mat(allArrayNum);
if strcmp(date,'281218_B3_aston')
    replaceInd=find(allArrayNums==14);
    allArrayNums(replaceInd)=15;
end
for uniqueElectrode=1:length(electrodeNums)
    array=arrayNums(uniqueElectrode);
    electrode=electrodeNums(uniqueElectrode);
    temp1=find(allElectrodeNums==electrode);
    temp2=find(allArrayNums==array);
    uniqueElectrodeTrials=intersect(temp1,temp2);
    if finalCurrentValsFile==2%staircase procedure was used, finalCurrentVals3.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals3.mat'])
    elseif finalCurrentValsFile==3%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals4.mat'])
    elseif finalCurrentValsFile==4%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals5.mat'])
    elseif finalCurrentValsFile==5%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals6.mat'])
    elseif finalCurrentValsFile==6%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals7.mat'])
    elseif finalCurrentValsFile==7%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals8.mat'])
    end
    currentAmplitudes=[];
    hits=[];
    misses=[];    
    currentAmpTrials=allCurrentLevel(uniqueElectrodeTrials);
    uniqueCurrentAmp=unique(currentAmpTrials);
    for currentAmpCond=1:length(uniqueCurrentAmp)
        currentAmplitude=uniqueCurrentAmp(currentAmpCond);
        currentAmpTrials=find(allCurrentLevel==currentAmplitude);
        if ~isempty(currentAmpTrials)
            temp3=intersect(microstimAllHitTrials,currentAmpTrials);
            temp4=intersect(temp3,uniqueElectrodeTrials);
            hits=[hits length(temp4)];
            temp5=intersect(microstimAllMissTrials,currentAmpTrials);
            temp6=intersect(temp5,uniqueElectrodeTrials);
            misses=[misses length(temp6)];
            currentAmplitudes=[currentAmplitudes currentAmplitude];
        end
    end
    hits./misses;
    for Weibull=0:1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
        [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
        hold on
        yLimits=get(gca,'ylim');
        plot([threshold threshold],yLimits,'r:')
        plot([theta theta],yLimits,'k:')
        %     text(threshold-10,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        ylabel('proportion of trials');
        xlabel('current amplitude (uA)');
        if Weibull==1
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', Weibull fit.'])
            pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_weibull']);
        elseif Weibull==0
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', sigmoid fit.'])
            pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_sigmoid']);
        end
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        thresholds(uniqueElectrode,Weibull+1)=threshold;
        thresholds(uniqueElectrode,Weibull+2)=electrode;
        thresholds(uniqueElectrode,Weibull+3)=array;
    end
end
save([rootdir,date,'\',date,'_thresholds.mat'],'thresholds');