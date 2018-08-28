function generate_area_ch_mapping
%Written by Xing on 16/4/18 to generate matrices containing info on the
%visual cortical area, array number, and channel number that corresponds to each channel
%on each instance.
for instanceInd=1:8
    for channelInd=1:128
        [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd);
        arrayNums(channelInd,instanceInd)=arrayNum;
        if strcmp(area,'V1')
            areas(channelInd,instanceInd)=1;
        elseif strcmp(area,'V4')
            areas(channelInd,instanceInd)=4;
        end
        channelNums(channelInd,instanceInd)=channelNum;
    end
end
save('d:\data\channel_area_mapping.mat2','arrayNums','channelNums','areas');