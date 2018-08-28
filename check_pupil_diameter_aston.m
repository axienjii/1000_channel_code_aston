function check_pupil_diameter
%Written by Xing 25/7/17
%Read in data from analog input channels 129 and 130, and 131 and 132 on
%instance 1, to obtain eye position and pupil diameter, respectively.
date='250717_resting_state';
date='120717_resting_state';
date='090817_resting_state';
date='100817_resting_state';
saveEyeData=1;
instanceName='instance1';
eyeChannels=[131 132];%horizontal and vertical pupil diameter
instanceNS6FileName=['X:\best\',date,'\',instanceName,'.ns6'];
if saveEyeData==1
    for channelInd=1:length(eyeChannels)
        readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
        NSchOriginal=openNSx(instanceNS6FileName,'read',readChannel);
        NSch{channelInd}=NSchOriginal.Data;
    end
    save(['X:\best\',date,'\',instanceName,'_NSch_eye_channels_pupil_diameter.mat'],'NSch');
else
    load(['X:\best\',date,'\',instanceName,'_NSch_eye_channels_pupil_diameter.mat'],'NSch');
end

figure;
subplot(2,6,1:6);
plot(NSch{1});
title('Pupil diameter X')
subplot(2,6,7:12);
plot(NSch{2});
title('Pupil diameter Y')
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pathname=fullfile('X:\best',date,[instanceName,'_pupil_diameter']);
print(pathname,'-dtiff');

%Plot eye position
eyeChannels=[129 130];%X and Y position
instanceNS6FileName=['X:\best\',date,'\',instanceName,'.ns6'];
if saveEyeData==1
    for channelInd=1:length(eyeChannels)
        readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
        NSchOriginal=openNSx(instanceNS6FileName,'read',readChannel);
        NSch{channelInd}=NSchOriginal.Data;
    end
    save(['X:\best\',date,'\',instanceName,'_NSch_eye_channels_position.mat'],'NSch');
else
    load(['X:\best\',date,'\',instanceName,'_NSch_eye_channels_position.mat'],'NSch');
end

figure;
subplot(2,6,1:6);
plot(NSch{1});
title('X position')
subplot(2,6,7:12);
plot(NSch{2});
title('Y position')
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pathname=fullfile('X:\best',date,[instanceName,'_eye_position']);
print(pathname,'-dtiff');