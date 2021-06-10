% Script that plots JPL,CARB,SSMET SITES windspeed data using same 
% subset of days.
% *Some days may be misisng due to bad data or instrument error.
% -----------------------------------------------------------------
% Analysis using bottom percentage of windspeed 
% -----------------------------------------------------------------
% 
% function valleyflow_bottom_wsps_JPL_SSMET_CARB(site)
% clearvars
clc;clear;close

% read in all data
load('bottomdays.mat');
load('pmdays.mat');
load('~/Documents/Summer2020/external_data/ceilometer_data/comp75/CL51_composite.mat','Blh')

site = ["JPL","SS","CARB"];
%
% for i=1:numel(site)
for i=3
    
    if i==1
        MET = readJPLmet; % UTC
        lat = MET.lat;
        lon = MET.lon;
        sitename = MET.sitename;
        datetimes = datetime(MET.time,'TimeZone','UTC');
        datetimes = datetime(datetimes,'TimeZone','America/Los_Angeles');
        windspeed = MET.wspd;
        winddirection = MET.wdir;
        dates = datetime(year(datetimes),month(datetimes),day(datetimes),'TimeZone','America/Los_Angeles');
    end
    
    if i==2; 
        MET = readSSmet; % UTC time
        lat = MET.lat;
        lon = MET.lon;
        sitename = MET.sitename;
        datetimes = datetime(MET.time,'TimeZone','UTC');
        datetimes = datetime(datetimes,'TimeZone','America/Los_Angeles');
        windspeed = MET.wspd;
        winddirection = MET.wdir;
        dates = datetime(year(datetimes),month(datetimes),day(datetimes),'TimeZone','America/Los_Angeles');
    end
    
    if i==3;
        MET = readCARBmet; % PST time
        lat = MET.lat;
        lon = MET.lon;
        sitename = MET.sitename;
        datetimes = datetime(MET.time,'TimeZone','America/Los_Angeles');
        windspeed = MET.wspd;
        winddirection = MET.wdir;
        dates = datetime(year(datetimes),month(datetimes),day(datetimes),'TimeZone','America/Los_Angeles');
    end
% constrain site data to same subset of days
g = ismember(dates,pmdays);
windspeed = windspeed(g);
winddirection = winddirection(g);
datetimes = datetimes(g);
dates = dates(g);

% use bottom days
% g = ismember(dates,bottom_days);
% windspeed = windspeed(g);
% winddirection = winddirection(g);
% datetimes = datetimes(g);
% dates = dates(g);

% data as function of hour averaging
out1 = avgData(datetimes, windspeed);
out2 = avgWdir(datetimes, winddirection);
%%
% deal with discontinuity 
% out1.var(out1.var<250) = out1.var(out1.var<250)+360;
plot(out1.x,out1.var);
grid
% 
hold on
subplot(1,2,1)
plot(out1.x,out1.var);
grid;xticks([0:2:24]);xlabel('Hour (PST)','Interpreter','latex');
ylabel('Wind speed ($ms^{-1}$)','Interpreter','latex');xlim([0 23.5]);hold on
set(gca,'ticklabelinterpreter','latex')
yyaxis right
x = linspace(0,24,5400);
plot(x,smooth(Blh(1,:),19)) % 1min smoothing 16 sec data
ylabel('Altitude (m)','Interpreter','latex')
legend({'NTB','BLH'},'location','NW','Interpreter','latex')
hold off

% discontinuity fix
out2.var(out2.var<250) = out2.var(out2.var<250) + 360;
subplot(1,2,2)
plot(out2.x,out2.var);
grid;xticks([0:2:24]);yticks([0:45:460])
yticklabels({0,45,90,135,180,225,270,315,360,45,90})
xlabel('Hour (PST)','Interpreter','latex');ylabel('Wind direction $(^o$)','Interpreter','latex');xlim([0 23.5]);hold on
legend('NTB','location','NW','interpreter','latex')
set(gca,'ticklabelinterpreter','latex')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/winds1.png')
end
% plot(x
% subplot(1,2,1);legend({'JPL','Salton','NTB'},'Location','SE','Interpreter','latex')
% subplot(1,2,2);legend({'JPL','Salton','NTB'},'Location','SW','Interpreter','latex')
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])

% saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/winds.png')