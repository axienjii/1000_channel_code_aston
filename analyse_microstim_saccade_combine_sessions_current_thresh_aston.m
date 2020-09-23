function analyse_microstim_saccade_combine_sessions_current_thresh_aston
%Written by Xing 25/5/20
%Calls function, 'analyse_microstim_saccade14_combine_sessions_read_current' to read in
%current amplitudes, for high and medium amplitude conditions.

dates={
    '110918_B3_aston';
    '110918_B5_aston';
    '110918_B6_aston';
    '110918_B7_aston';
    '110918_B8_aston';
    '120918_B1_aston';
    '130918_B1_aston';
    '140918_B1_aston';
    '140918_B2_aston';
    '190918_B1_aston';
    '190918_B2_aston';
    '200918_B1_aston';
    '210918_B1_aston';
    '240918_B1_aston';
    '250918_B1_aston';
    '260918_B1_aston';
    '270918_B1_aston';
    '280918_B1_aston';
    '081018_B1_aston';
    '161018_B1_aston';
    '171018_B1_aston';
    '181018_B1_aston';
    '191018_B1_aston';
    '191018_B2_aston';
    '221018_B1_aston';
    '231018_B1_aston';%missing?
    '241018_B2_aston';
    '261018_B1-B6_aston';%261018_B1-B5 missing?
    '261018_B6_aston';
    '061118_B2_aston';
    '061118_B3_aston';
    '061118_B4_aston';
    '071118_B2_aston';
    '071118_B3_aston';
    '071118_B4_aston';
    '081118_B1_aston';
    '081118_B3_aston';
    '091118_B1_aston';
    '091118_B3_aston';
    '131118_B1_aston';
    '131118_B3_aston';
    '141118_B1_aston';
    '141118_B6-B9_aston';%B6-B8 missing?
    '141118_B9_aston';
    '151118_B1-B3_aston';%B1-B2 missing?
    '151118_B3_aston';
    '151118_B7_aston';
    '161118_B1-B2_aston';%B1 missing?
    '161118_B2_aston';
    '161118_B8-B9_aston';%B8-B9 missing?
    '191118_B1-B4_aston';
    '191118_B4_aston';
    '191118_B8_aston';
    '191118_B10-B12_aston';%B10-B11 missing?
    '191118_B12_aston';
    '201118_B1-B8_aston';
    '201118_B10_aston';
    '211118_B1-B2_aston';
    '221118_B1-B3_aston';
    '221118_B6-B8_aston';
    '231118_B1-B3_aston';
    '261118_B1-B4_aston';
    '261118_B8-B9_aston';
    '261118_B15_aston';
    '271118_B4-B5_aston';
    '281118_B1-B4_aston';
    '291118_B5_aston';
    '291118_B7-B8_aston';
    '031218_B4_aston';
    '041218_B1_aston';
    '041218_B8_aston';
    '051218_B1-B2_aston';
    '061218_B1_aston';
    '061218_B3_aston';
    '071218_B4_aston';
    '101218_B1-B3_aston';
    '121218_B1-B2_aston';
    '121218_B5_aston';
    '121218_B11_aston';
    '141218_B1-B2_aston';
    '141218_B5_aston';
    '141218_B8-B10_aston';
    '171218_B1_aston';
    '171218_B5-B7_aston';
   };

suprathresholdCurrent=1;%set to 1 to use conditions with high current amplitudes, with no hits accrued. Set to 0 to use conditions with lower current amplitudes instead
differentCriteria=0;
if differentCriteria==1
    ind=strfind(dates,'221018_B1_aston');
    removeInd=find(not(cellfun('isempty',ind)));
    dates=dates([1:removeInd-1 removeInd+1:end]);
    ind=strfind(dates,'241018_B2_aston');
    removeInd=find(not(cellfun('isempty',ind)));
    dates=dates([1:removeInd-1 removeInd+1:end]);
end

for dateInd=1:length(dates)
    date=dates{dateInd};
    astonInd=strfind(date,'_aston');
    date(astonInd:astonInd+5)=[];
    hyphenInd=find(date=='-');
    if ~isempty(hyphenInd)
        bInd=find(date=='B');
        firstSessionNum=str2num(date(bInd(1)+1:hyphenInd-1));
        lastSessionNum=str2num(date(bInd(2)+1:end));
        sessionNums=firstSessionNum:lastSessionNum;
        for sessionInd=1:length(sessionNums)
            dates{dateInd,sessionInd}=[date(1:bInd(1)),num2str(sessionNums(sessionInd))];
        end
    end
end
datesReshape=reshape(dates,1,size(dates,1)*size(dates,2));
dates=datesReshape(~cellfun('isempty',datesReshape));

readData=0;
for suprathresholdCurrent=[0]
    extractCurrentOnly=1;
    calcThresholdList={};
    if readData==1
        for dateInd=1:length(dates)
            close all
            try
                if extractCurrentOnly==1
                    calThresholdList=analyse_microstim_saccade14_combine_sessions_read_current_aston(dates{dateInd},1,calcThresholdList);
                    close all
                end
            catch ME
                dates{dateInd}
            end
        end
    end
end

localDisk=0;
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end

allMaxCurrentListAllTrials=[];
allMidCurrentListAllTrials=[];
figure;hold on
allElectrodeAllTrials=[];
allArrayAllTrials=[];
allElectrodeAllTrialsMax=[];
allArrayAllTrialsMax=[];
allElectrodeAllTrialsMid=[];
allArrayAllTrialsMid=[];
allProportionc50Max=[];
allProportionc50Mid=[];
for dateInd=1:length(dates)
    date=dates{dateInd};
    if extractCurrentOnly==1
        fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_max_amp_list.mat'];
        if exist(fileName,'file')
            load(fileName);
            indRemove1=find(allElectrodeNumsMax==0);
            if ~isempty(indRemove1)
                allElectrodeNumsMax(indRemove1)=[];
                allArrayNumsMax(indRemove1)=[];
            end
            if length(allElectrodeNumsMax)==length(allMaxCurrentList)%&&length(allElectrodeNumsList)==length(proportionc50Max)
                maxElectrodesArrays=[allElectrodeNumsMax' allArrayNumsMax'];
                if ~isempty(indRemove1)
                    allMaxCurrentList(indRemove1)=[];
                end
                allMaxCurrentListAllTrials=[allMaxCurrentListAllTrials allMaxCurrentList];
                allElectrodeAllTrialsMax=[allElectrodeAllTrialsMax allElectrodeNumsMax];
                allArrayAllTrialsMax=[allArrayAllTrialsMax allArrayNumsMax];
            else
                pauseHere=1;
            end
        end
        fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_mid_amp_list.mat'];
        if exist(fileName,'file')
            load(fileName);
            indRemove1=find(allElectrodeNumsMid==0);
            if ~isempty(indRemove1)
                allElectrodeNumsMid(indRemove1)=[];
                allArrayNumsMid(indRemove1)=[];
            end
            if length(allElectrodeNumsMid)==length(allMidCurrentList)%&&length(allElectrodeNumsList)==length(proportionc50Mid)
                minElectrodesArrays=[allElectrodeNumsMid' allArrayNumsMid'];
                if ~isempty(indRemove1)
                    allMidCurrentList(indRemove1)=[];
                end
                allMidCurrentListAllTrials=[allMidCurrentListAllTrials allMidCurrentList];
                allElectrodeAllTrialsMid=[allElectrodeAllTrialsMid allElectrodeNumsMid];
                allArrayAllTrialsMid=[allArrayAllTrialsMid allArrayNumsMid];
            end
        end
    end
end

%load in previous channel and array numbers, for reference:
load('D:\aston_data\saccade_endpoints_110918_B3_aston-201118_B8_max_amp.mat');
uniqueElectrodeListMax=uniqueElectrodeList;
uniqueArrayListMax=uniqueArrayList;
channelIDsMax=[uniqueElectrodeListMax' uniqueArrayListMax'];
load('D:\aston_data\saccade_endpoints_110918_B3_aston-201118_B8_mid_amp.mat');
uniqueElectrodeListMid=uniqueElectrodeList;
uniqueArrayListMid=uniqueArrayList;
channelIDsMid=[uniqueElectrodeListMid' uniqueArrayListMid'];

%find intersecting channels, from high and medium current conditions
[intersectRows indMax indMid]=intersect(channelIDsMax,channelIDsMid,'rows');

% channelIDsMax=[allElectrodeAllTrialsMax' allArrayAllTrialsMax'];
% channelIDsMid=[allElectrodeAllTrialsMid' allArrayAllTrialsMid'];
% [intersectRows indMax indMid]=intersect(channelIDsMax,channelIDsMid,'rows');
electrodeNums=intersectRows(:,1);
arrayNums=intersectRows(:,2);
for uniqueElectrode=1:length(electrodeNums)
    uniqueElectrodeList(uniqueElectrode)=electrodeNums(uniqueElectrode);
    uniqueArrayList(uniqueElectrode)=arrayNums(uniqueElectrode);
    if suprathresholdCurrent==1
        temp1=find(allElectrodeAllTrialsMax==electrodeNums(uniqueElectrode));
        temp2=find(allArrayAllTrialsMax==arrayNums(uniqueElectrode));
        ind=intersect(temp1,temp2);
        allMaxCurrentUnique(uniqueElectrode)={allMaxCurrentListAllTrials(ind)};
%         allProportionc50MaxUnique(uniqueElectrode)={allProportionc50Max(ind)};
    elseif suprathresholdCurrent==0
        temp1=find(allElectrodeAllTrialsMid==electrodeNums(uniqueElectrode));
        temp2=find(allArrayAllTrialsMid==arrayNums(uniqueElectrode));
        ind=intersect(temp1,temp2);
        allMidCurrentUnique(uniqueElectrode)={allMidCurrentListAllTrials(ind)};
%         allProportionc50MidUnique(uniqueElectrode)={allProportionc50Mid(ind)};
    end
end
indRemove=find(uniqueElectrodeList==0);
uniqueElectrodeList(indRemove)=[];
uniqueArrayList(indRemove)=[];

%load lowest current threshold values:
load('D:\aston_data\meanThresholds_Aston.mat')
% load('D:\aston_data\lowestThresholds_Aston.mat')
for chInd=1:length(intersectRows)
    temp1=find(astonMeanThresholds(:,2)==intersectRows(chInd,1));
    temp2=find(astonMeanThresholds(:,1)==intersectRows(chInd,2));
    ind=intersect(temp1,temp2);
    if ~isempty(ind)
        thresholdFinal(chInd)=astonMeanThresholds(ind,3);
    end
end
for chInd=1:length(electrodeNums)
    if ~isempty(allMaxCurrentUnique)&&~isempty(allMidCurrentUnique)
       meanMax(chInd)=mean(allMaxCurrentUnique{chInd}); 
       meanMid(chInd)=mean(allMidCurrentUnique{chInd}); 
%        meanProportionc50Max(chInd)=mean(allProportionc50MaxUnique{chInd}); 
%        meanProportionc50Mid(chInd)=mean(allProportionc50MidUnique{chInd}); 
    end
end

%remove channel(s) where no threshold obtained:
removeInd=find(thresholdFinal==0);
thresholdFinal(removeInd)=[];
meanMax(removeInd)=[];
meanMid(removeInd)=[];

removeInd=isnan(meanMax);
removeInd=find(removeInd==1);
thresholdFinal(removeInd)=[];
meanMax(removeInd)=[];
meanMid(removeInd)=[];
proportionC50Max=meanMax./thresholdFinal;
proportionC50Mid=meanMid./thresholdFinal;

grandMeanProportionc50Max=nanmean(proportionC50Max)
grandStdProportionc50Max=nanstd(proportionC50Max)
grandMeanProportionc50Mid=nanmean(proportionC50Mid)
grandStdProportionc50Mid=nanstd(proportionC50Mid)

proportion=meanMid./meanMax;
meanProportion=nanmean(proportion);
stdProportion=nanstd(proportion);
