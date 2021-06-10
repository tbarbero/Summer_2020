% seasonality of windspeeds

clear
load('bottomdays.mat');
tbl = readMESOWEST('MXCB1.2020-08-10.csv'); % plain site

% manually change a,b to look at seasonality
a = datenum(datetime(2020,6,1));
b = datenum(datetime(2020,7,25));

g = datenum(tbl.datetime)>a & datenum(tbl.datetime)<b;

time = tbl.datetime(g);
time = datetime(time,'TimeZone','UTC');
time = datetime(time,'TimeZone','America/Los_Angeles');
[y,m,d] = datevec(time)
dates = datetime(y,m,d,'TimeZone','America/Los_Angeles');
wspd = tbl.windspeed(g);
wdir = tbl.winddirection(g);

% look at background-dusty days only
g = ismember(dates,bottom_days);
time = time(g);
wspd = tbl.windspeed(g);
wdir = tbl.winddirection(g);

[wsps, wdirs, x] = avgData(time, wspd, wdir);

plot(x,wdirs,'.-');grid

% early dust season -- typically more westerly (~230-240)

% summer - boring weather typically - something bringing winds more
% easterly (~200-210)
% monsoon winds? - high pressure brings southerly winds