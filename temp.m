
for channelInd=1:NS5.MetaTags.ChannelCount
    figInd=ceil(channelInd/36);
    figure(figInd);hold on
    subplotInd=channelInd-((figInd-1)*36);
    subplot(6,6,subplotInd);
    plot(meanChannelMUA(channelInd,:))
%     title(num2str(channelInd));
end