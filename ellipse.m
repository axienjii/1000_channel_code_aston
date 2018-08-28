function [p]=ellipse(a,b,x0,y0,col)
%a: horizontal radius
%b: vertical radius
% x0,y0 ellipse centre coordinates
t=-pi:0.01:pi;
x=x0+a*cos(t);
y=y0+b*sin(t);
if nargin<=4
    p=plot(x,y)
else
    p=plot(x,y,':','Color',col)
end