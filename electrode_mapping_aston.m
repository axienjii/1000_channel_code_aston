function [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd)
%Written by Xing 29/8/18
%Assigns channels to correct array and location on array, depending on
%the instance number and their order in the raw data file.
%In Aston, arrays 2 and 5 were implanted in V4, whereas in Lick, arrays 2
%and 3 were in V4.
if instanceInd<5
    channelOrder=[97:128 1:96];%DABC
    if channelInd<=32||channelInd>96
        arrayOrder=1;
    else
        arrayOrder=2;
    end
else
    channelOrder=[65:96 33:64 1:32 97:128];%CBAD
    if channelInd<=32||channelInd>96
        arrayOrder=2;
    else
        arrayOrder=1;
    end
end
channelNum=channelOrder(channelInd);
if channelNum>64
    channelNum=channelNum-64;
end
arrayNum=(instanceInd-1)*2+arrayOrder;%determine to which of the 16 arrays the channel belongs

V4Arrays=[2 5];%arrays implanted in V4
V1Arrays=[1 3 4 6:16];%arrays implanted in V1
if find(V1Arrays==arrayNum)
    area='V1';
else
    area='V4';
end