% script to output windspeed and winddirection data into averages as a 
% function of hour

function out = avgWdir(time, wdir)
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
    
    % sum all sines and cosines of wdir
    % deg --> rad
    n = numel(g);
    tmp = wdir(g)*(pi/180);
    s = (1/n)*nansum(sin(tmp)); % sin returns sin of every element of tmp
    c = (1/n)*nansum(cos(tmp));
    
    if s>0 & c>0
        wdirs(i) = atan(s/c)
    elseif c<0
        wdirs(i) = (atan(s/c) + pi);
    elseif s<0 & c>0
        wdirs(i) = (atan(s/c) + (2*pi));
    end
    
    
end
wdirs = wdirs * (180/pi);

out.time = time;
out.var = wdirs;
out.x = x;
end