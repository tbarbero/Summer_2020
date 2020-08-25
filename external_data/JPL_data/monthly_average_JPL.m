% create wspd as a function of hour plot for JPL station

clear all
clc

% load data
JPL = readJPLmet;
load('dustydays.mat');

% create variables
time = datetime(JPL.time,'TimeZone','UTC');
time = datetime(time,'TimeZone','America/Los_Angeles');
dates = datetime(year(time),month(time),day(time),'TimeZone','America/Los_Angeles');
windspeed = JPL.wspd;
winddirection = JPL.wdir;

% exclude dusty day data 
g = ~ismember(dates,dustydays); % dustydays in PST timezone
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% constrain to data after Feb 21
g = month(time)>2 | month(time)==2 & day(time)>21;
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% show data prior to May-21 (bad aod data post may 21)
g = month(time)<5 | month(time)==5 & day(time)<21; 
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% averages
[wsps, wdirs, x] = avgData(time, windspeed, winddirection);

subplot(1,2,1)
plot(x,wsps)
xlabel('Hour (PST)'); ylabel('Windspeed (m/s)')
xticks([0:2:24]); xlim([0,23]);grid

subplot(1,2,2)
plot(x,wdirs)
xlabel('Hour (PST)');ylabel('Wind Direction');add_degs;
xticks([0:2:24]); ; xlim([0,23]);grid; 

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])