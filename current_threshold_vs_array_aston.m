function current_threshold_vs_array
%Written by Xing 23/8/18
%Checks for relationship between current threshold for phosphene perception
%and array number
load('X:\best\070818_B7\070818_B7_data\currentThresholdChs134.mat')
colind = hsv(16);
figure;hold on
for rowInd=1:size(goodArrays8to16,1)
    plot(goodArrays8to16(rowInd,7),goodCurrentThresholds(rowInd),'MarkerEdgeColor',colind(goodArrays8to16(rowInd,7),:),'Marker','x');
end
arrayMean=[];
arrayStd=[];
for arrayInd=8:16
    arrayRowInds=find(goodArrays8to16(:,7)==arrayInd);
    arrayMean=[arrayMean mean(goodCurrentThresholds(arrayRowInds))];
    arrayStd=[arrayStd std(goodCurrentThresholds(arrayRowInds))];
end
figure;hold on
bar(8:16,arrayMean);
errorbar(8:16,arrayMean,arrayStd,'LineStyle','none');
xlim([7.5 16.5]);
ylim([0 50]);
xlabel('array number');
ylabel('mean current threshold (uA)');
title('mean current threshold for each array, error bar 1 SD');