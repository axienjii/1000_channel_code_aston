function combine_SNR_mat_files_aston
%Written by Xing 4/2/19
%Combines SNR values across NSPs.
% date='140819_B2_aston';
% date='150819_B2_aston';
date='160819_B2_aston';
allChsSNR=[];
for instance=1:8
    copyfile(['X:\aston\',date,'\mean_MUA_instance',num2str(instance),'_new.mat'],['X:\aston\aston_resting_state_data\monkey_A\checkSNR_task\',date,'\mean_MUA_NSP',num2str(instance),'_new.mat'])
    load(['X:\aston\aston_resting_state_data\monkey_A\checkSNR_task\',date,'\mean_MUA_NSP',num2str(instance),'_new.mat'])
    allChsSNR=[allChsSNR channelSNR(1:128)'];
end
mean(allChsSNR(:))
std(allChsSNR(:))
save(['X:\aston\resting_state_data\monkeyanalyse_CheckSNR2_aston_batch_A\checkSNR_task\',date,'\allSNR.mat'],'allChsSNR');