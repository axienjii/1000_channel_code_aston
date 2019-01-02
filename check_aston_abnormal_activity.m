function check_aston_abnormal_activity
%Written by Xing on 5/11/18, to check raw signals after observation of
%unusual waveforms during 2-phosphene task (visual and microstim trials
%interleaved).

%check monitor port recording during current-thresholding task (microstim trials only):
date='211218_aston_test2';
instanceName='instance2';
sampFreq=30000;
instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
hold on
for channelInd=1:4%:length(neuronalChannels)
    readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%first minute of recording
    NSch{channelInd}=NSchOriginal.Data;
        plot(NSchOriginal.Data);
%     end
end

%check monitor port recording during current-thresholding task (microstim trials only):
date='211218_aston_test1';
instanceName='instance2';
sampFreq=30000;
instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
hold on
for channelInd=1:4%:length(neuronalChannels)
    readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%first minute of recording
    NSch{channelInd}=NSchOriginal.Data;
        plot(NSchOriginal.Data);
%     end
end

%check recording during current-thresholding task (microstim trials only):
date='201218_B2_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:1:120*30000');%first minute of recording
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during current-thresholding task (microstim trials only):
date='201218_B1_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:1:60*30000');%first minute of recording
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B4_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:10274863-3000000:10274863');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B7_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:13848145-3000000:13848145');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B6_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:19290365-3000000:19290365');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B5_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchNoRead=openNSx(instanceNS6FileName,readChannel,'noread');
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:13414320-3000000:13414320');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during motion task (microstim trials only):
date='291118_B10_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B7_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B6_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B5_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (microstim trials only):
date='211118_B4_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (visual trials only, but following current thresholding):
date='211118_B3_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during current thresholding:
date='211118_B2_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (visual and microstim trials interleaved):
date='081118_B18_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (visual and microstim trials interleaved):
date='081118_B17_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
for channelInd=[1:8:64]%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
figure;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during 2-phosphene task (visual and microstim trials interleaved):
date='051118_B2_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
for channelInd=64%check a V1 channel
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
figure;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

Fl=500;
N  = 2;    % filter order
Fn = Fs/2; % Nyquist frequency
[B, A] = butter(N,Fl/Fn,'high'); % compute filter coefficients
highfilt = filtfilt(B, A, double(NSchOriginal.Data));
plot(highfilt);

date='261018_B1_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end


%check monitor port signal:
instanceName='instance3';
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
for channelInd=128+9%copy of microstimulation signal from monitor port
    readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording prior to any stim:
date='280818_B1_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end
ez_powerspec(double(NSchOriginal.Data),sampFreq)

%check recording during 2-phosphene task (visual and microstim trials interleaved):
date='071118_B4_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during visual-only task:
date='071118_B1_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
    for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
    end
end

%check recording during visual-only task:
date='061118_B1_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
    for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
    end
end

date='061118_B7_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\aston_data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel),'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
    for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data((minuteCount-1)*sampFreq*60+1:minuteCount*sampFreq*60));
    end
end

date='051118_B3_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
    for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data((minuteCount-1)*sampFreq*60+1:minuteCount*sampFreq*60));
    end
end

date='051118_B2_aston';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['X:\aston\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['X:\aston\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
        plot(NSchOriginal.Data);%((minuteCount-1)*sampFreq*60+1:minuteCount*sampFreq*60));
%     end
end