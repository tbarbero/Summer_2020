% Look at background valley flow from JPL,SSMET,CARB sites

clc
clear all

% load datasets: SS, CARB, JPL
SS = load('202002.mat');
CARB = readCARBmet;
JPL = readJPLmet;

g = find(month(SS.time)==2 & day(SS.time)==29);
SStime = SS.time(g);
SSwspd = 0.5144.*SS.wspd(g);
SSwdir = SS.wdir(g);
g = find(month(CARB.time)==2 & day(CARB.time)==29);
CARBtime = CARB.time(g);
CARBwspd = CARB.wspd(g);
CARBwdir = CARB.wdir(g);
g = find(month(JPL.time)==2 & day(JPL.time)==29);
JPLtime = JPL.time(g);
JPLwspd = JPL.wspd(g);
JPLwdir = JPL.wdir(g);

% get averages
% [wsps, wdirs, x] = avgData(time, wspd, wdir);
[wsps1, wdirs1, x1] = avgData(SStime, SSwspd, SSwdir);
[wsps2, wdirs2, x2] = avgData(JPLtime, JPLwspd, JPLwdir);
[wsps3, wdirs3, x3] = avgData(CARBtime, CARBwspd, CARBwdir);
%%
% plots
subplot(3,2,1); plot(x1, wsps1); grid; legend('Our Site');ylabel('Wspd (m/s)');xlabel(' Hour (PST)');title('29th Feb Data');xticks([0:2:24])
subplot(3,2,2); plot(x1, wdirs1); grid; add_degs; legend('Our Site');ylabel('Wdir (m/s)');xlabel(' Hour (PST)');xticks([0:2:24])
subplot(3,2,3); plot(x2,wsps2);grid;legend('JPL');ylabel('Wspd (m/s)');xlabel(' Hour (PST)');xticks([0:2:24])
subplot(3,2,4); plot(x2,wdirs2);grid; add_degs;legend('JPL');ylabel('Wdir (m/s)');xlabel(' Hour (PST)');xticks([0:2:24])
subplot(3,2,5); plot(x3,wsps3);grid;legend('CARB');ylabel('Wspd (m/s)');xlabel(' Hour (PST)');xticks([0:2:24])
subplot(3,2,6); plot(x3,wdirs3);grid; add_degs;legend('CARB');ylabel('Wdir (m/s)');xlabel(' Hour (PST)');xticks([0:2:24])

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.8, 0.75])