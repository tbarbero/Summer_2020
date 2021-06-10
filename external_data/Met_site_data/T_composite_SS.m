temp = SS.temp;
time=SS.time;

time = datetime(time,'TimeZone','UTC');
time = datetime(time,'TimeZone','America/Los_Angeles');
[y,m,d] = datevec(time);
dates = datetime(y,m,d,'TimeZone','America/Los_Angeles');
load('bottomdays.mat')

g = ismember(dates,bottom_days);
time = time(g);
dates = dates(g);
temp = temp(g);


out = avgData(time,temp);

plot(out.x,out.var)