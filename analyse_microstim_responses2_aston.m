function analyse_microstim_responses2
%Written by Xing 15/8/17 to plot current amplitudes across microstimulation
%session, for recent sessions. Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
% date='070817_B1';array=13;%array 13, electrode 37 (g)
% date='070817_B2';array=13;%array 13, electrode 37 (g)
% date='070817_B3';array=13;%array 13, electrode 38 (g)

% date='070817_B4';array=13;%array 13, electrode 34
% date='070817_B5';array=13;%array 13, electrode 35
% date='070817_B6';array=1;%array 1, electrode 38
% date='070817_B7';array=1;%array 1, electrode 36
% date='070817_B8';array=1;%array 1, electrode 37
% date='070817_B9';array=1;%array 1, electrode 34
% date='070817_B10';array=9;%array 9, electrode 27
% date='070817_B11';array=9;%array 9, electrode 26

% date='080817_B1';array=10;%array 10, electrode 48 (g)
% date='080817_B2';array=10;%array 10, electrode 38 
% date='080817_B3';array=10;%array 10, electrode 47 (m)
% date='080817_B4';array=10;%array 10, electrode 46 (m), 56 (g), 39, 45 (m)
% date='080817_B5';array=10;%array 10, electrode 59, 37
% date='080817_B6';array=10;%array 10, electrode 40
% 
% date='090817_B1';array=10;%array 10, electrode 38
% date='090817_B2';array=10;%array 10, electrode 45
% date='090817_B3';array=10;%array 10, electrode 48, 38, 47, 46
% date='090817_B4';array=12;%array 12, electrode 57, 22, others
% date='090817_B5';array=10;%array 10, electrode 48
% date='090817_B6';array=10;%array 10, electrode 56
% 
% date='100817_B1';array=13;%array 13, electrode 35 (m), 33, 34

% date='140817_B1';array=13;%array 13, electrode 41 (g)
% date='140817_B2';array=13;%array 13, electrode 37 (g)
% date='140817_B8';array=13;%array 13, electrode 37 (g)
% date='140817_B9';array=13;%array 13, electrode 41 (g)

load(['X:\best\',date,'\',date,'_data\microstim_saccade_',date,'.mat'])
% load('C:\Users\Xing\Lick\saccade_task_logs\microstim_saccade_140817_B8.mat')
microstimAllHitTrials=intersect(find(allWhichTarget==1),find(performance==1));
a=find(performance==1);
b=find(allWhichTarget==1);
microstimAllMissTrials=intersect(find(allWhichTarget==2),find(performance==1));
microstimAllResponseTrials=intersect(find(allWhichTarget>0),find(performance==1));
electrodeNums=unique(cell2mat(allElectrodeNum(microstimAllResponseTrials)));%identify the electrodes on which microstim was delivered
allElectrodeNum=cell2mat(allElectrodeNum);
allArrayNum=cell2mat(allArrayNum);
for electrodeInd=1:length(electrodeNums)
    electrode=electrodeNums(electrodeInd);
    microstimHitTrials=intersect(microstimAllHitTrials,find(allElectrodeNum==electrode));
    microstimMissTrials=intersect(microstimAllMissTrials,find(allElectrodeNum==electrode));
    microstimResponseTrials=intersect(microstimAllResponseTrials,find(allElectrodeNum==electrode));
    tGuess=40;
    tGuessSd=30;
    range=30;
    pThreshold=0.82;
    beta=3.5;delta=0.01;gamma=0.5;
    q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma,[],range);
    q.normalizePdf=1; % This adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.
    col=[];
    for k=1:length(microstimResponseTrials)
        % Update the pdf
        if allWhichTarget(microstimResponseTrials(k))==1
            response=1;
            col=[col;0 0 0];
        elseif allWhichTarget(microstimResponseTrials(k))==2
            response=0;
            col=[col;1 0 0];
        end
        q=QuestUpdate(q,allCurrentLevel(microstimResponseTrials(k)),response); % Add the new datum (actual test intensity and observer response) to the database.
    end
    if length(microstimResponseTrials)>20
        scatter(1:length(microstimResponseTrials),allCurrentLevel(microstimResponseTrials),14,col);
        hold on
%         figure;hold on
%         scatter(1:length(microstimResponseTrials),allCurrentLevel(microstimResponseTrials));
%         figure;hold on
        plot(1:length(microstimResponseTrials),allCurrentLevel(microstimResponseTrials));
        ylabel('current amplitude (uA)');
        xlabel('trial number');
        title(['Current amplitude across microstimulation session. Black (',num2str(length(microstimHitTrials)),'): hit; Red (',num2str(length(microstimMissTrials)),'): miss. N trials = ',num2str(length(microstimResponseTrials))])
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile('D:\data',date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes']);
        print(pathname,'-dtiff');
        
        % Ask Quest for the final estimate of threshold.
        t=QuestMean(q);		% Recommended by Pelli (1989) and King-Smith et al. (1994). Still our favorite.
        sd=QuestSd(q);
        fprintf('Final threshold estimate (mean+-sd) is %.2f +- %.2f\n',t,sd);
    end
end