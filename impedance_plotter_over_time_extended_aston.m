function impedance_plotter_over_time_extended_aston
%Written by Xing 20/12/19 to read impedance values from mat files and draw
%box plots of impedance values over time. 
colind = hsv(16);
colindImp = hsv(1000);%colour-code impedances
impedanceAllChannelsSessions=[];
figure
hold on
dates=[{'280818'} {'041018'} {'201118'} {'181218'} {'010319'} {'170419'} {'160819'}];
for dateInd=1:7
    date=dates{dateInd};
    load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat']);
    impedanceAllChannelsSessions=[impedanceAllChannelsSessions impedanceAllChannels(:,1)];
    formatIn = 'ddmmyy';
    xval(dateInd)=datenum(date,formatIn);
%     subplot(1,15,dateInd);
end
% save('D:\aston_data\signal_quality\impedance_160819.mat','impedanceAllChannelsSessions','xval');
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

figure;hold on
surgery=datenum('260718',formatIn);
xvals=repmat(xval-surgery,[1024 1]);
scatter(xvals(:),impedanceAllChannelsSessions(:),1,[0.5 0.5 0.5]);
meanImp=nanmean(impedanceAllChannelsSessions,1);
hold on
plot(xval-surgery,meanImp,'k-');
mdl = fitlm(xval-surgery,meanImp);
xVals=0:xval(end)-surgery;
yVals=xVals*-0.154804977981788+2.834187859653726e+02;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'b-');
xlabel('Days after implantation')
ylabel('Impedance (kOhm)');

figure;hold on
surgery=datenum('260718',formatIn);
xvals=repmat(xval-surgery,[1024 1]);
meanImp=mean(impedanceAllChannelsSessions(:));
stdImp=std(impedanceAllChannelsSessions(:));
indOutliers=find(impedanceAllChannelsSessions(:)>meanImp+3*stdImp);
impedanceAllChannelsSessionsNoOutliers=impedanceAllChannelsSessions(:);
impedanceAllChannelsSessionsNoOutliers(indOutliers)=[];
xvalsNoOutliers=xvals(:);
xvalsNoOutliers(indOutliers)=[];
scatter(xvalsNoOutliers,impedanceAllChannelsSessionsNoOutliers,1,[0.5 0.5 0.5]);
impedanceAllChannelsSessionsNoOutliersNan=impedanceAllChannelsSessions;
impedanceAllChannelsSessionsNoOutliersNan(indOutliers)=nan;
meanImp=nanmean(impedanceAllChannelsSessionsNoOutliersNan,1);
hold on
plot(xval-surgery,meanImp,'k-');
mdl = fitlm(xvalsNoOutliers,impedanceAllChannelsSessionsNoOutliers);
xVals=0:xval(end)-surgery;
yVals=xVals*-1.278609392784273+4.732590840711530e+02;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'b-');
xlabel('Days after implantation')
ylabel('Impedance (kOhm)');
ylim([0 1500]);

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
sprintf(['F(',num2str(dfBetween),',',num2str(dfWithin),') = ',num2str(Fstat),', p = %.4f'],p)%F(1,4094) = 126.9886, p = 0.0000
[c,~,~,gnames] = multcompare(stats);
figure;
boxplot([earlySessions(:) lateSessions(:)]);

%exclude outliers above 3000 kOhms:
cutoff=3000;
earlySessionsVector=earlySessions(:);
lateSessionsVector=lateSessions(:);
excludeEarly=find(earlySessionsVector>cutoff);
excludeLate=find(lateSessionsVector>cutoff);
if numSessionsPerGroup==1
    length(excludeEarly)
    length(excludeLate)
    intersectEarlyLate=intersect(excludeEarly,excludeLate);
    length(intersectEarlyLate)%3 chs
end
earlySessionsVector(excludeEarly)=[];
lateSessionsVector(excludeLate)=[];
groupAssignmentEarly=earlySessionsVector*0+1;
groupAssignmentLate=lateSessionsVector*0+2;
groupAssignment=[groupAssignmentEarly;groupAssignmentLate];
formattedGroupAssignment=groupAssignment(:);
earlyLateSessions=[earlySessionsVector;lateSessionsVector];
formattedSessions=earlyLateSessions(:);
% [h p ci stats]=anovan(formattedSessions,formattedGroupAssignment);
[p table stats]=anova1(formattedSessions,formattedGroupAssignment);
dfBetween=table{2,3};
dfWithin=table{3,3};
Fstat=table{2,5};
sprintf(['F(',num2str(dfBetween),',',num2str(dfWithin),') = ',num2str(Fstat),', p = %.4f'],p)%F(1,4021) = 2633.0911, p = 0.0000
[c,~,~,gnames] = multcompare(stats);

pause
