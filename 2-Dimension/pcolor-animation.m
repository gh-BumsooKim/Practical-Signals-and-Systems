clear all, close all, clc

dx = 0.2;
dy = 0.2;

x = -2.5:dx:2.5; 
y = -2.5:dy:2.5; 

[X,Y] = meshgrid(x,y);
N = 11;

for ii=1:N
    x0 = -1+(ii-1)/5;
    y0 = x0;
    z = exp(-(X-x0).^2-(Y-y0).^2);
    pcolor(x,y,z), colorbar
    pause(0.5)
end
