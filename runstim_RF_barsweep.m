function runstim_RF_barsweep(T_Trl)

global Par   %global parameters

FixWinSizex = 1.1; 
FixWinSizey = 1.1;

%Plot marker at RF loc
% RFon = 0;

rand('state',sum(clock))

%Global properties -assumes 85Hz
frame = 1./85;

%Dot sizes
FixDotSize = 0.6;
FixPix = Par.PixPerDeg.*FixDotSize;
TargSz = 0.8.*Par.PixPerDeg;
Px = 0;
Py = 0;

%Receptive field guesses in pixels
RFx = (512/2)-2.*Par.PixPerDeg; %Subtract off about 2 degress so the bar goes a little into the other hemifield
RFy = -(384/2); %or plus for upper 
% change to pos or neg

% RFxa = [-50 -70  -50 -80 -100]; % Darwin, guess based on flash map
% RFya = [-50 -50 -100 -70  -60]; % Darwin

%Tracker times
FIXT = 200; %time to fix before stim onset
% STIMT = 1000; %800 %time to target
STIMT = 1250; 
%STIMT is the exposure time of the RF mapping bar

%Timing properties
BarDur = STIMT./1000;
BarDurFrame = round(BarDur./frame);
%This is speed in degrees per second
BarSpeed = 15.75.*Par.PixPerDeg; %Gives abotu 512 pixels at 1.25s 15.75
%actual dist5.75nce covered by bar in stimulus time
BarDist = BarSpeed.*BarDur;

%Bar properties
BarCol = [1 1 1];
BarThick = 1.*Par.PixPerDeg; %in degrees
BarLength = 2000; %This is half the bar length (in pixels)

%0 = left to right, 90 = down-to-up, 180 = right to left, 270 = up to down
Ang = [0 90 180 270];

Times = Par.Times; %copy timing structure
BG = [0.5 0.5 0.5]; %background Color

%Create log file
LOG.fn = 'runstim_RFauto';
LOG.BG = BG;
LOG.Par = Par;
LOG.Ang = Ang;
LOG.Times = Times;
LOG.BarDur = BarDur;
LOG.BarSpeed = BarSpeed;
LOG.BarCol = BarCol;
LOG.BarThick = BarThick;
LOG.BarLength = BarLength;
LOG.BarDist = BarDist;
LOG.Frame = frame;
LOG.FIXT = FIXT;
LOG.STIMT = STIMT;
LOG.RFx = RFx;
LOG.RFy = RFy;
LOG.ScreenX = 1024;
LOG.Screeny = 768;

mydir = 'C:\Users\ninuser\Documents\MATLAB\TrackerTraining_Martin\';
fn = input('Enter LOG file name (e.g. 20110413_B1), blank = no file\n','s');
if isempty(fn)
    logon = 0;
else
    logon = 1;
    fn = [mydir,'RF_barsweep_',fn];
    save(fn,'LOG')
end

%Copy the run stime
fnrs = [fn,'_','runstim.m'];
cfn = [mfilename('fullpath') '.m'];
copyfile(cfn,fnrs)

RANDTAB = randperm(4);

%////YOUR STIMULATION CONTROL LOOP /////////////////////////////////
Hit = 2;
TZ = 0;
%timing
PREFIXT = Times.ToFix; %time to enter fixation window

%Windows (fix and target)
WIN = [0 0 Par.PixPerDeg.*FixWinSizex Par.PixPerDeg.*FixWinSizey 0];
Par.WIN = WIN';
Par.ESC = false; %escape has not been pressed

while ~Par.ESC
    %Pretrial

    %randomization
    %The four directions to sweep
    I = RANDTAB(1);

    %Spatial properties
    BarStartx = RFx-(cosd(Ang(I)).*(BarDist./2));
    BarStarty = RFy-(sind(Ang(I)).*(BarDist./2));
    BarEndx = RFx+(cosd(Ang(I)).*(BarDist./2));
    BarEndy = RFy+(sind(Ang(I)).*(BarDist./2));

    %Speed
    BarSpeedx = (BarEndx-BarStartx)./BarDurFrame;
    BarSpeedy = (BarEndy-BarStarty)./BarDurFrame;

    %Word bit = direction
    dasword(I);

    %/////////////////////////////////////////////////////////////////////
    %START THE TRIAL
    %set control window positions and dimensions
    refreshtracker(1) %for your control display
    SetWindowDas      %for the dascard
    Abort = false;    %whether subject has aborted before end of trial

    %///////// EVENT 0 START FIXATING //////////////////////////////////////
    Par.Updatxy = 1;
    cgellipse(Px,Py,FixPix,FixPix,[1,0,0],'f') %the red fixation dot on the screen
    cgflip(BG(1), BG(2), BG(3))

    dasreset(0)
    %subject has to start fixating central dot
    Par.SetZero = false; %set key to false to remove previous presses
    Par.Updatxy = 1; %centering key is enabled
    Time = 1;
    Hit = 0;
    while Time < PREFIXT && Hit == 0
        dasrun(5)
        [Hit Time] = DasCheck; %retrieve position values and plot on Control display
    end

    %///////// EVENT 1 KEEP FIXATING or REDO  ////////////////////////////////////
    Par.Updatxy = 1;
    if Hit ~= 0  %subjects eyes are in fixation window keep fixating for FIX time
        dasreset(1);     %test for exiting fix window

        Time = 1;
        Hit = 0;
        while Time < FIXT && Hit == 0
            %Check for 5 ms
            dasrun(5)
            %or just pause for 5ms?
            [Hit Time] = DasCheck;
        end

        if Hit ~= 0 %eye has left fixation to early
            %possibly due to eye overshoot, give another chance
            dasreset(0);
            Time = 1;
            Hit = 0;
            while Time < PREFIXT && Hit == 0
                dasrun(5)
                [Hit Time] = DasCheck; %retrieve position values and plot on Control display
            end
            if Hit ~= 0  %subjects eyes are in fixation window keep fixating for FIX time
                dasreset(1);     %test for exiting fix window

                Time = 1;
                Hit = 0;
                while Time < FIXT && Hit == 0
                    %Check for 5 ms
                    dasrun(5)
                    %                     dasrun(5)
                    [Hit Time] = DasCheck;
                end
            else
                Hit = -1; %the subject did not fixate
            end
        end

    else
        Hit = -1; %the subject did not fixate
    end

    %///////// EVENT 2 DISPLAY STIMULUS //////////////////////////////////////
    if Hit == 0 %subject kept fixation, display stimulus
        Par.Updatxy = 1;

        dasreset(1); %test for exiting fix window
        Time = 0;
        StimFlg = true;
        stimbitdone = 0;
        cgpenwid(BarThick)
        while Time < STIMT && Hit == 0  %Keep fixating till target onset

            cgellipse(Px,Py,FixPix,FixPix,[1,0,0],'f') %the red fixation dot on the screen

            %Centre of Bar, update x and y position
            if ~stimbitdone
                Barx = BarStartx;
                Bary = BarStarty;
            else
                Barx = Barx+BarSpeedx;
                Bary = Bary+BarSpeedy;
            end

            %Bar begin and end
            BarAng = Ang(I)+90;
            x1 = Barx-(cosd(BarAng).*(BarLength));
            x2 = Barx+(cosd(BarAng).*(BarLength));
            y1 = Bary-(sind(BarAng).*(BarLength));
            y2 = Bary+(sind(BarAng).*(BarLength));

            cgdraw(x1,y1,x2,y2,BarCol)
%             if RFon
%                 for r = 1:length(RFxa)
%                     cgellipse(RFxa(r),RFya(r),20,20,[1,0,1],'f')
%                 end
%             end
            
            cgflip(BG(1), BG(2), BG(3));
            if ~stimbitdone
                dasbit(Par.StimB, 1);
                stimbitdone = 1;
            end

            %..............................................................
            if Time > STIMT && StimFlg %present stim no longer than stim time
                StimFlg = false;
            end
            
            %Check for 5 ms
            dasrun(2)
            [Hit Time] = DasCheck;
            
        end


        %///////// EVENT 3 TARGET ONSET, REACTION TIME //////////////////////////////////////
        Par.Updatxy = 1;
        if Hit == 0 %subject kept fixation
            cgellipse(0,0,TargSz,TargSz,[0.6,0.2,0.6],'f') %the red fixation dot on the screen
            cgflip(BG(1), BG(2), BG(3))
            dasbit(Par.TargetB, 1);
            %EXTRACT USING THE TARGETB
            %Update counter
            TZ = TZ+1;
            MAT(TZ,:) = [I,Ang(I),1];
            Hit = 2;
        else
            Abort = true;
        end


        %END EVENT 3
    else
        Abort = true;
    end
    %END EVENT 2

    %///////// POSTTRIAL AND REWARD //////////////////////////////////////
    if Hit ~= 0 && ~Abort %has entered a target window (false or correct)

%         if Par.Mouserun
%             HP = line('XData', Par.ZOOM * (LPStat(2) + Par.MOff(1)), 'YData', Par.ZOOM * (LPStat(3) + Par.MOff(2)), 'EraseMode','none');
%         else
%             HP = line('XData', Par.ZOOM * LPStat(2), 'YData', Par.ZOOM * LPStat(3), 'EraseMode','none');
%         end
%         set(HP, 'Marker', '+', 'MarkerSize', 20, 'MarkerEdgeColor', 'm')
        
        if Hit == 2

            dasbit(Par.CorrectB, 1);
            
           
            Par.Corrcount = Par.Corrcount + 1;
            
            dasbit(Par.RewardB, 1);
            dasjuice(5);
            pause(Par.RewardTime) %RewardTime is in seconds
            dasjuice(0.0);
            
            dasbit(Par.RewardB, 0);

            %Remove trial
            RANDTAB(1) = [];
            if ~length(RANDTAB)
                RANDTAB = randperm(4);
            end
        
        else
            Hit = 0;
        end

        %keep following eye motion
        dasrun(5)
        DasCheck; %keep following eye motion

    end

    %///////////////////////INTERTRIAL AND CLEANUP

%     display([ num2str(Hit) '  ' num2str(LPStat(5)) '  ' num2str(LPStat(6))  '  ' num2str(Time - LPStat(6)) ]);

    %reset all bits to null
    for i = [0 1 2 3 4 5 6 7]  %Error, Stim, Saccade, Trial, Correct,
        dasbit(i, 0);
    end
    dasclearword

    %Par.Trlcount = Par.Trlcount + 1;  %counts total number of trials for this session
    %tracker('update_trials', gcbo, [], guidata(gcbo)) %displays number of trials, corrects and errors
    Par.Trlcount = Par.Trlcount + 1;  %counts total number of trials for this session
    SCNT = {'TRIALS'};
    SCNT(2) = { ['N: ' num2str(Par.Trlcount) ]};
    SCNT(3) = { ['C: ' num2str(Par.Corrcount) ] };
    SCNT(4) = { ['E: ' num2str(Par.Errcount) ] };
    set(T_Trl, 'String', SCNT ) %display updated numbers in GUI

    [Hit T] = DasCheck;
    %      cgrect(465,-370,50,50,[1,1,1])
    cgflip(BG(1), BG(2), BG(3))
    %  pause( Times.InterTrial/1000 ) %pause is called with seconds
    %Times.InterTrial is in ms

    
    if TZ > 0
        save(fn,'LOG','MAT')
    end
end   %WHILE_NOT_ESCAPED%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
