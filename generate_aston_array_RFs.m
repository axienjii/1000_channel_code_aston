function generate_aston_array_RFs
%Written by Xing 3/9/18. Split RF data from instances, with 128-channel
%numbering system, into arrays with 64-channel numbering system.
date='best_aston_280818-290818';
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    fileName=fullfile('X:\aston',date,['RFs_',instanceName,'.mat']);
    load(fileName)
    originalChannelRFs=channelRFs;
    originalMeanChannelSNR=meanChannelSNR;
    originalRFs=RFs;
    for arrayInd=1:16
        channelRFs=[];
        meanChannelSNR=[];
        RFs=[];
        for channelInd=1:128
            [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd);
            if arrayNum==arrayInd
                channelRFs(channelNum,:)=originalChannelRFs(channelInd,:);
                meanChannelSNR(channelNum)=originalMeanChannelSNR(channelInd);
                RFs{channelNum}=originalRFs{channelInd};
            end
        end
        if ~isempty(channelRFs)
            saveFileName=['X:\aston\best_aston_280818-290818\RFs_instance',num2str(instanceInd),'_array',num2str(arrayInd),'.mat'];
            save(saveFileName,'channelRFs','meanChannelSNR','RFs');
        end
    end
end