% particulate matter (pm) composites
clear;clc;close
tbl=readPM10("PM10_SHR_2020.csv") % hourly data in PST time
%
% create vars
[y,m,d] = datevec(tbl.date);
time = datetime(y,m,d,tbl.start_hour,0,0,'TimeZone','America/Los_Angeles');
dates = datetime(year(time),month(time),day(time),'TimeZone','America/Los_Angeles');
PM = tbl.value;
clearvars y m d

% save days
pmdays = unique(dates); % already in PST timezone
g = ~isnat(pmdays);
pmdays = pmdays(g);
save('/Users/tyler/Documents/Summer2020/external_data/pmdays.mat','pmdays');
% clean data
tbl(2683:end,:) = [];

% only include background bottom days
% g = ismember(dates,bottom_days);
% time = time(g);
% PM10 = PM10(g);

% constrain data prior to may 21
% g = month(time)<5 | month(time)==5 & day(time)<21;
% time = time(g);
% PM10 = PM10(g);

% composites
% out = avgData(time,PM);
numtime = hour(time) + minute(time)/60;
x = 0:23.5;
mx = NaN(numel(x));
for i=1:numel(x)
    g = find(numtime>=x(i) & numtime<=x(i)+step); 
        pm(i) = nanmean(pm(g));
        std_var(i) = nanstd(var(g));
        array_pm{i} = pm(g); % get ra
       
end

plot(x,PM10avgs,'MarkerSize',10)
PM(k,:) = PM10avgs;

PMtot = PM(1,:) + PM(2,:);

plot(x,PMtot)
legend({'PM$_{10}$','PM$_{2.5}$','PM Total'},'Location','NW','Interpreter','latex')
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
% print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/pm10.eps')