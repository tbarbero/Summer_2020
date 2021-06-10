% test wind direction averaging method mean of circular quantity vs 
% u,v components
clc;clear;close
load('bottomdays.mat');
load('pmdays.mat')
tbl = readCARBmet;
%%
wspd = tbl.wspd;
wdir = tbl.wdir;
time = tbl.time; %in PT
time = datetime(time,'TimeZone','America/Los_Angeles');
[y,m,d] = datevec(time);
dates = datetime(y,m,d,'TimeZone','America/Los_Angeles');


g = ismember(dates,pmdays);
wspd = wspd(g);
wdir = wdir(g);
time = time(g);

% convert to math direction
md = 270 - wdir; % math wind dir 0deg = W 
md(md<0) = md(md<0)+360;


% get components of wind speed
tmp = md * (pi/180); % convert to rad
u = wspd.*cos(tmp); 
v = wspd.*sin(tmp); 

% average here (get all i-th hour directions,
avg_wdir = NaN(24,1);
for i=1:24
    g = find(hour(time)==i-1);
    ssin = nansum(u(g));
    scos = nansum(v(g));
    avg_wdir(i,1) = atan2(scos,ssin)*(180/pi); % get degrees
end

avg_wdir = 270 - avg_wdir;  % convert from md to meteorological direction
avg_wdir(avg_wdir>360) = avg_wdir(avg_wdir>360) - 360; % convert to (0,360) if angle > 360

subplot(121)
plot([0:23],avg_wdir);grid
xticks([0:2:24])
yticks([0:45:315])
title('u-v component averaging method')
subplot(122)
out1 = avgWdir(time,wdir);
plot(out1.x,out1.var);grid
xticks([0:2:24])
yticks([0:45:315])
title('circular quantities averaging method')