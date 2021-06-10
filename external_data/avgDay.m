% Find the "most average" day. Then use to find set of 'average days' for
% WRF modeling.
clear;close;clc
load('NTB.mat');

tmp = ans;

h = hour(tmp.time);
d = day(tmp.time);
m = month(tmp.time);
num = m+d/31;
% create array of days to track which days we will get from lowest RMSE
days = unique(datetime(2020,m,d,'TimeZone','America/Los_Angeles'));


spd = tmp.wspd;
dir = tmp.wdir;

wspd = NaN(24,31,12); %hr,day,month

for i = 1:31
    for j = 1:12
        
        g = find(d==i & m==j);
        if ~isempty(g) % if empty, left as NaNs
            
            % gets wind speed into easy index array % 0:23 --> 1:24 h(g)
            wspd(h(g)+1,i,j) = spd(g); 
            
        end
    end
end

% reshape from (24,31,12) --> (24,31*12) --> (24x372)
wspd = reshape(wspd,24,31*12); 
% take out all days with NaNs
wspd = wspd(:,~isnan(nanmean(wspd)));
NTBdata.wspd = wspd;
% average 
avg = nanmean(wspd,2);
NTBdata.avg = avg;
% repmat (repeats matrix 'avg' (once in a row) and repeats it 214 times in
% column so we can take the difference between observations 'wspd' and the
% mean 'avg'

% % difference, mean, sqrt
% error = wspd-repmat(avg,1,(size(wspd,2)));
% error_sq = error.^2;
% mean_sq = nanmean(error_sq);
% rmse1 = sqrt(mean_sq);

rmse = sqrt(nanmean((wspd-repmat(avg,1,size(wspd,2))).^2));
%%
% find the difference between the 'norm' and each day, take lowest
% percentage of rmse
% already done need to find which days are corresponding to the lowest rmse
histogram(rmse,'BinWidth',0.1','Normalization','pdf')
threshold = prctile(rmse, 75);
hold on;scatter(threshold,0.5)

%%
g = find(rmse<threshold);
% get corresponding days
NTBbottomdays = days(g);
%% save data
NTBdata.rmse = rmse;
NTBdata.days = days;

save('/Users/tyler/Documents/Summer2020/external_data/bottom_NTB_wspd.mat',...
    'NTBbottomdays','NTBdata')