function rename_resting_state_files_aston
%Written by Xing 2/10/19
%To replace the word 'instance' in resting state file names with the
%abbreviation 'NSP,' for data that is intended for uploading and sharing.

%check_SNR data
dates=[{'140819_B2_aston'} {'150819_B2_aston'} {'160819_B2_aston'}];
for sessionInd=1:length(dates)
    topDir=['F:\aston_checkSNR_data\',dates{sessionInd}];
    for instanceInd=1:8
        fileNames=[{['instance',num2str(instanceInd),'_1_visual_response.tif']} {['instance',num2str(instanceInd),'_2_visual_response.tif']} {['instance',num2str(instanceInd),'_3_visual_response.tif']} {['instance',num2str(instanceInd),'_4_visual_response.tif']} {['instance',num2str(instanceInd),'.ccf']} {['instance',num2str(instanceInd),'.mat']} {['instance',num2str(instanceInd),'.nev']} {['instance',num2str(instanceInd),'.ns6']} {['mean_MUA_instance',num2str(instanceInd),'.mat']} {['MUA_instance',num2str(instanceInd),'.mat']}];
        newFileNames=[{['NSP',num2str(instanceInd),'_1_visual_response.tif']} {['NSP',num2str(instanceInd),'_2_visual_response.tif']} {['NSP',num2str(instanceInd),'_3_visual_response.tif']} {['NSP',num2str(instanceInd),'_4_visual_response.tif']} {['NSP',num2str(instanceInd),'.ccf']} {['NSP',num2str(instanceInd),'.mat']} {['NSP',num2str(instanceInd),'.nev']} {['NSP',num2str(instanceInd),'.ns6']} {['mean_MUA_NSP',num2str(instanceInd),'.mat']} {['MUA_NSP',num2str(instanceInd),'.mat']}];
        for fileType=1:length(fileNames)
            oriName=fullfile(topDir,fileNames{fileType});
            newFileName=fullfile(topDir,newFileNames{fileType});
            if exist(oriName,'file')
                movefile(oriName,newFileName);
            end
        end
    end
end
       
%Resting state data:
dates=[{'140819_B1_aston'} {'150819_B1_aston'} {'160819_B1_aston'}];
for sessionInd=1:length(dates)
    topDir=['X:\aston\',dates{sessionInd},'_resting_state'];
    for instanceInd=1:8
        fileNames=[{['instance',num2str(instanceInd),'.ccf']} {['instance',num2str(instanceInd),'.mat']} {['instance',num2str(instanceInd),'.nev']} {['instance',num2str(instanceInd),'.ns6']} {['instance',num2str(instanceInd),'_aligned.ns6']} {['LFP_instance',num2str(instanceInd),'.mat']} {['MUA_instance',num2str(instanceInd),'.mat']} {['instance',num2str(instanceInd),'_eye_position.tif']} {['instance',num2str(instanceInd),'_NSch_eye_channels_position.mat']} {['instance',num2str(instanceInd),'_pupil_diameter.tif']}];
        newFileNames=[{['NSP',num2str(instanceInd),'.ccf']} {['NSP',num2str(instanceInd),'.mat']} {['NSP',num2str(instanceInd),'.nev']} {['NSP',num2str(instanceInd),'.ns6']} {['NSP',num2str(instanceInd),'_aligned.ns6']} {['LFP_NSP',num2str(instanceInd),'.mat']} {['MUA_NSP',num2str(instanceInd),'.mat']} {['NSP',num2str(instanceInd),'_eye_position.tif']} {['NSP',num2str(instanceInd),'_NSch_eye_channels_position.mat']} {['NSP',num2str(instanceInd),'_pupil_diameter.tif']}];
        for fileType=1:length(fileNames)
            oriName=fullfile(topDir,fileNames{fileType});
            newFileName=fullfile(topDir,newFileNames{fileType});
            if exist(oriName,'file')
                movefile(oriName,newFileName);
            end
        end
    end
end 