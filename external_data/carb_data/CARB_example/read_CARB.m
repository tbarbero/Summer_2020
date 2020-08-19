% Read in the CARB met data and put into a large array:
% [lon lat date val1 val2 val3 ...]
%
% Dates in these files are the "start hour", thus the correct time, in
% terms of representing the averaging period, should be half-past
clearvars

% Get a list of all the files
list = dir('*.csv');
n = size(list,1)-1;

meta = readMETA('meta.csv');

% variable lengths (# of sites)
nSITE = numel(meta.SiteName);

% make the time array
Tstart = datenum(datetime(2020,2,1,0,30,0));
Tend = datenum(datetime(2020,2,29,23,30,0));
[y,m,d,h,min,sec] = datevec(Tstart:1/24:Tend);
time = datetime(y,m,d,h,min,sec,'TimeZone','America/Los_Angeles');
% clearvars Tstart Tend y m d h min sec


% var arrays [sitenum,time]
% going through csv files - 1 because meta is a csv
for i = 2
    f = list(i).name;
    
    if strncmp('BPSTA',f(1:end-11),5) % pressure (hPa)
        P = NaN(nSITE,numel(time));
        out = readBPSTA(f);
        for j = 1:nSITE
            % index all values for site j
            g = find(out.name == meta.SiteName{j}); 
            
            % index the times for this site
            [y,m,d] = datevec(out.date(g));
            Tind = round((datenum(y,m,d,out.start_hour(g),30,0) - ...
                datenum(time(1)))*24 + 1);
            
            % fill in the variables
            P(j,Tind) = out.pressure(g)';
        end
    end
    
    if strncmp('DEWPNT',f(1:end-11),5) % Dew point (C)
        Td = NaN(nSITE,numel(time));
        out = readDEWPNT(f);
        for j = 1:nSITE
            g = find(out.name == meta.SiteName{j}); 
            [y,m,d] = datevec(out.date(g));
            Tind = round((datenum(y,m,d,out.start_hour(g),30,0) - ...
                datenum(time(1)))*24 + 1);
            Td(j,Tind) = out.dpt(g)';
        end
    end
    
    if strncmp('PKSPD',f(1:end-11),5) % Gusts (m/s)
        gust = NaN(nSITE,numel(time));
        out = readPKSPD(f);
        for j = 1:nSITE
            g = find(out.name == meta.SiteName{j}); 
            [y,m,d] = datevec(out.date(g));
            Tind = round((datenum(y,m,d,out.start_hour(g),30,0) - ...
                datenum(time(1)))*24 + 1);
            gust(j,Tind) = out.gust(g)'*0.514444; % kts to m/s;
        end
    end    
    
    if strncmp('SWINSPD',f(1:end-11),5) % 10m wind speed (m/s)
        u10m = NaN(nSITE,numel(time));
        v10m = NaN(nSITE,numel(time));
        out = readSWINSPD(f); 
        for j = 1:nSITE
            g = find(out.name == meta.SiteName{j}); 
            [y,m,d] = datevec(out.date(g));
            Tind = round((datenum(y,m,d,out.start_hour(g),30,0) - ...
                datenum(time(1)))*24 + 1);
            u10m(j,Tind) = out.u(g)'*0.514444; % kts to m/s;
            v10m(j,Tind) = out.v(g)'*0.514444; % kts to m/s;
        end
    end
    
    if strncmp('TEMP',f(1:end-11),4) % In-situ temperature (C)
        T = NaN(nSITE,numel(time));
        out = readTEMP(f);
        for j = 1:nSITE
            g = find(out.name == meta.SiteName{j}); 
            [y,m,d] = datevec(out.date(g));
            Tind = round((datenum(y,m,d,out.start_hour(g),30,0) - ...
                datenum(time(1)))*24 + 1);
            T(j,Tind) = out.temp(g)'; % kts to m/s;
        end
    end
    
    if strncmp('RELHUM',f(1:end-11),6) % In-situ temperature (C)
        rh = NaN(nSITE,numel(time));
        out = readRELHUM(f);
        for j = 1:nSITE
            g = find(out.name == meta.SiteName{j}); 
            [y,m,d] = datevec(out.date(g));
            Tind = round((datenum(y,m,d,out.start_hour(g),30,0) - ...
                datenum(time(1)))*24 + 1);
            rh(j,Tind) = out.rh(g)'; % kts to m/s;
        end
    end
    
end
% clearvars Tind i j y m d g out f n nSITE

% UTC time
time = datetime(time,'TimeZone','America/Los_Angeles');
lat = meta.Latitude;
lon = meta.Longitude;
elevation = meta.Elevation;
name = meta.SiteName;
% clearvars meta list

% and save
save('CARB.MET.mat')





    