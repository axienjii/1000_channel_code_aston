function generate_area_ch_mapping_aston
%Written by Xing on 29/11/18 to generate matrices containing info on the
%visual cortical area, array number, and channel number that corresponds to each channel
%on each instance.
for instanceInd=1:8
    for channelInd=1:128
        [channelNum,arrayNum,area]=electrode_mapping_aston(instanceInd,channelInd);
        arrayNums(channelInd,instanceInd)=arrayNum;
        if strcmp(area,'V1')
            areas(channelInd,instanceInd)=1;
        elseif strcmp(area,'V4')
            areas(channelInd,instanceInd)=4;
        end
        channelNums(channelInd,instanceInd)=channelNum;
    end
end
save('D:\aston_data\channel_area_mapping.mat','arrayNums','channelNums','areas');