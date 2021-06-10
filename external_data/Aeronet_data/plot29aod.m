% plot 29th aod

load('aod_data.mat');
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

g = month(datetimes)==2 & day(datetimes)==29;

datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

% constrain plotted data
g = datetimes>=datetime(2020,2,29,7,30,0,'TimeZone','America/Los_Angeles')...
    & datetimes<=datetime(2020,2,29,15,30,0,'TimeZone','America/Los_Angeles');
g = datetimes>=datetimes(9) & datetimes<=datetimes(88);
plot(datetimes(g),coarse(g)+fine(g));grid;hold;
plot(datetimes(g),coarse(g))
plot(datetimes(g),fine(g))
datetick
xlim([datetime(2020,2,29,7,0,0,'TimeZone','America/Los_Angeles')...
    ,datetime(2020,2,29,16,0,0,'TimeZone','America/Los_Angeles')])
xlabel('Time (PST)','Interpreter','Latex')
ylabel('Aerosol optical depth','Interpreter','Latex')
set(gca,'TickLabelInterpreter','Latex')
legend({'Total AOD','Coarse-mode AOD','Fine-mode AOD'},'Location','NW','Interpreter','Latex')

% print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/29aod.eps')