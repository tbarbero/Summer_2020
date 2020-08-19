% Create monthly averages of Windspeed/Winddirection of our Met site
% (UTC time)

% function hourly_avgs(filename)
% Choose month
% load(filename,'time', 'wspd', 'wdir');
load('202002.mat', 'time', 'wspd', 'wdir');

% put data into table for easy indexing
tbl = table(time, wspd, wdir);

% g returns index of specified time
% g = month(tbl.time)==2 & day(tbl.time)<29;
g = month(tbl.time) & day(tbl.time);


% create instance (subset) of data
windspeed = tbl.wspd(g);
winddir = tbl.wdir(g);

% create numerical instance of time (UTC time)
time = hour(tbl.time(g))+minute(tbl.time(g))/60;

% 1/2hour avgs
x = 0:0.5:23.5;

% get monthly avg windspds for each 1/2hr 
for i=1:numel(x)
   
    % gets indices corresp to data for each halfhour
    
    g = find(time>=x(i) & time<=x(i)+0.5);

     % g changes, hold indices of data for each desired half hour. 
    if ~isempty(g)
%         wsps(i) = mean(windspeed(g))
        A = windspeed(g);
        B = A(~isnan(A));
        % B has windspeed data w/o NaNs
        wsps(i) = mean(B);
        
        C = winddir(g);
        D = C(~isnan(C));
        wdirs(i) = mean(D);
    end
end
clearvars A B C D i 

% put in local time (8 hrs behind)
x = x-8;
wsps = [wsps(x>0) wsps(x<0)];
wdirs = [wdirs(x>0) wdirs(x<0)];
x = [x(x>0) x(x<0)];
x(x<0) = x(x<0)+24;

% constrain data to certain times
% g = x>=7 & x<=17;

% plots
subplot(1,2,1)
plot(x,wsps)
xlabel('Time (UTC)')
ylabel('Windspeed (m/s)')
xticks([0:2:24])
grid on
subplot(1,2,2)
plot(x,wdirs)
xlabel('Time (UTC)')
ylabel('Wind Direction (^o)')
xticks([0:2:24])
grid on

% add degrees
yt=get(gca,'ytick');
for k=1:numel(yt)
yt1{k}=sprintf('%d°',yt(k));
end
set(gca,'yticklabel',yt1);

% set(gcf,'units','points','position',[x0,y0,width,height])
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.2, 0.32, 0.6, 0.55])
% saveas(gcf,'windspeeddir.jpg')