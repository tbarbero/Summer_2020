 % look at RH/q of our met site 
clear;close;clc

% load('pmdays.mat');
load('bottomdays.mat');
SS = readSSmet;
%%
datetimes = datetime(SS.time,'TimeZone','UTC');
datetimes = datetime(datetimes,'TimeZone','America/Los_Angeles');
[y,m,d] = datevec(datetimes);

dates = datetime(y,m,d,'TimeZone','America/Los_Angeles');

rh = SS.rh;
q = SS.q;

g = ismember(dates,bottom_days);
% g = (month(dates)==6  | month(dates)==7 | month(dates)==8);
% g = (month(dates)==6);

rh = rh(g);
q = q(g);
dates = dates(g);
datetimes = datetimes(g);

% average
numtime = hour(datetimes)+minute(datetimes)/60;
x = 0:0.5:23.5;
for i=1:numel(x)
    g = find(numtime>=x(i) & numtime<=x(i)+0.5); 
    
    if ~isempty(g);
%         tmp = rh(g);
        tmp = q(g);
%         rh_avg(i) = mean(tmp);
        qmean(i) = nanmean(tmp);
        qstd(i) = std(tmp(~isnan(tmp)));
    end
end
plot(x,qmean)
grid; ylabel('Specific Humidity (g/kg)');xlabel('Hour (PST)');xticks([0:2:24])
hold
% get confidence intervals
% sig should be the standard dev of values at each time step, not sig of
% the entire data set (I think)

% plot(x,qmean+qstd);
% plot(x,qmean-qstd);