% What is the diurnal cycle of fine and coarse AOD?

load('aod_data.mat');

date = SaltonSea.Date_ddmmyyyy;
time = SaltonSea.Time_hhmmss;

% only look before May 21
g = month(date)<5 | month(date)==5 & day(date)<21;
% g = month(date)==2 & day(date)<31;
% g = month(date)<5

% subset the aod data of interest
coarse = SaltonSea.CoarseAOD(g);
fine = SaltonSea.FineAOD(g);

% 30 minute averages
x = 0:.5:23.5; % hour

% numerical representation of time
time = hour(time(g))+minute(time(g))/60;

aod_c = NaN(size(x));
aod_f = NaN(size(x));
for i = 1:numel(x)
    
    g = find(time>=x(i) & time<=x(i)+.5 & coarse >= 0 & coarse <= .1);
    if ~isempty(g); aod_c(i) = mean(coarse(g)); end
    
    g = find(time>=x(i) & time<=x(i)+.5 & fine >= 0 & fine <= .1);
    if ~isempty(g); aod_f(i) = mean(fine(g)); end

end

% put in local time
x = x-7;
aod_c = [aod_c(x>0) aod_c(x<0)];
aod_f = [aod_f(x>0) aod_f(x<0)];
x = [x(x>0) x(x<0)];
x(x<0) = x(x<0)+24;

g = x>=8 & x<=16; % don't use data around sunrise/sunset
plot(x(g),aod_c(g),'.-','MarkerSize',10);hold
plot(x(g),aod_f(g),'.-r','MarkerSize',10);grid
legend('Dust','Pollution')
ylabel('Aerosol optical depth')
xlabel('Hour (PST)')

% print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/aod.eps')