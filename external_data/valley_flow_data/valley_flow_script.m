% Get windspeed and wdireciton monthly averages of data from
% scattered sites around the basin to analyze valley flows.

clear all
clc
load('dustydays.mat');
% tbl = readMESOWEST('CQ121.2020-08-07.csv');
% tbl = readMESOWEST('KTRM.2020-08-07.csv'); % airport site
% tbl = readMESOWEST('KNJK.2020-08-10.csv'); % kinda portrays southerly flow -- sitll mnts flow too (SW)
% tbl = readMESOWEST('KIPL.2020-08-10.csv'); %sort of see southerly flow more SW -- influence of SW Mnts
tbl = readMESOWEST('E3298.2020-08-10.csv');
% tbl = readMESOWEST('D3583.2020-08-10.csv');
% tbl = readMESOWEST('MXCB1.2020-08-10.csv');
% tbl = readMESOWEST(filename);
time = tbl.datetime;
time = datetime(time,'TimeZone','UTC');
time = datetime(time,'TimeZone','America/Los_Angeles');

windspeed = tbl.windspeed;
winddirection = tbl.winddirection;

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
%
% look at data after feb 21
g = month(time)>2 | month(time)==2 & day(time)>21;
windspeed = windspeed(g);
winddirection = winddirection(g);
time = time(g);

% look at data before may 21
g = month(time)<5 | month(time)==5 & day(time)<21;
windspeed = windspeed(g);
winddirection = winddirection(g);
time = time(g);
%
% exclude dusty day data
X = strcat('Using days with AOD<',num2str(aod_threshold));
disp(X)
[y,m,d] = ymd(time);
dates = datetime(y,m,d,'TimeZone','America/Los_Angeles');
% format just changes the output, not the actual value of datetime (BAD)
% dates = time;
% dates.Format = 'yyyy-MM-dd';
% dustydays.Format = 'yyyy-MM-dd';
g = ~ismember(dates,dustydays);
windspeed = windspeed(g);
winddirection = winddirection(g);
time = time(g);
%

% create numerical times from datetimes
numtime = hour(time)+minute(time)/60;

temporalres = abs(time(1)-time(2));
if temporalres == duration(1,0,0)
    x = 0:23;
    step = 1;
else % any higher resolution use 30min avgs
    x = 0:0.5:23.5;
    step = 0.5;
end

for i=1:numel(x)
    g = find(numtime>=x(i) & numtime<x(i)+step);
    
    
    % get averages
    A = windspeed(g);
    B = A(~isnan(A));
    wsps(i) = mean(B);

    C = winddirection(g);
    D = C(~isnan(C));
    wdirs(i) = mean(D);
end
clearvars A B C D i g

% instead of this convert using "America/Los Angeles" in datetime function
% x = x-7;
% wsps = [wsps(x>0) wsps(x<0)];
% wdirs = [wdirs(x>0) wdirs(x<0)];
% x = [x(x>0) x(x<0)];
% x(x<0) = x(x<0)+24;

%
% plots
%

subplot(1,3,1)
geoscatter(lat, lon)
geobasemap 'colorterrain'
geolimits([32.4 34],[-117 -115])
title(site)
hold on

subplot(1,3,2)
hold on;
plot(x,wsps)
xlabel('Time (PST)'); ylabel('Windspeed (m/s)');
xticks([0:2:24]); grid on;title('Monthly Averaged Wind Speed');


hold on

subplot(1,3,3)
plot(x,wdirs)
xlabel('Time (PST)'); ylabel('Wind Direction');
xticks([0:2:24]); grid on; title('Monthly Averaged Wind Direction');
yticks([0:15:360])

hold on
% add degrees
yt=get(gca,'ytick');
for k=1:numel(yt)
yt1{k}=sprintf('%d�',yt(k));
end
set(gca,'yticklabel',yt1);

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.32, 0.7, 0.55])


% saveas(gcf,'windspeeddir.jpg')
% end
