function generate_processed_resting_state(date,allInstanceInd)
%Written by Xing 24/8/17
%Load resting state data, extract MUA, LFP, and EEG, and save new processed data files.
% date='180717_resting_state';
% date='200717_resting_state';
% date='210717_resting_state';
% date='260717_resting_state';
% date='250717_resting_state';
% date='090817_resting_state';
% date='100817_resting_state';
topDir='X:\best';
for instanceInd=allInstanceInd    
    instanceName=['instance',num2str(instanceInd)];
    alignedInstanceNS6FileName=fullfile(topDir,date,[instanceName,'_aligned.ns6']);
    NS=openNSx(alignedInstanceNS6FileName,'read');
    
    channelDataMUA=[];
    channelDataLFP=[];
    channelDataEEG=[];
    for channelInd=1:128
        S=double(NS.Data(channelInd,:)');
        Fs=30000;%sampling frequency
        
        %================================================
        %generate MUA for each channel:
        %Bandpassed, rectified, low-passed, and downsampled data
        %BANDPASS
        Fbp=[500,9000];
        N  = 2;    % filter order
        Fn = Fs/2; % Nyquist frequency
        [B, A] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn]); % compute filter coefficients
        dum1 = filtfilt(B, A, S); % apply filter to the data
        %RECTIFY
        dum2 = abs(dum1);
        %LOW-PASS
        Fl=200;
        N  = 2;    % filter order
        Fn = Fs/2; % Nyquist frequency
        [B, A] = butter(N,Fl/Fn,'low'); % compute filter coefficients
        muafilt1 = filtfilt(B, A, dum2);
        %Downsample
        downsampleFactorMUA=30;
        muafilt2 = downsample(muafilt1,downsampleFactorMUA); % apply filter to the data and downsample
        %Remove the first sample to get rid of artifact
        muafilt3 = muafilt2(2:end);
        %50Hz removal
        FsD = Fs/downsampleFactorMUA;
        Fn = FsD/2; % Downsampled Nyquist frequency
        for v = [50 100 150];
            Fbp = [v-2,v+2];
            [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
            MUA = filtfilt(Blp, Alp, muafilt3);
        end
        %remove outlying samples of MUA
        %         dumz = abs((muafilt-mean(muafilt))./std(muafilt));
        %         muafilt(dumz>4) = NaN;
        channelDataMUA(channelInd,:)=MUA;
        
        %================================================
        %generate LFP for each channel:
        LFPparameters.LFPsamplingrate = 500; % Hz
        LFPparameters.LFPlowpassFreq = 150; % Hz
        LFP=GetLFP(S,Fs,LFPparameters);
        channelDataLFP(channelInd,:)=LFP.data(2:end);%Remove the first sample to keep the number of samples consistent with EEG data
        
        %================================================
        %generate EEG for each channel:
        %filter from 0-200 Hz
        %LOW-PASS
        Fl=200;
        N  = 2;    % filter order
        Fn = Fs/2; % Nyquist frequency
        [B, A] = butter(N,Fl/Fn,'low'); % compute filter coefficients
        eegfilt = filtfilt(B, A, S);
        %Downsample to 500 Hz
        downsampleFactorEEG=Fs/500;
        eegfilt = downsample(eegfilt,downsampleFactorEEG); % apply filter to the data and downsample
        %Remove the first sample to get rid of artifact
        eegfilt = eegfilt(2:end);
        %50Hz removal
        FsD = Fs/downsampleFactorEEG;
        Fn = FsD/2; % Downsampled Nyquist frequency
        for v = [50 100 150];
            Fbp = [v-2,v+2];
            [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
            EEG = filtfilt(Blp, Alp, eegfilt);
        end
        channelDataEEG(channelInd,:)=EEG;
    end
    fileNameMUA=fullfile(topDir,date,['MUA_',instanceName,'.mat']);
    save(fileNameMUA,'channelDataMUA');
    fileNameLFP=fullfile(topDir,date,['LFP_',instanceName,'.mat']);
    save(fileNameLFP,'channelDataLFP');
    fileNameEEG=fullfile(topDir,date,['EEG_',instanceName,'.mat']);
    save(fileNameEEG,'channelDataEEG');
    pause(20)
    clear NS
end
