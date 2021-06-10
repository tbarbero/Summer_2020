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
% g = month(datetimes)<5 | month(datetimes)==5 & day(datetimes)<21; % union
% datetimes = datetimes(g);
% dates = dates(g);
% coarse = coarse(g);
% fine = fine(g);

g = ismember(dates,pmdays)
datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

% create a variable that holds dusty days, omit these from analysis
aod_threshold = 0.1;

g = coarse > aod_threshold;
dustydays = dates(g);
dustydays = unique(dustydays);

% save variables to use later
save('/Users/tyler/Documents/Summer2020/external_data/dustydays.mat','dustydays','aod_threshold')
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
g = x>=8 & x<=16; % don't use data around sunrise/sunset
hold
% plot coarse mode aod
plot(x(g),aod_c(g),'b');
plot(x(g),aod_c(g)+std_aodc(g),'b--','HandleVisibility','off');
plot(x(g),aod_c(g)-std_aodc(g),'b--','HandleVisibility','off');
% plot fine mode aod
plot(x(g),aod_f(g),'r');
plot(x(g),aod_f(g)+std_aodf(g),'r--','HandleVisibility','off');
plot(x(g),aod_f(g)-std_aodf(g),'r--','HandleVisibility','off');
grid

set(gca,'TickLabelInterpreter','Latex')
legend('Coarse-mode','Fine-mode','Location','SE','Interpreter', 'Latex')
ylabel('Aerosol optical depth','Interpreter', 'Latex'); xlabel('Hour (PST)','Interpreter', 'Latex')
% title('Averaged AOD as a function of hour')
% print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/aod.eps')