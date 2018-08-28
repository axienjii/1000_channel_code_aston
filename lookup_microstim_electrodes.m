function [electrode RFx RFy array instance SNR impedance]=lookup_microstim_electrodes(date,electrodeInd)
%Written by Xing 27/7/17. Takes data of recording session and electrode
%index as input arguments, and looks up and returns the identity and other properties
%of that electrode.
switch date
    case '200717_B7'
        switch electrodeInd
            case 1
                electrode=34;
                RFx=101.4;
                RFy=-87.2;
                array=13;
                instance=7;
                %candidate channels for simultaneous stimulation and recording:
                % instance 7, array 13, electrode 34: RF x, RF y, size (pix), size (dva):
                %[101.373182692835,-87.1965720730945,30.6314285392835,1.18450541719806]
                SNR=20.7;
                impedance=13;
                %record from 25, 26, 27
            case 2
                electrode=35;
                RFx=101.4;
                RFy=-86.9;
                array=13;
                instance=7;
                % instance 7, array 13, electrode 35: RF x, RF y, size (pix), size (dva):
                %[101.419820931771,-86.8574476383865,38.9826040277579,1.50744212233355]
                SNR=20.8;
                impedance=13;
                %record from 26, 27, 28
            case 3
                electrode=38;
                RFx=37.6;
                RFy=-44.1;
                array=1;
                instance=1;
                SNR=6.5;
                impedance=38;
            case 4
                electrode=36;
                RFx=40.5;
                RFy=-44.7;
                array=1;
                instance=1;
                SNR=12;
                impedance=58;
            case 5
                electrode=37;
                RFx=112.9;
                RFy=-71.3;
                array=13;
                instance=7;
                SNR=23.5;impedance=33;
            case 6
                electrode=38;
                RFx=112.9;
                RFy=-71.3;
                array=13;
                instance=7;
                SNR=23.6;
                impedance=33;
            case 7
                electrode=27;
                RFx=120.9;
                RFy=-130.7;
                array=9;
                instance=5;
                SNR=8.3;
                impedance=43;
            case 8
                electrode=26;
                RFx=119.7;
                RFy=-114.9;
                array=9;
                instance=5;
                SNR=8.6;
                impedance=52;
            case 9
                electrode=37;
                RFx=31.6;
                RFy=-63.3;
                array=1;
                instance=1;
                SNR=6.1;
                impedance=40;
            case 10
                electrode=34;
                RFx=27.5;
                RFy=-22.4;
                array=1;
                instance=1;
                SNR=2.0;
                impedance=43;
        end
    
    case '210717_B4'
        switch electrodeInd
            case 1
                electrode=34;
                RFx=101.4;
                RFy=-87.2;
                array=13;
                instance=7;
                SNR=20.7;
                impedance=13;
                %record from 25, 26, 27
            case 2
                electrode=35;
                RFx=101.4;
                RFy=-86.9;
                array=13;
                instance=7;
                SNR=20.8;
                impedance=13;
                %record from 26, 27, 28
            case 3
                electrode=38;
                RFx=37.6;
                RFy=-44.1;
                array=1;
                instance=1;
                SNR=6.5;
                impedance=38;
            case 4
                electrode=36;
                RFx=40.5;
                RFy=-44.7;
                array=1;
                instance=1;
                SNR=12;
                impedance=58;
            case 5
                electrode=37;
                RFx=112.9;
                RFy=-71.3;
                array=13;
                instance=7;
                SNR=23.5;impedance=33;
            case 6
                electrode=38;
                RFx=112.9;
                RFy=-71.3;
                array=13;
                instance=7;
                SNR=23.6;
                impedance=33;
            case 7
                electrode=27;
                RFx=120.9;
                RFy=-130.7;
                array=9;
                instance=5;
                SNR=8.3;
                impedance=43;
            case 8
                electrode=26;
                RFx=119.7;
                RFy=-114.9;
                array=9;
                instance=5;
                SNR=8.6;
                impedance=52;
            case 9
                electrode=37;
                RFx=31.6;
                RFy=-63.3;
                array=1;
                instance=1;
                SNR=6.1;
                impedance=40;
            case 10
                electrode=34;
                RFx=27.5;
                RFy=-22.4;
                array=1;
                instance=1;
                SNR=2.0;
                impedance=43;
            case 11
                electrode=101-64;
                RFx=133.7;
                RFy=-114.2;
                array=10;
                instance=6;
                SNR=20.6;
                impedance=43; 
                TargWinSz = 4;               
            case 12
                electrode=112-64;
                RFx=150.4;
                RFy=-103.0;
                array=10;
                instance=6;
                SNR=35.4;
                impedance=27;  
                TargWinSz = 4;                  
            case 13
                electrode=120-64;
                RFx=166.2;
                RFy=-96.4;
                array=10;
                instance=6;
                SNR=20.2;
                impedance=33;  
                TargWinSz = 4;                    
            case 14
                electrode=121-64;
                RFx=88.4;
                RFy=-133.5;
                array=10;
                instance=6;
                SNR=5.1;
                impedance=27; 
                TargWinSz = 4;    
        end
    
    case '240717_B2'
        switch electrodeInd
            case 1
                electrode=58;
                RFx=119.7;
                RFy=-114.9;
                array=10;
                instance=5;
                SNR=8.6;
                impedance=23;
            case 2
                electrode=39;
                RFx=107.5;
                RFy=-92.5;
                array=10;
                instance=5;
                SNR=24;
                impedance=27;
            case 3
                electrode=48;
                RFx=120.5;
                RFy=-96.1;
                array=10;
                instance=5;
                SNR=26;
                impedance=27;
            case 4
                electrode=57;
                RFx=113.2;
                RFy=-120.2;
                array=10;
                instance=5;
                SNR=22;
                impedance=27;
            case 5
                electrode=59;
                RFx=120.9;
                RFy=-130.7;
                array=10;
                instance=5;
                SNR=8;
                impedance=29;
            case 6
                electrode=56;
                RFx=126.2;
                RFy=-96.3;
                array=10;
                instance=5;
                SNR=27;
                impedance=33;
        end
        
    case '250717_B2'
        switch electrodeInd
            case 1
                electrode=40;
                RFx=6.1;
                RFy=-57.6;
                array=12;
                instance=6;
                SNR=27;
                impedance=11;
            case 2
                electrode=23;
                RFx=55.9;
                RFy=-71.0;
                array=12;
                instance=6;
                SNR=15;
                impedance=12;
            case 3
                electrode=39;
                RFx=16.3;
                RFy=-55.4;
                array=12;
                instance=6;
                SNR=22;
                impedance=12;
            case 4
                electrode=59;
                RFx=41.3;
                RFy=-76.5;
                array=12;
                instance=6;
                SNR=10;
                impedance=12;
            case 5
                electrode=21;
                RFx=12.9;
                RFy=-71.2;
                array=12;
                instance=6;
                SNR=3;
                impedance=13;
            case 6
                electrode=41;
                RFx=29.6;
                RFy=-73.4;
                array=12;
                instance=6;
                SNR=9;
                impedance=13;
            case 7
                electrode=6;
                RFx=126.2;
                RFy=-96.3;
                array=12;
                instance=6;
                SNR=4;
                impedance=16;
        end
        
    case '260717_B3' 
        switch electrodeInd
            case 1
                electrode=40;
                RFx=6.1;
                RFy=-57.6;
                array=12;
                instance=6;
                SNR=27;
                impedance=11;
            case 2
                electrode=23;
                RFx=55.9;
                RFy=-71.0;
                array=12;
                instance=6;
                SNR=15;
                impedance=12;
            case 3
                electrode=39;
                RFx=16.3;
                RFy=-55.4;
                array=12;
                instance=6;
                SNR=22;
                impedance=12;
            case 4
                electrode=59;
                RFx=41.3;
                RFy=-76.5;
                array=12;
                instance=6;
                SNR=10;
                impedance=12;
            case 5
                electrode=21;
                RFx=12.9;
                RFy=-71.2;
                array=12;
                instance=6;
                SNR=3;
                impedance=13;
            case 6
                electrode=41;
                RFx=29.6;
                RFy=-73.4;
                array=12;
                instance=6;
                SNR=9;
                impedance=13;
            case 7
                electrode=6;
                RFx=126.2;
                RFy=-96.3;
                array=12;
                instance=6;
                SNR=4;
                impedance=16;
        end
        
    case '080817_B7'
        array=10;
        load(['D:\data\',date,'\',date,'_data\impedance_array',num2str(array),'.mat']);
        eval(['arrayRFs=array',num2str(array),';']);
        electrode=arrayRFs(electrodeInd,8);
        RFx=arrayRFs(electrodeInd,1);
        RFy=arrayRFs(electrodeInd,2);
        instance=ceil(array/2);
        SNR=arrayRFs(electrodeInd,5);
        impedance=arrayRFs(electrodeInd,6);
        
    case '090817_B8'
        array=10;
        array=12;
        load(['D:\data\',date,'\',date,'_data\impedance_array',num2str(array),'.mat']);
        eval(['arrayRFs=array',num2str(array),';']);
        electrode=arrayRFs(electrodeInd,8);
        RFx=arrayRFs(electrodeInd,1);
        RFy=arrayRFs(electrodeInd,2);
        instance=ceil(array/2);
        SNR=arrayRFs(electrodeInd,5);
        impedance=arrayRFs(electrodeInd,6);
        
    case '200917_B2'       
        load('Y:\Xing\200917_data\currentThresholdChs.mat'); 
        array=goodArrays8to16(electrodeInd,7);       
        electrode=goodArrays8to16(electrodeInd,8);
        RFx=goodArrays8to16(electrodeInd,1);
        RFy=goodArrays8to16(electrodeInd,2);
        instance=ceil(array/2);
        SNR=goodArrays8to16(electrodeInd,5);
        impedance=goodArrays8to16(electrodeInd,6);
end