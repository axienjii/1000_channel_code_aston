function [Tuning_Amplitude,Width,Perc_Var_acc, Prefered_SF, Bandwidth, Baseline_FR, pFit]=Wrapped_Gaus_SF(Response,STD,chInd)
%Modified by Xing on 15/8/18 to fit SF data with a wrapped Gaussian
%and analyse SF tuning.
global ERR
sf = [0.5 1 2 4 8];
[C_Max,I_Max]=max(Response);
I_Max=I_Max*15-15;
[C_Min,I_Min]=min(Response);
I_Min=I_Min*15-15;
Initial_Width=30;
xgrid=linspace(0,180,1800);
options = optimset( 'Display' , 'off', ...
    'LargeScale', 'off',...
    'MaxFunEvals',10^4, ...
    'MaxIter', 10^8);

% [coefEsts_Pre,fval_Pre,exitflag_Pre,output_Pre]=fminunc(@Wrapped_Gaus,[C_Max-C_Min I_Max Initial_Width C_Min],options,Response,STD);
% 
% Y_Pre=coefEsts_Pre(1).*(exp((-(xgrid-coefEsts_Pre(2)+360*(-5)).^2)./(2*coefEsts_Pre(3).^2))+exp((-(xgrid-coefEsts_Pre(2)+360*(-4)).^2)./(2*coefEsts_Pre(3).^2))+...
%     exp((-(xgrid-coefEsts_Pre(2)+360*(-3)).^2)./(2*coefEsts_Pre(3).^2))+exp((-(xgrid-coefEsts_Pre(2)+360*(-2)).^2)./(2*coefEsts_Pre(3).^2))+...
%     exp((-(xgrid-coefEsts_Pre(2)+360*(-1)).^2)./(2*coefEsts_Pre(3).^2))+exp((-(xgrid-coefEsts_Pre(2)+360*(0)).^2)./(2*coefEsts_Pre(3).^2))+...
%     exp((-(xgrid-coefEsts_Pre(2)+360*(1)).^2)./(2*coefEsts_Pre(3).^2))+exp((-(xgrid-coefEsts_Pre(2)+360*(2)).^2)./(2*coefEsts_Pre(3).^2))+...
%     exp((-(xgrid-coefEsts_Pre(2)+360*(3)).^2)./(2*coefEsts_Pre(3).^2))+exp((-(xgrid-coefEsts_Pre(2)+360*(4)).^2)./(2*coefEsts_Pre(3).^2))+...
%     exp((-(xgrid-coefEsts_Pre(2)+360*(5)).^2)./(2*coefEsts_Pre(3).^2)))+coefEsts_Pre(4);
% 
% [C_Max_Y_Pre,I_Max_Y_Pre]=max(Y_Pre);
% [C_Min_Y_Pre,I_Min_Y_Pre]=min(Y_Pre);
% 
% Half_Max=C_Min_Y_Pre+(C_Max_Y_Pre-C_Min_Y_Pre)*(50/100);
% Beg=find(Y_Pre>=Half_Max);
% End=Beg(end);
% Beg=Beg(1);
% 
% Width=(End-Beg)/10;

%[coefEsts,fval,exitflag,output]=fminunc(@Wrapped_Gaus,[C_Max_Y_Pre-C_Min_Y_Pre I_Max Width/2 C_Min_Y_Pre],options,Response,STD);
    [coefEsts,fval,exitflag,output]=fminunc(@Wrapped_GausSF,[C_Max-C_Min I_Max Initial_Width C_Min],options,Response,STD);

    % % Wrapped Gaussian -5 to 5
    Y=coefEsts(1).*(exp((-(xgrid-coefEsts(2)+180*(-5)).^2)./(2*coefEsts(3).^2))+exp((-(xgrid-coefEsts(2)+180*(-4)).^2)./(2*coefEsts(3).^2))+...
        exp((-(xgrid-coefEsts(2)+180*(-3)).^2)./(2*coefEsts(3).^2))+exp((-(xgrid-coefEsts(2)+180*(-2)).^2)./(2*coefEsts(3).^2))+...
        exp((-(xgrid-coefEsts(2)+180*(-1)).^2)./(2*coefEsts(3).^2))+exp((-(xgrid-coefEsts(2)+180*(0)).^2)./(2*coefEsts(3).^2))+...
        exp((-(xgrid-coefEsts(2)+180*(1)).^2)./(2*coefEsts(3).^2))+exp((-(xgrid-coefEsts(2)+180*(2)).^2)./(2*coefEsts(3).^2))+...
        exp((-(xgrid-coefEsts(2)+180*(3)).^2)./(2*coefEsts(3).^2))+exp((-(xgrid-coefEsts(2)+180*(4)).^2)./(2*coefEsts(3).^2))+...
        exp((-(xgrid-coefEsts(2)+180*(5)).^2)./(2*coefEsts(3).^2)))+coefEsts(4);
    [C_Max_Y,I_Max_Y]=max(Y);
    [C_Min_Y,I_Min_Y]=min(Y);
    
    Half_Max=C_Min_Y+(C_Max_Y-C_Min_Y)*(50/100);
    [C_Max_Y_Pre,I_Max_Y_Pre]=max(Y);
    [C_Min_Y_Pre,I_Min_Y_Pre]=min(Y);
    
    Half_Max=C_Min_Y_Pre+(C_Max_Y_Pre-C_Min_Y_Pre)*(50/100);
    Beg=find(Y>=Half_Max);
    End=Beg(end);
    Beg=Beg(1);

    Width=coefEsts(3);
    
    Tuning_Amplitude=C_Max_Y-C_Min_Y;
    Prefered_SF=I_Max_Y/10;
    Bandwidth=(Width/2);
    Baseline_FR=C_Min_Y;
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplotInd=mod(chInd,20);
    if subplotInd==0
        subplotInd=20;
    end
    if subplotInd==1
        figure;
    end
    subplot(4,5,subplotInd);
    ResponseForFig=[Response Response(1)];
    plot(sf,ResponseForFig,'o','Color','b');
    %%%%%%%%%%%% for computing the goodness of fit with chi square test %%%%%%%%%%%%%%%%%%%%%%%%
% %     Wrapped Gaussian -5 to 5
    fitted_ResponseForFig=coefEsts(1).*(exp((-(sf-coefEsts(2)+180*(-5)).^2)./(2*coefEsts(3).^2))+exp((-(sf-coefEsts(2)+180*(-4)).^2)./(2*coefEsts(3).^2))+...
        exp((-(sf-coefEsts(2)+180*(-3)).^2)./(2*coefEsts(3).^2))+exp((-(sf-coefEsts(2)+180*(-2)).^2)./(2*coefEsts(3).^2))+...
        exp((-(sf-coefEsts(2)+180*(-1)).^2)./(2*coefEsts(3).^2))+exp((-(sf-coefEsts(2)+180*(0)).^2)./(2*coefEsts(3).^2))+...
        exp((-(sf-coefEsts(2)+180*(1)).^2)./(2*coefEsts(3).^2))+exp((-(sf-coefEsts(2)+180*(2)).^2)./(2*coefEsts(3).^2))+...
        exp((-(sf-coefEsts(2)+180*(3)).^2)./(2*coefEsts(3).^2))+exp((-(sf-coefEsts(2)+180*(4)).^2)./(2*coefEsts(3).^2))+...
        exp((-(sf-coefEsts(2)+180*(5)).^2)./(2*coefEsts(3).^2)))+coefEsts(4);
    
     Chi2=sum(((fitted_ResponseForFig(1:12)-ResponseForFig(1:12)).^2));%./(STD(1:12)));%%% STD is standard error!!!!
     pFit=1-chi2cdf(Chi2,size(sf,2)-5);
    
    d_m_r=(1/length(ResponseForFig(1:12)))*sum((fitted_ResponseForFig(1:12)-ResponseForFig(1:12)).^2);
    d_r_r=(1/length(ResponseForFig(1:12)))*sum((ResponseForFig(1:12)-mean(ResponseForFig(1:12))).^2);
    Perc_Var_acc=100*(1-d_m_r/d_r_r);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Perc_Var_acc>60&&Width>5
        line(xgrid, Y, 'Color','b','LineWidth',2,'LineStyle','-');
    else
        line(xgrid, Y, 'Color','r','LineWidth',2,'LineStyle','-');
    end
    hold on
    xlim([0 180]);
    set(gca,'XTick',1:5);
    set(gca,'XTickLabel',[0.5 1 2 4 8]);
    xlabel('SF');
    ylabel('firing rate');
    
    ptext=sprintf(',  SF= %.0f var acc= %.0f',Prefered_SF,Perc_Var_acc);
    yLimVals=get(gca,'YLim');
    xLimVals=get(gca,'XLim');
%     text('Position',[xLimVals(1)+(xLimVals(2)-xLimVals(1))/2 yLimVals(1)+0.05*(yLimVals(2)-yLimVals(1))],'FontSize',9,'String',ptext);
    titleText=['ch ',num2str(chInd),ptext];
    title(titleText,'fontsize',6);
    
