function [LFP] = GetLFP(RawData,RawDataSampleRate,LFPparameters)
%Modified from Feng's code, GetMUAeLFP, on 7/8/18, by Xing.
% RawData must be in 2D matrix, time x trial format

% parameters
LFPsamplerate = LFPparameters.LFPsamplingrate;
LFPlowpassFreq = LFPparameters.LFPlowpassFreq;

% RawDataSampleRate = 30000;
LFPsupersamplingRatio = lcm(RawDataSampleRate, LFPsamplerate) / RawDataSampleRate;
LFPdownsamplingRatio = RawDataSampleRate * LFPsupersamplingRatio / LFPsamplerate;

% build filter

% low pass 150Hz
Fl = LFPlowpassFreq;
Fn = RawDataSampleRate/2;
N = 2;
[BLFP, ALFP] = butter(N,Fl/Fn,'low'); % LFP low pass

% band stop 50Hz
Fn = RawDataSampleRate/2;
Fbp=[49,51];
N  = 2;    % filter order
[Bbs, Abs] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % Bandstop

% band stop filtering 50Hz
BSdata = filtfilt(Bbs, Abs, RawData);

% LFP filtering
LFPdata = filtfilt(BLFP, ALFP, BSdata);

% LFP supersampling
if LFPsupersamplingRatio > 1
    datalength = size(LFPdata,1);
    x = 1:datalength;
    xx = 1:(1/LFPsupersamplingRatio):datalength;
    LFPdata = spline(x, LFPdata, xx);
end

% LFP downsampling
LFPdata = downsample(LFPdata,LFPdownsamplingRatio);
    
LFP.data = LFPdata;
LFP.LFPsamplerate = LFPsamplerate;
LFP.LFPlowpassFreq = LFPlowpassFreq;