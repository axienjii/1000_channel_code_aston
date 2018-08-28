function [y,params] = Gauss2D_RFfit4_MUA(x,degx,degy,estback,Starting)

%fminsearch approach
%Makes an oriented Gaussian
%This one actually works!
%x is a matrix of responses at positions degx and degy in degrees
%Input data is assumed to be 0 for non-responsive regions
%No further normalisation is required.
% If estback is set to 1 the the baseline is measured using a measure of
% the lowest responses
if nargin < 4
    estback = 0;
end

if estback
    %MEasure the baseline as the lowest quartile of the responses
    s = sort(reshape(x,size(x,1)*size(x,2),1));
    lowQ = s(round(0.25*length(s)));
    %Subtract lowQ from all responses
    x = x-lowQ;
end

%Params are:
%meanx,meany,stdx,stdy,theta
if nargin < 5
Starting=[0,0,1,1,0];
end
options=optimset('Display','off');
params=fminsearch(@fit2dgausseq,Starting,options,x,degx,degy);

%Remake best fittign GAussian
mx = params(1);
my = params(2);
sx = params(3);
sy = params(4);
theta = params(5);

%MAke coordinate matrices
[matx,maty] = meshgrid(degx,degy);
a = cos(theta)^2/2/sx^2 + sin(theta)^2/2/sy^2;
b = -sin(2*theta)/4/sx^2 + sin(2*theta)/4/sy^2 ;
c = sin(theta)^2/2/sx^2 + cos(theta)^2/2/sy^2;
Z = exp( - (a*(matx-mx).^2 + 2*b*(matx-mx).*(maty-my) + c*(maty-my).^2)) ;


%Calculate normlaisation factor
nf = max(max(x));
y = Z.*nf;

if estback
    %Add back on the baseline
    y = y+lowQ;
end


return

function sse = fit2dgausseq(params,x,degx,degy)

mx = params(1);
my = params(2);
sx = params(3);
sy = params(4);
theta = params(5);

%MAke coordinate matrices
[matx,maty] = meshgrid(degx,degy);
a = cos(theta)^2/2/sx^2 + sin(theta)^2/2/sy^2;
b = -sin(2*theta)/4/sx^2 + sin(2*theta)/4/sy^2 ;
c = sin(theta)^2/2/sx^2 + cos(theta)^2/2/sy^2;
Z = exp( - (a*(matx-mx).^2 + 2*b*(matx-mx).*(maty-my) + c*(maty-my).^2)) ;

%Normalize  x
x = x./max(max(x));

%Error
sse = sum(sum((Z-x).^2));
