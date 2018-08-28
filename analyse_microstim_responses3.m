function analyse_microstim_responses3
%Written by Xing 15/8/17 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end

date='150817_B9';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=1;%array 13, electrode 37 (g)
date='160817_B1';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=2;%array 13, electrode 37 (g)
date='160817_B2';arrayNumber=13;electrodeNumber=38;finalCurrentValsFile=2;%array 13, electrode 38 (g)
date='160817_B5';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=2;%array 13, electrode 41 (r)
date='160817_B6';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=2;%array 13, electrode 55 (r)
date='160817_B7';arrayNumber=13;electrodeNumber=56;finalCurrentValsFile=2;%array 13, electrode 56 (r)
date='160817_B8';arrayNumber=13;electrodeNumber=61;finalCurrentValsFile=2;%array 13, electrode 61 (r)
date='170817_B1';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=3; %(g)
date='170817_B3';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=3; %(g)
date='170817_B4';arrayNumber=13;electrodeNumber=56;finalCurrentValsFile=3; %(g)
date='170817_B5';arrayNumber=13;electrodeNumber=61;finalCurrentValsFile=3; %(g)
date='170817_B12';arrayNumber=10;electrodeNumber=56;finalCurrentValsFile=3; %(g)
date='170817_B18';arrayNumber=10;electrodeNumber=45;finalCurrentValsFile=3;
date='180817_B1';arrayNumber=10;electrodeNumber=48;finalCurrentValsFile=3;%.mat file from stimulus presentation computer corrupted- only 1 KB in size
date='180817_B2';arrayNumber=10;electrodeNumber=38;finalCurrentValsFile=3; %(g)
date='180817_B3';arrayNumber=10;electrodeNumber=47;finalCurrentValsFile=3; %(g)
date='180817_B4';arrayNumber=10;electrodeNumber=46;finalCurrentValsFile=3; %(g)
date='180817_B5';arrayNumber=10;electrodeNumber=39;finalCurrentValsFile=3; %(g)
date='180817_B6';arrayNumber=10;electrodeNumber=39;finalCurrentValsFile=3;
date='180817_B7';arrayNumber=10;electrodeNumber=45;finalCurrentValsFile=3; %(m)
date='180817_B8';arrayNumber=10;electrodeNumber=59;finalCurrentValsFile=4; %(g)
useFinalCurrentVals=1;

date='210817_B2';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=4; %(m?) 
% date='210817_B3';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=4; %(m?) 
% date='210817_B4';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=4; %(r) 
% date='210817_B6';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=5; %(m) 
% date='210817_B7';arrayNumber=12;electrodeNumber=24;finalCurrentValsFile=5; %   ?
% date='210817_B8';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=6; % 
% date='210817_B10';arrayNumber=12;electrodeNumber=5;finalCurrentValsFile=6; %(r) 
% date='210817_B11';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=6; %(r) 
% date='210817_B12';arrayNumber=12;electrodeNumber=39;finalCurrentValsFile=6; %(r) 
% date='210817_B13';arrayNumber=12;electrodeNumber=58;finalCurrentValsFile=6; %(r) 
% date='210817_B14';arrayNumber=12;electrodeNumber=59;finalCurrentValsFile=6; %(r) %and electrode 21?
% date='210817_B15';arrayNumber=12;electrodeNumber=59;finalCurrentValsFile=6; %(r) 
% date='210817_B16';arrayNumber=12;electrodeNumber=20;finalCurrentValsFile=6; %(g)
% date='210817_B17';arrayNumber=12;electrodeNumber=27;finalCurrentValsFile=6; %(g) 
% date='210817_B18';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=6; %(r) 
% date='210817_B19';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=6; %(r) 
% date='210817_B20';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=6; %(r) 
% date='210817_B21';arrayNumber=12;electrodeNumber=43;finalCurrentValsFile=6; %(m) 
useFinalCurrentVals=1;

date='220817_B1';arrayNumber=12;electrodeNumber=34;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B2';arrayNumber=12;electrodeNumber=36;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B4';arrayNumber=12;electrodeNumber=42;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B5';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=6; %(r) uses quest
% date='220817_B7';arrayNumber=12;electrodeNumber=12;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B10';arrayNumber=12;electrodeNumber=3;finalCurrentValsFile=6; %(m) uses quest
useFinalCurrentVals=0;

% date='220817_B26';arrayNumber=12;electrodeNumber=3;finalCurrentValsFile=6; %(g)
% date='220817_B30';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=6; %(r)
% date='220817_B31';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=6; %(r)
% date='220817_B33';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=6; %(r)
% date='220817_B34';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=6; %(m-g)
% date='220817_B37';arrayNumber=12;electrodeNumber=49;finalCurrentValsFile=6; %(g)
% date='220817_B39';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=6; %(m)
% useFinalCurrentVals=1;

% date='230817_B1';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=6; %(g)
% date='230817_B2';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='230817_B3';arrayNumber=12;electrodeNumber=24;finalCurrentValsFile=6; %(g)
% date='230817_B4';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=6; %(g)
% date='230817_B5';arrayNumber=12;electrodeNumber=5;finalCurrentValsFile=6; %(g)
% date='230817_B7';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=6; %(g)
% date='230817_B8';arrayNumber=12;electrodeNumber=39;finalCurrentValsFile=6; %(g)
% date='230817_B9';arrayNumber=12;electrodeNumber=58;finalCurrentValsFile=6; %(g)
% date='230817_B10';arrayNumber=12;electrodeNumber=59;finalCurrentValsFile=6; %(g)
% date='230817_B11';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=6; %(g)
% date='230817_B12';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=6; %(g)
% date='230817_B13';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=6; %(g)
% date='230817_B16';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=6; %(m)
% date='230817_B17';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=6; %(r)%can discard
% date='230817_B18';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=6; %(g)
% date='230817_B19';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=6; %(m)
% useFinalCurrentVals=1;

date='240817_B1';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=6; %(m)
date='240817_B2';arrayNumber=12;electrodeNumber=40;finalCurrentValsFile=6; %(m)
date='240817_B3';arrayNumber=12;electrodeNumber=21;finalCurrentValsFile=6; %(r)
date='240817_B4';arrayNumber=12;electrodeNumber=6;finalCurrentValsFile=6; %(r)
% date='240817_B5';arrayNumber=12;electrodeNumber=43;finalCurrentValsFile=6; %(g)
% date='240817_B6';arrayNumber=12;electrodeNumber=11;finalCurrentValsFile=6; %(g)
% date='240817_B7';arrayNumber=12;electrodeNumber=34;finalCurrentValsFile=6; %(g)
% date='240817_B8';arrayNumber=12;electrodeNumber=36;finalCurrentValsFile=6; %(g)
% date='240817_B9';arrayNumber=12;electrodeNumber=42;finalCurrentValsFile=6; %(g)
% date='240817_B10';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=6; %(r)
% date='240817_B11';arrayNumber=12;electrodeNumber=12;finalCurrentValsFile=6; %(g)
% date='240817_B12';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=6; %(m-g)
% date='240817_B13';arrayNumber=12;electrodeNumber=4;finalCurrentValsFile=6; %(r)
% date='240817_B15';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=6; %(g)
% date='240817_B16';arrayNumber=12;electrodeNumber=60;finalCurrentValsFile=6; %(r)
% date='240817_B17';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=6; %(g)
% date='240817_B18';arrayNumber=13;electrodeNumber=33;finalCurrentValsFile=6; %(g)
% date='240817_B19';arrayNumber=13;electrodeNumber=34;finalCurrentValsFile=6; %(m)
% date='240817_B20';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=6; %(g)
% date='240817_B21';arrayNumber=13;electrodeNumber=51;finalCurrentValsFile=6; %(g)
% date='240817_B22';arrayNumber=13;electrodeNumber=11;finalCurrentValsFile=6; %(g)
% date='240817_B23';arrayNumber=13;electrodeNumber=12;finalCurrentValsFile=6; %(g)
% date='240817_B24';arrayNumber=13;electrodeNumber=13;finalCurrentValsFile=6; %(r)
% date='240817_B25';arrayNumber=13;electrodeNumber=52;finalCurrentValsFile=6; %(m-g)
% date='240817_B26';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=6; %(m)
% date='240817_B27';arrayNumber=13;electrodeNumber=14;finalCurrentValsFile=6; %(r)
date='240817_B28';arrayNumber=11;electrodeNumber=3;finalCurrentValsFile=6; %(g) repeat with lower currents
date='240817_B29';arrayNumber=11;electrodeNumber=3;finalCurrentValsFile=6; %(g) repeat with lower currents
date='240817_B30';arrayNumber=11;electrodeNumber=3;finalCurrentValsFile=6; %(g) final
% date='240817_B31';arrayNumber=11;electrodeNumber=18;finalCurrentValsFile=6; %(g)
% date='240817_B32';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='240817_B33';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='240817_B36';arrayNumber=11;electrodeNumber=55;finalCurrentValsFile=6; %(m)
% date='240817_B38';arrayNumber=11;electrodeNumber=34;finalCurrentValsFile=6; %(r)
useFinalCurrentVals=1;

date='250817_B3';arrayNumber=12;electrodeNumber=6;finalCurrentValsFile=6; %(m)
% date='250817_B4';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='250817_B5';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=6; %(g)
date='250817_B6';arrayNumber=12;electrodeNumber=6;finalCurrentValsFile=6; %(r)
% date='250817_B7';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=6; %(r)
% date='250817_B8';arrayNumber=12;electrodeNumber=4;finalCurrentValsFile=6; %(r)
% date='250817_B9';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=6; %(g)
% date='250817_B10';arrayNumber=12;electrodeNumber=60;finalCurrentValsFile=6; %(m)
% date='250817_B12';arrayNumber=13;electrodeNumber=13;finalCurrentValsFile=6; %(g)
% date='250817_B13';arrayNumber=13;electrodeNumber=14;finalCurrentValsFile=6; %(r)
% date='250817_B14';arrayNumber=10;electrodeNumber=48;finalCurrentValsFile=6; %(g)
% date='250817_B15';arrayNumber=10;electrodeNumber=48;finalCurrentValsFile=6; %(g)
% date='250817_B20';arrayNumber=11;electrodeNumber=51;finalCurrentValsFile=6; %(m-g)
% date='250817_B21';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=6; %(g) can discard
% date='250817_B22';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=6; %(g)
% date='250817_B23';arrayNumber=11;electrodeNumber=34;finalCurrentValsFile=6; %(g)
% date='250817_B24';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=6; %(g)
% date='250817_B25';arrayNumber=11;electrodeNumber=34;finalCurrentValsFile=6; %(g)
% date='250817_B26';arrayNumber=14;electrodeNumber=5;finalCurrentValsFile=6; %(g)
% date='250817_B27';arrayNumber=14;electrodeNumber=4;finalCurrentValsFile=6; %(g)
% date='250817_B29';arrayNumber=14;electrodeNumber=12;finalCurrentValsFile=6; %(m-g)
% date='250817_B30';arrayNumber=14;electrodeNumber=21;finalCurrentValsFile=6; %(g)
useFinalCurrentVals=1;

date='280817_B1';arrayNumber=14;electrodeNumber=20;finalCurrentValsFile=6; %(g)
date='280817_B2';arrayNumber=14;electrodeNumber=20;finalCurrentValsFile=6; %(m) 
date='280817_B3';arrayNumber=14;electrodeNumber=28;finalCurrentValsFile=6; %(g)
date='280817_B4';arrayNumber=14;electrodeNumber=63;finalCurrentValsFile=6; %(g)
date='280817_B5';arrayNumber=14;electrodeNumber=13;finalCurrentValsFile=6; %(m)
date='280817_B6';arrayNumber=14;electrodeNumber=62;finalCurrentValsFile=6; %(g)
date='280817_B7';arrayNumber=14;electrodeNumber=54;finalCurrentValsFile=6; %(g)
date='280817_B8';arrayNumber=14;electrodeNumber=55;finalCurrentValsFile=6; %(g)
date='280817_B9';arrayNumber=14;electrodeNumber=29;finalCurrentValsFile=6; %(r)
date='280817_B11';arrayNumber=14;electrodeNumber=37;finalCurrentValsFile=6; %(g)
date='280817_B12';arrayNumber=14;electrodeNumber=36;finalCurrentValsFile=6; %(g)
date='280817_B13';arrayNumber=14;electrodeNumber=31;finalCurrentValsFile=6; %(g)
date='280817_B14';arrayNumber=14;electrodeNumber=53;finalCurrentValsFile=6; %(r) can discard
date='280817_B16';arrayNumber=14;electrodeNumber=53;finalCurrentValsFile=6; %(g)
% date='280817_B19';arrayNumber=14;electrodeNumber=3;finalCurrentValsFile=6; %(r)
% date='280817_B20';arrayNumber=14;electrodeNumber=32;finalCurrentValsFile=6; %(g)
% date='280817_B21';arrayNumber=14;electrodeNumber=47;finalCurrentValsFile=6; %(g)
% date='280817_B22';arrayNumber=14;electrodeNumber=59;finalCurrentValsFile=6; %(g)
% date='280817_B23';arrayNumber=14;electrodeNumber=40;finalCurrentValsFile=6; %(g)
% date='280817_B24';arrayNumber=14;electrodeNumber=61;finalCurrentValsFile=6; %(g)
% date='280817_B25';arrayNumber=14;electrodeNumber=39;finalCurrentValsFile=6; %(g)
% date='280817_B27';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=6; %(r)
% date='280817_B28';arrayNumber=14;electrodeNumber=58;finalCurrentValsFile=6; %(r)
% date='280817_B29';arrayNumber=14;electrodeNumber=44;finalCurrentValsFile=6; %(r)
% date='280817_B30';arrayNumber=14;electrodeNumber=45;finalCurrentValsFile=6; %(g)
% date='280817_B31';arrayNumber=14;electrodeNumber=46;finalCurrentValsFile=6; %(g)
useFinalCurrentVals=1;

date='290817_B1';arrayNumber=14;electrodeNumber=16;finalCurrentValsFile=6; %(g)
date='290817_B2';arrayNumber=14;electrodeNumber=30;finalCurrentValsFile=6; %(g)
date='290817_B3';arrayNumber=14;electrodeNumber=30;finalCurrentValsFile=6; %(g)
date='290817_B4';arrayNumber=14;electrodeNumber=13;finalCurrentValsFile=6; %(r)
date='290817_B7';arrayNumber=14;electrodeNumber=29;finalCurrentValsFile=6; %(m-g)
date='290817_B9';arrayNumber=14;electrodeNumber=3;finalCurrentValsFile=6; %(g)
date='290817_B10';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=6; %(g)
date='290817_B13';arrayNumber=14;electrodeNumber=58;finalCurrentValsFile=6; %(g)
date='290817_B14';arrayNumber=14;electrodeNumber=44;finalCurrentValsFile=6; %(g)
date='290817_B21';arrayNumber=13;electrodeNumber=44;finalCurrentValsFile=6; %(g)
date='290817_B23';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=6; %(r)
date='290817_B24';arrayNumber=13;electrodeNumber=62;finalCurrentValsFile=6; %(g)
date='290817_B25';arrayNumber=13;electrodeNumber=62;finalCurrentValsFile=6; %(g)
date='290817_B26';arrayNumber=13;electrodeNumber=43;finalCurrentValsFile=6; %(g)
date='290817_B28';arrayNumber=13;electrodeNumber=32;finalCurrentValsFile=6; %(g)
date='290817_B29';arrayNumber=13;electrodeNumber=48;finalCurrentValsFile=6; %(g)
date='290817_B30';arrayNumber=13;electrodeNumber=49;finalCurrentValsFile=6; %(g)
date='290817_B31';arrayNumber=13;electrodeNumber=22;finalCurrentValsFile=6; %(g)
date='290817_B33';arrayNumber=13;electrodeNumber=58;finalCurrentValsFile=6; %(r)
date='290817_B34';arrayNumber=13;electrodeNumber=31;finalCurrentValsFile=6; %(g)
date='290817_B36';arrayNumber=13;electrodeNumber=25;finalCurrentValsFile=6; %(g)
date='290817_B37';arrayNumber=13;electrodeNumber=3;finalCurrentValsFile=6; %(g) use sigmoid fit
date='290817_B38';arrayNumber=13;electrodeNumber=23;finalCurrentValsFile=6; %(g)
date='290817_B39';arrayNumber=13;electrodeNumber=47;finalCurrentValsFile=6; %(g) use sigmoid fit
date='290817_B40';arrayNumber=13;electrodeNumber=26;finalCurrentValsFile=6; %(g)
date='290817_B41';arrayNumber=13;electrodeNumber=60;finalCurrentValsFile=6; %(g)
date='290817_B42';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=6; %(r)
date='290817_B44';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=6; %(m-g) bipolar, 55+56
date='290817_B45';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=6; %(m-g) bipolar, 55+56
date='290817_B46';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=6; %(m) bipolar, 37+38, can discard
date='290817_B47';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=6; %(g) bipolar, 37+38
useFinalCurrentVals=1;

date='300817_B1';arrayNumber=13;electrodeNumber=11;finalCurrentValsFile=7; %(g) bipolar, 11+12
date='300817_B2';arrayNumber=13;electrodeNumber=33;finalCurrentValsFile=7; %(g) bipolar, 33+34
date='300817_B3';arrayNumber=13;electrodeNumber=11;finalCurrentValsFile=7; %(m-g) 
date='300817_B4';arrayNumber=13;electrodeNumber=12;finalCurrentValsFile=7; %(m) 
date='300817_B5';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=7; %(g) 
date='300817_B6';arrayNumber=13;electrodeNumber=38;finalCurrentValsFile=7; %(g) 
date='300817_B7';arrayNumber=13;electrodeNumber=33;finalCurrentValsFile=7; %(g) 
date='300817_B8';arrayNumber=13;electrodeNumber=34;finalCurrentValsFile=7; %(g) 
date='300817_B9';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=7; %(m) 
date='300817_B10';arrayNumber=13;electrodeNumber=33;finalCurrentValsFile=7; %(g) bipolar, 33+35
date='300817_B11';arrayNumber=13;electrodeNumber=34;finalCurrentValsFile=7; %(g) bipolar, 34+35
date='300817_B12';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(g) bipolar, 50+51
date='300817_B13';arrayNumber=13;electrodeNumber=52;finalCurrentValsFile=7; %(g) bipolar, 52+53
date='300817_B16';arrayNumber=9;electrodeNumber=1;finalCurrentValsFile=7; %(g) 
date='300817_B17';arrayNumber=9;electrodeNumber=17;finalCurrentValsFile=7; %(g) 
date='300817_B18';arrayNumber=9;electrodeNumber=27;finalCurrentValsFile=7; %(m) use sigmoid fit
date='300817_B19';arrayNumber=9;electrodeNumber=44;finalCurrentValsFile=7; %(g) 
date='300817_B20';arrayNumber=9;electrodeNumber=64;finalCurrentValsFile=7; %(m) 
date='300817_B21';arrayNumber=9;electrodeNumber=9;finalCurrentValsFile=7; %(g)
date='300817_B22';arrayNumber=9;electrodeNumber=26;finalCurrentValsFile=7; %(g)
date='300817_B23';arrayNumber=9;electrodeNumber=19;finalCurrentValsFile=7; %(m-g)
date='300817_B24';arrayNumber=9;electrodeNumber=37;finalCurrentValsFile=7; %(r)
date='300817_B25';arrayNumber=9;electrodeNumber=63;finalCurrentValsFile=7; %(m)
date='300817_B26';arrayNumber=9;electrodeNumber=45;finalCurrentValsFile=7; %(r) start higher
date='300817_B27';arrayNumber=9;electrodeNumber=48;finalCurrentValsFile=7; %(g)
date='300817_B28';arrayNumber=9;electrodeNumber=47;finalCurrentValsFile=7; %(g)
date='300817_B29';arrayNumber=12;electrodeNumber=21;finalCurrentValsFile=7; %(g)
date='300817_B30';arrayNumber=12;electrodeNumber=6;finalCurrentValsFile=7; %(g)
date='300817_B31';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=7; %(g) use sigmoid fit
date='300817_B32';arrayNumber=12;electrodeNumber=4;finalCurrentValsFile=7; %(g)
date='300817_B33';arrayNumber=12;electrodeNumber=10;finalCurrentValsFile=7; %(m)
date='300817_B34';arrayNumber=12;electrodeNumber=18;finalCurrentValsFile=7; %(g)
date='300817_B35';arrayNumber=12;electrodeNumber=8;finalCurrentValsFile=7; %(r) use lower values
date='300817_B36';arrayNumber=12;electrodeNumber=14;finalCurrentValsFile=7; %(g)
date='300817_B37';arrayNumber=12;electrodeNumber=30;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='040917_B1';arrayNumber=12;electrodeNumber=33;finalCurrentValsFile=7; %(m-g)
% date='040917_B2';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(m-g)
% date='040917_B3';arrayNumber=12;electrodeNumber=52;finalCurrentValsFile=7; %(g)
% date='040917_B4';arrayNumber=12;electrodeNumber=50;finalCurrentValsFile=7; %(g)
% date='040917_B5';arrayNumber=12;electrodeNumber=51;finalCurrentValsFile=7; %(g)
% date='040917_B6';arrayNumber=12;electrodeNumber=61;finalCurrentValsFile=7; %(g)
% date='040917_B7';arrayNumber=12;electrodeNumber=1;finalCurrentValsFile=7; %(g)
% date='040917_B8';arrayNumber=15;electrodeNumber=15;finalCurrentValsFile=7; %(m) use sigmoid fit
% date='040917_B9';arrayNumber=15;electrodeNumber=7;finalCurrentValsFile=7; %(g)
% date='040917_B10';arrayNumber=15;electrodeNumber=55;finalCurrentValsFile=7; %(g)
% date='040917_B11';arrayNumber=15;electrodeNumber=48;finalCurrentValsFile=7; %(g)
% date='040917_B12';arrayNumber=15;electrodeNumber=40;finalCurrentValsFile=7; %(g)
% date='040917_B13';arrayNumber=15;electrodeNumber=49;finalCurrentValsFile=7; %(g)
% date='040917_B14';arrayNumber=15;electrodeNumber=2;finalCurrentValsFile=7; %(r)
% date='040917_B15';arrayNumber=15;electrodeNumber=46;finalCurrentValsFile=7; %(g)
% date='040917_B16';arrayNumber=15;electrodeNumber=62;finalCurrentValsFile=7; %(g)
% date='040917_B17';arrayNumber=15;electrodeNumber=63;finalCurrentValsFile=7; %(g)
% date='040917_B18';arrayNumber=10;electrodeNumber=37;finalCurrentValsFile=7; %(g)
% date='040917_B19';arrayNumber=10;electrodeNumber=40;finalCurrentValsFile=7; %(g)
% date='040917_B20';arrayNumber=10;electrodeNumber=23;finalCurrentValsFile=7; %(g)
% date='040917_B21';arrayNumber=10;electrodeNumber=29;finalCurrentValsFile=7; %(g)
% date='040917_B22';arrayNumber=10;electrodeNumber=55;finalCurrentValsFile=7; %(g)
% date='040917_B23';arrayNumber=10;electrodeNumber=35;finalCurrentValsFile=7; %(g)
% date='040917_B25';arrayNumber=10;electrodeNumber=31;finalCurrentValsFile=7; %(g)
% date='040917_B27';arrayNumber=10;electrodeNumber=58;finalCurrentValsFile=7; %(g)
% date='040917_B29';arrayNumber=10;electrodeNumber=30;finalCurrentValsFile=7; %(g)
% date='040917_B30';arrayNumber=10;electrodeNumber=44;finalCurrentValsFile=7; %(g)
% date='040917_B31';arrayNumber=10;electrodeNumber=57;finalCurrentValsFile=7; %(g)
% date='040917_B32';arrayNumber=10;electrodeNumber=22;finalCurrentValsFile=7; %(g)
% date='040917_B33';arrayNumber=10;electrodeNumber=62;finalCurrentValsFile=7; %(r)
% date='040917_B34';arrayNumber=10;electrodeNumber=21;finalCurrentValsFile=7; %(g)
% date='040917_B35';arrayNumber=10;electrodeNumber=32;finalCurrentValsFile=7; %(g)
% date='040917_B36';arrayNumber=10;electrodeNumber=24;finalCurrentValsFile=7; %(g)
% date='040917_B37';arrayNumber=10;electrodeNumber=34;finalCurrentValsFile=7; %(g)
% date='040917_B38';arrayNumber=10;electrodeNumber=8;finalCurrentValsFile=7; %(g)
% date='040917_B39';arrayNumber=10;electrodeNumber=36;finalCurrentValsFile=7; %(g)
% date='040917_B41';arrayNumber=10;electrodeNumber=28;finalCurrentValsFile=7; %(r)
useFinalCurrentVals=1;

date='050917_B1';arrayNumber=10;electrodeNumber=14;finalCurrentValsFile=7; %(m)
date='050917_B2';arrayNumber=10;electrodeNumber=14;finalCurrentValsFile=7; %(g)
date='050917_B3';arrayNumber=10;electrodeNumber=28;finalCurrentValsFile=7; %(g)
date='050917_B5';arrayNumber=10;electrodeNumber=61;finalCurrentValsFile=7; %(g)
date='050917_B6';arrayNumber=10;electrodeNumber=16;finalCurrentValsFile=7; %(g)
date='050917_B7';arrayNumber=10;electrodeNumber=43;finalCurrentValsFile=7; %(g)
date='050917_B8';arrayNumber=10;electrodeNumber=20;finalCurrentValsFile=7; %(g)
date='050917_B9';arrayNumber=10;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='050917_B10';arrayNumber=10;electrodeNumber=62;finalCurrentValsFile=7; %(g)
date='050917_B11';arrayNumber=10;electrodeNumber=51;finalCurrentValsFile=7; %(g)
date='050917_B12';arrayNumber=10;electrodeNumber=15;finalCurrentValsFile=7; %(g)
date='050917_B18';arrayNumber=16;electrodeNumber=12;finalCurrentValsFile=7; %(g)
date='050917_B19';arrayNumber=16;electrodeNumber=20;finalCurrentValsFile=7; %(g)
date='050917_B20';arrayNumber=16;electrodeNumber=19;finalCurrentValsFile=7; %(r)
date='050917_B22';arrayNumber=16;electrodeNumber=28;finalCurrentValsFile=7; %(r)
date='050917_B23';arrayNumber=16;electrodeNumber=4;finalCurrentValsFile=7; %(r)
date='050917_B24';arrayNumber=16;electrodeNumber=13;finalCurrentValsFile=7; %(r)
date='050917_B25';arrayNumber=16;electrodeNumber=11;finalCurrentValsFile=7; %(r)
date='050917_B26';arrayNumber=16;electrodeNumber=21;finalCurrentValsFile=7; %(g)
date='050917_B27';arrayNumber=16;electrodeNumber=27;finalCurrentValsFile=7; %(m)
date='050917_B28';arrayNumber=16;electrodeNumber=5;finalCurrentValsFile=7; %(r)
date='050917_B29';arrayNumber=16;electrodeNumber=37;finalCurrentValsFile=7; %(m)
date='050917_B30';arrayNumber=16;electrodeNumber=3;finalCurrentValsFile=7; %(r)
date='050917_B32';arrayNumber=16;electrodeNumber=45;finalCurrentValsFile=7; %(g)
date='050917_B34';arrayNumber=16;electrodeNumber=23;finalCurrentValsFile=7; %(r)
date='050917_B36';arrayNumber=16;electrodeNumber=36;finalCurrentValsFile=7; %(r)
date='050917_B37';arrayNumber=16;electrodeNumber=32;finalCurrentValsFile=7; %(r)
date='050917_B38';arrayNumber=16;electrodeNumber=24;finalCurrentValsFile=7; %(r)
date='050917_B39';arrayNumber=16;electrodeNumber=59;finalCurrentValsFile=7; %(r)
date='050917_B40';arrayNumber=16;electrodeNumber=56;finalCurrentValsFile=7; %(r)
useFinalCurrentVals=1;

date='060917_B1';arrayNumber=16;electrodeNumber=7;finalCurrentValsFile=7; %(m-g)
date='060917_B2';arrayNumber=16;electrodeNumber=16;finalCurrentValsFile=7; %(r)
date='060917_B3';arrayNumber=16;electrodeNumber=61;finalCurrentValsFile=7; %(g)
date='060917_B4';arrayNumber=16;electrodeNumber=58;finalCurrentValsFile=7; %(g)
date='060917_B5';arrayNumber=16;electrodeNumber=40;finalCurrentValsFile=7; %(g) use sigmoid fit
date='060917_B6';arrayNumber=16;electrodeNumber=38;finalCurrentValsFile=7; %(r)
date='060917_B7';arrayNumber=16;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='060917_B9';arrayNumber=16;electrodeNumber=48;finalCurrentValsFile=7; %(r)
date='060917_B10';arrayNumber=16;electrodeNumber=6;finalCurrentValsFile=7; %(r)
date='060917_B11';arrayNumber=16;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='060917_B12';arrayNumber=16;electrodeNumber=2;finalCurrentValsFile=7; %(r)
date='060917_B13';arrayNumber=16;electrodeNumber=39;finalCurrentValsFile=7; %(r)
date='060917_B14';arrayNumber=16;electrodeNumber=30;finalCurrentValsFile=7; %(m)
date='060917_B15';arrayNumber=16;electrodeNumber=15;finalCurrentValsFile=7; %(m)
date='060917_B16';arrayNumber=16;electrodeNumber=57;finalCurrentValsFile=7; %(g)
date='060917_B17';arrayNumber=16;electrodeNumber=35;finalCurrentValsFile=7; %(m-g) use sigmoid fit?
date='060917_B18';arrayNumber=16;electrodeNumber=43;finalCurrentValsFile=7; %(g)
date='060917_B19';arrayNumber=16;electrodeNumber=46;finalCurrentValsFile=7; %(g)
date='060917_B20';arrayNumber=16;electrodeNumber=47;finalCurrentValsFile=7; %(g)
date='060917_B21';arrayNumber=16;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='060917_B22';arrayNumber=16;electrodeNumber=64;finalCurrentValsFile=7; %(m)
date='060917_B23';arrayNumber=16;electrodeNumber=22;finalCurrentValsFile=7; %(m)
date='060917_B28';arrayNumber=8;electrodeNumber=27;finalCurrentValsFile=7; %(g)
date='060917_B29';arrayNumber=8;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='060917_B30';arrayNumber=8;electrodeNumber=45;finalCurrentValsFile=7; %(m)
date='060917_B31';arrayNumber=8;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='060917_B32';arrayNumber=8;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='060917_B33';arrayNumber=8;electrodeNumber=19;finalCurrentValsFile=7; %(g)
date='060917_B34';arrayNumber=8;electrodeNumber=43;finalCurrentValsFile=7; %(m)
date='060917_B35';arrayNumber=8;electrodeNumber=39;finalCurrentValsFile=7; %(g)
date='060917_B36';arrayNumber=8;electrodeNumber=48;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='070917_B1';arrayNumber=8;electrodeNumber=48;finalCurrentValsFile=7; %(g)
% date='070917_B2';arrayNumber=8;electrodeNumber=64;finalCurrentValsFile=7; %(g)
% date='070917_B3';arrayNumber=8;electrodeNumber=32;finalCurrentValsFile=7; %(g)
% date='070917_B4';arrayNumber=8;electrodeNumber=14;finalCurrentValsFile=7; %(g)
% date='070917_B5';arrayNumber=8;electrodeNumber=6;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='270917_B22';arrayNumber=10;electrodeNumber=51;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='041017_B6';arrayNumber=10;electrodeNumber=51;finalCurrentValsFile=7; %(?)
% date='041017_B7';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=7; %(g)
% date='041017_B8';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(r)
date='041017_B9';arrayNumber=13;electrodeNumber=49;finalCurrentValsFile=7; %(g)
date='041017_B10';arrayNumber=11;electrodeNumber=55;finalCurrentValsFile=7; %(r)
% date='041017_B13';arrayNumber=14;electrodeNumber=32;finalCurrentValsFile=7; %(r)
% date='041017_B14';arrayNumber=16;electrodeNumber=15;finalCurrentValsFile=7; %(r)
% date='041017_B18';arrayNumber=10;electrodeNumber=8;finalCurrentValsFile=7; %(g)
date='041017_B19';arrayNumber=12;electrodeNumber=39;finalCurrentValsFile=7; %(r)
useFinalCurrentVals=1;

date='051017_B1';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=7; %(m)
% date='051017_B3';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=7; %(r)
% date='051017_B4';arrayNumber=15;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='051017_B6';arrayNumber=10;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='051017_B7';arrayNumber=12;electrodeNumber=10;finalCurrentValsFile=7; %(g)
date='051017_B9';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(m-g)
date='051017_B10';arrayNumber=12;electrodeNumber=27;finalCurrentValsFile=7; %(m-g)
date='051017_B15';arrayNumber=12;electrodeNumber=39;finalCurrentValsFile=7; %(r)
date='051017_B16';arrayNumber=14;electrodeNumber=32;finalCurrentValsFile=7; %(m-g)
date='051017_B17';arrayNumber=8;electrodeNumber=40;finalCurrentValsFile=7; %(r)
date='051017_B18';arrayNumber=12;electrodeNumber=20;finalCurrentValsFile=7; %(g)
date='051017_B19';arrayNumber=12;electrodeNumber=10;finalCurrentValsFile=7; %(g)
date='051017_B20';arrayNumber=12;electrodeNumber=49;finalCurrentValsFile=7; %(g)
date='051017_B21';arrayNumber=15;electrodeNumber=62;finalCurrentValsFile=7; %(g)
date='051017_B22';arrayNumber=8;electrodeNumber=45;finalCurrentValsFile=7; %(r)
date='051017_B23';arrayNumber=8;electrodeNumber=26;finalCurrentValsFile=7; %(g)
date='051017_B24';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=7; %(r-m)
date='051017_B25';arrayNumber=13;electrodeNumber=38;finalCurrentValsFile=7; %(g)
date='051017_B26';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=7; %(g)
date='051017_B27';arrayNumber=12;electrodeNumber=30;finalCurrentValsFile=7; %(r)
date='051017_B28';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=7; %(g)
% date='051017_B29';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=7; %(r)
% date='051017_B30';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=7; %(r)
date='051017_B33';arrayNumber=10;electrodeNumber=40;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='091017_B8';arrayNumber=10;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='091017_B9';arrayNumber=15;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='091017_B10';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=7; %(g)
date='091017_B11';arrayNumber=13;electrodeNumber=38;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='101017_B1';arrayNumber=8;electrodeNumber=19;finalCurrentValsFile=7; %(g)
% date='101017_B2';arrayNumber=15;electrodeNumber=46;finalCurrentValsFile=7; %(g)
date='101017_B3';arrayNumber=8;electrodeNumber=27;finalCurrentValsFile=7; %(g)
date='101017_B4';arrayNumber=12;electrodeNumber=49;finalCurrentValsFile=7; %(g)
date='101017_B5';arrayNumber=16;electrodeNumber=35;finalCurrentValsFile=7; %(r)
date='101017_B6';arrayNumber=16;electrodeNumber=50;finalCurrentValsFile=7; %(m-g)
date='101017_B7';arrayNumber=16;electrodeNumber=46;finalCurrentValsFile=7; %(m-g)
date='101017_B8';arrayNumber=16;electrodeNumber=45;finalCurrentValsFile=7; %(m-g)
date='101017_B11';arrayNumber=8;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='101017_B16';arrayNumber=16;electrodeNumber=15;finalCurrentValsFile=7; %(m)
date='101017_B17';arrayNumber=16;electrodeNumber=22;finalCurrentValsFile=7; %(m)
date='101017_B25';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=7; %(r)
date='101017_B26';arrayNumber=12;electrodeNumber=3;finalCurrentValsFile=7; %(r)
date='101017_B27';arrayNumber=12;electrodeNumber=36;finalCurrentValsFile=7; %(g)
date='101017_B28';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(m-g)
date='101017_B29';arrayNumber=12;electrodeNumber=61;finalCurrentValsFile=7; %(g)
date='101017_B30';arrayNumber=14;electrodeNumber=29;finalCurrentValsFile=7; %(g)
date='101017_B31';arrayNumber=14;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='101017_B32';arrayNumber=14;electrodeNumber=45;finalCurrentValsFile=7; %(g)
date='101017_B33';arrayNumber=14;electrodeNumber=32;finalCurrentValsFile=7; %(g)
date='101017_B34';arrayNumber=16;electrodeNumber=30;finalCurrentValsFile=7; %(g)
date='101017_B43';arrayNumber=14;electrodeNumber=55;finalCurrentValsFile=7; %(g)
date='101017_B44';arrayNumber=14;electrodeNumber=63;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='111017_B2';arrayNumber=16;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='111017_B3';arrayNumber=8;electrodeNumber=27;finalCurrentValsFile=7; %(g)
date='111017_B4';arrayNumber=14;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='111017_B5';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='111017_B20';arrayNumber=12;electrodeNumber=36;finalCurrentValsFile=7; %(r-m)
date='111017_B21';arrayNumber=12;electrodeNumber=15;finalCurrentValsFile=7; %(r)
date='111017_B22';arrayNumber=16;electrodeNumber=15;finalCurrentValsFile=7; %(r-m)
date='111017_B22';arrayNumber=16;electrodeNumber=64;finalCurrentValsFile=7; %(r-m)
useFinalCurrentVals=1;

date='121017_B2';arrayNumber=16;electrodeNumber=15;finalCurrentValsFile=7; %(r-m)
date='121017_B4';arrayNumber=16;electrodeNumber=64;finalCurrentValsFile=7; %(m)
date='121017_B5';arrayNumber=8;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='121017_B6';arrayNumber=8;electrodeNumber=43;finalCurrentValsFile=7; %(g)
date='121017_B7';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=7; %(r)
date='121017_B8';arrayNumber=13;electrodeNumber=33;finalCurrentValsFile=7; %(g)
date='121017_B9';arrayNumber=8;electrodeNumber=45;finalCurrentValsFile=7; %(r)
date='121017_B10';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(m-g)
date='121017_B11';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=7; %(r)
date='121017_B12';arrayNumber=12;electrodeNumber=27;finalCurrentValsFile=7; %(r)
date='121017_B13';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=7; %(m)
date='121017_B17';arrayNumber=14;electrodeNumber=45;finalCurrentValsFile=7; %(g)
date='121017_B18';arrayNumber=14;electrodeNumber=32;finalCurrentValsFile=7; %(g)
date='121017_B19';arrayNumber=16;electrodeNumber=37;finalCurrentValsFile=7; %(m)
date='121017_B20';arrayNumber=8;electrodeNumber=50;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='131017_B3';arrayNumber=14;electrodeNumber=45;finalCurrentValsFile=7; %(g)
date='131017_B4';arrayNumber=14;electrodeNumber=32;finalCurrentValsFile=7; %(g)
date='131017_B5';arrayNumber=8;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='131017_B6';arrayNumber=13;electrodeNumber=33;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='171017_B1';arrayNumber=10;electrodeNumber=16;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B2';arrayNumber=11;electrodeNumber=18;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B3';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B4';arrayNumber=10;electrodeNumber=24;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B5';arrayNumber=10;electrodeNumber=37;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B6';arrayNumber=10;electrodeNumber=20;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B7';arrayNumber=10;electrodeNumber=43;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B8';arrayNumber=13;electrodeNumber=32;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B10';arrayNumber=10;electrodeNumber=29;finalCurrentValsFile=7; %(g)
date='171017_B11';arrayNumber=10;electrodeNumber=57;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B12';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B13';arrayNumber=10;electrodeNumber=46;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B14';arrayNumber=10;electrodeNumber=47;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B15';arrayNumber=10;electrodeNumber=48;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B17';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B18';arrayNumber=11;electrodeNumber=55;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B19';arrayNumber=10;electrodeNumber=36;finalCurrentValsFile=7; %(g) 
date='171017_B20';arrayNumber=10;electrodeNumber=37;finalCurrentValsFile=7; %(g) very low threshold
date='171017_B21';arrayNumber=13;electrodeNumber=26;finalCurrentValsFile=7; %(g) very low threshold
% date='171017_B22';arrayNumber=13;electrodeNumber=3;finalCurrentValsFile=7; %(g) 
date='171017_B23';arrayNumber=13;electrodeNumber=23;finalCurrentValsFile=7; %(r) 
date='171017_B24';arrayNumber=16;electrodeNumber=40;finalCurrentValsFile=7; %(r) 
date='171017_B25';arrayNumber=9;electrodeNumber=44;finalCurrentValsFile=7; %(m-g) 
date='171017_B27';arrayNumber=16;electrodeNumber=39;finalCurrentValsFile=7; %(r) 
date='171017_B29';arrayNumber=10;electrodeNumber=16;finalCurrentValsFile=7; %(m-g) 
date='171017_B30';arrayNumber=11;electrodeNumber=18;finalCurrentValsFile=7; %(m)  
date='171017_B31';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=7; %(g) 
date='171017_B32';arrayNumber=10;electrodeNumber=24;finalCurrentValsFile=7; %(g) 
date='171017_B33';arrayNumber=10;electrodeNumber=37;finalCurrentValsFile=7; %(g) 
date='171017_B34';arrayNumber=10;electrodeNumber=20;finalCurrentValsFile=7; %(g) 
date='171017_B35';arrayNumber=10;electrodeNumber=43;finalCurrentValsFile=7; %(g) 
date='171017_B36';arrayNumber=13;electrodeNumber=32;finalCurrentValsFile=7; %(m) 
date='171017_B37';arrayNumber=10;electrodeNumber=29;finalCurrentValsFile=7; %(g) 
date='171017_B38';arrayNumber=10;electrodeNumber=57;finalCurrentValsFile=7; %(g) 
date='171017_B39';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=7; %(g) 
date='171017_B40';arrayNumber=10;electrodeNumber=46;finalCurrentValsFile=7; %(g) 
date='171017_B41';arrayNumber=10;electrodeNumber=47;finalCurrentValsFile=7; %(g) 
date='171017_B42';arrayNumber=10;electrodeNumber=58;finalCurrentValsFile=7; %(r-m) 
date='171017_B43';arrayNumber=10;electrodeNumber=59;finalCurrentValsFile=7; %(m) 
date='171017_B44';arrayNumber=10;electrodeNumber=51;finalCurrentValsFile=7; %(g) 
date='171017_B45';arrayNumber=11;electrodeNumber=34;finalCurrentValsFile=7; %(g) 
useFinalCurrentVals=1;

date='181017_B2';arrayNumber=13;electrodeNumber=26;finalCurrentValsFile=7; %(g) too many false alarms
date='181017_B3';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=7; %(g) too many false alarms
date='181017_B4';arrayNumber=13;electrodeNumber=32;finalCurrentValsFile=7; %(g) too many false alarms
date='181017_B5';arrayNumber=10;electrodeNumber=51;finalCurrentValsFile=7; %(g) too many false alarms
date='181017_B6';arrayNumber=10;electrodeNumber=20;finalCurrentValsFile=7; %(g) many false alarms
date='181017_B7';arrayNumber=10;electrodeNumber=37;finalCurrentValsFile=7; %(g) 
date='181017_B8';arrayNumber=10;electrodeNumber=57;finalCurrentValsFile=7; %(g) 
date='181017_B9';arrayNumber=10;electrodeNumber=46;finalCurrentValsFile=7; %(g) 
date='181017_B10';arrayNumber=10;electrodeNumber=51;finalCurrentValsFile=7; %(g) 
date='181017_B11';arrayNumber=10;electrodeNumber=20;finalCurrentValsFile=7; %(g) 
date='181017_B12';arrayNumber=10;electrodeNumber=37;finalCurrentValsFile=7; %(g) 
date='181017_B13';arrayNumber=13;electrodeNumber=32;finalCurrentValsFile=7; %(m-g) 
date='181017_B14';arrayNumber=13;electrodeNumber=3;finalCurrentValsFile=7; %(g) 
date='181017_B15';arrayNumber=10;electrodeNumber=46;finalCurrentValsFile=7; %(g) 
date='181017_B16';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=7; %(g) 
date='181017_B22';arrayNumber=15;electrodeNumber=49;finalCurrentValsFile=7; %(g) 
date='181017_B23';arrayNumber=13;electrodeNumber=22;finalCurrentValsFile=7; %(m-g) 
date='181017_B24';arrayNumber=13;electrodeNumber=12;finalCurrentValsFile=7; %(g) 
date='181017_B25';arrayNumber=13;electrodeNumber=13;finalCurrentValsFile=7; %(m-g) 
date='181017_B29';arrayNumber=10;electrodeNumber=29;finalCurrentValsFile=7; %(g) 
date='181017_B30';arrayNumber=10;electrodeNumber=24;finalCurrentValsFile=7; %(g) 
date='181017_B31';arrayNumber=10;electrodeNumber=44;finalCurrentValsFile=7; %(g) 
date='181017_B32';arrayNumber=10;electrodeNumber=47;finalCurrentValsFile=7; %(g) 
useFinalCurrentVals=1;

date='191017_B2';arrayNumber=10;electrodeNumber=44;finalCurrentValsFile=7; %(?) very low threshold
date='191017_B3';arrayNumber=10;electrodeNumber=45;finalCurrentValsFile=7; %(?) very low threshold
date='191017_B4';arrayNumber=10;electrodeNumber=30;finalCurrentValsFile=7; %(g) 
date='191017_B5';arrayNumber=10;electrodeNumber=59;finalCurrentValsFile=7; %(?) very low threshold
date='191017_B6';arrayNumber=10;electrodeNumber=47;finalCurrentValsFile=7; %(?) very low threshold
date='191017_B7';arrayNumber=10;electrodeNumber=29;finalCurrentValsFile=7; %(g) 
date='191017_B8';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(?) very low threshold
date='191017_B9';arrayNumber=11;electrodeNumber=55;finalCurrentValsFile=7; %(g) 
date='191017_B10';arrayNumber=11;electrodeNumber=18;finalCurrentValsFile=7; %(g) 
date='191017_B12';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=7; %(r) use higher currents
date='191017_B13';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=7; %(g) 
date='191017_B14';arrayNumber=13;electrodeNumber=12;finalCurrentValsFile=7; %(g) 
date='191017_B15';arrayNumber=13;electrodeNumber=13;finalCurrentValsFile=7; %(g) 
date='191017_B16';arrayNumber=13;electrodeNumber=22;finalCurrentValsFile=7; %(r-m) use higher currents
date='191017_B17';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=7; %(r-m) use higher currents?
date='191017_B18';arrayNumber=13;electrodeNumber=3;finalCurrentValsFile=7; %(g) 
date='191017_B19';arrayNumber=10;electrodeNumber=24;finalCurrentValsFile=7; %(g) 
date='191017_B20';arrayNumber=10;electrodeNumber=42;finalCurrentValsFile=7; %(g) 
date='191017_B21';arrayNumber=10;electrodeNumber=44;finalCurrentValsFile=7; %(m) 
date='191017_B22';arrayNumber=10;electrodeNumber=45;finalCurrentValsFile=7; %(g) 
date='191017_B23';arrayNumber=10;electrodeNumber=47;finalCurrentValsFile=7; %(g) 
date='191017_B24';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(g) 
date='191017_B25';arrayNumber=13;electrodeNumber=34;finalCurrentValsFile=7; %(g) 
date='191017_B26';arrayNumber=13;electrodeNumber=56;finalCurrentValsFile=7; %(g) 
date='191017_B42';arrayNumber=13;electrodeNumber=48;finalCurrentValsFile=7; %(g) very low threshold
useFinalCurrentVals=1;

date='201017_B2';arrayNumber=13;electrodeNumber=61;finalCurrentValsFile=7; %(r) 
date='201017_B3';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=7; %(r) high false alarm rate
date='201017_B4';arrayNumber=13;electrodeNumber=11;finalCurrentValsFile=7; %(r) high false alarm rate
date='201017_B5';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=7; %(r) high false alarm rate
date='201017_B6';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=7; %(r) high false alarm rate
date='201017_B7';arrayNumber=13;electrodeNumber=60;finalCurrentValsFile=7; %(m-g) 
date='201017_B8';arrayNumber=13;electrodeNumber=51;finalCurrentValsFile=7; %(m-g) 
date='201017_B9';arrayNumber=13;electrodeNumber=52;finalCurrentValsFile=7; %(m-g) 
date='201017_B11';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=7; %(g) 
date='201017_B12';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(g) 
date='201017_B13';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=7; %(m-g) 
date='201017_B14';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(g) 
date='201017_B15';arrayNumber=12;electrodeNumber=27;finalCurrentValsFile=7; %(g) 
date='201017_B16';arrayNumber=10;electrodeNumber=35;finalCurrentValsFile=7; %(g) 
date='201017_B17';arrayNumber=10;electrodeNumber=36;finalCurrentValsFile=7; %(g) 
date='201017_B18';arrayNumber=10;electrodeNumber=43;finalCurrentValsFile=7; %(g) 
date='201017_B19';arrayNumber=13;electrodeNumber=48;finalCurrentValsFile=7; %(g) 
date='201017_B20';arrayNumber=13;electrodeNumber=11;finalCurrentValsFile=7; %(g) 
date='201017_B21';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=7; %(g) 
date='201017_B22';arrayNumber=13;electrodeNumber=61;finalCurrentValsFile=7; %(g) 
date='201017_B23';arrayNumber=8;electrodeNumber=45;finalCurrentValsFile=7; %(g) 
date='201017_B24';arrayNumber=10;electrodeNumber=36;finalCurrentValsFile=7; %(r) high false alarm rate
useFinalCurrentVals=1;

date='231017_B2';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(m) 
date='231017_B3';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=7; %(r) high false alarm rate
date='231017_B4';arrayNumber=8;electrodeNumber=45;finalCurrentValsFile=7; %(m) 
date='231017_B5';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=7; %(m) 
date='231017_B6';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=7; %(m-g) 
date='231017_B12';arrayNumber=13;electrodeNumber=43;finalCurrentValsFile=7; %(m-g) high false alarm rate
date='231017_B13';arrayNumber=13;electrodeNumber=44;finalCurrentValsFile=7; %(m-g) 
date='231017_B14';arrayNumber=12;electrodeNumber=12;finalCurrentValsFile=7; %(m) 
date='231017_B16';arrayNumber=12;electrodeNumber=10;finalCurrentValsFile=7; %(m) 
date='231017_B17';arrayNumber=12;electrodeNumber=52;finalCurrentValsFile=7; %(m) 
date='231017_B18';arrayNumber=12;electrodeNumber=50;finalCurrentValsFile=7; %(g) 
date='231017_B19';arrayNumber=12;electrodeNumber=18;finalCurrentValsFile=7; %(g) 
date='231017_B20';arrayNumber=12;electrodeNumber=30;finalCurrentValsFile=7; %(g)  
date='231017_B21';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=7; %(g) 
date='231017_B22';arrayNumber=13;electrodeNumber=47;finalCurrentValsFile=7; %(g) 
date='231017_B23';arrayNumber=13;electrodeNumber=61;finalCurrentValsFile=7; %(g) 
date='231017_B24';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=7; %(g) 
date='231017_B25';arrayNumber=13;electrodeNumber=52;finalCurrentValsFile=7; %(g) 
date='231017_B26';arrayNumber=13;electrodeNumber=22;finalCurrentValsFile=7; %(g) 
date='231017_B27';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=7; %(m-g)
date='231017_B28';arrayNumber=8;electrodeNumber=19;finalCurrentValsFile=7; %(g)
date='231017_B29';arrayNumber=8;electrodeNumber=43;finalCurrentValsFile=7; %(g)
date='231017_B30';arrayNumber=15;electrodeNumber=48;finalCurrentValsFile=7; %(g)
date='231017_B31';arrayNumber=16;electrodeNumber=45;finalCurrentValsFile=7; %(g)
date='231017_B32';arrayNumber=16;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='231017_B33';arrayNumber=16;electrodeNumber=46;finalCurrentValsFile=7; %(g)
date='231017_B34';arrayNumber=10;electrodeNumber=36;finalCurrentValsFile=7; %(g)
date='231017_B35';arrayNumber=15;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='231017_B36';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='241017_B6';arrayNumber=16;electrodeNumber=46;finalCurrentValsFile=7; %(r) high false alarm rate
date='241017_B7';arrayNumber=16;electrodeNumber=44;finalCurrentValsFile=7; %(r) high false alarm rate
date='241017_B8';arrayNumber=8;electrodeNumber=9;finalCurrentValsFile=7; %(g) 
date='241017_B9';arrayNumber=12;electrodeNumber=18;finalCurrentValsFile=7; %(g) 
date='241017_B10';arrayNumber=8;electrodeNumber=19;finalCurrentValsFile=7; %(g) 
date='241017_B11';arrayNumber=16;electrodeNumber=46;finalCurrentValsFile=7; %(g) 
date='241017_B12';arrayNumber=16;electrodeNumber=44;finalCurrentValsFile=7; %(g) 
date='241017_B13';arrayNumber=12;electrodeNumber=27;finalCurrentValsFile=7; %(g) 
date='241017_B14';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=7; %(g) 
date='241017_B19';arrayNumber=12;electrodeNumber=30;finalCurrentValsFile=7; %(r) 
date='241017_B20';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=7; %(g) 
date='241017_B21';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=7; %(m) 
date='241017_B22';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=7; %(g) 
date='241017_B23';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=7; %(m) 
date='241017_B24';arrayNumber=13;electrodeNumber=43;finalCurrentValsFile=7; %(g) 
date='241017_B25';arrayNumber=13;electrodeNumber=58;finalCurrentValsFile=7; %(m-g) 
date='241017_B26';arrayNumber=13;electrodeNumber=49;finalCurrentValsFile=7; %(g) 
date='241017_B27';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(g) 
date='241017_B28';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=7; %(m-g) 
date='241017_B29';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=7; %(m) 
date='241017_B30';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=7; %(g) 
date='241017_B31';arrayNumber=15;electrodeNumber=55;finalCurrentValsFile=7; %(g) 
date='241017_B32';arrayNumber=15;electrodeNumber=62;finalCurrentValsFile=7; %(g) 
date='241017_B33';arrayNumber=15;electrodeNumber=15;finalCurrentValsFile=7; %(g) 
date='241017_B34';arrayNumber=8;electrodeNumber=44;finalCurrentValsFile=7; %(g) 
date='241017_B35';arrayNumber=16;electrodeNumber=57;finalCurrentValsFile=7; %(g) 
date='241017_B36';arrayNumber=16;electrodeNumber=47;finalCurrentValsFile=7; %(r) 
date='241017_B37';arrayNumber=16;electrodeNumber=38;finalCurrentValsFile=7; %(g) 
date='241017_B38';arrayNumber=16;electrodeNumber=39;finalCurrentValsFile=7; %(g) 
date='241017_B39';arrayNumber=16;electrodeNumber=40;finalCurrentValsFile=7; %(m) 
date='241017_B40';arrayNumber=16;electrodeNumber=37;finalCurrentValsFile=7; %(m-g) 
date='241017_B41';arrayNumber=16;electrodeNumber=30;finalCurrentValsFile=7; %(g) 
date='241017_B42';arrayNumber=16;electrodeNumber=20;finalCurrentValsFile=7; %(g) 
date='241017_B43';arrayNumber=12;electrodeNumber=20;finalCurrentValsFile=7; %(g) 
useFinalCurrentVals=1;

date='251017_B1';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=7; %(g) 
date='251017_B2';arrayNumber=12;electrodeNumber=27;finalCurrentValsFile=7; %(g)
date='251017_B3';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=7; %(g)
date='251017_B4';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=7; %(g)
date='251017_B5';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=7; %(g)
date='251017_B6';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=7; %(g)
date='251017_B7';arrayNumber=13;electrodeNumber=49;finalCurrentValsFile=7; %(g)
date='251017_B8';arrayNumber=13;electrodeNumber=58;finalCurrentValsFile=7; %(r)
date='251017_B9';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(m-g)
date='251017_B10';arrayNumber=13;electrodeNumber=34;finalCurrentValsFile=7; %(g)
date='251017_B11';arrayNumber=15;electrodeNumber=62;finalCurrentValsFile=7; %(g)
date='251017_B12';arrayNumber=15;electrodeNumber=15;finalCurrentValsFile=7; %(g)
date='251017_B13';arrayNumber=16;electrodeNumber=38;finalCurrentValsFile=7; %(m)
date='251017_B21';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=7; %(g)
date='251017_B22';arrayNumber=13;electrodeNumber=38;finalCurrentValsFile=7; %(g)
date='251017_B23';arrayNumber=15;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='251017_B24';arrayNumber=10;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='251017_B25';arrayNumber=16;electrodeNumber=46;finalCurrentValsFile=7; %(g)
date='251017_B26';arrayNumber=15;electrodeNumber=46;finalCurrentValsFile=7; %(g)
date='251017_B27';arrayNumber=8;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='251017_B28';arrayNumber=12;electrodeNumber=61;finalCurrentValsFile=7; %(g)
date='251017_B29';arrayNumber=16;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='251017_B30';arrayNumber=8;electrodeNumber=27;finalCurrentValsFile=7; %(r)
date='251017_B31';arrayNumber=14;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='251017_B32';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='251017_B33';arrayNumber=10;electrodeNumber=37;finalCurrentValsFile=7; %(g)
date='251017_B34';arrayNumber=10;electrodeNumber=20;finalCurrentValsFile=7; %(g)
date='251017_B35';arrayNumber=13;electrodeNumber=32;finalCurrentValsFile=7; %(g)
date='251017_B36';arrayNumber=10;electrodeNumber=51;finalCurrentValsFile=7; %(g)
date='251017_B37';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='251017_B38';arrayNumber=11;electrodeNumber=55;finalCurrentValsFile=7; %(g)
date='251017_B39';arrayNumber=13;electrodeNumber=13;finalCurrentValsFile=7; %(g)
date='251017_B41';arrayNumber=11;electrodeNumber=18;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='081117_B3';arrayNumber=15;electrodeNumber=15;finalCurrentValsFile=7; %(g)
date='081117_B5';arrayNumber=15;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='081117_B7';arrayNumber=15;electrodeNumber=62;finalCurrentValsFile=7; %(g)
date='081117_B8';arrayNumber=15;electrodeNumber=46;finalCurrentValsFile=7; %(g)
date='081117_B9';arrayNumber=13;electrodeNumber=58;finalCurrentValsFile=7; %(r)
date='081117_B10';arrayNumber=13;electrodeNumber=34;finalCurrentValsFile=7; %(g)
date='081117_B14';arrayNumber=10;electrodeNumber=30;finalCurrentValsFile=7; %(g)
date='081117_B15';arrayNumber=10;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='081117_B16';arrayNumber=10;electrodeNumber=35;finalCurrentValsFile=7; %(g)
date='081117_B17';arrayNumber=10;electrodeNumber=8;finalCurrentValsFile=7; %(g)
date='081117_B18';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='081117_B19';arrayNumber=13;electrodeNumber=49;finalCurrentValsFile=7; %(g)
date='081117_B20';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='081117_B21';arrayNumber=13;electrodeNumber=48;finalCurrentValsFile=7; %(g)
date='081117_B22';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=7; %(g)
date='081117_B23';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(g)
date='081117_B24';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=7; %(g)
date='081117_B25';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='081117_B26';arrayNumber=11;electrodeNumber=55;finalCurrentValsFile=7; %(r)
date='081117_B27';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=7; %(g)
date='081117_B28';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(g)
date='081117_B29';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='271117_B4';arrayNumber=15;electrodeNumber=63;finalCurrentValsFile=7; %(r)%high false alarm rate
date='271117_B5';arrayNumber=15;electrodeNumber=62;finalCurrentValsFile=7; %(r)%high false alarm rate
date='271117_B6';arrayNumber=13;electrodeNumber=48;finalCurrentValsFile=7; %(g)
date='271117_B7';arrayNumber=13;electrodeNumber=49;finalCurrentValsFile=7; %(g)
date='271117_B8';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=7; %(g)
date='271117_B9';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='271117_B10';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='271117_B13';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=7; %(g)
date='271117_B14';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='271117_B15';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(g)
date='271117_B16';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(g)
date='271117_B17';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=7; %(g)
date='271117_B19';arrayNumber=15;electrodeNumber=62;finalCurrentValsFile=7; %(g)
date='271117_B20';arrayNumber=15;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='271117_B22';arrayNumber=10;electrodeNumber=35;finalCurrentValsFile=7; %(g)
date='271117_B23';arrayNumber=10;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='271117_B24';arrayNumber=10;electrodeNumber=8;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='281117_B2';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(r)
date='281117_B3';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(g)
date='281117_B4';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(r)
date='281117_B5';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=7; %(r)
date='281117_B6';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(g)
date='281117_B7';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(g)
date='281117_B8';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=7; %(g)
date='281117_B9';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(r)%high false alarm rate
useFinalCurrentVals=1;

date='291117_B1';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='291117_B2';arrayNumber=12;electrodeNumber=25;finalCurrentValsFile=7; %(g)
date='291117_B3';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=7; %(r)
date='291117_B4';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=7; %(r)
date='291117_B5';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=7; %(g)
date='291117_B7';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=7; %(g)
date='291117_B13';arrayNumber=9;electrodeNumber=48;finalCurrentValsFile=7; %(g)
date='291117_B14';arrayNumber=9;electrodeNumber=64;finalCurrentValsFile=7; %(g)
date='291117_B15';arrayNumber=9;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='291117_B16';arrayNumber=9;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='291117_B17';arrayNumber=9;electrodeNumber=47;finalCurrentValsFile=7; %(g)
date='291117_B18';arrayNumber=9;electrodeNumber=1;finalCurrentValsFile=7; %(g)
date='291117_B19';arrayNumber=9;electrodeNumber=9;finalCurrentValsFile=7; %(g)
date='291117_B20';arrayNumber=9;electrodeNumber=19;finalCurrentValsFile=7; %(g)
date='291117_B21';arrayNumber=9;electrodeNumber=26;finalCurrentValsFile=7; %(r)
date='291117_B22';arrayNumber=9;electrodeNumber=27;finalCurrentValsFile=7; %(g)
date='291117_B23';arrayNumber=16;electrodeNumber=39;finalCurrentValsFile=7; %(g)
date='291117_B24';arrayNumber=16;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='291117_B25';arrayNumber=16;electrodeNumber=38;finalCurrentValsFile=7; %(g)
date='291117_B26';arrayNumber=16;electrodeNumber=45;finalCurrentValsFile=7; %(g)
date='291117_B27';arrayNumber=16;electrodeNumber=46;finalCurrentValsFile=7; %(g)
date='291117_B28';arrayNumber=16;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='291117_B29';arrayNumber=16;electrodeNumber=37;finalCurrentValsFile=7; %(g)
date='291117_B30';arrayNumber=16;electrodeNumber=47;finalCurrentValsFile=7; %(g)
date='291117_B31';arrayNumber=16;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='291117_B32';arrayNumber=16;electrodeNumber=57;finalCurrentValsFile=7; %(g)
date='291117_B33';arrayNumber=12;electrodeNumber=33;finalCurrentValsFile=7; %(g)
date='291117_B34';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=7; %(m)
date='291117_B35';arrayNumber=12;electrodeNumber=34;finalCurrentValsFile=7; %(g)
date='291117_B36';arrayNumber=12;electrodeNumber=12;finalCurrentValsFile=7; %(g)
date='291117_B37';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=7; %(g)
date='291117_B38';arrayNumber=12;electrodeNumber=14;finalCurrentValsFile=7; %(m-g)
date='291117_B39';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=7; %(g)
date='291117_B40';arrayNumber=12;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='291117_B41';arrayNumber=12;electrodeNumber=18;finalCurrentValsFile=7; %(g)
date='291117_B42';arrayNumber=12;electrodeNumber=42;finalCurrentValsFile=7; %(g)
date='291117_B43';arrayNumber=14;electrodeNumber=59;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='301117_B1';arrayNumber=16;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='301117_B2';arrayNumber=16;electrodeNumber=38;finalCurrentValsFile=7; %(g)
date='301117_B3';arrayNumber=16;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='301117_B4';arrayNumber=16;electrodeNumber=57;finalCurrentValsFile=7; %(g)
date='301117_B5';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=7; %(g)
date='301117_B6';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=7; %(g)
date='301117_B7';arrayNumber=12;electrodeNumber=50;finalCurrentValsFile=7; %(g)
date='301117_B8';arrayNumber=12;electrodeNumber=18;finalCurrentValsFile=7; %(g)
date='301117_B9';arrayNumber=9;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='301117_B10';arrayNumber=9;electrodeNumber=19;finalCurrentValsFile=7; %(g)
date='301117_B11';arrayNumber=9;electrodeNumber=26;finalCurrentValsFile=7; %(r)
date='301117_B12';arrayNumber=9;electrodeNumber=27;finalCurrentValsFile=7; %(g)
date='301117_B13';arrayNumber=14;electrodeNumber=44;finalCurrentValsFile=7; %(g)
date='301117_B23';arrayNumber=16;electrodeNumber=7;finalCurrentValsFile=7; %(g)
date='301117_B24';arrayNumber=16;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='301117_B25';arrayNumber=16;electrodeNumber=64;finalCurrentValsFile=7; %(g)
date='301117_B26';arrayNumber=16;electrodeNumber=15;finalCurrentValsFile=7; %(m)
date='301117_B27';arrayNumber=16;electrodeNumber=22;finalCurrentValsFile=7; %(g)
date='301117_B28';arrayNumber=16;electrodeNumber=30;finalCurrentValsFile=7; %(g)
date='301117_B29';arrayNumber=8;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='301117_B30';arrayNumber=14;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='301117_B31';arrayNumber=14;electrodeNumber=47;finalCurrentValsFile=7; %(g)
date='301117_B32';arrayNumber=14;electrodeNumber=3;finalCurrentValsFile=7; %(g)
date='301117_B33';arrayNumber=14;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='301117_B34';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=7; %(g)
date='301117_B35';arrayNumber=14;electrodeNumber=54;finalCurrentValsFile=7; %(g)
date='301117_B37';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=7; %(g)
date='301117_B38';arrayNumber=14;electrodeNumber=21;finalCurrentValsFile=7; %(g)
date='301117_B39';arrayNumber=12;electrodeNumber=10;finalCurrentValsFile=7; %(g)
date='301117_B40';arrayNumber=12;electrodeNumber=52;finalCurrentValsFile=7; %(r)%high false alarm rate
date='301117_B41';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=7; %(g)
date='301117_B42';arrayNumber=12;electrodeNumber=4;finalCurrentValsFile=7; %(r)%high false alarm rate
date='301117_B43';arrayNumber=12;electrodeNumber=43;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

date='041217_B1';arrayNumber=16;electrodeNumber=64;finalCurrentValsFile=7; %(g)
date='041217_B6';arrayNumber=14;electrodeNumber=3;finalCurrentValsFile=7; %(r)%high false alarm rate
date='041217_B11';arrayNumber=12;electrodeNumber=43;finalCurrentValsFile=7; %(g)
date='041217_B15';arrayNumber=14;electrodeNumber=3;finalCurrentValsFile=7; %(g)
date='041217_B2';arrayNumber=16;electrodeNumber=15;finalCurrentValsFile=7; %(m)
date='041217_B7';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=7; %(r)%high false alarm rate
date='041217_B12';arrayNumber=12;electrodeNumber=60;finalCurrentValsFile=7; %(r)
date='041217_B3';arrayNumber=16;electrodeNumber=22;finalCurrentValsFile=7; %(r)%high false alarm rate
date='041217_B4';arrayNumber=16;electrodeNumber=30;finalCurrentValsFile=7; %(r)%high false alarm rate
date='041217_B5';arrayNumber=8;electrodeNumber=40;finalCurrentValsFile=7; %(g)
date='041217_B8';arrayNumber=14;electrodeNumber=54;finalCurrentValsFile=7; %(g)
date='041217_B9';arrayNumber=14;electrodeNumber=63;finalCurrentValsFile=7; %(g)
date='041217_B10';arrayNumber=14;electrodeNumber=21;finalCurrentValsFile=7; %(g)
date='041217_B16';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=7; %(g)
date='041217_B17';arrayNumber=12;electrodeNumber=52;finalCurrentValsFile=7; %(g)
date='041217_B18';arrayNumber=12;electrodeNumber=10;finalCurrentValsFile=7; %(g)
date='041217_B26';arrayNumber=16;electrodeNumber=22;finalCurrentValsFile=7; %(r)use lower current values
date='041217_B27';arrayNumber=16;electrodeNumber=30;finalCurrentValsFile=7; %(m-g)
date='041217_B28';arrayNumber=16;electrodeNumber=22;finalCurrentValsFile=7; %(g)
date='041217_B29';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=7; %(g)
useFinalCurrentVals=1;

copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
%read in current amplitude conditions:
%catch trials:
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
%microstim trials:
hits=[];
misses=[];
if useFinalCurrentVals==1
    if finalCurrentValsFile==1%strcmp(date,'150817_B9'), staircase procedure not used
        load([rootdir,date,'\',date,'_data\finalCurrentVals.mat'])
        for currentAmpCond=1:length(finalCurrentVals)/2
            currentAmplitude=finalCurrentVals(currentAmpCond+length(finalCurrentVals)/2);
            currentAmpTrials=find(allCurrentLevel==currentAmplitude);
            hits(currentAmpCond)=length(intersect(microstimAllHitTrials,currentAmpTrials));
            misses(currentAmpCond)=length(intersect(microstimAllMissTrials,currentAmpTrials));
            currentAmplitudes=finalCurrentVals(find(finalCurrentVals~=0));
        end
    else
        if finalCurrentValsFile==2%staircase procedure was used, finalCurrentVals3.mat
            load([rootdir,date,'\',date,'_data\finalCurrentVals3.mat'])
        elseif finalCurrentValsFile==3%staircase procedure was used, finalCurrentVals4.mat
            load([rootdir,date,'\',date,'_data\finalCurrentVals4.mat'])
        elseif finalCurrentValsFile==4%staircase procedure was used, finalCurrentVals4.mat
            load([rootdir,date,'\',date,'_data\finalCurrentVals5.mat'])
        elseif finalCurrentValsFile==5%staircase procedure was used, finalCurrentVals4.mat
            load([rootdir,date,'\',date,'_data\finalCurrentVals6.mat'])
        elseif finalCurrentValsFile==6%staircase procedure was used, finalCurrentVals4.mat
            load([rootdir,date,'\',date,'_data\finalCurrentVals7.mat'])
        elseif finalCurrentValsFile==7%staircase procedure was used, finalCurrentVals4.mat
            load([rootdir,date,'\',date,'_data\finalCurrentVals8.mat'])
        end
        currentAmplitudes=[];
        hits=[];
        misses=[];
        for currentAmpCond=1:length(finalCurrentVals)
            currentAmplitude=finalCurrentVals(currentAmpCond);
            currentAmpTrials=find(allCurrentLevel==currentAmplitude);
            if ~isempty(currentAmpTrials)
                hits=[hits length(intersect(microstimAllHitTrials,currentAmpTrials))];
                misses=[misses length(intersect(microstimAllMissTrials,currentAmpTrials))];
                currentAmplitudes=[currentAmplitudes currentAmplitude];
            end
        end
    end
elseif useFinalCurrentVals==0
    currentAmplitudes=[];
    hits=[];
    misses=[];
    finalCurrentVals=unique(allStimCurrentLevel);
    for currentAmpCond=1:length(finalCurrentVals)
        currentAmplitude=finalCurrentVals(currentAmpCond);
        currentAmpTrials=find(allCurrentLevel==currentAmplitude);
        if ~isempty(currentAmpTrials)
            hits=[hits length(intersect(microstimAllHitTrials,currentAmpTrials))];
            misses=[misses length(intersect(microstimAllMissTrials,currentAmpTrials))];
            currentAmplitudes=[currentAmplitudes currentAmplitude];
        end
    end
%     perfInd=find(performance~=0);
%     q=QuestUpdate(q,log10(intensity(reps,n)),correct);
%         currentthresh(reps,n) = 10.^QuestMean(q);
end
hits./misses;
for Weibull=0:1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
    [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
    hold on
    yLimits=get(gca,'ylim');
    plot([threshold threshold],yLimits,'r:')
    plot([theta theta],yLimits,'k:')
%     text(threshold-10,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
    text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
    ylabel('proportion of trials');
    xlabel('current amplitude (uA)');
    if Weibull==1
        title(['Psychometric function for array',num2str(arrayNumber),' electrode',num2str(electrodeNumber),', Weibull fit.'])
        pathname=fullfile('D:\data',date,['array',num2str(arrayNumber),'_electrode',num2str(electrodeNumber),'_current_amplitudes_weibull']);
    elseif Weibull==0
        title(['Psychometric function for array',num2str(arrayNumber),' electrode',num2str(electrodeNumber),', sigmoid fit.'])
        pathname=fullfile('D:\data',date,['array',num2str(arrayNumber),'_electrode',num2str(electrodeNumber),'_current_amplitudes_sigmoid']);
    end
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    print(pathname,'-dtiff');
end
