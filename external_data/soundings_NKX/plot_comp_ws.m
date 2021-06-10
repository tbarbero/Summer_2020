% composite average upper level sounding wspd
clc;clear;close
load('sounding_composite_0z.mat');
% load('sounding_composite_12z.mat');

md = 270 - wdir; % convert to math dir
md(md<0) = md(md<0) + 360; % nonzero dirs
tmp = md * (pi/180); % get in radians
u = wspd.*cos(tmp);
v = wspd.*sin(tmp);
scos = nansum(u);
ssin = nansum(v);
wdir_mean = atan2(ssin,scos)*(180/pi); % dir in deg

wdir_mean = 270 - wdir_mean; % convert to meteorological dir
wdir_mean(wdir_mean>360) = wdir_mean(wdir_mean>360) - 360; % if greater than 360

z_mean = nanmean(Z);
plot(smooth(wdir_mean,19),z_mean,'LineWidth',1.5)
title('NKX 0z-Sounding Average Wind Direction Profile','Interpreter','latex')
legend({'Mean Wind Direction'},'Location','NE','Interpreter','latex')
grid
xlabel('Wind Direction ($^o$)','Interpreter','latex')
ylabel('Altitude (m)','Interpreter','latex')
set(gca,'ticklabelinterpreter','latex')
yline(3000,'--r','HandleVisibility','off')
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/sounding_wdir.png')