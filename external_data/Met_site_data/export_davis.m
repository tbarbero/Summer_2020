% Export Davis met station data to matlab file. Manually input the monthly
% file from the met station "f", on line 4
clearvars
f = '202004.txt';


% Call the file "read_met.m" to import the data
[dte, hr, T, rh, Td, wspd, wdir, gust, gust_dir, P] = ...
    read_met(f, [3, Inf]);

% get hours and minutes
hr = append(hr,'m');
t = datetime(hr,'InputFormat','hh:mm a');
h = hour(t);
m = minute(t);

% convert wind direction to degrees using "dir2deg.m"
wdir = dir2deg(wdir);
gdir = dir2deg(gust_dir);
clearvars gust_dir


% get the mr: mr = mr_sat * rh
%   e = 6.112*exp((17.67*Td)/(Td+243.5)) 
%   q = (0.622*e)/(p-(0.378*e))
%   e = vapor pressure (mb)
%   Td = dew point (C)
%   p = pressure (mb)
%   q = specific humidity (kg/kg)
e = 6.112*exp((17.67*Td)./(Td+243.5));
es = 6.112*exp((17.67*T)./(T+243.5));
q = 1000*(0.622*e)./(P-(0.378*e)); %g/Kg
qs = 1000*(0.622*es)./(P-(0.378*es)); %g/Kg
mr = q./(1+q*1e-3);

% Convert time to UTC
[y,m,d,h,mi,s] = datevec(datenum(dte+h/24+m/(24*60)));
time = datetime(y,m,d,h,mi,s,'TimeZone','America/Los_Angeles');
clearvars y m d h mi s dte hr t
time = datetime(time,'TimeZone','UTC');

% save the data
save([f(1:6) '.mat'])

