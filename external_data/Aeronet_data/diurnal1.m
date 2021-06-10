% What is the diurnal cycle of fine and coarse AOD?
clear;clc;close

% load data
load('aod_data.mat');
load('pmdays.mat');

% create variables
[y,m,d] = datevec(SaltonSea.Date_ddmmyyyy);
[h,mm,s] = hms(SaltonSea.Time_hhmmss);
datetimes = datetime(y,m,d,h,mm,s,'TimeZone','UTC');
datetimes = datetime(datetimes,'TimeZone','America/Los_Angeles');
dates = datetime(year(datetimes),month(datetimes),day(datetimes),...
    'TimeZone','America/Los_Angeles');
coarse = SaltonSea.CoarseAOD;
fine = SaltonSea.FineAOD;
clearvars y m d h mm s

% constrain data to before May 21 (instrument error after may 21)
g = month(datetimes)<5 | month(datetimes)==5 & day(datetimes)<21; % union
datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

g = ismember(dates,pmdays);
datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

% % create a variable that holds dusty days, omit these from analysis
aod_threshold = 0.1;

% g = coarse > aod_threshold;
% dustydays = dates(g);
% dustydays = unique(dustydays);

% save variables to use later
% save('/Users/tyler/Documents/Summer2020/external_data/dustydays.mat','dustydays','aod_threshold')
%

% 30 minute averages
x = 0:.5:23.5;

% numerical representation of time
time = hour(datetimes)+minute(datetimes)/60;

aod_c = NaN(size(x));
aod_f = NaN(size(x));

for i = 1:numel(x)
    g = find(time>=x(i) & time<=x(i)+.5 & coarse >= 0 & coarse <= aod_threshold);
        aod_c(i) = nanmean(coarse(g));
        std_aodc(i) = std(coarse(g));
        array_coarse{i} = coarse(g); % holds all data in cell array
        
    g = find(time>=x(i) & time<=x(i)+.5 & fine >= 0 & fine <= aod_threshold);
        aod_f(i) = nanmean(fine(g)); 
        std_aodf(i) = std(fine(g));
        array_fine{i} = fine(g); % holds all data in cell array
end

% find max column
for i=1:numel(array_coarse);mx1(i) = numel(array_coarse{i});end
mx1 = max(mx1);
for i=1:numel(array_fine);mx2(i) = numel(array_fine{i});end
mx2 = max(mx2);
% create max column
arrayc = NaN(mx1,numel(aod_c));
arrayf = NaN(mx2,numel(aod_f));

% concatenate all coarse(g) values to array1
for i=1:48    
    tmp1 = array_coarse{i};
    tmp2 = array_fine{i};
    if numel(tmp1)~=mx1
        tmp1 = [tmp1; NaN(mx1-numel(tmp1),1)];
    end
    if numel(tmp2)~=mx2
        tmp2 = [tmp2; NaN(mx2-numel(tmp2),1)];
    end
    arrayc(:,i) = tmp1;
    arrayf(:,i) = tmp2;
end

% make total AOD array (arrayf+arrayc)
mx = max(size(arrayc,1),size(arrayf,1));
arrayt = NaN(mx,48);
arrayt(1:size(arrayf,1),:) = arrayf;
arrayt = arrayt+arrayc;


% plots
% g = x>=8 & x<=16; % don't use data around sunrise/sunset
p = [0:0.5:23.5];
x = [0.5:47.5];

% plot coarse mode aod
subplot(1,2,1);hold on
plot(x+0.5,aod_c,'k','linewidth',1.5);
legend('Mean coarse-mode AOD','interpreter','latex')
% plot(x,aod_c+std_aodc,'b--','HandleVisibility','off');
% plot(x,aod_c-std_aodc,'b--','HandleVisibility','off');
boxplot(arrayc,p,'plotstyle','compact','symbol','');grid
xlim([16,34]);ylim([0.015,0.08])
% label every other xtick
ax = gca;
labels = string(ax.XAxis.TickLabels); % extract
labels(2:2:end) = ' '; % remove every other one
ax.XAxis.TickLabels = labels; % set

set(gca,'TickLabelInterpreter','Latex')
% legend('Coarse-mode','Location','SE','Interpreter', 'Latex')
ylabel('Coarse-Mode AOD','Interpreter', 'Latex')
xlabel('Hour (PST)','Interpreter', 'Latex')

% plot fine mode aod
subplot(1,2,2);hold on % have to appply limits in command line???
plot(x+0.5,aod_f+aod_c,'k','linewidth',1.5);
legend('Mean total AOD','interpreter','latex')
% plot(x,aod_f+std_aodf,'r--','HandleVisibility','off');
% plot(x,aod_f-std_aodf,'r--','HandleVisibility','off');
boxplot(arrayt,p,'plotstyle','compact','symbol','');grid;
xlim([16,34]);
ylim([0.04 0.13])
% label every other xtick
ax = gca;
labels = string(ax.XAxis.TickLabels); % extract
labels(2:2:end) = ' '; % remove every other one
ax.XAxis.TickLabels = labels; % set

set(gca,'TickLabelInterpreter','Latex')
% legend('Fine-mode','Location','SE','Interpreter', 'Latex')
ylabel('Total AOD','Interpreter', 'Latex');
xlabel('Hour (PST)','Interpreter', 'Latex')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
axis tight
% print('/Users/tyler/Documents/Summer2020/external_data/poster_figs/pm.png','-dpng','-fillpage')
% saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/aod.png')