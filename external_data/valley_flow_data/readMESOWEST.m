% script for reading yearly MESOWEST wsps,wdir,temp data
function out = readMESOWEST(filename, dataLines)
%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["stationID", "datetime", "airtemp", "windspeed", ...
    "winddirection"];
opts.VariableTypes = ["string", "datetime", "double", "double", ...
    "double"];
opts = setvaropts(opts, 2, "InputFormat", 'yyyy-MM-dd''T''HH:mm:ss''Z');
% opts = setvaropts(opts, 4, "WhitespaceRule", "preserve");
% opts = setvaropts(opts, [4, 5, 6, 8, 9, 10, 12], "EmptyFieldRule", "auto");
% opts.ExtraColumnsRule = "ignore";
% opts.EmptyLineRule = "read";

% Import the data
out = readtable(filename, opts);

% generate separate date, time variables
% time = NaN(numel(out.datetime));
% date = NaN(numel(out.datetime));

% for i=1:numel(out.date_time,1)
%     if ~isnan(out.date_time(i))
%         tmp = out.date_time(i);
%         j = find(tmp=='T');
%         date = 
% u = NaN(numel(out.windstring),1);
% v = NaN(numel(out.windstring),1);
% for i = 1:numel(out.windstring)
%     if ~isnan(out.start_hour(i))
%         tmp = out.windstring{i}; % dir/wspd 360/0.52
%         j = find(tmp=='/');
%         dir = str2double(tmp(1:j-1));
%         U = str2double(tmp(j+1:end));
%         if ~isnan(U) && isnan(dir); dir = 0; end
%         dir = 270 - dir; % convert to "math" wind direction
%         dir(dir<0) = dir(dir<0) + 360;
%         u(i) = U*cosd(dir);
%         v(i) = U*sind(dir); 
%         U(i) = U;
%     end
% end
% out.u = u;
% out.v = v;


end