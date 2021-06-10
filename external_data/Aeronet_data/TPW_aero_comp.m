clear;clc;close
load('bottomdays.mat');
aero = readtable('aeronet_dat','FileType','text');
tpw = aero.Precipitable_Water_cm_;
date = datetime(aero.Date_dd_mm_yyyy_,'InputFormat','dd:MM:uuuu');
time = aero.Time_hh_mm_ss_;
[h,m,s] = hms(time);
dts = datetime(year(date),month(date),day(date),h,m,s,'TimeZone','UTC');
dts = datetime(dts,'TimeZone','America/Los_Angeles');
[y,Mnths,d] = datevec(dts);
date = datetime(y,Mnths,d,'TimeZone','America/Los_Angeles');

%%
g = ismember(date,bottom_days);
date_sub = date(g);
tpw_sub = tpw(g);
dts_sub = dts(g);

out = avgData(dts_sub,tpw_sub);
plot(out.x,out.var)
grid
xlabel('Hr (PST)')
ylabel('Aeronet PW (cm)')