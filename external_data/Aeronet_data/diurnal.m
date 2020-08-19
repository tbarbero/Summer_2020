% What is the diurnal cycle of fine and coarse AOD?
% function diurnal(mon, dy)
clear
load('aeronet_L1p5_Tyler.mat');

date = datetime(SaltonSea.Date_ddmmyyyy,'Format','dd/MM/yyyy HH:mm:SS');
time = datetime(SaltonSea.Time_hhmmss,'Format','dd/MM/yyyy HH:mm:SS');
fullt = date+timeofday(time);

% convert to PST
fullt_utc = datetime(fullt,'TimeZone','UTC');
fullt_pst = datetime(fullt_utc,'TimeZone','America/Los_Angeles');
date_pst = fullt_pst;
%
% Extract date var and time var from fulltime
[y,m,d] = ymd(fullt_pst);
dates = datetime(y,m,d,'Timezone','America/Los_Angeles');
[h,m,s] = hms(fullt_pst);
times = datetime(0,0,0,h,m,s,'Format','hh:mm:ss');

% date_pst.Format = 'dd/MM/yyyy';
% time_pst = fullt_pst;
% time_pst.Format = 'HH:mm:SS';
SaltonSea.Date_pst = dates;
SaltonSea.Time_pst = times;

date = SaltonSea.Date_pst;
time = SaltonSea.Time_pst;

% only look before May 21
g = month(date)<5 | month(date)==5 & day(date)<21; % union
subdate = date(g);
subtime = time(g);
coarse = SaltonSea.CoarseAOD(g);
fine = SaltonSea.FineAOD(g);

% get non-dusty days in array
% if one AOD_c value over 0.1 --> mark day and exclude
aod_threshold = 0.075;
h = coarse > aod_threshold;  % returns logical 1,0 if 1 then gives back non-dust indices
dustydays = subdate(h);
dustydays = unique(dustydays);

% save variables to use later
save('dustydays.mat','dustydays','aod_threshold')


% exclude dusty day data
xd = ~ismember(subdate,dustydays); % crosses each row of A w/ B --> logical
coarse = coarse(xd);
fine = fine(xd);
subdate = subdate(xd);
subtime = subtime(xd);

% 30 minute averages
x = 0:.5:23.5; % hour

% numerical representation of time
time = hour(subtime)+minute(subtime)/60;

aod_c = NaN(size(x));
aod_f = NaN(size(x));
for i = 1:numel(x)
    
    % for each 1/2hour find time betw 0 and 0.5hrs and coarseAOD
    % constrained between 0 and 0.1 (no dust storms)
    g = find(time>=x(i) & time<=x(i)+.5 & coarse >= 0 & coarse <= .1);
    if ~isempty(g); aod_c(i) = mean(coarse(g)); end
    % g returns indices for true arguments, if NOTempty, take mean 
    
    g = find(time>=x(i) & time<=x(i)+.5 & fine >= 0 & fine <= .1);
    if ~isempty(g); aod_f(i) = mean(fine(g)); end

end

% % put in PST time
% x = x-7;
% aod_c = [aod_c(x>0) aod_c(x<0)];
% aod_f = [aod_f(x>0) aod_f(x<0)];
% x = [x(x>0) x(x<0)];
% x(x<0) = x(x<0)+24;

g = x>=8 & x<=16; % don't use data around sunrise/sunset
plot(x(g),aod_c(g)); hold on
plot(x(g),aod_f(g)); grid on
% plot(x,aod_c); hold on
% plot(x,aod_f); grid on
legend('Dust','Pollution','Location','NW')
ylabel('Aerosol optical depth'); xlabel('Hour (PST)')
title('Monthly Averaged AOD')