% average script

function out = avgData(time, var)
numtime = hour(time)+minute(time)/60;

% determine temporal resolution of data
temporalres = abs(time(1)-time(2));

if temporalres == duration(1,0,0) % if hourly data
    x = 0:23;
    step = 1;
elseif temporalres == duration(0,1,0) % if minutely data
    x = 0:0.5:23.5;
    step = 0.5;
else  % if any resolution greater than 1 minute but less than 1 hour
    x = 0:0.5:23.5;
    step = 0.5;
end

% compute averages
for i=1:numel(x)
    g = find(numtime>=x(i) & numtime<x(i)+step); 
        avg_var(i) = nanmean(var(g));
        std_var(i) = nanstd(var(g));
end

out.time = time;
out.var = avg_var;
out.x = x;
out.std_var = std_var;
end