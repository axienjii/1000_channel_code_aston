% stimulator = cerestim96();
% my_devices = stimulator.scanForDevices;
% stimulator. selectDevice(3);

% selectDevice method, Selects a CereStim 96 Stimulator out of all the stimulators plugged
% into the computer
% Format: cerestim_object.selectDevice(index)
% Inputs:
% index: The stimulator index according to the list of serial numbers
% obtained from cerestim96.scanForDevices() call


%% 

clear all; 
close all;
clc;

%%
clc
%Create stimulator object
stimulator = cerestim96()

my_devices = stimulator.scanForDevices
pause(.3)
stimulator. selectDevice(5); 
% the number inside the brackets is the stimulator instance number

pause(.5)
%Connect to the stimulator
stimulator.connect; 