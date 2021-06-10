% T composite at JPL
clc;close;clear;
JPL = readJPLmet;
load('pmdays.mat');
%%
time = datetime(JPL.time,'TimeZone','UTC');
time = datetime(time,'TimeZone','America/Los_Angeles');
[y,m,d] = datevec(time);
days = datetime(y,m,d,'TimeZone','America/Los_Angeles');
temp = JPL.temp;
% look at only pm days
g = ismember(days,pmdays);
time = time(g);
days = days(g);
temp = temp(g);
%%
numtime = hour(time) + minute(time)/60;
x = 0:0.5:23.5;step=0.5;
% compute averages
for i=1:numel(x)
    g = find(numtime>=x(i) & numtime<=x(i)+step); 
        T(i) = nanmean(temp(g));
        std_T(i) = nanstd(temp(g));
end
%%
hold
plot(x,T);grid;xlabel('Hour (PST)');ylabel('T (^oC)')
% plot(x,T-std_T)
% plot(x,T+std_T)