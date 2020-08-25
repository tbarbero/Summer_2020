% script to get days corresponding to bottom x-percent of windspeeds over
% all sites

clear all
clc

site_list = ["E3298.2020-08-10.csv";"KIPL.2020-08-10.csv";...
    "KTRM.2020-08-07.csv";"MXCB1.2020-08-10.csv"];

all_wsps_avg = [];
all_days_avg = [];
all_datetimes = [];
all_wsps = [];
all_wdir = [];

for i=1:numel(site_list)
    tbl = readMESOWEST(site_list(i));

tbl.datetime = datetime(tbl.datetime,'Timezone','UTC');
tbl.datetime = datetime(tbl.datetime,'Timezone','America/Los_Angeles');

% clean data
g = ~isnan(tbl.winddirection) & ~isnan(tbl.windspeed);
windspeed = tbl.windspeed(g);
winddirection = tbl.winddirection(g);
datetimes = tbl.datetime(g);


% create daily averages then take the bottom percentage of those days
[y,m,d] = ymd(datetimes(1));
date1 = datetime(y,m,d,0,0,0);
date_start = datenum(date1);

[y,m,d] = ymd(datetimes(end));
date_end = datetime(y,m,d,0,0,0);
date_end = datenum(date_end);

% get averages of wsps over individual days
i=1;
while date_start < date_end
    date_iter = date_start + 1; 
    g = datenum(datetimes)>=date_start & datenum(datetimes)<date_iter;
    
    if mean(g)==0 % if no data for day--> mean(g)=0, --> skip
        mean_wsps(i) = NaN;
        mean_wdir(i) = NaN;
        days_used(i) = NaT;
        
        i=i+1;
        date_start = date_start+1;
        
        continue
    elseif sum(g)>=24 % need sufficient data points, otherwise may return false averages.
                      % i.e., one wspd value before early sunrise (low
                      % wspd) will return a negatively biased low average for that day
    mean_wsps(i) = mean(windspeed(g));
    mean_wdir(i) = mean(winddirection(g));
    days_used(i) = datetime(date_start,'ConvertFrom','datenum','Format','dd-MMM-yyyy');
        
    i=i+1;
    date_start = date_start+1;
    else % sum(g)<24
        mean_wsps(i) = NaN;
        mean_wdir(i) = NaN;
        days_used(i) = NaT;
        
        i=i+1;
        date_start = date_start+1;
    end
end
clearvars g i date_start date_end date_iter date1 y m d

% end of daily averaging, put all wsps averages into one array
all_wsps_avg = [all_wsps_avg, mean_wsps]; % days that are 0 wsps = no data
all_days_avg = [all_days_avg, days_used];

% all data in big arrays, for indexing later
all_datetimes = [all_datetimes; tbl.datetime];
all_wsps = [all_wsps; tbl.windspeed];
all_wdir = [all_wdir; tbl.winddirection];

end
%
% get bottom x-percentile
bottom = prctile(all_wsps_avg,30);
g = all_wsps_avg<bottom;

% get days corresponding to bottom percentage of wsps data
bottom_days = unique(all_days_avg(g))';
bottom_days = datetime(bottom_days,'TimeZone', 'America/Los_Angeles','Format','dd-MMM-yyyy');
save('bottomdays.mat','bottom_days','bottom');
% %%
% % need a list of dates dd-mmm-yyyy of ALL data
% % need a list of wspd and wdir of ALL data
% % clean data 
% g = ~isnan(all_wdir) & all_wsps~=0; %if wsps = 0, then no data.
% all_wsps = all_wsps(g);
% all_wdir = all_wdir(g);
% all_datetimes = all_datetimes(g);
% 
% % create dates variable to compare with bottom_days
% all_dates = datetime(year(all_datetimes),month(all_datetimes),day(all_datetimes),...
%     'Timezone','America/Los_Angeles');
% 
% % create new variables that represent all data from bottom x-percent of days
% g = ismember(all_dates,bottom_days);
% bottom_wsps = all_wsps(g);
% bottom_wdir = all_wdir(g);
% bottom_datetimes = all_datetimes(g);
% 
% % avg wsps/wdir as a function of hour over bottom_days data
% [wsps, wdirs, x] = avgData(bottom_datetimes, bottom_wsps, bottom_wdir);
% %%
% 
% 
% 
% 
% 
% 
% 
% %%
% % find days corresponding to bottom x-percent of daily-avged wsps
% figure(1)
% histogram(all_wsps_avg,'binwidth',0.1);grid
% 
% 
% bottom = prctile(all_wsps_avg,30);
% g = all_wsps_avg<bottom;
% bottom_days = all_days_avg(g); % days that had data in bottom x-percent of wspd
% bottom_days = unique(bottom_days);
% 
% % get all wsps and all wdir data that corresponds to bottom days
% 
% 
