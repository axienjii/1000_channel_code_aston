function impedance_plotter4_aston
%Written by Xing 03/9/18 to read impedance values from txt files and draw
%plots of impedance values from txt files, generated from Central's
%impedance tester function. 
%Also checks channels with lowest impedances, looks up RF centre locations
%and positions of electrodes on array, and identifies good candidate
%channels for microstimulation (and for early testing, for simultaneous
%recording).
%Corrected the indexing of RF coordinate data, which was previously incorrect in 
%impedance_plotter.m
% date='280818';
% date='041018';
% date='201118';
% date='181218';
% date='010319';
% date='170419';
% date='260419';
date='160819';
colind = hsv(16);
colindImp = hsv(1000);%colour-code impedances

figure
hold on
allArray=[];
allElectrode=[];
allImpedance=[];
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    instanceImpFileName=['X:\aston\aston_impedance_values\',date,'\impedance_',instanceName,'_',date];%impedance values, hand-tightening
    fileID = fopen(instanceImpFileName,'r');
    [A,count] = fscanf(fileID,'%c',inf);
    indStart=regexp(A,'elec');
    indHyphen=regexp(A,'-');
    indEnd=regexp(A,'kOhm');
    if length(indStart)~=128||length(indHyphen)~=128||length(indEnd)~=128
        sprintf('Number of identifying markers are not identical. Check file.')
    end
    fclose(fileID);
    for i=1:length(indStart)
        array(i)=str2num(A(indStart(i)+4:indHyphen(i)-1));
        electrode(i)=str2num(A(indHyphen(i)+1:indHyphen(i)+4));
        impedance(i)=str2num(A(indEnd(i)-5:indEnd(i)-1));
    end
    allArray=[allArray array];
    allElectrode=[allElectrode electrode];
    allImpedance=[allImpedance impedance];                       
end
impedanceAllChannels=[allImpedance' allArray' allElectrode'];
save(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');

impedanceAllChannels
switch(date)        
    case('280818')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='';
%         load(['C:\Users\User\Documents\impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
%         impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
    case('041018')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='280818';
        load(['X:\aston\aston_impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
    case('201118')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='041018';
        load(['X:\aston\aston_impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
    case('181218')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='201118';
        load(['X:\aston\aston_impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
    case('010319')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='181218';
        load(['X:\aston\aston_impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
    case('170419')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='010319';
        load(['X:\aston\aston_impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
    case('260419')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='170419';
        load(['X:\aston\aston_impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
    case('160819')
        load(['X:\aston\aston_impedance_values\',date,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsNew=impedanceAllChannels;
        previousDate='260419';
        load(['X:\aston\aston_impedance_values\',previousDate,'\impedanceAllChannels.mat'],'impedanceAllChannels');
        impedanceAllChannelsPrevious=impedanceAllChannels;
        %column 1: impedance
        %column 2: array number
        %column 3: electrode number (out of 1024)
        xLabelsConds={[previousDate,' HT'],[date,' HT']};
        titleText=['red: ',previousDate,'; blue: ',date];
end
figure;hold on
% length(find(impedanceAllChannelsPrevious(:,1)>800))%number of channels with too-high impedances values during hand-tightening, 485
length(find(impedanceAllChannelsNew(:,1)>800))%number of channels with too-high impedances values using a torque wrench, 111
for i=1:size(impedanceAllChannelsNew,1)
    plot([1 2],[impedanceAllChannelsPrevious(i,1),impedanceAllChannelsNew(i,1)]);
end
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',xLabelsConds)
xlim([0.5 2.5]);
pathname=fullfile('X:\aston\aston_impedance_values\',date,['impedance_changes_',previousDate,'_to_',date]);
print(pathname,'-dtiff');

figure;hold on
bins=0:50:7000; 
hist(impedanceAllChannelsPrevious(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'EdgeColor','none') 
set(h,'FaceColor','r','facealpha',0.5) 
hold on 
hist(impedanceAllChannelsNew(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'facealpha',0.5,'EdgeColor','none') 
xlim([0 7000]); 
set(gca,'box','off'); 
title(titleText)
pathname=fullfile('X:\aston\aston_impedance_values\',date,'impedance_histograms');
print(pathname,'-dtiff');

%zoom in on cluster of lower impedance values
figure;hold on
bins=0:10:7000;
hist(impedanceAllChannelsPrevious(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'EdgeColor','none') 
set(h,'FaceColor','r','facealpha',0.5) 
hold on 
hist(impedanceAllChannelsNew(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'facealpha',0.5,'EdgeColor','none') 
xlim([0 7000]); 
set(gca,'box','off'); 
xlim([0 1400]); 
ylim([0 70]); 
pathname=fullfile('X:\aston\aston_impedance_values\',date,'impedance_histograms_zoom_lower_values');
print(pathname,'-dtiff');

%identify electrodes with lowest impedance values:
for instanceInd=1:8%determine the electrode number on a given array
    if instanceInd<5
        channelOrder=[33:128 1:32];%BCDA
    else
        channelOrder=[65:96 33:64 1:32 97:128];%CBAD
    end
    impedanceAllChannelsNew((instanceInd-1)*128+1:(instanceInd-1)*128+128,5)=channelOrder;
end
[dummy ind]=sort(impedanceAllChannelsNew(:,1));
sortImpedanceAllChannels=impedanceAllChannelsNew(ind,:);%column 2: array number; column 5: electrode number (out of 128). column 1: latest impedance; column 3: electrode number (out of 1024)
sortImpedanceAllChannelsPrevious=impedanceAllChannelsPrevious(ind,:);%column 2: array number; column 5: electrode number (out of 128). column 1: latest impedance; column 3: electrode number (out of 1024)
%identify electrodes with low impedance values that are situated along
%middle rows of arrays, i.e. electrode numbers 25:40 (not inclusive, as
%those electrodes are on the edge of the array, and hence have only 2
%neighbouring electrodes from which recordings can be made, whereas the
%others have 3 neighbours from which recordings can be made)
%Note that 32 and 33 are also positioned along the edge of the array.
a=find(sortImpedanceAllChannels(:,5)>25);
b=find(sortImpedanceAllChannels(:,5)<40);
goodLocationInd=intersect(a,b);
goodLocationImpedances=sortImpedanceAllChannels(goodLocationInd,:);
save(['X:\aston\aston_impedance_values\',date,'\goodLocationImpedances.mat'],'goodLocationImpedances')

figure;hold on
impThreshold=10000;
goodChImps=[];
goodChV1SimRec=[];%candidate V1 channels for simultaneous microstimulation and recording 
for candidateInd=1:size(sortImpedanceAllChannels,1)
    array=sortImpedanceAllChannels(candidateInd,2);
    channel=sortImpedanceAllChannels(candidateInd,5);
    instance=ceil(array/2);
    loadDate='best_aston_280818-290818';
    fileName=['X:\aston\',loadDate,'\RFs_instance',num2str(instance),'_array',num2str(array),'.mat'];
    load(fileName)
    if channel>64
        channel=channel-64;
    end
    chInfo(candidateInd,1:4)=channelRFs(channel,1:4);%RF.centrex RF.centrey RF.sz RF.szdeg
    chInfo(candidateInd,5)=meanChannelSNR(channel);%SNR
    chInfo(candidateInd,6)=sortImpedanceAllChannels(candidateInd,1);%impedance
    chInfoPrevious(candidateInd,6)=sortImpedanceAllChannelsPrevious(candidateInd,1);%previous impedance
    chInfo(candidateInd,7)=array;
    chInfo(candidateInd,8)=channel;
    if chInfo(candidateInd,1)>0&&chInfo(candidateInd,2)<0%RF coordinates are in correct quadrant
        if chInfo(candidateInd,6)<impThreshold%impedance is below cutoff, e.g. 100 kOhms
            plotDifferenceImps=0;
            if plotDifferenceImps==0
                impCol=chInfo(candidateInd,6)*0.9/impThreshold+0.05;
            elseif plotDifferenceImps==1
                impCol=chInfo(candidateInd,6)-chInfoPrevious(candidateInd,6);%difference between latest and previous impedance values
            end
            goodChImps=[goodChImps;chInfo(candidateInd,:)];
            if array~=2&&array~=5
% %                 plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',colind(array,:),'Marker','x');
%                 if channel>25&&channel<40&&channel~=32&&channel~=33%channels positioned along middle of array, with 3 close neighbours from which recordings can be made
%                     plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[1 impCol impCol],'Marker','o','MarkerSize',10,'MarkerFaceColor',[0.8 1 0.8]);
%                     goodChV1SimRec=[goodChV1SimRec;chInfo(candidateInd,:)];
%                 else
                    if plotDifferenceImps==0
                        plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[1 impCol impCol],'Marker','o','MarkerSize',10);
                        text(chInfo(candidateInd,1)-1,chInfo(candidateInd,2),num2str(chInfo(candidateInd,6)),'FontSize',6,'Color',[1 impCol impCol]);
                   elseif plotDifferenceImps==1
                        if impCol<=0
                            impCol=-impCol*0.9/impThreshold+0.05;
                            plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[impCol 1 impCol],'Marker','o','MarkerSize',10);
                            text(chInfo(candidateInd,1)-1,chInfo(candidateInd,2),num2str(chInfo(candidateInd,6)),'FontSize',6,'Color',[impCol 1 impCol]);
                        elseif impCol>0
                            impCol=impCol*0.9/impThreshold+0.05;
                            plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[1 impCol impCol],'Marker','o','MarkerSize',10);
                            text(chInfo(candidateInd,1)-1,chInfo(candidateInd,2),num2str(chInfo(candidateInd,6)),'FontSize',6,'Color',[1 impCol impCol]);
                        end
                    end
%                 end
            else
% %                 plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',colind(array,:),'Marker','o');
%                 if channel>25&&channel<40&&channel~=32&&channel~=33%channels positioned along middle of array, with 3 close neighbours from which recordings can be made
%                     plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[impCol impCol 1],'Marker','o','MarkerSize',10,'MarkerFaceColor',[0.8 0.8 1]);
%                 else
                    if plotDifferenceImps==0
                        plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[impCol impCol 1],'Marker','o','MarkerSize',10);
                    elseif plotDifferenceImps==1
                        if impCol<=0
                            impCol=-impCol*0.9/impThreshold+0.05;
                            plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[impCol impCol 1],'Marker','o','MarkerSize',10);
                        elseif impCol>0
                            impCol=impCol*0.9/impThreshold+0.05;
                            plot(chInfo(candidateInd,1),chInfo(candidateInd,2),'MarkerEdgeColor',[1 impCol 1],'Marker','o','MarkerSize',10);
                        end
                    end
%                 end
                text(chInfo(candidateInd,1)-1,chInfo(candidateInd,2),num2str(chInfo(candidateInd,6)),'FontSize',6,'Color',[impCol impCol 1]);
            end
        end
    end
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
axis square
xlim([0 200]);
ylim([-200 0]);
title('low-high impedance: dark-light; V1: red; V4: blue');
if plotDifferenceImps==0
    pathname=fullfile('X:\aston\aston_impedance_values\',date,['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals']);
elseif plotDifferenceImps==0
    pathname=fullfile('X:\aston\aston_impedance_values\',date,['RFs_channels_impedance_below_',num2str(impThreshold),'kOhms_vals_difference']);
end
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff','-r300');
    
figure;
hold on
xlim([-50 200]);
ylim([-200 50]);
colind = hsv(16);
array8=chInfo(chInfo(:,7)==8,:);
plot(array8(:,1),array8(:,2),'x','Color',colind(8,:));
%some channels with low impedance on array 8
array9=chInfo(chInfo(:,7)==9,:);
plot(array9(:,1),array9(:,2),'x','Color',colind(9,:));
%minimum impedance for array 9 after first channel starts at 41 kOhms
array10=chInfo(chInfo(:,7)==10,:);
plot(array10(:,1),array10(:,2),'x','Color',colind(10,:));
%minimum impedance for array 10 starts at 23 kOhms
array11=chInfo(chInfo(:,7)==11,:);
plot(array11(:,1),array11(:,2),'x','Color',colind(11,:));
%minimum impedance for array 11 after first 5 channels starts at 51 kOhms
array12=chInfo(chInfo(:,7)==12,:);
plot(array12(:,1),array12(:,2),'x','Color',colind(12,:));
%many channels with low impedance on array 12
array13=chInfo(chInfo(:,7)==13,:);
plot(array13(:,1),array13(:,2),'x','Color',colind(13,:));
%many channels with low impedance on array 13
array14=chInfo(chInfo(:,7)==14,:);
plot(array14(:,1),array14(:,2),'x','Color',colind(14,:));
%some channels with low impedance on array 14
array15=chInfo(chInfo(:,7)==15,:);
plot(array15(:,1),array15(:,2),'x','Color',colind(15,:));
%minimum impedance for array 15 after first channel starts at 59 kOhms
array16=chInfo(chInfo(:,7)==16,:);
plot(array16(:,1),array16(:,2),'x','Color',colind(16,:));
%some channels with low impedance on array 16

array1=chInfo(chInfo(:,7)==1,:);
array2=chInfo(chInfo(:,7)==2,:);
array3=chInfo(chInfo(:,7)==3,:);
array4=chInfo(chInfo(:,7)==4,:);
array5=chInfo(chInfo(:,7)==5,:);
array6=chInfo(chInfo(:,7)==6,:);
array7=chInfo(chInfo(:,7)==7,:);
array8=chInfo(chInfo(:,7)==8,:);
array9=chInfo(chInfo(:,7)==9,:);
array10=chInfo(chInfo(:,7)==10,:);
array11=chInfo(chInfo(:,7)==11,:);
array12=chInfo(chInfo(:,7)==12,:);
array13=chInfo(chInfo(:,7)==13,:);
array14=chInfo(chInfo(:,7)==14,:);
array15=chInfo(chInfo(:,7)==15,:);
array16=chInfo(chInfo(:,7)==16,:);

for arrayInd=1:16
   save(['X:\aston\aston_impedance_values\',date,'\array',num2str(arrayInd),'.mat'],['array',num2str(arrayInd)]); 
end
