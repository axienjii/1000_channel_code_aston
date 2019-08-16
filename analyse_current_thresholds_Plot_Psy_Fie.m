function [Theta threshold50]=analyse_current_thresholds_Plot_Psy_Fie(Current,N_Seen,N_Miss,N_FA,N_CR,Weibull)
%Modified from Pieter's Plot_Psy_Fie code. Determines current
%thresholds for a given electrode and array and generates fitted curve
%using either a Weibull or a sigmoid function.
% close all

% Weibull = 0; % set to 1 to get the Weibull fit, 0 for a sigmoid fit
% Current=[25	28	31	35	39	43	48	53	59	66	73	81	90	100]; % the current values
% N_Seen = [0	 0	0	0	0	0	1	5	4	9	16	10	22	28];
% N_Miss = [46 46	46	46	46	46	45	41	42	37	30	36	24	18];
% N_FA = 49;
% N_CR = 644;
N_Trials = N_Seen + N_Miss;
N_Catch = N_FA + N_CR;

P_Hit = N_Seen./N_Trials; % probability of hit
P_Miss = N_Miss./N_Trials;
P_FA = N_FA/(N_FA+N_CR);
SEM = sqrt(P_Hit.*(1-P_Hit)./N_Trials);
SEM_FA = sqrt(P_FA*(1-P_FA)/N_Catch);


% Some preparation for the curve fitting 
% starting values

MaxSlope=100;
MaxPerf = 0.99;                         % the parameter that determines asymptotic performance
Slope = 0.1;                             % slope of the psychometric function
Thresh = 50;                             % threshold value of the function

StartVals = [P_FA MaxPerf Slope Thresh]; % starting values of the fit parameters
MinVals = [0 0 0.1 0];                   % minimum values of parameters
MaxVals = [1 1 MaxSlope 1000];           % maximum values of parameters

% some presetting of the fitting process
options = optimset('MaxFunEvals',5000,'MaxIter',5000);

% doing the fit
if Weibull
  [x,fval] = fminsearchbnd(@(x) LLHWeibullComputeFit(x,Current,N_Trials,N_Seen,N_Catch,N_CR),StartVals,MinVals,MaxVals,options);
else
  [x,fval] = fminsearchbnd(@(x) LLHComputeFit(x,Current,N_Trials,N_Seen,N_Catch,N_CR),StartVals,MinVals,MaxVals,options);
end


% plot the result
CurrentVals = (1:Current(end)*2)*0.5;
if Weibull
  Perf = LumWeibull(CurrentVals, x(1), x(2), x(3), x(4));
else
  Perf = LumSigmoid(CurrentVals, x(1), x(2), x(3), x(4));
end
ind50=find(Perf<=0.5);
if isempty(ind50)
    threshold50=CurrentVals(1);
else
    ind50=ind50(end);
    threshold50=CurrentVals(ind50);
end
Slope=x(3);
Theta=x(4);
% figure('Name','Psychometric function')
plot(CurrentVals,Perf);                     % plot the fitted function
hold on;

errorbar([0 Current],[P_FA P_Hit],[SEM_FA,SEM],'bo')
hold off;

['Threshold ',num2str(Theta),' uA']
