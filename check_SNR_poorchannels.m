function check_SNR_poorchannels
load('D:\data\260617_B1\RFs_instance1.mat')
figure
hold on
for i=[1:32 97:128]
    if meanChannelSNR(i)>3
        if channelRFs(i,1)<0||channelRFs(i,2)>0
            i
            channelRFs(i,1:2)
            plot(channelRFs(i,1),channelRFs(i,2),'kx');
            text(channelRFs(i,1)+2,channelRFs(i,2)+3,num2str(i),'FontSize',8,'Color',[0 0 0]);
        end
    end
end
xlim([-300 300])
ylim([-300 300])