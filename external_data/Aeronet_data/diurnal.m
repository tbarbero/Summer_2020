% What is the diurnal cycle of fine and coarse AOD?

clear
clc

% load data
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

% constrain data to before May 21 (instrument error after may 21)
g = month(datetimes)<5 | month(datetimes)==5 & day(datetimes)<21; % union
datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

% create a variable that holds dusty days, omit these from analysis
aod_threshold = 0.06;

g = coarse > aod_threshold;
dustydays = dates(g);
dustydays = unique(dustydays);

% save variables to use later
save('dustydays.mat','dustydays','aod_threshold')

% exclude dusty day data
g = ~ismember(dates,dustydays); % crosses each row of A w/ B --> logical
datetimes = datetimes(g);
dates = dates(g);
coarse = coarse(g);
fine = fine(g);

% 30 minute averages
x = 0:.5:23.5;

% numerical representation of time
time = hour(datetimes)+minute(datetimes)/60;

aod_c = NaN(size(x));
aod_f = NaN(size(x));
for i = 1:numel(x)
    
    g = find(time>=x(i) & time<=x(i)+.5 & coarse >= 0 & coarse <= aod_threshold);
    if ~isempty(g); aod_c(i) = mean(coarse(g)); end
    
    g = find(time>=x(i) & time<=x(i)+.5 & fine >= 0 & fine <= aod_threshold);
    if ~isempty(g); aod_f(i) = mean(fine(g)); end

end

g = x>=8 & x<=16; % don't use data around sunrise/sunset
plot(x(g),aod_c(g)); hold on
plot(x(g),aod_f(g)); grid 

% plot this to see full extent
% plot(x,aod_c); hold on
% plot(x,aod_f); grid on
legend('Dust','Pollution','Location','SE')
ylabel('Aerosol optical depth'); xlabel('Hour (PST)')
title('Averaged AOD as a function of hour')