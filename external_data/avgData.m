% script to output windspeed and winddirection data into averages as a 
% function of hour

function [wsps, wdirs, x] = avgData(time, wspd, wdir)
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

% perform averages
for i=1:numel(x)
    % find all data between time interval
    g = find(numtime>=x(i) & numtime<=x(i)+step); 

    if ~isempty(g)
        tmp = wspd(g);
        tmp = tmp(~isnan(tmp));
        % B has windspeed data w/o NaNs
        wsps(i) = mean(tmp);
        
        tmp = wdir(g);
        tmp = tmp(~isnan(tmp));
        wdirs(i) = mean(tmp);
    end
end
end