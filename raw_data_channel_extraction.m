function raw_data_channel_extraction
%Modified by Xing on 20/6/17 from ana_RF_flashgrid.

%Analyses data from runstim_RF_GridMap
%Normally used for mapping V4
%Matt, May 2015
tic
analysedata = 1;        %If data already analysed you can skip straight to the graphs
saveout = 0;            %Save out the data  at the end?
savename = 'FlashMap_20170620';   %Name of data file to save
fileName = 'RF_GridMap_20170619_B1.mat';

datadir = 'D:\data\190617_B1\';
date='190617_B1';
date='280617_B2';

for instanceInd=1
    instanceName=['instance',num2str(instanceInd)];
    
    instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
    switch(instanceInd)
        case(1)
            goodChannels=[2 3 6:11 16 19:23 28 29 31:33 36 42:50 56 58 60:65 75:81 89 93:96 98:112 114:128];
            goodChannels=[11 16 19:23 28 29 31:33 36 42:50 56 58 60:65 75:81 89 93:96 98:112 114:128];
            goodChannels=129:130;
        case(2)
            goodChannels=[1:5 18 20:23 34 35 37:42 56:57 59:60 69 72 74:78 90:98 107:110 113:116 125 128];
        case(8)
            goodChannels=[1:1];
        case(5)
            goodChannels=[1:32 97:128];
        case(6)
            goodChannels=33:96;
    end
        
    readRawData=1;
    if readRawData==1
        numMin=1;%duration of each segment to be read in, in minutes
        errorMessages=[];%keep a list of any errors
        for channelCount=1:length(goodChannels)
            channelInd=goodChannels(channelCount);
            readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
            NSch=openNSx(instanceNS6FileName,'read',readChannel);
            fileName=fullfile('D:\data',date,[instanceName,'_ch',num2str(channelInd),'_rawdata.mat']);
            save(fileName,'NSch');            
%             data=double(NSch.Data);%for MUA extraction, process data for that channel at one shot, across entire session            
        end
    end
end

