function [channel_InstanceNo channel_1024No]=convert_channel_1024_2(array,channel)
%Written by Xing 25/7/17
%Input arguments are the array number and channel number (from 1 to 64).
%Returns the channel number on the instance (1 to 128) as well as the
%channel number out of 1024 channels.

%assign channel number out of 128 on a given instance:
channelInstanceNos=[];
%instances 1 to 4:
oddArray=[97:128 1:32];%BCDA
evenArray=33:96;
channelInstanceNos=[oddArray;evenArray;oddArray;evenArray;oddArray;evenArray;oddArray;evenArray];
%instance 5 to 8:
oddArray=[65:96 33:64];
evenArray=[1:32 97:128];%CBAD
channelInstanceNos=[channelInstanceNos;oddArray;evenArray;oddArray;evenArray;oddArray;evenArray;oddArray;evenArray];
%channelInstanceNos contains 16 rows and 64 columns
channel_InstanceNo=channelInstanceNos(array,channel);


%assign channel number out of 1024:
%instances 1 to 4:
if array<=8
    arrayNum=[33:128 1:32];%BCDA
    if mod(array,2)==1%odd array
        ind128=find(arrayNum==channel);
    elseif mod(array,2)==0%even array
        ind128=find(arrayNum==channel+64);
    end
elseif array>8
    arrayNum=[65:96 33:64 1:32 97:128];
    if mod(array,2)==1%odd array
        ind128=find(arrayNum==channel);
    elseif mod(array,2)==0%even array
        ind128=find(arrayNum==channel+64);
    end
end
instance=ceil(array/2);
channel_1024NoInd=(instance-1)*128+ind128;
load('D:\data\order_1024.mat','order_1024');
channel_1024No=order_1024(channel_1024NoInd);