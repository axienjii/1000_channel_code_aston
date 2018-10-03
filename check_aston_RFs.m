function check_aston_RFs
%Written by Xing 3/9/18. Reads RF data 2 files, with and without impedance
%values, and checks that the RF values are identical between the two.
date='best_aston_280818-290818';
for arrayInd=1:16
    instanceInd=ceil(arrayInd/2);
    loadFileName=['X:\aston\best_aston_280818-290818\RFs_instance',num2str(instanceInd),'_array',num2str(arrayInd),'.mat'];
    load(loadFileName);
    RFx1=channelRFs(:,1);
    RFy1=channelRFs(:,2);
    
    loadFileName2=['X:\aston\aston_impedance_values\280818\','array',num2str(arrayInd),'.mat'];
    load(loadFileName2);
    eval(['arrayNew=array',num2str(arrayInd),';']);
    [sortedRFs inds]=sort(arrayNew(:,8));
    RFx2=arrayNew(inds,1);
    RFy2=arrayNew(inds,2);
    sum(RFx1==RFx2)%check that values are identical
    sum(RFy1==RFy2)
    pause
end