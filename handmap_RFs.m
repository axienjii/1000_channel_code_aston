function handmap_RFs
%identify channels that need to be manually redone, by eye:
instance1chs=[3 6 7 8 10 11 13 15 16 18 19 20 21 22 23 25 26 27 29 30 31 32 100 101 102 103 104 105 106 108 109 111 114 115 117 119 120 121 122 124 126 127 128];
instance2chs=[33 34 35:72 75:77 80];

%obtain list of channels that were really redone manually:

%V1:
load('D:\data\280617_B1\RFs_instance2.mat')
array1Manualchs=unique(manualChannels(:,2));%array 1, instance 1
load('D:\data\best_260617-280617\RFs_instance1.mat')
array4Manualchs=unique(manualChannels(:,2));%array 4, instance 2
load('D:\data\260617_B1\RFs_instance3array5_chs1-32_97-128.mat')
array5Manualchs=unique(manualChannels(:,2));%array 5, instance 3
load('D:\data\260617_B1\RFs_instance3_array6.mat')
array6Manualchs=unique(manualChannels(:,2));%array 6, instance 3
load('D:\data\260617_B1\RFs_instance4_array7_8.mat')
array7_8Manualchs=unique(manualChannels(:,2));%arrays 7 & 8, instance 4

%V4
load('D:\data\260617_B1\RFs_instance1_array2.mat')
array2Manualchs=unique(manualChannels(:,2));%array 2, instance 1
load('D:\data\260617_B1\RFs_instance2_array3.mat')
array3Manualchs=unique(manualChannels(:,2));%array 3, instance 2

save('D:\data\best_260617-280617\manualChsAll','array1Manualchs','array2Manualchs','array3Manualchs','array4Manualchs','array5Manualchs','array6Manualchs','array7_8Manualchs')