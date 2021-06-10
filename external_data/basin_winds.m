% basin wind speed box plot 

clear;close;clc;
site_list = ["CQ047.2020-08-10.csv";"KIPL.2020-08-10.csv";...
    "KTRM.2020-08-07.csv";"MXCB1.2020-08-10.csv"];
% define wind speed array
% wspd_array = NaN(24,223*4);

for i=1:numel(site_list)
    
tbl = readMESOWEST(site_list(i));
tbl.datetime = datetime(tbl.datetime,'Timezone','UTC');
tbl.datetime = datetime(tbl.datetime,'Timezone','America/Los_Angeles');

% clean data file b/c windspeeds are set to zero if no data.
g = ~isnan(tbl.winddirection) & ~isnan(tbl.windspeed);
windspeed = tbl.windspeed(g);
winddirection = tbl.winddirection(g);
datetimes = tbl.datetime(g);

% [y,m,d] = datevec(time);

% get array for each site, of 24x#days
for j=1:24
    g = find(hour(datetimes)==j-1);
    wspd_array{i,j} = windspeed(g);
end
end
%%
% get max size
for j=1:24
    for i=1:4
        val(i,j) = numel(wspd_array{i,j});
    end
    mx(j) = nansum(val(:,j));
end
%%
% allocate array for all data

wspd = NaN(max(mx),24);

for j=1:24
    tmp = [];
    for i=1:4
        tmp = [tmp; wspd_array{i,j}];
    end
    if numel(tmp)~=max(mx)
        tmp = [tmp; NaN(max(mx)-size(tmp,1),1)];
    end
        wspd(:,j) = tmp;
end
g = 0:23;
boxplot(wspd,g);hold;grid
mean_wspd = nanmean(wspd);
title('composite of baisn wind speeds')
plot(g+1,mean_wspd)