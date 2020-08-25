% create wsps as a function of hour plots 

clear all
clc

% load data
load('dustydays.mat') 
CARB = readCARBmet; % hourly data, time in PST

% create variables
time = datetime(CARB.time, 'TimeZone','America/Los_Angeles');
dates = datetime(year(time),month(time),day(time),'TimeZone','America/Los_Angeles');
windspeed = CARB.wspd;
winddirection = CARB.wdir;

% exclude dusty day data
g = ismember(dates,dustydays);
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% constrain data post february 21
g = month(time)>2 | month(time)==2 & day(time)>21;
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% constrain data prior may 21
g = month(time)<5 | month(time)==5 & day(time)<21;
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% averages
[wsps, wdirs, x] = avgData(time, windspeed, winddirection);

% plots
subplot(1,2,1)
hold on;
plot(x,wsps)
xlabel('Time (PST)');ylabel('Windspeed (m/s)');
xticks([0:2:24]);grid;

subplot(1,2,2)
plot(x,wdirs)
xlabel('Time (PST)');ylabel('Wind Direction');add_degs;
xticks([0:2:24]);grid; 

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
% saveas(gcf,'windspeeddir.jpg')