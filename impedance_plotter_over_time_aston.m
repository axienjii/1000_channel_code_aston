function impedance_plotter_over_time_aston
%Written by Xing 13/6/19 to read impedance values from mat files and draw
%box plots of impedance values over time. 
colind = hsv(16);
colindImp = hsv(1000);%colour-code impedances
impedanceAllChannelsSessions=[];
figure
hold on
dates=[{'280818'} {'041018'} {'201118'} {'181218'} {'010319'} {'170419'}];
for dateInd=1:6
    date=dates{dateInd};
    load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat']);
    impedanceAllChannelsSessions=[impedanceAllChannelsSessions impedanceAllChannels(:,1)];
    formatIn = 'ddmmyy';
    xval(dateInd)=datenum(date,formatIn);
%     subplot(1,15,dateInd);
end
boxplot(impedanceAllChannelsSessions,'positions',xval,'boxstyle','filled','labels',dates);
set(gca, 'FontSize', 8)
set(gca,'XTickLabelRotation',60)
xlabel('date')
ylabel('impedance (kOhms)');
surgery=datenum('260718',formatIn);
xlim([surgery-5 xval(end)+5]);
plot([surgery surgery],[0 1500],'r');
ylim([0 1500])
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r','LineWidth',5);

numSessionsPerGroup=2;
earlySessions=impedanceAllChannelsSessions(:,1:numSessionsPerGroup);
lateSessions=impedanceAllChannelsSessions(:,end-numSessionsPerGroup+1:end);
% lateSessions=impedanceAllChannelsSessions(:,4:5);
% [h p ci stats]=ttest(earlySessions,lateSessions);
% sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)
groupAssignment=[earlySessions*0+1 lateSessions*0+2];
formattedGroupAssignment=groupAssignment(:);
earlyLateSessions=[earlySessions lateSessions];
formattedSessions=earlyLateSessions(:);
% [h p ci stats]=anovan(formattedSessions,formattedGroupAssignment);
[p table stats]=anova1(formattedSessions,formattedGroupAssignment);
dfBetween=table{2,3};
dfWithin=table{3,3};
Fstat=table{2,5};
sprintf(['F(',num2str(dfBetween),',',num2str(dfWithin),') = ',num2str(Fstat),', p = %.4f'],p)
figure;
boxplot([earlySessions(:) lateSessions(:)]);

pause
