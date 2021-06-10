% put mesowest sites wspd and wdir into two separate matrices for schematic
clc;clear;close
load('bottomdays.mat');
tmp = ["Site";"Lat";"Lon"];
site = ["CQ125.2020-08-10";"KL08.2020-08-10.csv"; "KTRM.2020-08-07.csv";"CQ047.2020-08-10.csv";"KIPL.2020-08-10.csv";"MXCB1.2020-08-10.csv"]
ss = size(site,1);
% assign memory
wspd = NaN(ss,24);
wdir = NaN(ss,24);
lonn = NaN(ss,1);
latt = NaN(ss,1);
sites = [];
for i=1:ss
    tbl = readMESOWEST(site(i));
    
    % get metadata
    tmp = tbl.stationID{4};
    j = find(tmp==':');
    s = string(tmp(j+2:end));
    

    tmp = tbl.stationID{6};
    j = find(tmp==':');
    lat = tmp(j+2:end);
    lat = str2double(lat);

    tmp = tbl.stationID{7};
    j = find(tmp==':');
    lon = tmp(j+2:end);
    lon = str2double(lon);
    
    tbl.datetime = datetime(tbl.datetime,'Timezone','UTC');
    tbl.datetime = datetime(tbl.datetime,'Timezone','America/Los_Angeles');
    g = ~isnan(tbl.winddirection) & tbl.windspeed~=0;
    windspeed = tbl.windspeed(g);
    winddirection = tbl.winddirection(g);
    datetimes = tbl.datetime(g);
    dates = datetime(year(datetimes),month(datetimes),day(datetimes),...
    'Timezone','America/Los_Angeles');

    g = ismember(dates,bottom_days);
    % subset of data corresponding to bottom days
    windspeed = windspeed(g);
    winddirection = winddirection(g);
    datetimes = datetimes(g);
    
    out1 = avgData(datetimes, windspeed);
    out2 = avgWdir(datetimes, winddirection);
    
    if numel(out1.x) == 48
        wspd(i,:) = out1.var(1:2:48);
        wdir(i,:) = out2.var(1:2:48);
    elseif numel(out1.x) == 24
    wspd(i,:) = out1.var;
    wdir(i,:) = out2.var;
    end
    % meta
    lonn(i,1) = lon;
    latt(i,1) = lat;
    sites = [sites;s];
end

% CARB
c = readCARBmet;
lonn(ss+1,1) = c.lon;
latt(ss+1,1) = c.lat;
sites(ss+1,1) = c.sitename;
datetimes = datetime(c.time,'timezone','America/Los_Angeles');
dates = datetime(year(datetimes),month(datetimes),day(datetimes),...
    'Timezone','America/Los_Angeles');
windspeed = c.wspd;
winddirection = c.wdir;
g = ismember(dates,bottom_days);

% subset of data corresponding to bottom days
windspeed = windspeed(g);
winddirection = winddirection(g);
datetimes = datetimes(g);

out1 = avgData(datetimes, windspeed);
out2 = avgWdir(datetimes, winddirection);

if numel(out1.x) == 48
    wspd(ss+1,:) = out1.var(1:2:48);
    wdir(ss+1,:) = out2.var(1:2:48);
elseif numel(out1.x) == 24
    wspd(ss+1,:) = out1.var;
    wdir(ss+1,:) = out2.var;
end
    
    
    
meta = table(sites,latt,lonn);

save('schematic_data.mat','wspd','wdir','meta');
save('METsites.mat','meta');