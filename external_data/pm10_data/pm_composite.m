% particulate matter (pm) composites
clear;clc;close
% lst = ["PM10_SHR_2020.csv";"PM25HR_PICKDATA_2020-7-25"];
lst = ["PM10_all_sites.csv";"PM2.5_all_sites"];
% lst = ["PM2.5_all_sites"];
for k=1:size(lst,1)
    
tbl = readPM10(lst(k)) % hourly data in PST time

% create vars
[y,m,d] = datevec(tbl.date);
time = datetime(y,m,d,tbl.start_hour,0,0,'TimeZone','America/Los_Angeles');
dates = datetime(year(time),month(time),day(time),'TimeZone','America/Los_Angeles');
pm = tbl.value;
clearvars y m d

% clean data
% tbl(2683:end,:) = [];
% tbl.value(tbl.value<0)==NaN;

% % save days
% pmdays = unique(dates); % already in PST timezone
% g = ~isnat(pmdays);
% pmdays = pmdays(g);
% % save('/Users/tyler/Documents/Summer2020/external_data/pmdays.mat','pmdays');

numtime = hour(time) + minute(time)/60;
x = 0:23;
for i=1:numel(x)
    g = find(numtime==x(i)); 
        pm_m(i) = nanmean(pm(g));
        pm_std(i) = nanstd(pm(g));
        array_pm{i} = pm(g); % get cell-array for boxplot 
end

% find max column
for i=1:numel(array_pm);mx(i) = numel(array_pm{i});end
mx = max(mx);

% concatenate pm(g) to pm_array
pm_array = NaN(mx,24);
for i=1:24
    tmp = array_pm{i};
    if numel(tmp)~=mx
        tmp = [tmp; NaN(mx-numel(tmp),1)];
    end
    pm_array(:,i) = tmp;
end

if k==1
subplot(1,2,1)
p = [0:23];
hold;grid
boxplot(pm_array,p,'plotstyle','compact','symbol','')
ylim([0,85])
plot(x+1,pm_m,'k','LineWidth',1.5)
legend('PM$_{10}$ Mean','Location','NW','interpreter','latex')
set(gca,'ticklabelinterpreter','latex')
xlabel('Hour (PST)','Interpreter','latex')
ylabel('PM$_{\textbf{10}}$   ($\mu g/m^3$)','Interpreter','latex')
% label every other xtick
ax = gca;
labels = string(ax.XAxis.TickLabels); % extract
labels(2:2:end) = ' '; % remove every other one
ax.XAxis.TickLabels = labels; % set

elseif k==2
subplot(1,2,2)
p = [0:23];
hold;grid
boxplot(pm_array,p,'plotstyle','compact','symbol','')
ylim([0,25])
plot(x+1,pm_m,'k','linewidth',1.5)
legend('PM$_{2.5}$ Mean','interpreter','latex')
set(gca,'ticklabelinterpreter','latex')
xlabel('Hour (PST)','Interpreter','latex')
ylabel('PM$_{\textbf{2.5}}$    ($\mu g/m^3$)','Interpreter','latex')
% label every other xtick
ax = gca;
labels = string(ax.XAxis.TickLabels); % extract
labels(2:2:end) = ' '; % remove every other one
ax.XAxis.TickLabels = labels; % set

end
end
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
% saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/pm_total.png')
% print('pm','-dpng','-bestfit')