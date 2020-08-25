% function to make our MET data into a table
function [SS] = readSSmet
% load data
time_array = [];
wsps_array = [];
wdir_array = [];
for i=2:7
    load(['20200' int2str(i) '.mat'])
    
    % put data into arrays
    time_array = [time_array; time];
    wsps_array = [wsps_array; wspd];
    wdir_array = [wdir_array; wdir];
end

SS.time = time_array;
SS.wspd = 0.514444.*wsps_array;
SS.wdir = wdir_array;
SS.lat = 33.16923;
SS.lon = -115.85593;
SS.sitename = "Salton Sea";

end