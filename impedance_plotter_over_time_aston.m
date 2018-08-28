function impedance_plotter_over_time
%Written by Xing 1/3/18 to read impedance values from mat files and draw
%box plots of impedance values over time. 
colind = hsv(16);
colindImp = hsv(1000);%colour-code impedances
impedanceAllChannelsSessions=[];
figure
hold on
dates=[{'260617'} {'110717'} {'170717'} {'200717'} {'080817'} {'100817'} {'180817'} {'200917'} {'061017'} {'091017'} {'131017'} {'201017'} {'020218'} {'280218'} {'080618'} {'070818'}];
for dateInd=1:16
    switch(dateInd)
        case 1
            date='260617';
        case 2
            date='110717';
        case 3
            date='170717';
        case 4
            date='200717';
        case 5
            date='080817';
        case 6
            date='100817';
        case 7
            date='180817';
        case 8
            date='200917';
        case 9
            date='061017';
        case 10
            date='091017';
        case 11
            date='131017';
        case 12
            date='201017';
        case 13
            date='020218';
        case 14
            date='280218';
        case 15
            date='080618';
        case 16
            date='070818';
    end
    load(['C:\Users\User\Documents\impedance_values\',date,'\impedanceAllChannels.mat']);
    impedanceAllChannelsSessions=[impedanceAllChannelsSessions impedanceAllChannels(:,1)];
    formatIn = 'ddmmyy';
    xval(dateInd)=datenum(date,formatIn);
%     subplot(1,15,dateInd);
end
xval(4)=xval(4)+1;
xval(5)=xval(5)-2;
xval(9)=xval(9)-1;
boxplot(impedanceAllChannelsSessions,'positions',xval,'boxstyle','filled','labels',dates);
set(gca, 'FontSize', 8)
set(gca,'XTickLabelRotation',60)
xlabel('date')
ylabel('impedance (kOhms)');
surgery=datenum('200417',formatIn);
xlim([surgery-5 xval(end)+5]);
plot([surgery surgery],[0 1500],'r');
ylim([0 1500])
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r','LineWidth',5);
pause
