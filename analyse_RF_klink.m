function analyse_RF_klink
%29/5/17
%Written by Xing. Extracts MUA data from raw .NS6 file, during presentation
%of sweeping white bar stimuli for RF mapping.
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
% date='020818_B2';
date='070818_B2';
processRaw=1;
if processRaw==1
    for instanceInd=1:4
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
        NS=openNSx(instanceNS6FileName);%200 s
        % NS=openNSx('t:1:6000000');%200 s
        sampFreq=NS.MetaTags.SamplingFreq;
        channelData={};
        for channelInd=1:NS.MetaTags.ChannelCount
            channelData{channelInd}=NS.Data(channelInd,:);
        end
        
        %extract MUA for each channel and trial:
        channelDataMUA=[];
        channelDataLFP=[];
        for channelInd=1:NS.MetaTags.ChannelCount
            S=double(channelData{channelInd}');
            %MAKE MUAe
            %Bandpassed, rectified and low-passed data
            %================================================
            Fs=30000;%sampling frequency
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
            muafilt = filtfilt(B, A, dum2);
            %Downsample
            downsampleFreq=30;
            muafilt = downsample(muafilt,downsampleFreq); % apply filter to the data and downsample
            
            %Kill the first sample to get rid of artifact
            muafilt = muafilt(2:end);
            
            %50Hz removal
            FsD = Fs/downsampleFreq;
            Fn = FsD/2; % Downsampled Nyquist frequency
            for v = [50 100 150];
                Fbp = [v-2,v+2];
                [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
                muafilt = filtfilt(Blp, Alp, muafilt);
            end
            
            %remove outlying samples of MUA
            %         dumz = abs((muafilt-mean(muafilt))./std(muafilt));
            %         muafilt(dumz>4) = NaN;
            
            %Baseline correct and store
            %Find background MUAe activity
            MUA = muafilt;
            
            %Assign to vargpout
            channelDataMUA{channelInd}=MUA;
            
            %obtain LFP
            LFPparameters.LFPsamplingrate = 500; % Hz
            LFPparameters.LFPlowpassFreq = 150; % Hz
            
            LFP=GetLFP(S,Fs,LFPparameters);%modified from Feng's GetMUAeLFP script, to generate only LFP
            channelDataLFP{channelInd}=LFP;
        end
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'.mat']);
        save(fileName,'channelDataMUA');   
        fileName=fullfile('D:\data',date,['LFP_',instanceName,'.mat']);
        save(fileName,'channelDataLFP');        
    end
end
