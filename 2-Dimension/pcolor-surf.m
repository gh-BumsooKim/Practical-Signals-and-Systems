clear all, close all, clc

dx = 0.2;
dy = 0.2;

x = -2.5:dx:2.5; 
y = -2.5:dy:2.5; 

figure(1);
[xx,yy] = meshgrid(x,y);
z = exp(-xx.^2-yy.^2);
pcolor(x,y,z), colorbar

figure(2);
surf(x,y,z)
