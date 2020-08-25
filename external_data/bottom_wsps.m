% Script that plots a site's windspeed data using same subset of days **
% some days may be misisng due to bad data or instrument error.
clear
clc

% read in bottom days
load('bottomdays.mat');

% tbl = readMESOWEST('CQ121.2020-08-07.csv'); % hourly
tbl = readMESOWEST('KTRM.2020-08-07.csv'); % y
% tbl = readMESOWEST('KNJK.2020-08-10.csv'); % hourly % kinda portrays southerly flow -- sitll mnts flow too (SW)
% tbl = readMESOWEST('KIPL.2020-08-10.csv'); % y
% tbl = readMESOWEST('E3298.2020-08-10.csv'); y
% tbl = readMESOWEST('D3583.2020-08-10.csv');%----bad
% tbl = readMESOWEST('MXCB1.2020-08-10.csv'); y

% get metadata for site
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

tbl.datetime = datetime(tbl.datetime,'Timezone','UTC');
tbl.datetime = datetime(tbl.datetime,'Timezone','America/Los_Angeles');

% clean data
g = ~isnan(tbl.winddirection) & tbl.windspeed~=0;
windspeed = tbl.windspeed(g);
winddirection = tbl.winddirection(g);
datetimes = tbl.datetime(g);

% create dates variable to compare to **good data** AND bottom days
% good data: data that is non-zero AND not a NaN
dates = datetime(year(datetimes),month(datetimes),day(datetimes),...
    'Timezone','America/Los_Angeles');

g = ismember(dates,bottom_days);
% subset of data corresponding to bottom days
windspeed = windspeed(g);
winddirection = winddirection(g);
datetimes = datetimes(g);

% do averaging as a function of hour
[wsps, wdirs, x] = avgData(datetimes, windspeed, winddirection);

% plots
subplot(1,3,1);geoscatter(lat, lon);geobasemap 'colorterrain'; geolimits([32.4 34],[-117 -115])
title(site); hold on

subplot(1,3,2);plot(x,wsps);grid;xticks([0:2:24]);xlabel('Hour (PST)');ylabel('Wspd (m/s)');
subplot(1,3,3);plot(x,wdirs);grid;xticks([0:2:24]);yticks([0:15:360]);add_degs;xlabel('Hour (PST)');ylabel('Deg (^o)')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.32, 0.7, 0.55])
fig = strcat(site,'.png');
% saveas(gcf,fig)
%% notes
% KIPL site looks a little worse when using same subset of days. --
% -- KIPL reoslution not that great, could cause bad data
% KNJK bad data (hourly)

% might not align PERFECTLY NW-SE valley flow b/c some bottom 50% westerly winds still
% could be in dataset and would dilute the NW-SE valley flow