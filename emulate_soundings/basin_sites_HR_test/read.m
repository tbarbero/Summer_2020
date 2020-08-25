% Read in the mesowest data
% 'America/Los_Angeles'
clearvars
files = dir('*.csv');

% read in each file
for i = 1:numel(files) % length of files

    f = files(i).name;
    disp(f)
    
    opts = delimitedTextImportOptions("NumVariables", 21);
    opts.DataLines = [1 Inf]; % read all rows of csv file 1 to end of file
    opts.Delimiter = ",";
    tbl = readtable(f, opts);

    % Meta : Var1 (column 1) and {#} # is the row. 
    name = tbl.Var1{2}(17:end); % gets station name 
    lat = str2double(tbl.Var1{3}(13:end)); % gets str(lat) -> double
    lon = str2double(tbl.Var1{4}(14:end));
    elev = str2double(tbl.Var1{5}(19:end));
    id = tbl.Var1{9};
    % seeing what time is in UTC or PST? if PST do---
    clearvars time
    if strncmp('UTC',tbl.Var2{9}(end-2:end),3)
        time = datetime(tbl.Var2(9:end),'InputFormat', ...
            'MM/dd/yyyy HH:mm ''UTC''','TimeZone','GMT');
    elseif strncmp('PST',tbl.Var2{9}(end-2:end),3)
        %?????????????????
        for j = 9:numel(tbl.Var2)
            tbl.Var2{j} = tbl.Var2{j}(1:end-4);
        end
        %?????????????????
        % taking all times converting to UTC dattime objs
        %diff between tbl.Var2{} and () is that {} makes it an array while
        % () outputs str
        time = datetime(tbl.Var2(9:end),'InputFormat', ...
            'MM/dd/yyyy HH:mm','TimeZone','UTC-8');
        time = datetime(time,'TimeZone','UTC');
    end

    vars = cell(18,1);
    data = NaN(18,numel(time)); % creates Nan values of a 18 by 551 array
    for j = 1:18
        eval(['vars{j} = tbl.Var' num2str(j+2) '{7};']);
        eval(['tmp = tbl.Var' num2str(j+2) '(9:end);']);
        data(j,:) = str2double(tmp);
    end
    
    eval(['met.' id '.name = name;'])
    eval(['met.' id '.lat = lat;'])
    eval(['met.' id '.lon = lon;'])
    eval(['met.' id '.elev = elev;'])
    eval(['met.' id '.time = time;'])
    eval(['met.' id '.vars = vars;'])
    eval(['met.' id '.data = data;'])
    
end

save('MesoWest.mat','-struct','met')