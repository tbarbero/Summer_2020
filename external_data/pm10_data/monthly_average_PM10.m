% Plot diurnal PM10 data
% function PM10(mon,dy)
tbl = readPM10('PM10_SHR_2020.csv');
load('dustydays.mat');

% clean data
tbl(2683:2694,:) = [];
g = find(tbl.value==0);
tbl.value(g) = NaN;

% retrieve data 
[y,m,d] = datevec(tbl.date);
time = datetime(y,m,d,tbl.start_hour,0,0); % (PST time)
PM10 = tbl.value;

% create temporary time var
fakedates = datetime(y,m,d,'InputFormat','dd:mm:yyyy');
clearvars y m d

% exclude data from dusty days
g = ~ismember(fakedates,dustydays);
PM10 = PM10(g);
time = time(g);

% constrain data to before mid-may
g = month(time)<5 | month(time)==5 & day(time)<21;
PM10 = PM10(g);
time = time(g);

%
% create numerical times from datetimes
numtime = hour(time(g))+minute(time(g))/60;

x = 0:23;

for i=1:numel(x)
    g = find(numtime==x(i));
    
    % get hourly averages for PM10 over specified month
    A = PM10(g);
    B = A(~isnan(A));
    PM10avgs(i) = mean(B);
end
clearvars i A B g

% plot
plot(x,PM10avgs);grid on
xlabel('Hour (PST)');ylabel('PM10 (ug/m^3)');
title('Monthly Averaged PM10');xlim([0,23]);xticks([0:2:23])
legend('PM10','Location','NW')
