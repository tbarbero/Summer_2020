% Get windspeed and winddirection averages of data as a function of 
% hour from scattered sites around the basin to analyze valley flows.
% -----------------------------------------------------------------
% Analysis using bottom percentage of AOD
% -----------------------------------------------------------------

clear all
clc
% read in dusty days
load('dustydays.mat');

% main sites
tbl = readMESOWEST('KTRM.2020-08-07.csv');
% tbl = readMESOWEST('KIPL.2020-08-10.csv');
% tbl = readMESOWEST('E3298.2020-08-10.csv');
% tbl = readMESOWEST('MXCB1.2020-08-10.csv');

% other sites
% tbl = readMESOWEST('D3583.2020-08-10.csv');
% tbl = readMESOWEST('KNJK.2020-08-10.csv');
% tbl = readMESOWEST('CQ121.2020-08-07.csv');

% get metadata
tmp = tbl.stationID{4};
j = find(tmp==':');
site = tmp(j+2:end);

tmp = tbl.stationID{6};
j = find(tmp==':');
lat = tmp(j+2:end);
lat = str2double(lat);

tmp = tbl.stationID{7};
j = find(tmp==':');
lon = tmp(j+2:end);
lon = str2double(lon);

clearvars tmp j 

% create variables
time = tbl.datetime;
time = datetime(time,'TimeZone','UTC');
time = datetime(time,'TimeZone','America/Los_Angeles');
dates = datetime(year(time),month(time),day(time),'TimeZone','America/Los_Angeles');
windspeed = tbl.windspeed;
winddirection = tbl.winddirection;

% exclude dusty day data
X = strcat('Using days with AOD<',num2str(aod_threshold));
disp(X)
g = ~ismember(dates,dustydays);
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% look at data after feb 21 (no met data previously)
g = month(time)>2 | month(time)==2 & day(time)>21;
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% look at data before may 21 (bad data after)
g = month(time)<5 | month(time)==5 & day(time)<21;
time = time(g);
windspeed = windspeed(g);
winddirection = winddirection(g);

% compute averages
[wsps, wdirs, x] = avgData(time, windspeed, winddirection);

% plots
subplot(1,3,1)
geoscatter(lat,lon)
geobasemap 'colorterrain'
geolimits([32.4 34],[-117 -115])
title(site);

subplot(1,3,2)
plot(x,wsps)
xlabel('Time (PST)');ylabel('Windspeed (m/s)');
xticks([0:2:24]);grid;title('Avg Wsps Analysis Using AOD'); hold on

subplot(1,3,3)
plot(x,wdirs)
xlabel('Time (PST)');ylabel('Wind Direction');
xticks([0:2:24]);grid;title('Avg Wdir Analysis Using AOD');
yticks([0:15:360]);hold on; add_degs

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.32, 0.7, 0.55])

% saveas(gcf,'windspeeddir.jpg')