% Create monthly averages of Windspeed/Winddirection of our Met site
% (UTC time)
% function monthly_average_MET(filename)
clear all
clc

% read in data
SS = readSSmet;
load('dustydays.mat');

% create variables
time = datetime(SS.time,'TimeZone','UTC');
time = datetime(SS.time,'TimeZone','America/Los_Angeles');
windspeed = SS.wspd;
winddirection = SS.wdir;
dates = datetime(year(time),month(time),day(time),'TimeZone','America/Los_Angeles');

% exclude dusty day data
g = ~ismember(dates,dustydays); % dustydays in PST timezone
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% look at before may 21 data
g = month(time)<5 | month(time)==5 & day(time)<21;
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% averages
[wsps, wdirs, x] = avgData(time, windspeed, winddirection);

% plots
subplot(1,2,1)
plot(x,wsps)
xlabel('Hour (PST)');ylabel('Windspeed (m/s)')
xticks([0:2:24]);xlim([0,23]);grid

subplot(1,2,2)
plot(x,wdirs)
xlabel('Hour (PST)');ylabel('Wind Direction');add_degs;
xticks([0:2:24]);xlim([0,23]);grid
% saveas(gcf,'windspeeddir.jpg')
% end