% Create monthly averages from CARB sites (PST times)
clear all
clc

% function monthly_average_CARB(mon,dy)
% load data
load('dustydays.mat')
tbl = readSWINSPD('SWINSPD_PICKDATA_2020-8-1.csv');
% clean data
tbl(5113:5124,:) = [];

% get times
[y,m,d] = datevec(tbl.date);
time = datetime(y,m,d,tbl.start_hour,0,0);

% get wind direction and wind speed
for i=1:numel(tbl.windstring)
    tmp = tbl.windstring{i};
    j=find(tmp=='/');
    winddirection(i) = str2double(tmp(1:j-1));
    windspeed(i) = str2double(tmp(j+1:end));
end

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

% exclude dusty day data
g = ~ismember(tbl.date(g),dustydays);
windspeed = windspeed(g);
winddirection = winddirection(g);
time = time(g);

%
% create numerical times from datetimes
numtime = hour(time)+minute(time)/60;

x = 0:23;

for i=1:numel(x)
%     disp(x(i))
    g = find(numtime==x(i));
    
    
    % get averages
    A = windspeed(g);
    B = A(~isnan(A));
    wsps(i) = mean(B);

    C = winddirection(g);
    D = C(~isnan(C));
    wdirs(i) = mean(D);
end
clearvars A B C D i g
%
% plots
subplot(1,2,1)
hold on;
plot(x,wsps)
xlabel('Time (PST)'); ylabel('Windspeed (m/s)');
xticks([0:2:24]); grid on;title('Monthly Averaged Wind Speed');
% legend('CARB','Location', 'NW')

hold on

subplot(1,2,2)
plot(x,wdirs)
xlabel('Time (PST)'); ylabel('Wind Direction');
xticks([0:2:24]); grid on; title('Monthly Averaged Wind Direction');
% legend('CARB','Location', 'SW')

% add degrees
yt=get(gca,'ytick');
for k=1:numel(yt)
yt1{k}=sprintf('%d°',yt(k));
end
set(gca,'yticklabel',yt1);

% set(gcf,'units','points','position',[x0,y0,width,height])

% saveas(gcf,'windspeeddir.jpg')
