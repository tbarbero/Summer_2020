% Script that plots JPL,CARB,SSMET SITES windspeed data using same 
% subset of days.
% *Some days may be misisng due to bad data or instrument error.
% -----------------------------------------------------------------
% Analysis using bottom percentage of windspeed 
% -----------------------------------------------------------------

clear
clc

% read in all data
load('bottomdays.mat');
JPL = readJPLmet;
CARB = readCARBmet;
SS = readSSmet;


% site = "CARB";
% site = "JPL";
% site = "SS";

if site == "JPL"
    lat = JPL.lat;
    lon = JPL.lon;
    sitename = JPL.sitename;
    datetimes = datetime(JPL.time,'TimeZone','UTC');
    datetimes = datetime(datetimes,'TimeZone','America/Los_Angeles');
    windspeed = JPL.wspd;
    winddirection = JPL.wdir;
    dates = datetime(year(datetimes),month(datetimes),day(datetimes),'TimeZone','America/Los_Angeles');
elseif site == "SS"
    lat = SS.lat;
    lon = SS.lon;
    sitename = SS.sitename;
    datetimes = datetime(SS.time,'TimeZone','UTC');
    datetimes = datetime(datetimes,'TimeZone','America/Los_Angeles');
    windspeed = SS.wspd;
    winddirection = SS.wdir;
    dates = datetime(year(datetimes),month(datetimes),day(datetimes),'TimeZone','America/Los_Angeles');

elseif site == "CARB"
    lat = CARB.lat;
    lon = CARB.lon;
    sitename = CARB.sitename;
    datetimes = datetime(CARB.time,'TimeZone','America/Los_Angeles');
    windspeed = CARB.wspd;
    winddirection = CARB.wdir;
    dates = datetime(year(datetimes),month(datetimes),day(datetimes),'TimeZone','America/Los_Angeles');
end

% constrain site data to same subset of days
g = ismember(dates,bottom_days);
bottom_windspeed = windspeed(g);
bottom_winddirection = winddirection(g);
bottom_datetimes = datetimes(g);

% data as function of hour averaging
[wsps, wdirs, x] = avgData(bottom_datetimes, bottom_windspeed, bottom_winddirection);


% plots
subplot(1,3,1);geoscatter(lat, lon, 'r');geobasemap 'colorterrain'; geolimits([32.4 34],[-117 -115])
title(sitename); hold on

subplot(1,3,2);plot(x,wsps);grid;xticks([0:2:24]);xlabel('Hour (PST)');ylabel('Wspd (m/s)');xlim([0 23.5]);
subplot(1,3,3);plot(x,wdirs);grid;xticks([0:2:24]);yticks([0:15:360]);add_degs;xlabel('Hour (PST)');ylabel('Deg (^o)');xlim([0 23.5])
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.32, 0.7, 0.55])
fig = strcat(sitename,'.png');
% saveas(gcf,fig)

%% notes:
% JPL site portrays NW-SE valley flow fairly well
% portrays Westerly-Easterly flow and the Transition from mountain flows to valley flows.
% might be correct

% JPL site: more westerly than NW during early morning (0-6): probably avg
% between NW valley flow and SW-westerly mountain flow (SW-mnt flow weighed
% more heavily) 

% CARB site: hourly data -- could be reason why plots are off