function analyse_CheckSNR2_aston_batch
%Written by Xing 6/7/20. Runs batch file on SNR data, using corrected SNR
%code (calculate SD of baseline using MUA, not using mean MUA).

for sessionInd=13:15
    switch sessionInd
        case 1
            date='280818_B1_aston'
            whichDir=2;
        case 2
            date='031018_B2_aston'
            whichDir=1;
        case 3
            date='031018_B4_aston'
            whichDir=1;
        case 4
            date='041018_B2_aston'
            whichDir=1;
        case 5
            date='071118_B1_aston'
            whichDir=1;
        case 6
            date='201118_B11_aston'
            whichDir=1;
        case 7
            date='181218_B1_aston'
            whichDir=1;
        case 8
            date='170419_B1_aston'
            whichDir=1;
        case 9
            date='010319_B1_aston'
            whichDir=2;
        case 10
            date='170419_B1_aston'
            whichDir=1;
        case 11
            date='260419_B1_aston'
            whichDir=1;
        case 12
            date='260419_B2_aston'
            whichDir=1;
        case 13
            date='140819_B2_aston'
            whichDir=1;
        case 14
            date='150819_B2_aston'
            whichDir=1;
        case 15
            date='160819_B2_aston'
            whichDir=1;
    end
    whichDir=2;
    analyse_CheckSNR2_aston(date)
end