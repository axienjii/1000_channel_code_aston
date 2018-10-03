function RF_splitter
%Written by Xing 240717
%Separates RF information by array number
loadDate='best_260617-280617';
for instanceInd=1:8
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
    load(fileName)
    channelRFsOriginal=channelRFs;
    meanChannelSNROriginal=meanChannelSNR;
    if instanceInd<5
        oddArray=[97:128 1:32];%BCDA
        evenArray=33:96;
    else
        oddArray=33:96;
        evenArray=[97:128 1:32];%CBAD
    end
    channelRFs=channelRFsOriginal(oddArray,:);
    meanChannelSNR=meanChannelSNROriginal(oddArray,:);
    arrayNum=instanceInd*2-1;
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'_array',num2str(arrayNum),'.mat'];
    save(fileName);
    channelRFs=channelRFsOriginal(evenArray,:);
    meanChannelSNR=meanChannelSNROriginal(evenArray,:);
    arrayNum=instanceInd*2;
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'_array',num2str(arrayNum),'.mat'];
    save(fileName);
end