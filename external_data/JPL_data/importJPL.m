% Monthly average windspeed/dir for JPL data
clear all
clc
% Read in JPL Met Data
% function importJPL(month)
load('dustydays.mat');
for i=1:7
a(i) = strcat("JPL",num2str(i),"= importdata('2020_ss1_", int2str(i),"_m.met',' ',4);");
eval(a(i));
end

mdyall=[];hmsall=[];wspdall=[];wdirall=[];
for i=1:7
a = strcat("mdy = JPL",int2str(i),".textdata(5:end,1);");
eval(a);
mdyall = [mdyall; mdy];
b = strcat("hms = JPL",int2str(i),".textdata(5:end,2);");
eval(b);
hmsall = [hmsall; hms];
c = strcat("windspeed = JPL",int2str(i),".data(:,1);");
eval(c);
wspdall = [wspdall; windspeed];
d = strcat("winddirection = JPL",int2str(i),".data(:,2);");
eval(d);
wdirall = [wdirall; winddirection];
end
datestrs = append(mdyall, ' ',hmsall);
time = datetime(datestrs, 'InputFormat', 'MM-dd-yyyy HH:mm:ss'); % UTC time
clearvars hms hmsall mdy winddirection windspeed i  a b c d ...
    JPL1 JPL2 JPL3 JPL4 JPL5 JPL6 JPL7 

dates = datetime(mdyall,'InputFormat','MM-dd-yyyy');

% % exclude dusty day data before making table
g = ~ismember(dates,dustydays);
wdirall = wdirall(g);
wspdall = wspdall(g);
time = time(g);
dates = dates(g);

% show data after Feb 21
g = month(dates)>2 | month(dates)==2 & day(dates)>21;
wdirall = wdirall(g);
wspdall = wspdall(g);
time = time(g);
dates = dates(g);

% show data prior to May-21
g = month(dates)<5 | month(dates)==5 & day(dates)<21; 
wdirall = wdirall(g);
wspdall = wspdall(g);
time = time(g);
dates = dates(g);

%%%


tbl = table(time, dates, wspdall ,wdirall);
clearvars wspdall wdirall dates datestrs mdyall g

numtime = hour(tbl.time)+minute(tbl.time)/60;

x = 0:0.5:23;

for i=1:numel(x)
    g = find(numtime>=x(i) & numtime<=x(i)+0.5);
    
    if ~isempty(g)
        % averages 
        A = tbl.wspdall(g);
        B = A(~isnan(A));
        wsps(i) = mean(B);
        
        C = tbl.wdirall(g);
        D = C(~isnan(C));
        wdirs(i) = mean(D);
    end
end
clearvars A B C D g i k numtime

% put in PST time
x = x-7;
wsps = [wsps(x>0) wsps(x<0)];
wdirs = [wdirs(x>0) wdirs(x<0)];
x = [x(x>0) x(x<0)];
x(x<0) = x(x<0)+24;

subplot(1,2,1)
plot(x,wsps)
xlabel('Time (PST)'); ylabel('Windspeed (m/s)')
xticks([0:2:24]); xlim([0,23]);
% legend('JPL','Location','NW');
grid on

subplot(1,2,2)
plot(x,wdirs)
xlabel('Time (PST)');ylabel('Wind Direction')
xticks([0:2:24]); ; xlim([0,23]);
% legend('JPL','Location','SW');
grid on; 
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])

% add degrees
yt=get(gca,'ytick');
for k=1:numel(yt)
yt1{k}=sprintf('%d°',yt(k));
end
set(gca,'yticklabel',yt1);
clearvars yt yt1