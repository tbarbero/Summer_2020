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

out = readtable(filename, opts);
end