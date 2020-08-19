function out = readPM10(filename)
%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["site", "monitor", "date", "start_hour", "value", "variable", "units", "quality", "prelim", "name"];
opts.VariableTypes = ["double", "char", "datetime", "double", "double", "string","string", "double", "char", "string"];
% opts.VariableNames = ["summary_date", "site", "monitor", "pm10_shr_davg", "name", "obs_count", "units", "basin", "county_name", "state", "latitude", "longitude"];
% opts.VariableTypes = ["datetime", "double", "char", "double", "categorical", "categorical", "string", "categorical", "categorical", "categorical", "double", "categorical"];
opts = setvaropts(opts, 3, "InputFormat", "yyyy-MM-dd");
% opts = setvaropts(opts, [3], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
out = readtable(filename, opts);

end