% function to make CARB data into table
function [CARB] = readCARBmet
tbl = readSWINSPD('SWINSPD_PICKDATA_2020-8-1.csv');
tbl(5113:5124,:) = [];

% get times
[y,m,d] = datevec(tbl.date);
CARBtime = datetime(y,m,d,tbl.start_hour,0,0);

% get wind direction and wind speed
for i=1:numel(tbl.windstring)
    tmp = tbl.windstring{i};
    j=find(tmp=='/');
    CARBwdir(i) = str2double(tmp(1:j-1));
    CARBwspd(i) = str2double(tmp(j+1:end));
end
CARB.wspd = CARBwspd;
CARB.wdir = CARBwdir;
CARB.time = CARBtime;

clearvars y m d tmp tbl i j 
end