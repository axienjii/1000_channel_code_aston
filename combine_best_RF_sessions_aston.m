function combine_best_RF_sessions_aston
%Written by Xing 290818 to combine RF data between sessions with different
%sweeping bar stimuli, e.g.:
%260617_B1 arrays [2 3 5:16];%mapped with larger bar
%280617_B1 arrays [1 4];%close to fixation spot, mapped with thin small bar
%Also to combine data for manually mapped RFs.

%array 1:
load('D:\aston_data\290818_B1_aston\RFs_instance1.mat')
channelRFs29=channelRFs;
meanChannelSNR29=meanChannelSNR;
RFs29=RFs;
%array 2:
load('D:\aston_data\280818_B2_aston\RFs_instance1.mat')
channelRFs28=channelRFs;
meanChannelSNR28=meanChannelSNR;
RFs28=RFs;
channelRFs=[channelRFs29(1:32,:);channelRFs28(33:96,:);channelRFs29(97:128,:)];
meanChannelSNR=[meanChannelSNR29(1:32,:);meanChannelSNR28(33:96,:);meanChannelSNR29(97:128,:)];
RFs=[RFs29(1:32) RFs28(33:96) RFs29(97:128)];
save('D:\aston_data\best_aston_280818-290818\RFs_instance1.mat','channelRFs','meanChannelSNR','RFs');

%array 3:
load('D:\aston_data\290818_B1_aston\RFs_instance2.mat')
channelRFs29=channelRFs;
meanChannelSNR29=meanChannelSNR;
RFs29=RFs;
%array 4:
load('D:\aston_data\280818_B2_aston\RFs_instance2.mat')
channelRFs28=channelRFs;
meanChannelSNR28=meanChannelSNR;
RFs28=RFs;
channelRFs=[channelRFs29(1:32,:);channelRFs28(33:96,:);channelRFs29(97:128,:)];
meanChannelSNR=[meanChannelSNR29(1:32,:);meanChannelSNR28(33:96,:);meanChannelSNR29(97:128,:)];
RFs=[RFs29(1:32) RFs28(33:96) RFs29(97:128)];
save('D:\aston_data\best_aston_280818-290818\RFs_instance2.mat','channelRFs','meanChannelSNR','RFs');

%array 5:
load('D:\aston_data\280818_B2_aston\RFs_instance3.mat')
channelRFs29=channelRFs;
meanChannelSNR29=meanChannelSNR;
RFs29=RFs;
%array 6:
load('D:\aston_data\290818_B1_aston\RFs_instance3.mat')
channelRFs28=channelRFs;
meanChannelSNR28=meanChannelSNR;
RFs28=RFs;
channelRFs=[channelRFs29(1:32,:);channelRFs28(33:96,:);channelRFs29(97:128,:)];
meanChannelSNR=[meanChannelSNR29(1:32,:);meanChannelSNR28(33:96,:);meanChannelSNR29(97:128,:)];
RFs=[RFs29(1:32) RFs28(33:96) RFs29(97:128)];
save('D:\aston_data\best_aston_280818-290818\RFs_instance3.mat','channelRFs','meanChannelSNR','RFs');

%arrays 7 & 8:
load('D:\aston_data\290818_B1_aston\RFs_instance4.mat')
save('D:\aston_data\best_aston_280818-290818\RFs_instance4.mat','channelRFs','meanChannelSNR','RFs');

%arrays 9 & 10:
load('D:\aston_data\280818_B2_aston\RFs_instance5.mat')
save('D:\aston_data\best_aston_280818-290818\RFs_instance5.mat','channelRFs','meanChannelSNR','RFs');

%arrays 11 & 12:
load('D:\aston_data\280818_B2_aston\RFs_instance6.mat')
save('D:\aston_data\best_aston_280818-290818\RFs_instance6.mat','channelRFs','meanChannelSNR','RFs');

%arrays 13 & 14:
load('D:\aston_data\280818_B2_aston\RFs_instance7.mat')
save('D:\aston_data\best_aston_280818-290818\RFs_instance7.mat','channelRFs','meanChannelSNR','RFs');

%array 15:
load('D:\aston_data\290818_B1_aston\RFs_instance8.mat')
channelRFs29=channelRFs;
meanChannelSNR29=meanChannelSNR;
RFs29=RFs;
%array 16:
load('D:\aston_data\280818_B2_aston\RFs_instance8.mat')
channelRFs28=channelRFs;
meanChannelSNR28=meanChannelSNR;
RFs28=RFs;
channelRFs=[channelRFs28(1:32,:);channelRFs29(33:96,:);channelRFs28(97:128,:)];
meanChannelSNR=[meanChannelSNR28(1:32,:);meanChannelSNR29(33:96,:);meanChannelSNR28(97:128,:)];
RFs=[RFs28(1:32) RFs29(33:96) RFs28(97:128)];
save('D:\aston_data\best_aston_280818-290818\RFs_instance8.mat','channelRFs','meanChannelSNR','RFs');
