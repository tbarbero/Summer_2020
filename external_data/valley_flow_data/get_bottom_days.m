% Script to get bottom x-percentage of days corresponding to the bottom
% percentage of wind speeds
clear all
clc

site_list = ["CQ047.2020-08-10.csv";"KIPL.2020-08-10.csv";...
    "KTRM.2020-08-07.csv";"MXCB1.2020-08-10.csv"];

mean_wsps_array = NaN(numel(site_list),223); % assign 4x223 array for avgs
mean_wsps_array2 = NaN(1,223); % assign 1x223 array for final avgs

for k=1:numel(site_list)
    tbl = readMESOWEST(site_list(k));

tbl.datetime = datetime(tbl.datetime,'Timezone','UTC');
tbl.datetime = datetime(tbl.datetime,'Timezone','America/Los_Angeles');

% clean data file b/c windspeeds are set to zero if no data.
g = ~isnan(tbl.winddirection) & ~isnan(tbl.windspeed);
windspeed = tbl.windspeed(g);
winddirection = tbl.winddirection(g);
datetimes = tbl.datetime(g);

% --------------------------------------------------------------------
% create daily averages then take the bottom percentage of those days.
% --------------------------------------------------------------------
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
    end % if statement end
end % end of while loop to get mean for EACH site
clearvars g i date_start date_end date_iter date1 y m d

% get averages into array for easy averaging
for j=1:numel(mean_wsps)
mean_wsps_array(k,j) = mean_wsps(j);
end

end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalize each daily averaged wind speed by mean and std
for i=1:223
    norm_array(:,i) = (mean_wsps_array(:,i) - nanmean(mean_wsps_array(:)))/nanstd(mean_wsps_array(:));
end
norm_array2 = nanmean(norm_array);
% norm_array2 = abs(norm_array2);
bottom_percentile = 75;
bottom_value = prctile(norm_array2,bottom_percentile);

g = norm_array2<bottom_value;
bottom_days = days_used(g);
bottom_days = datetime(bottom_days,'TimeZone', 'America/Los_Angeles','Format','dd-MMM-yyyy');
bottom_days1 = bottom_days'; 
clearvars bottom_days

load('bottomdays.mat','bottom_days');
s = sum(bottom_days~=bottom_days1);

disp(['There are ' num2str(s) ' days different when normalizing wsps']);


% histogram(norm_array2) % tells us how far values are from each other?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% average wsps
mean_wsps_array2 = nanmean(mean_wsps_array);
% get bottom x-percentile of data
bottom_percentile = 75;
bottom_value = prctile(mean_wsps_array2,bottom_percentile);

% histogram of basin windspeeds
figure(1);histogram(mean_wsps_array2,'Normalization','pdf');grid;hold on
xlabel('Wind speed (m/s)','Interpreter','latex')
ylabel('Probability (\%)','Interpreter','latex')
set(gca,'ticklabelinterpreter','latex')
xline(bottom_value,'--r','linewidth',2)
% saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/hist_wsps.png')


% get days corresponding to bottom percentage of wsps data
g = mean_wsps_array2<bottom_value;
bottom_days = days_used(g);
bottom_days = datetime(bottom_days,'TimeZone', 'America/Los_Angeles','Format','dd-MMM-yyyy');
bottom_days1 = bottom_days'; 

% save('/Users/tyler/Documents/Summer2020/external_data/bottomdays.mat',...
%     'bottom_days','bottom_value','bottom_percentile');