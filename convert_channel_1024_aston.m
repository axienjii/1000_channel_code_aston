function [channel_InstanceNo channel_1024No]=convert_channel_1024(array,channel)
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
channel1024Nos=[];
%instances 1 to 4:
oddArray=[97:128 1:32];%BCDA
evenArray=33:96;
channel1024Nos=[oddArray;evenArray;oddArray+128;evenArray+128;oddArray+128*2;evenArray+128*2;oddArray+128*3;evenArray+128*3];
%instance 5 to 8:
oddArray=[65:96 33:64];
evenArray=[1:32 97:128];%CBAD
channel1024Nos=[channel1024Nos;oddArray+128*4;evenArray+128*4;oddArray+128*5;evenArray+128*5;oddArray+128*6;evenArray+128*6;oddArray+128*7;evenArray+128*7];
%channelInstanceNos contains 16 rows and 64 columns
channel_1024No=channel1024Nos(array,channel);