% Script that plots MESOWEST sites windspeed data using same subset of days **
% some days may be misisng due to bad data or instrument error.
% -----------------------------------------------------------------
% Analysis using bottom percentage of windspeed 
% -----------------------------------------------------------------

clear all
clc
close

% read in bottom days
load('bottomdays.mat');

% main sites 
tbl = readMESOWEST('KTRM.2020-08-07.csv'); % valley site -125 feet elev
% (-38m) at 2m height
% tbl = readMESOWEST('KIPL.2020-08-10.csv'); % plain site
% tbl = readMESOWEST('E3298.2020-08-10.csv'); % valley site +26 feet elev (BAD)
% (8m) at surface
% tbl = readMESOWEST('MXCB1.2020-08-10.csv'); % plain site
% tbl = readMESOWEST('E0772.2020-08-10.csv'); % valley site +26 feet elev
% (8m) BAD to close to eastern mountains 
% tbl = readMESOWEST('CQ047.2020-08-10.csv'); % valley site +26 feet elev (8m)
% tbl = readMESOWEST('Kl08.2020-08-10.csv') % anza desert site

% other sites
% tbl = readMESOWEST('D3583.2020-08-10.csv'); %sparse data 
% tbl = readMESOWEST('KNJK.2020-08-10.csv'); % BAD DATA 
% tbl = readMESOWEST('CQ121.2020-08-07.csv'); %plain site right below SS

% southeastern basin sites
% tbl = readMESOWEST('UP640.2020-08-10.csv');
% tbl = readMESOWEST('QCAC1.2020-08-10.csv');
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
% this catches most cases: 
% some sites label no data with wsps and wdir both zero
% some sites label wdir as nan and wsps as zero
% some sites label wdir and wsps as both NaN

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
out1 = avgData(datetimes, windspeed)
out2 = avgWdir(datetimes, winddirection)

% plots for paper


% % plots
hold on
subplot(1,3,1);geoscatter(lat, lon);geobasemap 'colorterrain'; geolimits([32.4 34],[-117 -115])
site_name = strcat("\leftarrow",site);
text(lat,lon,site_name, 'FontSize',8);
title(site);

% x = 0:23;
hold on;
subplot(1,3,2);
plot(out1.x,out1.var,'MarkerSize',5);grid;xticks([0:2:24]);xlim([0,23.5]);xlabel('Hour (PST)','Interpreter','latex')
ylabel('Wind speed (ms$^{-1}$)','Interpreter','latex');ylim([0,4]);set(gca,'TickLabelInterpreter','Latex')
title(site,'Interpreter','latex')


hold on;
subplot(1,3,3);plot(out2.x,out2.var,'MarkerSize',5);grid;xticks([0:2:24]);xlim([0,23.5])
yticks([135:45:360]);xlabel('Hour (PST)','Interpreter','latex');ylabel('Wind direction ($^o$)','Interpreter','latex')
set(gca,'TickLabelInterpreter','Latex')

% save file
full_path = strcat(pwd,'/figs/valley_flows_50/',site);
% print(gcf,'-depsc', full_path)



% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.32, 0.7, 0.55]);
% path = "/Users/tyler/Documents/Summer2020/external_data/figs/";
% fig = strcat(path,site,'.png');
% fig = strcat(path,'valley_sites.png');
% saveas(gcf,fig)