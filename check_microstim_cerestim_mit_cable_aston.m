function check_microstim_cerestim_mit_cable_aston
%Written by Xing 9/11/18
%Check monitor port output to ensure that microstimulation waveforms during
%recording session look as expected.
arrays=8:16;
monitorPorts=[1 5 9 1 5 9 1 5 9];%analog input channel on which monitor port signal is recorded (for first stimulated channel on a particular CereStim), for each array
instancesMonitorPorts=[2 2 2 3 3 3 4 4 4];%instance on which monitor port signal is recorded, for each array
date='091118_B7_aston';
stimArrays=[8 12 14 16];
figure;hold on
for arrayInd=1:length(stimArrays)
    array=stimArrays(arrayInd);
    arrayCol=find(arrays==array);%column index of array of interest
    instanceInd=instancesMonitorPorts(arrayCol);
    monitorPortInd=monitorPorts(arrayCol);
    instanceName=['instance',num2str(instanceInd)];
    instanceNS6FileName=['D:\aston_data\',date,'\',instanceName,'.ns6'];
    if instanceInd==3%raw neuronal signals recorded on 128 analog input chs
        monitorPortInd=128+monitorPortInd;%analog input channel
    end
    instanceNEVFileName=['D:\aston_data\',date,'\',instanceName,'.nev'];
    NEV=openNEV(instanceNEVFileName);
    startInd=find(NEV.Data.SerialDigitalIO.UnparsedData==49);
    startInd=startInd(1);
    
    readChannel=['c:',num2str(monitorPortInd),':',num2str(monitorPortInd)];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);
    NSch{channelInd}=NSchOriginal.Data;
    plot(NSchOriginal.Data(NEV.Data.SerialDigitalIO.TimeStamp(startInd):end));
end
legend(stimArrays);

%test bipolar stimulation, also record 5-volt reference signal to estimate
%amplitude
date='280917_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
eyeChannels=142:144;%analog input 14 to 16
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:));
hold on;plot(NSch(2,:),'r');
plot(NSch(3,:),'g');

%test second electrode, temporal delay of 1.65 ms for start of train
date='280917_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
eyeChannels=142;%analog input 14 to 16
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:));
ylimits=get(gca,'ylim');
plot([139026 139026],ylimits,'k:');

%test second electrode, temporal delay of 10 ms for start of train
date='280917_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
eyeChannels=142;%analog input 14 to 16
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:));
ylimits=get(gca,'ylim');
plot([20249 20249],ylimits,'k:');
plot([93099 93099],ylimits,'k:');
plot([165681 165681],ylimits,'k:');

%test first electrode, no temporal delay for start of train
date='280917_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
eyeChannels=142;%analog input 14 to 16
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:));
ylimits=get(gca,'ylim');
stimBTimestamps=[1 9 17 25];
for i=1:length(stimBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i))],ylimits,'r:');
end

%test second electrode, no temporal delay for start of train
date='280917_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
eyeChannels=142;%analog input 14 to 16
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:));
ylimits=get(gca,'ylim');
StimB=1;
stimBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^StimB);
for i=1:length(stimBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i))],ylimits,'r:');
end
%get cursor x coordinates manually
(cursor_info2.Position(1) - cursor_info1.Position(1))/30000

%test first electrode, check sync pulses on analog inputs 1 and 12 (14295
%and 14293, respectively)
date='280917_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14275)
plot(NSch(1,:));
ylimits=get(gca,'ylim');
StimB=1;
stimBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^StimB);
for i=1:length(stimBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i))],ylimits,'r:');
end
%get cursor x coordinates manually
(cursor_info2.Position(1) - cursor_info1.Position(1))/30000
%analog input 12 (Cerestim 14293)
plot(NSch(12,:),'m');
%analog input 14 (electrode 1)
plot(NSch(14,:),'c');

%test second electrode, check sync pulses on analog inputs 1 and 12 (14295
%and 14293, respectively)
date='280917_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14275)
plot(NSch(1,:));
ylimits=get(gca,'ylim');
StimB=1;
stimBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^StimB);
for i=1:length(stimBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimBTimestamps(i))],ylimits,'r:');
end
%get cursor x coordinates manually
(cursor_info2.Position(1) - cursor_info1.Position(1))/30000
%analog input 12 (Cerestim 14293)
plot(NSch(12,:),'m');
%analog input 14 (electrode 1)
plot(NSch(14,:),'c');

%test electrode, check timing of trigger pulse on analog input 16 and
%stimulation waveform on electrode 1, analog input 1 (14293)
%Delivered current at 20 uA, and resistor has impedance of ~40-50 kOhms.
%Hence expected voltage in each phase is 0.8V, matches amplitude of each
%phase in recorded data (around 0.7V).
date='290917_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14275)
plot(NSch(1,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
plot(NSch(16,:),'m');%plot signal on analog input 16, which measures 4.6V in the current recording

%Delivered current at 100 uA, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). Did this to avoid saturation of the NSP recording
%system, allowing us to measure amplitude of waveform for delivery of higher currents.
%Amplitude of individual phase is ~2.3V, expected amplitude is around 2.5V
%(100 uA x 23.2 kOhms = 2.3V).
date='290917_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14275)
plot(NSch(1,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
plot(NSch(16,:),'m');%plot signal on analog input 16, which measures 4.6V in the current recording
ylimits=get(gca,'ylim');
amplitudeOnePhase=(ylimits(2)-ylimits(1))/2%12605 data points
ylimits=get(gca,'ylim');
amplitudeRef=ylimits(2)-ylimits(1)%25210 data points
4.6/25210*12605%2.3V

%Delivered current at 200 uA, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). Did this to avoid saturation of the NSP recording
%system, allowing us to measure amplitude of waveform for delivery of higher currents.
%Amplitude of individual phase is , expected amplitude is around 2.5V
%(200 uA x 23.2 kOhms = 4.6V).
date='290917_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14275)
plot(NSch(1,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
plot(NSch(16,:),'m');%plot signal on analog input 16, which measures 4.6V in the current recording
amplitudeOnePhase=(max(double(NSch(1,:)))-min(double(NSch(1,:))))/2%16384 data points
amplitudeRef=max(double(NSch(16,:)))-min(double(NSch(16,:)))%31056 data points
4.6*amplitudeOnePhase/amplitudeRef%3.7V

%Used wait(10) to add 10-ms temporal delay to train of pulses on second CereStim.
%Delivered current at two different amplitudes, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). 
date='290917_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(1,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
(cursor_info1.Position(1) - cursor_info2.Position(1))/30000

%Used wait(0) to add 0-ms temporal delay to train of pulses on second CereStim.
%Delivered current at two different amplitudes, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). Also recorded sync pulse output from 14293, on
%analog input 12.
date='290917_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
%pulse is sent 20 ms after trigger, i.e. wait(0) results in delay of 20 ms.

%Used wait(10) to add 10-ms temporal delay to train of pulses on second CereStim.
%Delivered current at two different amplitudes, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). Also recorded sync pulse output from 14293, on
%analog input 12.
date='290917_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 30 ms after trigger, i.e. wait(10) results in delay of 30 ms.

%Used wait(20) to add 20-ms temporal delay to train of pulses on second CereStim.
%Delivered current at two different amplitudes, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). Also recorded sync pulse output from 14293, on
%analog input 12.
date='290917_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 20 ms after trigger, i.e. wait(20) results in delay of 20 ms.

%Used wait(50) to add 50-ms temporal delay to train of pulses on second CereStim.
%Delivered current at two different amplitudes, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). Also recorded sync pulse output from 14293, on
%analog input 12.
date='290917_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 54 ms after trigger, i.e. wait(50) results in delay of 54 ms.

%Used wait(100) to add 100-ms temporal delay to train of pulses on second CereStim.
%Delivered current at two different amplitudes, and resistor has impedance of ~40-50 kOhms,
%but circuit is modified such that the current flows across two resistors
%instead of one, thereby halving the voltage recorded (or effectively
%halving the resistance). Also recorded sync pulse output from 14293, on
%analog input 12.
date='290917_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 116 ms after trigger, i.e. wait(100) results in delay of 116 ms.

%Used wait(100) to add 100-ms temporal delay to train of pulses on second CereStim.
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform1';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 116 ms after trigger, i.e. wait(100) results in delay of 116 ms.

%Used wait(0) to add 0-ms temporal delay to train of pulses on second CereStim.
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform2';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 20 ms after trigger, i.e. wait(0) results in delay of 20 ms.

%Used Stim Manager to send pulse on CereStim 14293.
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform4';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent immediately after trigger, i.e. when Stim Manager used, no
%delay occurs when when wait command is not used.

%Used Stim Manager to send pulse on CereStim 14293. Wait(0).
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform5';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 16 ms after trigger, i.e. wait(0) results in delay of 16 ms when Stim Manager is used.

%Used Stim Manager to send pulse on CereStim 14293. Wait(100).
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform6';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info3.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 116 ms after trigger, i.e. wait(100) results in delay of 116 ms when Stim Manager is used.

%Used Stim Manager to send pulse on CereStim 14293. Wait(20).
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform7';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
%analog input 1 (Cerestim 14273)
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info3.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 20 ms after trigger, i.e. wait(20) results in delay of 20 ms when Stim Manager is used.

%Used Matlab code to send pulse on CereStim 14293. No wait() command used.
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform8';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent immediately after trigger, i.e. no wait() results in no delay of 20 ms when Matlab script is used.

%Used Matlab code to send pulse on CereStim 14293. Wait(0) command used.
%Recorded sync pulse output from 14293, on
%analog input 13.
date='031017_test_microstim_waveform9';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(129,:),'b');
plot(NSch(144,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(141,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 20 ms after trigger, i.e. wait(0) results in delay of 20 ms when Matlab code is used.

%Used Matlab code to send pulse on CereStim 14177 (the CereStim that was
%sent back to BR and that Saman reprogrammed). No wait() command used. 
%Recorded sync pulse output from 14177, on analog input 13.
date='041017_test_microstim_waveform1';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(13,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=65344;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent immediately after trigger, i.e. when CereStim 14177 is used and no wait() function present, the stimulation occurs with a slight delay of 100 us.

%Used Matlab code to send pulse on CereStim 14177 (the CereStim that was
%sent back to BR and that Saman reprogrammed). Wait(0) command used. 
%Recorded sync pulse output from 14177, on analog input 13.
date='041017_test_microstim_waveform2';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(13,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=65344;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 0.1 ms after trigger, i.e. when CereStim 14177 is used and wait(0) function present, the stimulation occurs very quickly, with a slight delay of 100 us.

%Used Matlab code to send pulse on CereStim 14177 (the CereStim that was
%sent back to BR and that Saman reprogrammed). Wait(10) command used. 
%Recorded sync pulse output from 14177, on analog input 13.
date='041017_test_microstim_waveform3';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(13,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=65344;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 10.1 ms after trigger, i.e. when CereStim 14177 is used and wait(10) function present, the stimulation occurs at correct time, with a slight delay of 100 us.

%Used Matlab code to send pulse on CereStim 14177 (the CereStim that was
%sent back to BR and that Saman reprogrammed). Wait(50) command used. 
%Recorded sync pulse output from 14177, on analog input 13.
date='041017_test_microstim_waveform4';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(13,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=65344;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 50.2 ms after trigger, i.e. when CereStim 14177 is used and wait(50) function present, the stimulation occurs at correct time, with a slight delay of 200 us.

%Used Matlab code to send pulse on CereStim 14177 (the CereStim that was
%sent back to BR and that Saman reprogrammed). Wait(100) command used. 
%Recorded sync pulse output from 14177, on analog input 13.
date='041017_test_microstim_waveform5';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(13,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=65344;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%pulse is sent 100.3 ms after trigger, i.e. when CereStim 14177 is used and wait(100) function present, the stimulation occurs at correct time, with a slight delay of 300 us.

%Used Matlab code to send pulse on CereStim 14177 (the CereStim that was
%sent back to BR and that Saman reprogrammed), minus the first pairs of 'trigger' pulses. No wait() command used. 
%Recorded sync pulse output from 14177, on analog input 13.
date='041017_test_microstim_waveform6';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(13,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=65344;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used Matlab code to send pulse on CereStim 14293 (the CereStim that was
%sent back to BR and that Saman reprogrammed), minus the first pairs of 'trigger' pulses. No wait() command used. 
%Recorded sync pulse output from 14177, on analog input 13.
date='041017_test_microstim_waveform7';
instanceInd=2;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(16,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(13,:),'c');%plot signal on analog input 13, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=65344;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used Matlab code to send pulse on CereStim 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=1 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 8 and 51 on array 10. Connected modified MIT cable
%to bank B of CereStim (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 51 (51 - 32 = 19), i.e.
%connected acoss resistor number 19. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim on analog input
%7, and copy of trigger pulse on analog input 16.
%Recorded sync pulse output from 14173, on analog input 7.
%Note that voltage reached saturation slightly.
date='051017_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used Matlab code to send pulse on CereStim 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=1 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 8 and 51 on array 10. Connected modified MIT cable
%to bank A of CereStim (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 8, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim on analog input
%7, and copy of trigger pulse on analog input 16.
%Recorded sync pulse output from 14173, on analog input 7.
%Note that voltage reached saturation slightly.
date='051017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used Matlab code to send pulse on CereStims 14176 & 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=1 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 49 and 51 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14176 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 49, i.e.
%connected acoss resistor number 17. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim on analog input
%7, and copy of trigger pulse on analog input 16.
%Recorded sync pulse output from 14176, on analog input 10.
date='051017_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 10, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0002 s = 0.2 ms = 200 us

%Used Matlab code to send pulse on CereStims 14176 & 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=1 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 49 and 51 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 51, i.e.
%connected acoss resistor number 19. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim on analog input
%7, and copy of trigger pulse on analog input 16.
%Recorded sync pulse output from 14173, on analog input 7.
date='051017_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0006 s = 0.6 ms = 600 us

%Used Matlab code to send pulse on CereStims 14176 & 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=2 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 49 and 8 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank A of CereStim 14173 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 8, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim on analog input
%7, and copy of trigger pulse on analog input 16.
%Recorded sync pulse output from 14173, on analog input 7.
date='051017_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0006 s = 0.6 ms = 600 us

%Used Matlab code to send pulse on CereStims 14176 & 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=2 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 49 and 8 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14176 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 49, i.e.
%connected acoss resistor number 17. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim on analog input
%10, and copy of trigger pulse on analog input 16.
%Recorded sync pulse output from 14176, on analog input 10.
date='051017_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0006 s = 0.6 ms = 600 us

%Used Matlab code to send pulse on CereStims 14176 & 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=2 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 49 and 8 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank A of CereStim 14173 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 8, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 16.
date='051017_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0006 s = 0.6 ms = 600 us

%Used Matlab code to send pulse on CereStims 14176 & 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=2 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 49 and 8 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14176 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 37, i.e.
%connected acoss resistor number 5. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14176 on analog input
%10, and copy of trigger pulse on analog input 16.
date='051017_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0006 s = 0.6 ms = 600 us

%Used Matlab code to send pulse on CereStims 14176 & 14173, using runstim_microstim_saccade_catch25.m code.
%Checked condiiton: LRorTB=2 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 49 and 8 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 51, i.e.
%connected acoss resistor number 19. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14176 on analog input
%7, and copy of trigger pulse on analog input 16.
date='051017_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0006 s = 0.6 ms = 600 us

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14175 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=1 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 29 and 40 on arrays 12 and 10 respectively. Connected modified MIT cable
%to bank A of CereStim 14176 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 29, i.e.
%connected acoss resistor number 29. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14175 on analog input
%7, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14175 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=1 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 29 and 40 on arrays 12 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0054 s = 5.4 ms

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14175 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=1 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 38 and 40 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0056 s = 5.6 ms

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14175 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=1 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 38 and 40 on arrays 13 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14176 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 38, i.e.
%connected acoss resistor number 6. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14176 on analog input
%10, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0051 s = 5.1 ms

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14175 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=2 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 38 and 29 on arrays 13 and 12 respectively. Connected modified MIT cable
%to bank B of CereStim 14176 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 38, i.e.
%connected acoss resistor number 6. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14176 on analog input
%10, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0072 s = 7.2 ms

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14175 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=2 & targetLocation=1, where microstimulation
%supposed to be sent on electrodes 38 and 29 on arrays 13 and 12 respectively. Connected modified MIT cable
%to bank A of CereStim 14175 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 29, i.e.
%connected acoss resistor number 29. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14175 on analog input
%9, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0095 s = 9.5 ms

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14293 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=2 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 62 and 40 on arrays 15 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14175 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 62, i.e.
%connected acoss resistor number 30. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0008 s = 0.8 ms

%Used Matlab code to send pulse on new set of 4 electrodes.
%CereStims 14293 & 14173, using runstim_microstim_saccade_catch27.m code.
%Checked condiiton: LRorTB=2 & targetLocation=2, where microstimulation
%supposed to be sent on electrodes 62 and 40 on arrays 15 and 10 respectively. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%12, and copy of trigger pulse on analog input 16.
date='061017_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0005 s = 0.5 ms

%Used Matlab code to send pulse on test pair of electrodes, on same CereStim, with wait(50).
%CereStim 14293, using runstim_microstim_test_waveform3.m code. 10 pulses.
%anodic first on one electrode, cathodic first on the other.
%Connected normal MIT cable to Y adaptor on NSS, and connected CerePlex M
%to Y adapter, sending input to instance 1.
%Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14.
date='101017_test_microstim_waveform';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0005 s = 0.5 ms

%Used Matlab code to send pulse on test pair of electrodes, on same CereStim, with wait(50).
%CereStim 14293, using runstim_microstim_test_waveform3.m code. 1 pulse.
%Connected normal MIT cable to Y adaptor on NSS, and connected CerePlex M
%to Y adapter, sending input to instance 1.
%Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14.
date='101017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0032 s = 3.2 ms?

%Used Matlab code to send pulse on test pair of electrodes, on same CereStim, with wait(200).
%CereStim 14293, using runstim_microstim_test_waveform3.m code. 1 pulse.
%Connected normal MIT cable to Y adaptor on NSS, and connected CerePlex M
%to Y adapter, sending input to instance 1.
%Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14.
date='101017_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(1,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0033 s = 3.3 ms?

%Used Matlab code to send pulse on test pair of electrodes, on same CereStim.
%CereStim 14294, using runstim_microstim_saccade_catch31.m code. 
%Microstimulation sent on electrodes 45 and 32 on array 14. Connected modified MIT cable
%to bank A of CereStim 14294 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 32, i.e.
%connected acoss resistor number 32. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14294 on analog input
%14, and copy of trigger pulse on analog input 14.
date='161017_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 11, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0033 s = 3.3 ms?

%Used Matlab code to send pulse on test pair of electrodes, on same CereStim.
%CereStim 14294, using runstim_microstim_saccade_catch31.m code. 
%Microstimulation sent on electrodes 45 and 32 on array 14. Connected modified MIT cable
%to bank B of CereStim 14294 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 45, i.e.
%connected acoss resistor number 13. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14294 on analog input
%14, and copy of trigger pulse on analog input 14.
date='161017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(2,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 16, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 11, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0033 s = 3.3 ms?

%Used Matlab code to send pulse with wait(0) on CereStim with newly upgraded firmware (v5.4).
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait.m code. 
%Microstimulation sent on electrode 1 on array 15. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14.
date='191017_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(3,:),'b');
plot(NSch(2,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0107 s = 10.7 ms
stimOnset=diff(NSch(1,:)>1000);
stimOnset=find(stimOnset==1);
triggerTimes=NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps);
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end

%Used Matlab code to send pulse with wait(1) on CereStim with newly upgraded firmware (v5.4).
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait.m code. 
%Microstimulation sent on electrode 1 on array 15. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14.
date='191017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(3,:),'b');
plot(NSch(2,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0115 s = 11.5 ms
stimOnset=diff(NSch(1,:)>1000);
stimOnset=find(stimOnset==1);
triggerTimes=NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps);

%Used Matlab code to send pulse with wait(10) on CereStim with newly upgraded firmware (v5.4).
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait.m code. 
%Microstimulation sent on electrode 1 on array 15. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14.
date='191017_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(3,:),'b');
plot(NSch(2,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0211 s = 21.1 ms
stimOnset=diff(NSch(1,:)>1000);
stimOnset=find(stimOnset==1);
triggerTimes=NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps);
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration = 0.0202    0.0206    0.0206    0.0211    0.0210

%Used Matlab code to send pulses on CereStims with newly upgraded firmware (v5.4).
%CereStim 14173, using runstim_microstim_saccade_catch32.m code. 
%Microstimulation sent on electrode 57 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 57, i.e.
%connected acoss resistor number 5. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14.
date='191017_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(3,:),'b');
plot(NSch(2,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used Matlab code to send pulses on CereStims with newly upgraded firmware (v5.4).
%CereStim 14173, using runstim_microstim_saccade_catch32.m code. 
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 51, i.e.
%connected acoss resistor number 19. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14.
date='191017_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(3,:),'b');
plot(NSch(2,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0216 s = 21.6 ms

%Used Matlab code to send pulses with wait(10) on CereStim with newly upgraded firmware (v5.4) after motherboard reprogramming.
%CereStim 14177 (same as the one that was sent back to Saman), using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14177 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0308 s = 30.8 ms
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerTimes=NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps);
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end

%Used Matlab code to send pulses with wait(0) on CereStim with newly upgraded firmware (v5.4) after motherboard reprogramming.
%CereStim 14177 (same as the one that was sent back to Saman), using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14177 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0237 s = 23.7 ms
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerTimes=NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps);
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration = 0.0202    0.0237    0.0218    0.0262    0.0237    0.0248    0.0301    0.0226    0.0117    0.0214    0.0125 0.0219

%Used Matlab code to send pulses with wait(0) on CereStim 14305, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14177 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delay: 0.0237 s = 23.7 ms
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerTimes=NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps);
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) after motherboard reprogramming.
%CereStim 14177 (same as the one that was sent back to Saman), using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14177 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) after motherboard reprogramming.
%CereStim 14305, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(0).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14305 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%consistent delay, of 0.1003 s

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) after motherboard reprogramming.
%CereStim 14305, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(1).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14305 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =    0.0011    0.0011    0.0011    0.0011    0.0011    0.0011    0.0011    0.0011

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) after motherboard reprogramming.
%CereStim 14305, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(5).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14305 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =    0.0051    0.0051    0.0051    0.0051    0.0051    0.0051    0.0051

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) after motherboard reprogramming.
%CereStim 14305, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(10).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14305 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) without motherboard reprogramming.
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(10).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) without motherboard reprogramming.
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(0).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =    1.0e-04 *    0.6667    0.6667    0.6667    0.6667    0.6667    0.6667    0.6667

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) without motherboard reprogramming.
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(1).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =    0.0011    0.0011    0.0011    0.0011    0.0010

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) without motherboard reprogramming.
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(5).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform12';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =    0.0051    0.0051    0.0051    0.0051    0.0051    0.0051    0.0051

%Used Matlab code to send pulses with Saman's script on CereStim with newly upgraded firmware (v5.4) without motherboard reprogramming.
%CereStim 14293, using runstim_microstim_saccade_catch22_test_wait2.m code. 
%Added a pause of 1 before sending of 'real' trigger pulse. Used wait(10).
%Microstimulation sent on electrode 51 on array 10. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14177 on analog input
%12, and copy of trigger pulse on analog input 14.
date='251017_test_microstim_waveform13';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(4,:),'b');
plot(NSch(3,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(2,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(2,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(3,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101    0.0101

%Used Matlab code to send pulses with script that incorporates Saman's testMultiCerestim script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 1 on each of 9 arrays. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e. 
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent two fake trigger pulses,
%followed by two real trigger pulses (as one was not enough).
date='281017_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333    0.3333
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with script that incorporates Saman's testMultiCerestim script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 1 on each of 9 arrays. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent 30 pairs of real
%trigger pulses, obtained 59 (instead of 60) trains, as the first pulse was
%ineffective.
date='281017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with script that incorporates Saman's testMultiCerestim script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 1 on each of 9 arrays. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent 3 pairs of real
%trigger pulses, obtained 5 (instead of 6) trains, as the first pulse was
%ineffective.
date='281017_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with script that incorporates Saman's testMultiCerestim script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 1 on each of 9 arrays. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent 3 real
%trigger pulses with pause of >2 s between each trigger, obtained 2 (instead of 3) trains, as the first pulse was
%ineffective.
date='281017_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with script that incorporates Saman's testMultiCerestim script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 1 on each of 9 arrays. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent 3 real
%trigger pulses with pause of >2 s between each trigger, and 0.2 ms pause after setting bit to high, obtained 2 (instead of 3) trains, as the first pulse was
%ineffective.
date='281017_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with script that incorporates Saman's testMultiCerestim script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 1 on each of 9 arrays. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent 3 real
%trigger pulses with pause of 15 s between 1st and second trigger, and 0.2 ms pause after setting bit to high, obtained 2 (instead of 3) trains, as the first pulse was
%ineffective.
date='281017_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with script that incorporates Saman's testMultiCerestim script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 1 on each of 9 arrays. Connected modified MIT cable
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent 3 fake trigger pulses, then 10-s pause, followed by 3 real
%trigger pulses with pause of 15 s between 1st and second trigger, and 0.2 ms pause after setting bit to high, obtained 2 (instead of 3) trains, as the first pulse was
%ineffective.
date='281017_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, followed by 2 real
%trigger pulses.
date='311017_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%need two pulses to trigger a real pulse, even if a pair of fake trigger
%pulses are present

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%sometimes first pulse is effective, sometimes it is second pulse

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    triggerOnset(i)=triggerTimes(temp(end));
    plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
    delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667
%sometimes first pulse is effective, sometimes it is second pulse

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14293 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 63, i.e.
%connected acoss resistor number 21. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%12, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(12,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
date='311017_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 12, which shows sync pulse from second CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   1.0e-04 *  0.3333   or  0.6667

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
%Correct line of code that executed wait function 
date='311017_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from first CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(7,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   0.1504    0.1504    0.1504 on second Cerestim (14293)

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on electrode 63 on each of array 15, and electrode 40 on array 10. Connected modified MIT cable
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
%Correct line of code that executed wait function 
date='311017_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from first CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   1.0e-04 *    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333 
%on first Cerestim (14173)

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes: electrode 63 on each of array 15
%(twice), electrode 46 on array 15, electrode 38 on aray 13, and electrode
%40 on array 10 (i.e. 5 pulses in total). Connected modified MIT cable  
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
%Correct line of code that executed wait function 
date='311017_test_microstim_waveform12';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from second CereStim
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from first CereStim
plot(NSch(10,:),'g');%plot signal on analog input 12, which shows sync pulse from first CereStim
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   Columns 1 through 12
%          0    0.0000    0.2290    0.9802    0.0000    0.2324    0.9836    0.0000    0.2401    0.9913    0.0000    0.2397
%   Columns 13 through 24
%     0.9909    0.0000    0.2285    0.9797    0.0000    0.2305    0.9817    0.0000    0.2304    0.9816    0.0000    0.2396
%   Columns 25 through 36
%     0.9908    0.0000    0.2386    0.9898    0.0001    0.2435    0.9947    0.0000    0.2336    0.9848    0.0001    0.2377
%   Columns 37 through 48
%     0.9889    0.0000    0.2375    0.9887    0.0000    0.2291    0.9803    0.0000    0.2335    0.9847    0.0000    0.2378
%   Columns 49 through 50
%     0.9890    0.0000
%on Cerestim 14293)

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes: electrode 63 on each of array 15
%(twice), electrode 46 on array 15, electrode 38 on aray 13, and electrode
%40 on array 10 (i.e. 5 pulses in total). Connected modified MIT cable  
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
%Correct line of code that executed wait function 
date='311017_test_microstim_waveform13';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   Columns 1 through 12

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes: electrode 63 on each of array 15
%(twice), electrode 46 on array 15, electrode 38 on aray 13, and electrode
%40 on array 10 (i.e. 5 pulses in total). Connected modified MIT cable  
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
%Correct line of code that executed wait function 
date='311017_test_microstim_waveform14';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   Columns 1 through 12

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes: electrode 63 on each of array 15
%(twice), electrode 46 on array 15, electrode 38 on aray 13, and electrode
%40 on array 10 (i.e. 5 pulses in total). Connected modified MIT cable  
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
%No pause in between first sending of microB
date='311017_test_microstim_waveform15';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   Columns 1 through 12

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes: electrode 63 on each of array 15
%(three times), electrode 38 on aray 13, and electrode
%40 on array 10 (i.e. 5 pulses in total). Connected modified MIT cable  
%to bank B of CereStim 14173 (i.e. channels 33 to 64) and connected probe across
%45-kOhm resister corresponding to channel 40, i.e.
%connected acoss resistor number 8. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent no fake trigger pulses, 2 real
%trigger pulses.
%No pause in between first sending of microB
date='311017_test_microstim_waveform16';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   Columns 1 through 12

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(300).
date='011117_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   Columns 1 through 12
%     0.3312    0.3300    0.3278    0.3276    0.3284    0.3313    0.3261    0.3269    0.3296    0.3255    0.3274    0.3312
%   Columns 13 through 24
%     0.3270    0.3308    0.3237    0.3274    0.3303    0.3301    0.3299    0.3298    0.3275    0.3284    0.3282    0.3300
%   Columns 25 through 36
%     0.3238    0.3286    0.3295    0.3253    0.3280    0.3289    0.3298    0.3276    0.3314    0.3312    0.3291    0.3268
%   Column 37
%     0.3307

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(600).
date='011117_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   0.6315    0.6624    0.6292    0.6634    0.6301    0.6634    0.6308    0.6634    0.6287    0.6584    0.6335
%   Columns 13 through 24
%     0.6654    0.6273    0.6624    0.6261    0.6624    0.6309    0.6624    0.6316    0.6624    0.6295    0.6594    0.6303
%   Columns 25 through 36
%     0.6614    0.6300    0.6644    0.6319    0.6624

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(450).
date='011117_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   0.4799    0.4768    0.4786    0.4794

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(150).
date='011117_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   0.1796    0.1774    0.1793    0.1792    0.1800    0.1778    0.1806    0.1803

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(10).
date='011117_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   0.0388    0.0346    0.0385    0.0393    0.0401    0.0360    0.0407    0.0385    0.0363

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 14293 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14293 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(5).
date='011117_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   0.0349    0.0308    0.0346    0.0355    0.0322    0.0341    0.0349

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14173
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 14173 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 14173 on analog input
%7, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(5).
date='011117_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14173
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(5).
date='011117_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration =   

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14173
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. Wait(5). Removed pause(1) before real trigger
date='011117_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =   0.0156

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14173
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. No wait function. Used pause(1) before real trigger
date='011117_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =   0.0156

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulses, 1 real
%trigger pulses. No wait function. Used pause(1) before real trigger
date='011117_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =   0.025-0.29

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 1 fake trigger pulse, 1 real
%trigger pulses. No wait function. Used pause(2) before real trigger
date='011117_test_microstim_waveform12';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =   0.024-0.029

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 2 real
%trigger pulses. No wait function. Used pause(2) before real trigger
date='011117_test_microstim_waveform13';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =   0.013-0.028

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes: electrode 1 on 14293
%and electrode 2 on 65494. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. No wait function. Used pause(1) before real trigger
date='011117_test_microstim_waveform14';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    0.0157    0.0251    0.0119    0.0229    0.0158    0.0257    0.0176    0.0275    0.0144    0.0263    0.0142    0.0251
%   Columns 13 through 17
%     0.0130    0.0279    0.0138    0.0277    0.0166

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. 
date='011117_test_microstim_waveform15';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 10, 13, 15, 16. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. 
date='011117_test_microstim_waveform16';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    


%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. 
date='011117_test_microstim_waveform15';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 8, 13, 15. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. 
date='011117_test_microstim_waveform17';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 8, 13, 15. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used when initial
%connections were made to the stimulators.
date='011117_test_microstim_waveform18';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in my_devices list.
date='011117_test_microstim_waveform19';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 10, 13, 15, 16. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in my_devices list.
date='011117_test_microstim_waveform20';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 10, 13, 15, 16. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 16, 10.
date='011117_test_microstim_waveform21';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 12, 13, 15, 16. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 16, 12.
date='011117_test_microstim_waveform22';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 12, 13, 15, 16. Connected modified MIT cable  
%to bank A of CereStim 65494 (i.e. channels 1 to 32) and connected probe across
%45-kOhm resister corresponding to channel 1, i.e.
%connected acoss resistor number 1. Sent output via BNC cable to analog
%input 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 12, 16.
date='011117_test_microstim_waveform23';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 12, 13, 15, 16. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 12, 16.
date='031117_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'c');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration = 1.0e-04 *    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333

%Used Matlab code to send pulses with early draft of direction of motion script, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 12, 13, 15, 16. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 2 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 12, 16. Used wait()
%function to set each electrode such that 
date='031117_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'c');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration = 1.0e-04 *    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 12, 13, 15, 16. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 12, 16. Used wait()
%function to set each electrode such that start of each train was 150 ms
%offset relative to the other.
date='031117_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'c');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
%delayDuration = 0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 12, 13, 15, 16. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 12, 16. No wait()
%function used. 
date='031117_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'c');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration = 1.0e-04 *    0.3333    0.3333    0.3333    0.3333    0.3333    0.6667    0.6667    0.6667    0.3333

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 5 electrodes, on arrays 8, 12, 13, 15, 16. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15, 12, 16. Wait()
%function used. 
date='031117_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'c');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration = 

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. 
date='031117_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'c');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration = 0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes, on arrays 9, 10, 15, 12. Simultaneously recorded sync pulse from CereStim 65494 on analog input
%11, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15, 12. Wait()
%function used. 
date='031117_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration = 
%on alternating trials, train on 4th CereStim occurs 0.5258 or ~0.42 s too early.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, and 15 (to two
%electrodes on 15). Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 15. Wait()
%function used. 
date='031117_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration = 
%on alternating trials, train on 4th CereStim occurs 0.5258 or 0.4214 s too early.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 13, 8, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 15. Wait()
%function used. 
date='061117_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(10,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    1.0e-04 *    0.3333    0.3333    0.6667    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333
%delayDuration = 0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504
%delayDuration = 0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. 
date='061117_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    1.0e-04 *    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.6667
%delayDuration = 0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504
%delayDuration = 0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007

%Upgraded CereStim firmware to v5.5, beta. Connected each of 4 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 12, 15. Wait()
%function used. 
date='061117_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    1.0e-04 *    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.3333    0.6667
%delayDuration = 0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504    0.1504
%delayDuration = 0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007    0.3007

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. 
date='061117_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 4th occurs at wrong time on alternating trials. Also, for
%1st trial, stimulation on 4th CereStim occurs an extra time, before
%triggering of CereStim.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 4 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 12, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim.
date='061117_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 4th CereStim occurs twice on each trial, before
%triggering of CereStim.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 4 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 12, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
date='061117_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 4th CereStim occurs twice on each trial, before
%triggering of CereStim.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 4 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 12, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
date='061117_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 4th CereStim occurs twice on each trial, before
%triggering of CereStim.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 4 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 12, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse.
date='061117_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 4th CereStim occurs twice on each trial, before
%triggering of CereStim.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse.
date='061117_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 4th CereStim occurs twice on each trial, before
%triggering of CereStim.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
date='061117_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'g');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 4th CereStim occurs twice on each trial, before
%triggering of CereStim.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 8, 12, 13. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 12, 8. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
date='081117_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 8, 12, 13. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 8, 12. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
date='081117_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial, and triggering on
%2nd CereStim occurred once before trigger pulse.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
date='081117_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial, and triggering on
%2nd CereStim occurred once before trigger pulse.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) right after setting of waveform parameters.
date='081117_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial, and triggering on
%2nd CereStim occurred once before trigger pulse.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) right after enabling of trigger.
date='081117_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) at the end of send_stim_multiple_cerestims.m function.
date='081117_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent no dasbit(Par.StimB).
date='081117_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) at beginning of trial (after 5-s pause between end of pre-trial and start of trial).
date='081117_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) at end of pre-trial (before 5-s pause).
date='081117_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) near to end of pre-trial (before 5-s pause and setting of control window).
date='081117_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) near to end of send_stim_multiple_cerestims.m function.
date='081117_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) near to end of send_stim_multiple_cerestims.m function, before pause(0.1) and stimulator.isConnected function.
date='081117_test_microstim_waveform12';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) near to end of send_stim_multiple_cerestims.m function, after stimulator.isConnected function.
date='081117_test_microstim_waveform13';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) after send_stim_multiple_cerestims.m function.
date='081117_test_microstim_waveform14';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) after setting of control window.
date='081117_test_microstim_waveform15';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) at end of send_stim_multiple_cerestims.m function, after stimulator.isConnected().
date='081117_test_microstim_waveform16';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) after send_stim_multiple_cerestims.m function.
date='081117_test_microstim_waveform17';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) just before setting of target window.
date='081117_test_microstim_waveform18';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) in between setting of distractor windows.
date='081117_test_microstim_waveform19';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) after setting of distractor windows.
date='081117_test_microstim_waveform20';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta. Connected each of 3 CereStims to
%different USB ports on PC.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Added dasbit (Par.StimB, value of 1) to indicate time at
%which stimulation parameters were set for each CereStim. Added Nick
%Halper's stimulator.getSequenceStatus loop where possible, to try to
%ensure that comands are not sent while CereStim is busy.
%Added a pause of 0.1 ms to each command invloving the stimulator object.
%Added a pause of 5 s in between setting of stimulation parameters and
%sending of trigger pulse, as well as at end of trial.
%Sent dasbit(Par.StimB) after setting of distractor windows.
date='081117_test_microstim_waveform21';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Increased number of pulses to 45.
date='081117_test_microstim_waveform23';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on 3rd CereStim occurs twice on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 1 electrode, on array 9. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Increased number of pulses to 45.
date='081117_test_microstim_waveform24';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes, on arrays 9, 10. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Increased number of pulses to 45.
%Recorded stimualtion signal on electrode 9 of array 9 (i.e. channel 9
%from Bank A of CereStim 65372, array 9).
date='081117_test_microstim_waveform25';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes, on arrays 9, 10. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Increased number of pulses to 45.
%Recorded stimualtion signal on electrode 48 of array 10 (i.e. channel 16
%from Bank B of CereStim 14173, array 10).
date='081117_test_microstim_waveform26';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Increased number of pulses to 45.
%Recorded stimualtion signal on electrode 48 of array 10 (i.e. channel 16
%from Bank B of CereStim 14173, array 10).
date='081117_test_microstim_waveform27';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 9, 10, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 9, 10, 15. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Increased number of pulses to 45.
%Recorded stimualtion signal on electrode 15 of array 15 (i.e. channel 15
%from Bank A of CereStim 65493, array 15).
date='081117_test_microstim_waveform28';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes, on arrays 13, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 15. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes, on arrays 13, 15. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 15, 13. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes, on arrays 13, 10. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes, on arrays 13, 10. Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 2 electrodes, on arrays 13, 10. 
%Swapped CereStim 14295 (previously for array 8) with 14173 (previously array 10). 
%Had tried 14177 and 14305 in place of 14173, and none of the 3 worked.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. 
%Used CereStims 14295, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 10, 13, 15. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs once on each trial.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. 
%Used CereStims 14295, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.
%But not if CereStims used stimulated in opposite order.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. Turned
%equipment off and on again.
%Used CereStims 14295, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 15, 13, 10 or 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. Turned
%equipment off and on again. Swapped USB cables between arrays 10 and 13.
%Made no difference.
%Used CereStims 14295, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 15, 13, 10 or 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. Turned
%equipment off and on again. Swapped USB cables between arrays 10 and 13.
%This time, never used 14295 as last CereStim, only either 1st or 2nd.
%Used CereStims 14295, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays is: array 15, 13, 10 or 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. Turned
%equipment off and on again. 
%Used CereStims 14177, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. 
%Used CereStims 14177, 14176, and 14293. Swapped 14177 and 14176
%(previously corresponded to arrays 10 and 13 respectively, now correspond
%to 13 and 10, respectively).
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform12';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.

%Edited code so create separate stimulator objects with completely distinct
%names, in Matlab script.
%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. 
%Used CereStims 14177, 14176, and 14293. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform13';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 10, 13, 15. 
%Used CereStims 14177, 14176, and 14293. Longer recording, to check.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. Sent 0 fake trigger pulses, 1 real
%trigger pulses. wait function. Arranged setting of stimulator parameters
%such that the order in which the CereStims were set matched the order used in stimulatorNums list.
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Wait()
%function used. Used version of code that is close to finalized, without
%extra pauses. Number of pulses was 45.
date='091117_test_microstim_waveform14';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%stimulation on CereStim occurs twice for array 10 (CereStim 14295), if it is the 3rd CereStim.

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 3 or 4 electrodes, on arrays 10, 11,12, 13, 15. 
%Used CereStims 14177, 14175, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Number of pulses was 45.
%On some trials, stimulation delivered to 3 electrodes on 3 CereStims (10, 13, 15),
%whereas on other trials, stimulation delivered to 4 electrodes on 3
%CereStims (11, 12, 13). Forgot to use 'beginGroup' and 'endGroup'
%functions. Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
date='271117_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 3 or 4 electrodes, on arrays 10, 11,12, 13, 15. 
%Used CereStims 14177, 14175, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Number of pulses was 45.
%On some trials, stimulation delivered to 3 electrodes on 3 CereStims (10, 13, 15),
%whereas on other trials, stimulation delivered to 4 electrodes on 3
%CereStims (11, 12, 13). Forgot to use 'beginGroup' and 'endGroup'
%functions. Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
date='271117_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 3 or 4 electrodes, on arrays 10, 11,12, 13, 15. 
%Used CereStims 14177, 14175, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Number of pulses was 45.
%On some trials, stimulation delivered to 3 electrodes on 3 CereStims (10, 13, 15),
%whereas on other trials, stimulation delivered to 4 electrodes on 3
%CereStims (11, 12, 13). Used 'beginGroup' and 'endGroup' functions.
%Stimulation works correctly! Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
date='271117_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 or 4 electrodes, on arrays 10, 11,12, 13, 15. 
%Used CereStims 14177, 14175, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 15, 13, 10 or 15, 13, 10. Number of pulses was 45.
%On some trials, stimulation delivered to 3 electrodes on 3 CereStims (10, 13, 15),
%whereas on other trials, stimulation delivered to 4 electrodes on 3
%CereStims (11, 12, 13). Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Stimulation works correctly!
date='271117_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    0.0219    0.0243    0.0268    0.3240    0.0227    0.0210    0.3231    0.0249    0.0234

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes, on arrays 10, 13, 15. 
%Used CereStims 14177, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 15, 13, 10, 10 or 10, 10, 13, 15. Number of pulses was 45.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Did not used beginGroup and endGroup functions.
date='271117_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    0.0219    0.0243    0.0268    0.3240    0.0227    0.0210    0.3231    0.0249    0.0234

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes, on arrays 10, 13, 15. 
%Used CereStims 14177, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 15, 13, 10, 10 or 10, 10, 13, 15. Number of pulses was 45.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Used beginGroup and endGroup functions after calling wait function.
date='271117_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    0.0219    0.0243    0.0268    0.3240    0.0227    0.0210    0.3231    0.0249    0.0234

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes, on arrays 10, 12, 13, 15. 
%Used CereStims 14177, 14175, 14176, and 14293.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 15, 13, 12, 10, or 10, 12, 13, 15. Number of pulses was 45.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Used beginGroup and endGroup functions after calling wait function.
date='271117_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%delayDuration =    0.0152    0.0151    0.4683    0.4673    0.4676    0.0169    0.4674

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 3 electrodes, on arrays 11, 12, 13. 
%Used CereStims 14174, 14175, 14176.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 12, 13, 11, or 11, 13, 12. Number of pulses was 45.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='281117_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes, on arrays 11, 12, 13. 
%Used CereStims 14174, 14175, 14176.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 12, 13, 11, 11, or 11, 11, 13, 12. Number of pulses was 45.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='281117_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_motion2.m code. 
%Microstimulation sent on 4 electrodes, on arrays 11, 12, 13. 
%Used CereStims 14174, 14175, 14176.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Order of electrodes on arrays was: array 12, 11, 13, 11, or 11, 13, 11, 12. Number of pulses was 45.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='281117_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on arrays 11, 12, 13, or 10, 13, 15. 
%Used CereStims 14177, 14174, 14175, 14176, 14294.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Did not use wait function, pulses supposed to be sent simultaneously across all electrodes and CereStims. 
%Number of pulses was 50.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='051217_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on arrays 11, 12, 13, or 10, 13, 15. 
%Used CereStims 14177, 14174, 14175, 14176, 14294.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Use wait function, with delay of 1 ms between channels. 
%Number of pulses was 50.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='061217_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on arrays 11, 12, 13, or 10, 13, 15. 
%Used CereStims 14177, 14174, 14175, 14176, 14294.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Use wait function, with delay of 1 ms between channels. 
%Number of pulses was 50.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='061217_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info2.Position(1) - cursor_info3.Position(1))/30000
%1 ms between onset of train of pulses on one conditions (e.g. second trial), but 3 ms on other condition (e.g. first
%trial)

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on arrays 11, 12, 13, or 10, 13, 15. 
%Used CereStims 14177, 14174, 14175, 14176, 14294.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Use wait function, with delay of 0.4 ms between channels. 
%Number of pulses was 50.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='061217_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info2.Position(1) - cursor_info3.Position(1))/30000
%0 ms between onset of train of pulses (instead of 0.4 ms)

%Upgraded CereStim firmware to v5.5, beta.
%Used Matlab code to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on arrays 11, 12, 13, or 10, 13, 15. 
%Used CereStims 14177, 14174, 14175, 14176, 14294.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Use wait function, with delay of 0.5 ms between channels. 
%Number of pulses was 50.
%Moved disableTrigger function to end of trial, as it was
%previously called right after sending of microB trigger.
%Adjusted use of wait function within send_stim_multiple_CereStims.m code:
%if more than one electrode was to be stimulated on a given CereStim, then
%a wait function should only be used for the second electrode on that
%CereStim if the second electrode on that CereStim did not immediately
%follow the first electrode on that CereStim.
%Do not use beginGroup and endGroup functions.
date='061217_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(15,:),'b');
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info2.Position(1) - cursor_info3.Position(1))/30000
%1.0 or 1.1 ms between onset of train of some pulses (instead of 0.5 ms)

%Upgraded CereStim firmware to v5.5, beta.
%Used Stim Manager to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 1 electrode, on array 8. 
%Used CereStims 14295.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, for each of the fake and real trains.
date='081217_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info2.Position(1) - cursor_info3.Position(1))/30000
%1.0 or 1.1 ms between onset of train of some pulses (instead of 0.5 ms)

%Upgraded CereStim firmware to v5.5, beta.
%Used Stim Manager to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 1 electrode, on array 8. 
%Used CereStims 14295.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1 for the fake train and 50 for the real train.
date='081217_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info2.Position(1) - cursor_info3.Position(1))/30000
%1.0 or 1.1 ms between onset of train of some pulses (instead of 0.5 ms)

%Upgraded CereStim firmware to v5.5, beta.
%Used Stim Manager to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 1 electrode, on array 8. 
%Used CereStims 14295.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1 for the fake train and 50 for the real train.
date='081217_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info2.Position(1) - cursor_info3.Position(1))/30000
%1.0 or 1.1 ms between onset of train of some pulses (instead of 0.5 ms)

%Upgraded CereStim firmware to v5.5, beta.
%Used Stim Manager to send pulses, using runstim_microstim_line.m code. 
%Microstimulation sent on 1 electrode, on array 8. 
%Used CereStims 14295.
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1 for the fake train and 50 for the real train.
date='111217_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
(cursor_info2.Position(1) - cursor_info3.Position(1))/30000
%1.0 or 1.1 ms between onset of train of some pulses (instead of 0.5 ms)

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 2209 Hz (the maximum possible).
date='131217_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 2209 Hz (the maximum possible).
date='131217_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 2209 Hz (the maximum possible).
date='131217_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 2209 Hz (the maximum possible).
date='131217_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 2209 Hz (the maximum possible).
date='131217_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 2209 Hz (the maximum possible).
date='131217_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 2209 Hz (the maximum possible).
date='131217_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 300 Hz.
date='131217_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%0.0034 s between pulses, i.e. 3.4 ms

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
date='131217_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform12';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform13';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform14';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform15';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform16';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 2, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform17';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 5, at 1200 Hz (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='131217_test_microstim_waveform18';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 50, at 1200 Hz? (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='141217_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 50, at 1200 Hz? (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='141217_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 1200 Hz? (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='141217_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 1200 Hz? (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='141217_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 1200 Hz? (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='141217_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 1200 Hz? (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='141217_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved.m to send pulses, within runstim_microstim_line.m code. 
%Microstimulation sent on 4 electrodes, on various arrays. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Used 'fake' pulse to introduce delay of 400 us before real stimulation pulse. 
%Number of pulses was 1, at 1200 Hz? (the frequency was chosen to distribute the pulses over the same time frame as they would be if they were not interleaved).
%Added wait() to stagger pulses across CereStims.
date='141217_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%3.5 ms between pulses on a given electrode

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
date='110118_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
date='110118_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Removed wait() functions to test effect. (Makes no difference.)
date='120118_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Called stimulator.play twice, doing 1 followed by 2. 
date='120118_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Called stimulator.play twice, explicitly doing 2 followed by 1. Results in
%reversal of order in unwanted stimulation delay between CereStims-
%previously, delay occurred on CereStim 13; now occurs on CereStim 12.
date='120118_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Called stimulator.play twice, explicitly doing 1 followed by 2, with a 1-second pause in between calls. Results in
date='120118_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%1.89 ms between start of pulses trains on two CereStims

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Called stimulator.play twice, explicitly doing 2 followed by 1, with a 1-second pause in between calls. Results in
date='120118_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
%1.86 ms between start of pulses trains on two CereStims

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used trigger pulse to initiate stimulation.
date='120118_test_microstim_waveform7';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Upgraded CereStim firmware to v5.5, beta.
%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Added wait() if needed, to offset pulse trains between pairs of electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used trigger pulse to initiate stimulation.
date='120118_test_microstim_waveform8';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used stimulator.play() to initiate stimulation.
date='120118_test_microstim_waveform9';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used stimulator.play() to initiate stimulation. Tested on different set of
%electrodes.
date='120118_test_microstim_waveform10';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Recorded copy of stimulation trains on electrode 20, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used trigger pulse to initiate stimulation.
date='120118_test_microstim_waveform11';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Recorded copy of stimulation trains on electrode 52, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used trigger pulse to initiate stimulation.
date='120118_test_microstim_waveform12';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Recorded copy of stimulation trains on electrode 52, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used trigger pulse to initiate stimulation.
date='120118_test_microstim_waveform13';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Recorded copy of stimulation trains on electrode 52, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used trigger pulse to initiate stimulation.
date='120118_test_microstim_waveform14';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Recorded copy of stimulation trains on electrode 52, CereStim 14175, via
%MIT cable, and sent to analog input 15.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform15';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform16';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'y');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
plot(NSch(11,:),'g');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform17';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform18';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
% plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50, at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform19';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50 (5 sets of 10), at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform20';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50 (2 sets of 25), at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform21';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50 (2 sets of 25), at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform22';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50 (10 sets of 5), at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform23';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used send_stim_multiple_cerestims_interleaved12.m to send pulses, within runstim_microstim_line_12patterns.m code. 
%Microstimulation sent on 4 electrodes, on various arrays, in pairs of electrodes. 
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 50 (10 sets of 5), at 300 Hz.
%Individual pulses on stimulation trains were interleaved between electrodes.
%Used trigger pulse to initiate stimulation. Interleave TB conditions, i.e.
%2 sets of 4 electrodes; each set varies from trial to trial.
date='120118_test_microstim_waveform24';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data;
figure;hold on
plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used runstim_microstim_test_waveform.m to send pulses. 
%Microstimulation sent on 1 electrode (electrode 1, i.e. bank A), to test whether signal is sent
%correctly via banks of Cerestim 65494 (previously named 14294).
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 32, at 300 Hz.
%Used stimulator.manual to initiate stimulation. 
date='190218_test_microstim_waveform1';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
% plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used runstim_microstim_test_waveform.m to send pulses. 
%Microstimulation sent on 1 electrode (electrode 23, i.e. 23rd electrode on bank A), to test whether signal is sent
%correctly via banks of Cerestim 65494 (previously named 14294).
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 32, at 300 Hz.
%Used stimulator.manual to initiate stimulation. 
date='190218_test_microstim_waveform2';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
% plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used runstim_microstim_test_waveform.m to send pulses. 
%Microstimulation sent on 1 electrode (electrode 55, i.e. 23rd electrode on bank B), to test whether signal is sent
%correctly via banks of Cerestim 65494 (previously named 14294).
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 32, at 300 Hz.
%Used stimulator.manual to initiate stimulation. 
date='190218_test_microstim_waveform3';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
% plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used runstim_microstim_test_waveform.m to send pulses. 
%Microstimulation sent on 1 electrode (electrode 33, i.e. 1st electrode on bank B), to test whether signal is sent
%correctly via banks of Cerestim 65494 (previously named 14294).
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 32, at 300 Hz.
%Used stimulator.manual to initiate stimulation. 
date='190218_test_microstim_waveform4';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
% plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used runstim_microstim_test_waveform.m to send pulses. 
%Microstimulation sent on 1 electrode (electrode 65, i.e. 1st electrode on bank C), to test whether signal is sent
%correctly via banks of Cerestim 65494 (previously named 14294).
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 32, at 300 Hz.
%Used stimulator.manual to initiate stimulation. 
date='190218_test_microstim_waveform5';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
% plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000

%Used runstim_microstim_test_waveform.m to send pulses. 
%Microstimulation sent on 1 electrode (electrode 87, i.e. 23rd electrode on bank C), to test whether signal is sent
%correctly via banks of Cerestim 65494 (previously named 14294).
%Simultaneously recorded sync pulses from CereStims on
%analog inputs, and copy of trigger pulse on analog input 14. 
%Number of pulses was 32, at 300 Hz.
%Used stimulator.manual to initiate stimulation. 
date='190218_test_microstim_waveform6';
instanceInd=1;
instanceName=['instance',num2str(instanceInd)];
instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
NEV=openNEV(instanceNEVFileName);
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
NSchOriginal=openNSx(instanceNS6FileName);
NSch=NSchOriginal.Data{2};
figure;hold on
% plot(NSch(14,:),'m');%plot signal on analog input 14, indicates timing of dasbit for trigger
% plot(NSch(1,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14295 (array 8)
% plot(NSch(6,:),'y');%plot signal on analog input 1, which shows sync pulse from CereStim 14172 (array 9)
% plot(NSch(7,:),'c');%plot signal on analog input 7, which shows sync pulse from CereStim 14173 (array 10)
% plot(NSch(8,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14174 (array 11)
% plot(NSch(9,:),'r');%plot signal on analog input 9, which shows sync pulse from CereStim 14175 (array 12)
% plot(NSch(10,:),'g');%plot signal on analog input 10, which shows sync pulse from CereStim 14176 (array 13)
% plot(NSch(11,:),'r');%plot signal on analog input 11, which shows sync pulse from CereStim 65494 (array 14)
plot(NSch(12,:),'r');%plot signal on analog input 12, which shows sync pulse from CereStim 14293 (array 15)
% plot(NSch(13,:),'b');%plot signal on analog input 13, which shows sync pulse from CereStim 14138 (array 16)
plot(NSch(15,:),'b');
ylimits=get(gca,'ylim');
microB=6;
microBTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^microB);
for i=1:length(microBTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(microBTimestamps(i))],ylimits,'r:');
end
stimParamTimestamps=find(NEV.Data.SerialDigitalIO.UnparsedData==2^1);
for i=1:length(stimParamTimestamps)
    plot([NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i)) NEV.Data.SerialDigitalIO.TimeStamp(stimParamTimestamps(i))],ylimits,'b:');
end
stimOnset=diff(NSch(12,:)>1000);
stimOnset=find(stimOnset==1);
triggerOnset=diff(NSch(14,:)>1000);
triggerTimes=find(triggerOnset==1);
delayDuration=[];
for i=1:length(stimOnset)
    plot([stimOnset(i) stimOnset(i)],ylimits,'g:');
    temp=find(triggerTimes<stimOnset(i));
    if ~isempty(temp)
        triggerOnset(i)=triggerTimes(temp(end));
        plot([triggerOnset(i) triggerOnset(i)],ylimits,'k:');
        delayDuration(i)=double(stimOnset(i)-triggerOnset(i))/30000;
    end
end
(cursor_info.Position(1) - cursor_info2.Position(1))/30000
