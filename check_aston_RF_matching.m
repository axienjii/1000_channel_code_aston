function check_aston_RF_matching
%Written by Xing 11/9/19
%Check RF data in array mat files, as well as in goodArrays8to16.
date='280818';
load('D:\aston_data\currentThresholdChs78.mat')
mismatched=[];
for i=1:size(goodArrays8to16,1)
    electrode=goodArrays8to16(i,8);
    array=goodArrays8to16(i,7);
    load(['C:\Users\User\Documents\aston_impedance_values\',date,'\array',num2str(array),'.mat'],['array',num2str(array)]);
    eval(['temp1=find(array',num2str(array),'(:,8)==electrode);'])
    eval(['temp2=find(array',num2str(array),'(:,7)==array);'])
%     temp1=find(array8(:,8)==electrode);
%     temp2=find(array8(:,7)==array);
    row=intersect(temp1,temp2);
    eval(['arrayRF(1:2)=array',num2str(array),'(row,1:2);'])
%     arrayRF(1:2)=array8(row,1:2);
    goodArrayRF(1:2)=goodArrays8to16(i,1:2);
    sameInd(i)=issame(arrayRF,goodArrayRF);
    if sameInd(i)~=2
        electrode
        array
        mismatched=[mismatched;array electrode goodArrayRF arrayRF];
    end
end
mismatched;

