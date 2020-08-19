function out = readPKSPD(filename, dataLines)
%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 12);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["site", "date", "start_hour", "gust", "variable", "units", "quality", "prelim", "met_source", "obs_type", "minutes", "name"];
opts.VariableTypes = ["double", "datetime", "double", "double", "categorical", "categorical", "double", "categorical", "categorical", "categorical", "double", "categorical"];
opts = setvaropts(opts, 2, "InputFormat", "yyyy-MM-dd");
opts = setvaropts(opts, [5, 6, 8, 9, 10, 12], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
out = readtable(filename, opts);

end