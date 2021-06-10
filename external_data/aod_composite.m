% aod composite analysis

clc
clear

% load data
load('aod_data.mat');
load('bottomdays.mat');

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

% constrain to bottom days
g = ismember(dates, bottom_days);
datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

% find corrupt data (-999)
g = find(coarse>0);
datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

% aod_threshold = 0.1;
% averaging as a function of hour
x = 0:.5:23.5;

% numerical representation of time
time = hour(datetimes)+minute(datetimes)/60;

aod_c = NaN(size(x));
aod_f = NaN(size(x));
for i = 1:numel(x)
    
%     g = find(time>=x(i) & time<=x(i)+.5 & coarse >= 0 & coarse <= aod_threshold);
    g = find(time>=x(i) & time<=x(i)+.5);
    if ~isempty(g); aod_c(i) = mean(coarse(g)); end
    
%     g = find(time>=x(i) & time<=x(i)+.5 & fine >= 0 & fine <= aod_threshold);
    g = find(time>=x(i) & time<=x(i)+.5);
    if ~isempty(g); aod_f(i) = mean(fine(g)); end
    
end

g = x>=7.5 & x<=15.5;
hold
plot(x(g),aod_c(g)+aod_f(g))
plot(x(g),aod_c(g));grid
plot(x(g),aod_f(g))

set(gca,'TickLabelInterpreter','Latex')
ylabel('Aerosol optical depth','Interpreter','Latex');xlabel('Hour (PST)','Interpreter','latex');ylim([0.015,0.08])
legend({'Total AOD','Coarse-mode AOD','Fine-mode AOD'},'Location','NW','Interpreter','Latex');
path = pwd;
fig = strcat(path,'/figs/','aod_composite.png');
% saveas(gcf,fig)

print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/aod_composite.eps')