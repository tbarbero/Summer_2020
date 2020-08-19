% Function that takes array of windspeed values and indexes the bottom 10
% percent of values.
% Notes 
% 
% data = randn(100,1);
% plot(data)
% %
% data(data<0) = data(data<0)*-1; % just taking absolute values of data
% plot(data)
% %
% data = randn(100,1)*5+5;
% data(data<0) = data(data<0)*-1;
% plot(data);grid;
% histogram(data)
% histogram(data,'binwidth',0.1)
% % cdfplot(data)
% 
% bottom_prctile = prctile(data,10)% returns value of specified percentile in dataset
% bottom_10_data = data(data<bottom_prctile);
% index = data<bottom_prctile
% time = 1:100;
% plot(time,data);
% hold on
% plot(time(index),bottom_10_data,'o')
% END NOTES 


clear
% tbl = readMESOWEST('CQ121.2020-08-07.csv');
tbl = readMESOWEST('KTRM.2020-08-07.csv'); % airport site
% tbl = readMESOWEST('KNJK.2020-08-10.csv'); % kinda portrays southerly flow -- sitll mnts flow too (SW)
% tbl = readMESOWEST('KIPL.2020-08-10.csv'); %sort of see southerly flow more SW -- influence of SW Mnts
% tbl = readMESOWEST('E3298.2020-08-10.csv');
% tbl = readMESOWEST('D3583.2020-08-10.csv');
% tbl = readMESOWEST('MXCB1.2020-08-10.csv');

tbl.datetime = datetime(tbl.datetime,'Timezone','UTC');
tbl.datetime = datetime(tbl.datetime,'Timezone','America/Los_Angeles');
time = tbl.datetime;
windspeed = tbl.windspeed;
winddirection = tbl.winddirection;

% tbl = readCARBmet
% time = tbl.time;
% windspeed = tbl.wspd;
% winddirection = tbl.wdir;
%
cdfplot(windspeed);
bottom = prctile(windspeed,100); 
% makes sense to look at bottom 70 percent because outliers (duststorm days
% occur with high windspeed) 
new_wspd = windspeed(windspeed<bottom);

g = find(windspeed<bottom);
new_wdir = winddirection(g);
new_time = time(g);

[wsps, wdirs, x] = avgData(new_time, new_wspd, new_wdir);
subplot(1,2,1);plot(x,wsps);grid;xticks([0:2:24]);xlabel('Hour (PST)');ylabel('Wspd (m/s)');
subplot(1,2,2);plot(x,wdirs);grid;xticks([0:2:24]);yticks([0:15:360]);add_degs;xlabel('Hour (PST)');ylabel('Deg (^o)')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.32, 0.7, 0.55])

%% things to discuss
% we wanted to constrain WS/AOD to get rid of westerly influence on WDIR
% (to show NW-SE valley flow).

% Is there a correlation between plain(our site) and coachella valley flow? -- lack of sites between

% We should look at bottom 70 percent b/c outliers occur high WS. -->
% possion disribution

% Try to emulate AOD to match WS plots? --> AOD < 0.01 0.05 0.75 (0.1 too
% high?
% so I would find an AOD value and then omit those dustydays from WS/WDIR
% plots, and see which AOD value matches with the bottom 70 percent WS plots
