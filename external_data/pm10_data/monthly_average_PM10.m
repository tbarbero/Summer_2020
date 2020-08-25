% create average pm10 plot as a function of hour

clear
clc

tbl = readPM10('PM10_SHR_2020.csv'); % hourly data in PST time
load('dustydays.mat');

% clean data
tbl(2683:end,:) = [];
g = find(tbl.value==0);
tbl.value(g) = NaN; 

% create variables (time, pm10)
[y,m,d] = ymd(tbl.date);
time = datetime(y,m,d,tbl.start_hour,0,0,'TimeZone','America/Los_Angeles');
dates = datetime(year(time),month(time),day(time),'TimeZone','America/Los_Angeles');
PM10 = tbl.value;
clearvars y m d

% exclude dusty days
g = ~ismember(dates,dustydays);
time = time(g);
PM10 = PM10(g);

% constrain data prior to may 21
g = month(time)<5 | month(time)==5 & day(time)<21;
time = time(g);
PM10 = PM10(g);

% averages as a function of hour over all data
numtime = hour(time);

x = 0:23;

for i=1:numel(x)
    g = find(numtime==x(i));
    
    tmp = PM10(g);
    tmp = tmp(~isnan(tmp)); % remove nans 
    PM10avgs(i) = mean(tmp);
end
clearvars i tmp g

% plot
plot(x,PM10avgs);grid on
xlabel('Hour (PST)');ylabel('PM10 (ug/m^3)');
title('PM10 averaged as a function of hour');xlim([0,23]);xticks([0:2:23])
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])