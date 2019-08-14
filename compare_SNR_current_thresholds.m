function compare_SNR_current_thresholds
%Written by Xing on 18/12/18.
%Plot current threshold against SNR, on channels which were previously uesd
%for microstimulation, and for which current thresholds were obtained. Goal
%is to check whether channels which did not produce a phosphene percept
%(a current threshold could not be obtained) are also the ones with low SNR
%values. Also, conversely, whether the channels with good current
%thresholds are those with higher SNR values. Lastly, if the above
%relationships hold, this script is used to identify potential channels
%with high SNR values for microstimulation, which have not previously been
%used for microstimulation. 

%Load current thresholds obtained to date:
load('X:\aston\171218_data\currentThresholdChs37.mat')

%Load LUT for conversion of channel number under 64-ch array system to
%channel number under 1024-channel system:
load('D:\aston_data\channel_area_mapping_aston.mat');

%Load SNR values:
allChSNR=[];
allInstanceInds=1:8;
for instanceInd=allInstanceInds
    load(['X:\aston\181218_B1_aston\mean_MUA_instance',num2str(instanceInd),'.mat'])
    allChSNR=[allChSNR;channelSNR(1:128)'];
end

stimChSNRs=[];
for stimChRow=1:length(goodCurrentThresholds)
    array=goodArrays8to16(stimChRow,7);
    electrode=goodArrays8to16(stimChRow,8);
    [temp1 dummy]=find(arrayNums(:)==array);
    [temp2 dummy]=find(channelNums(:)==electrode);
    ind=intersect(temp1,temp2);
    stimChSNRs(stimChRow)=allChSNR(ind);
end

figure;
plot(stimChSNRs,goodCurrentThresholds,'ko');
xlabel('SNR value');
ylabel('current threshold');

%Colour-coded by array, printing the array number and/or plotting a circle as a marker:
colind = hsv(16);
colind(8,:)=[1 0 0];
colind(10,:)=[139/255 69/255 19/255];
colind(11,:)=[50/255 205/255 50/255];
colind(12,:)=[0 0 1];
colind(13,:)=[0 0 0];
colind(14,:)=[1 20/255 147/255];
colind(15,:)=[230/255 230/255 0];
colind(16,:)=[139/255 0 139/255];

figure;
hold on;
for stimChRow=1:length(goodCurrentThresholds)
    array=goodArrays8to16(stimChRow,7);
    electrode=goodArrays8to16(stimChRow,8);
%     text(stimChSNRs(stimChRow),goodCurrentThresholds(stimChRow),num2str(array),'FontSize',10,'Color',colind(array,:));
    plot(stimChSNRs(stimChRow),goodCurrentThresholds(stimChRow),'MarkerEdgeColor',colind(array,:),'Marker','o','MarkerSize',5);
end
xlim([0 30])
ylim([0 250])
xlabel('SNR value');
ylabel('current threshold');

%Colour-coded by array, printing the electrode number:
figure;
hold on;
for stimChRow=1:length(goodCurrentThresholds)
    array=goodArrays8to16(stimChRow,7);
    electrode=goodArrays8to16(stimChRow,8);
    text(stimChSNRs(stimChRow),goodCurrentThresholds(stimChRow),num2str(electrode),'FontSize',10,'Color',colind(array,:));
%     plot(stimChSNRs(stimChRow),goodCurrentThresholds(stimChRow),'MarkerEdgeColor',colind(array,:),'Marker','o','MarkerSize',5);
end
xlim([0 30])
ylim([0 250])
xlabel('SNR value');
ylabel('current threshold');