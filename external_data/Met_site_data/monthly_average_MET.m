% Create monthly averages of Windspeed/Winddirection of our Met site
% (UTC time)
% function monthly_average_MET(filename)
clear all
clc

alltime=[];allwspd=[];allwdir=[];
load('dustydays.mat');
for i=2:7
a = strcat("load('20200",int2str(i),".mat','time', 'wspd', 'wdir');");
eval(a);
alltime = [alltime; time];
allwspd = [allwspd; wspd];
allwdir = [allwdir; wdir];
end
[y,m,d] = datevec(alltime);
date = datetime(y,m,d);

% exclude dusty day data
g = ~ismember(date,dustydays);
alltime = alltime(g);
allwspd = allwspd(g);
allwdir = allwdir(g);
% look at before may 21 data
g = month(alltime)<5 | month(alltime)==5 & day(alltime)<21;
alltime = alltime(g);
allwspd = allwspd(g);
allwdir = allwdir(g);

% put data into table for easy indexing
tbl = table(alltime, allwspd, allwdir);

% change wspd from knots to ms
tbl.allwspd = 0.5144.*tbl.allwspd;


% create numerical instance of time (UTC time)
time = hour(tbl.alltime)+minute(tbl.alltime)/60;

% 1/2hour avgs
x = 0:0.5:23.5;

% get monthly avg windspds for each 1/2hr 
for i=1:numel(x)
   
    % gets indices corresp to data for each halfhour
    
    g = find(time>=x(i) & time<=x(i)+0.5);

     % g changes, hold indices of data for each desired half hour. 
    if ~isempty(g)

        A = tbl.allwspd(g);
        B = A(~isnan(A));
        % B has windspeed data w/o NaNs
        wsps(i) = mean(B);
        
        C = tbl.allwdir(g);
        D = C(~isnan(C));
        wdirs(i) = mean(D);
    end
end
clearvars A B C D i 

% put in local time (7 hrs behind)
x = x-7;
wsps = [wsps(x>0) wsps(x<0)];
wdirs = [wdirs(x>0) wdirs(x<0)];
x = [x(x>0) x(x<0)];
x(x<0) = x(x<0)+24;

% constrain data to certain times
% g = x>=7 & x<=17;

% plots
subplot(1,2,1)
plot(x,wsps)
xlabel('Time (PST)'); ylabel('Windspeed (m/s)')
xticks([0:2:24]); xlim([0,23]);
% legend('SS Met','Location','NW');
grid on

subplot(1,2,2)
plot(x,wdirs)
xlabel('Time (PST)');ylabel('Wind Direction')
xticks([0:2:24]); ; xlim([0,23]);
% legend('SS Met','Location','SW');
grid on

% add degrees
yt=get(gca,'ytick');
for k=1:numel(yt)
yt1{k}=sprintf('%d°',yt(k));
end
set(gca,'yticklabel',yt1);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
% set(gcf,'units','points','position',[x0,y0,width,height])

% saveas(gcf,'windspeeddir.jpg')