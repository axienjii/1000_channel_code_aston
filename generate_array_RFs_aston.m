function generate_array_RFs
%Written by Xing on 28/2/18. Splits the RF data from each instance (with
%128 channels) into two data files- one for each arrays (64 channels each).

%Arrays 1 to 8 (instances 1 to 4):
load('D:\data\best_260617-280617\RFs_instance1.mat')
channelRFs=channelRFs([97:128 1:32],:);
meanChannelSNR=meanChannelSNR([97:128 1:32],:);
RFs=RFs([97:128 1:32]);
save('D:\data\best_260617-280617\RFs_instance1_array1.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance1.mat')
channelRFs=channelRFs(33:96,:);
meanChannelSNR=meanChannelSNR(33:96,:);
RFs=RFs(33:96);
save('D:\data\best_260617-280617\RFs_instance1_array2.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance2.mat')
channelRFs=channelRFs([97:128 1:32],:);
meanChannelSNR=meanChannelSNR([97:128 1:32],:);
RFs=RFs([97:128 1:32]);
save('D:\data\best_260617-280617\RFs_instance2_array3.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance2.mat')
channelRFs=channelRFs(33:96,:);
meanChannelSNR=meanChannelSNR(33:96,:);
RFs=RFs(33:96);
save('D:\data\best_260617-280617\RFs_instance2_array4.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance3.mat')
channelRFs=channelRFs([97:128 1:32],:);
meanChannelSNR=meanChannelSNR([97:128 1:32],:);
RFs=RFs([97:128 1:32]);
save('D:\data\best_260617-280617\RFs_instance3_array5.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance3.mat')
channelRFs=channelRFs(33:96,:);
meanChannelSNR=meanChannelSNR(33:96,:);
RFs=RFs(33:96);
save('D:\data\best_260617-280617\RFs_instance3_array6.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance4.mat')
channelRFs=channelRFs([97:128 1:32],:);
meanChannelSNR=meanChannelSNR([97:128 1:32],:);
RFs=RFs([97:128 1:32]);
save('D:\data\best_260617-280617\RFs_instance4_array7.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance4.mat')
channelRFs=channelRFs(33:96,:);
meanChannelSNR=meanChannelSNR(33:96,:);
RFs=RFs(33:96);
save('D:\data\best_260617-280617\RFs_instance4_array8.mat','channelRFs','meanChannelSNR','RFs')

%Arrays 9 to 16 (instances 5 to 8):
load('D:\data\best_260617-280617\RFs_instance5.mat')
channelRFs=channelRFs([65:96 33:64],:);
meanChannelSNR=meanChannelSNR([65:96 33:64],:);
RFs=RFs([65:96 33:64]);
save('D:\data\best_260617-280617\RFs_instance5_array9.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance5.mat')
channelRFs=channelRFs([1:32 97:128],:);
meanChannelSNR=meanChannelSNR([1:32 97:128],:);
RFs=RFs([1:32 97:128]);
save('D:\data\best_260617-280617\RFs_instance5_array10.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance6.mat')
channelRFs=channelRFs([65:96 33:64],:);
meanChannelSNR=meanChannelSNR([65:96 33:64],:);
RFs=RFs([65:96 33:64]);
save('D:\data\best_260617-280617\RFs_instance6_array11.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance6.mat')
channelRFs=channelRFs([1:32 97:128],:);
meanChannelSNR=meanChannelSNR([1:32 97:128],:);
RFs=RFs([1:32 97:128]);
save('D:\data\best_260617-280617\RFs_instance6_array12.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance7.mat')
channelRFs=channelRFs([65:96 33:64],:);
meanChannelSNR=meanChannelSNR([65:96 33:64],:);
RFs=RFs([65:96 33:64]);
save('D:\data\best_260617-280617\RFs_instance7_array13.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance7.mat')
channelRFs=channelRFs([1:32 97:128],:);
meanChannelSNR=meanChannelSNR([1:32 97:128],:);
RFs=RFs([1:32 97:128]);
save('D:\data\best_260617-280617\RFs_instance7_array14.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance8.mat')
channelRFs=channelRFs([65:96 33:64],:);
meanChannelSNR=meanChannelSNR([65:96 33:64],:);
RFs=RFs([65:96 33:64]);
save('D:\data\best_260617-280617\RFs_instance8_array15.mat','channelRFs','meanChannelSNR','RFs')

load('D:\data\best_260617-280617\RFs_instance8.mat')
channelRFs=channelRFs([1:32 97:128],:);
meanChannelSNR=meanChannelSNR([1:32 97:128],:);
RFs=RFs([1:32 97:128]);
save('D:\data\best_260617-280617\RFs_instance8_array16.mat','channelRFs','meanChannelSNR','RFs')