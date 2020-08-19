% Leeward sites
clc;
clear all;

% parse surface met station station
tic
read;
file = load('MesoWest.mat');

sites = fieldnames(file); % gets array of site names

for i = 1:numel(sites)
    site = sites{i};
    malt = file.(site).elev;
    mlat = file.(site).lat;
    mlon = file.(site).lon;
    mtime = file.(site).time(:);
    
    newstruct(i).name = site;
    newstruct(i).altitudeft = malt;
    newstruct(i).altitudem = unitsratio('m','feet') * newstruct(i).altitudeft;
    newstruct(i).lat = mlat;
    newstruct(i).lon = mlon;
    newstruct(i).time = mtime;
    
    for j = 1:numel(file.(site).vars)
        if ismember(file.(site).vars(j,1), {'wind_speed_set_1'})
            mWS = file.(site).data(j,:);
            newstruct(i).windspeed = mWS;
        elseif ismember(file.(site).vars(j,1), {'air_temp_set_1'})
            mtemp = file.(site).data(j,:);
            newstruct(i).temperature = mtemp;
        elseif ismember(file.(site).vars(j,1), {'pressure_set_1'}) 
            mpressure1 = file.(site).data(j,:);
            newstruct(i).pressure1 = mpressure1;
        elseif ismember(file.(site).vars(j,1), {'pressure_set_1d'}) 
            mpressure1d = file.(site).data(j,:);
            newstruct(i).pressure1d = mpressure1d; 
        elseif ismember(file.(site).vars(j,1), {'wind_direction_set_1'})
            mwinddir = file.(site).data(j,:);
            newstruct(i).winddirection = mwinddir;
        else
            continue
        end
    end
end

% Parse Salton Sea Met Station data
disp('Salton_Sea_Site')
ss = numel(sites)+1;
ourSite = load('202002.mat', 'time', 'T','P', 'wspd', 'wdir');
newstruct(ss).name = 'SaltonSea';
newstruct(ss).altitudem = -32;
newstruct(ss).lat = 33.16923;
newstruct(ss).lon = -115.85593;
newstruct(ss).time = ourSite.time;
newstruct(ss).temperature = ourSite.T;
newstruct(ss).pressure1 = 100.*ourSite.P;
newstruct(ss).pressure1d = [];
newstruct(ss).windspeed = 0.51444.*ourSite.wspd;
newstruct(ss).winddirection = ourSite.wdir;

% Parse JPL Data
disp('JPL_Site')
filename = 'JPLdata.txt';
delimiterIn = ' ';
headerlinesIn = 4;
JPL = importdata(filename,delimiterIn, headerlinesIn);
JPL.header = JPL.textdata(1:4,1:8);
JPL.time = append(JPL.textdata(5:41764,1), ' ', JPL.textdata(5:41764,2));
JPL.time = datetime(JPL.time, 'InputFormat', 'MM-dd-yyyy HH:mm:ss');
clearvars filename fileId headerlinesIn delimiterIn

newstruct(ss+1).name = 'JPL';
newstruct(ss+1).altitudem = -71;
newstruct(ss+1).lat = 33.22532;
newstruct(ss+1).lon = -115.82425;
newstruct(ss+1).time = JPL.time
newstruct(ss+1).temperature = JPL.data(:,3);
newstruct(ss+1).pressure1 = 100.*JPL.data(:,5);
newstruct(ss+1).pressure1d = [];
newstruct(ss+1).windspeed = JPL.data(:,1); %m/s
newstruct(ss+1).winddirection = JPL.data(:,2);

% Get pressure distributed between two variables
for i=1:numel(newstruct)
if isempty(newstruct(i).pressure1)
    if isempty(newstruct(i).pressure1d)
        continue
    elseif isnan(newstruct(i).pressure1d(1))
        newstruct(i).pressure1d = [];
    else
        newstruct(i).pressure = newstruct(i).pressure1d;
    end
    
elseif isnan(newstruct(i).pressure1(1))
    newstruct(i).pressure1 = [];
else
    newstruct(i).pressure = newstruct(i).pressure1;
end

% Get potential temperature
try
    theta = newstruct(i).temperature .* (100000./newstruct(i).pressure).^(2/7);
    newstruct(i).theta = theta;
catch
    newstruct(i).theta = [];
    continue
end
end
fields = {'pressure1d', 'pressure1'};
newstruct = rmfield(newstruct,fields);
toc
clearvars -except file newstruct sites JPL
%% Plot sites using GEOBASEMAP
for i=1:numel(newstruct)
    lat(i) = newstruct(i).lat;
    lon(i) = newstruct(i).lon;
end

geoscatter(lat, lon)
hold
% geoscatter(lat(10),lon(10),'red')
geobasemap 'colorterrain'
geolimits([32.4 34],[-117 -116])
hold off
% currentfig = pwd;
% filepath = append(currentfig,'/figs/','site_map','.png');
% print -depsc leewardsitemap
% saveas(gcf,filepath);
%% Parse Sounding Data
soundings = ['USSAL_20200222_1659.txt';'USSAL_20200222_1802.txt';'USSAL_20200222_2008.txt';...
     'USSAL_20200222_2241.txt';'USSAL_20200229_1923.txt';'USSAL_20200229_2127.txt';...
     'USSAL_20200229_2328.txt';'USSAL_20200301_0126.txt'];
for i=1:numel(soundings(:,1))
    eval(['data = load(soundings(' int2str(i) ',:));'])
    eval(['s' int2str(i) 'altitude = data(:,12);'])
    eval(['s' int2str(i) 'windspeed = data(:,11);'])
    eval(['s' int2str(i) 'temperature = data(:,8);'])
end
%% Looking at Cold pool (Parse Met station data according to hourly times)
for i=1:24
    dd(i) = append("02-Feb-2020 " ,int2str(i-1), ":00:00")
end
for i=1:numel(dd)
    disp(dd(i))
    bb = dd(i);
    b = datenum(dd(i));
    
    for j=1:numel(newstruct)
        [m(i,j), ind(i,j)] = min(abs(b-datenum(newstruct(j).time(:))));
        timedelta(i,j) = between(bb,newstruct(j).time(ind(i,j)));
         
         % if timedelta(i,j)>20: met temps(i,j)=Nan else do below
         timeconstraint = minutes(20);
     
         if abs(time(timedelta(i,j))) > timeconstraint
             % if true set as NaN (bad data)
             mettemps(i,j) = NaN;
             metws(i,j) = NaN;
             metalts(i,j) = NaN;     
             metwinddirection(i,j) = NaN;
             mettheta(i,j) = NaN;
         else
             % create windspeed and temp vars
             mettemps(i,j) = newstruct(j).temperature(ind(i,j));
             metws(i,j) = newstruct(j).windspeed(ind(i,j));
             metalts(i,j) = newstruct(j).altitudem;
             metwinddirection(i,j) = newstruct(j).winddirection(ind(i,j));
             try
                 mettheta(i,j) = newstruct(j).theta(ind(i,j));
             catch
                 mettheta(i,j) = NaN;
             end
         end
         
    end
end
clearvars m b bb i j k
%% Plots Cold Pool

% for i=1:numel(dates(:,1))
for i=13 % change this to look at certain plots
    eval(['figure(' int2str(i) ')'])
    subplot(1,2,1)
    eval(['s=scatter(metws(' int2str(i) ',:),metalts(2,:),300);'])
    s.Marker='.';
    hold on
%     eval(['plot(s' int2str(i) 'windspeed,s' int2str(i) 'altitude)'])
    ylim([-Inf 1500])
    grid on
    xlabel('Windspeed (m/s)')
    ylabel('Altitude (m)')
    title(["Windspeed v Altitude; " num2str(dd(i)) "UTC"])
    legend({'Met Station Data'},'Location','NW')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75])
    hold off
    
    subplot(1,2,2)
    hold on
    eval(['s1=scatter(mettemps(' int2str(i) ',:),metalts(2,:),300);'])
    eval(['s2=scatter(mettheta(' int2str(i) ',:),metalts(2,:),300);'])
    s1.Marker='.';
    s2.Marker='.';
%     eval(['plot(s' int2str(i) 'temperature,s' int2str(i) 'altitude)'])
    ylim([-Inf 1500])
    grid on
    xlabel('Temperature (^oC)')
    ylabel('Altitude (m)')
    title(["Temperature v Altitude; " num2str(dd(i)) "UTC"])
    legend({'(in-situ)','(theta)'},'Location','NE')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75])
    hold off
%     currentfig = pwd;
%     filepath = append(currentfig,'/figs/',dates(i,:),'.png');
%     saveas(gcf,filepath)
end
%% Parse Met Station Data
dates = ['22-Feb-2020 16:59:00';'22-Feb-2020 18:02:00';'22-Feb-2020 20:08:00';...
    '22-Feb-2020 22:41:00';'29-Feb-2020 19:23:00';'29-Feb-2020 21:27:00';...
    '29-Feb-2020 23:28:00';'01-Mar-2020 01:26:00'];
for i=1:numel(dates(:,1))
    disp(dates(i,:))
    bb = dates(i,:);
    b = datenum(dates(i,:));
    
    for j=1:numel(newstruct)
        [m(i,j), ind(i,j)] = min(abs(b-datenum(newstruct(j).time(:))));
        timedelta(i,j) = between(bb,newstruct(j).time(ind(i,j)));
         
         % if timedelta(i,j)>20: met temps(i,j)=Nan else do below
         timeconstraint = minutes(20);
     
         if abs(time(timedelta(i,j))) > timeconstraint
             % if true set as NaN (bad data)
             mettemps(i,j) = NaN;
             metws(i,j) = NaN;
             metalts(i,j) = NaN;     
             metwinddirection(i,j) = NaN;
             mettheta(i,j) = NaN;
         else
             % create windspeed and temp vars
             mettemps(i,j) = newstruct(j).temperature(ind(i,j));
             metws(i,j) = newstruct(j).windspeed(ind(i,j));
             metalts(i,j) = newstruct(j).altitudem;
             metwinddirection(i,j) = newstruct(j).winddirection(ind(i,j));
             try
                 mettheta(i,j) = newstruct(j).theta(ind(i,j));
             catch
                 mettheta(i,j) = NaN;
             end
         end
         
    end
end
clearvars m b bb i j k
%% Plots

% for i=1:numel(dates(:,1))
for i=1 % change this to look at certain plots
    eval(['figure(' int2str(i) ')'])
    subplot(1,2,1)
    eval(['s=scatter(metws(' int2str(i) ',:),metalts(2,:),300);'])
    s.Marker='.';
    hold on
    eval(['plot(s' int2str(i) 'windspeed,s' int2str(i) 'altitude)'])
    ylim([-Inf 1500])
    grid on
    xlabel('Windspeed (m/s)')
    ylabel('Altitude (m)')
    title(["Windspeed v Altitude; " num2str(dates(i,:)) "UTC"])
    legend({'Met Station Data', 'Sounding Data'},'Location','NW')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75])
    hold off
    
    subplot(1,2,2)
    hold on
    eval(['s1=scatter(mettemps(' int2str(i) ',:),metalts(2,:),300);'])
    eval(['s2=scatter(mettheta(' int2str(i) ',:),metalts(2,:),300);'])
    s1.Marker='.';
    s2.Marker='.';
    eval(['plot(s' int2str(i) 'temperature,s' int2str(i) 'altitude)'])
    ylim([-Inf 1500])
    grid on
    xlabel('Temperature (^oC)')
    ylabel('Altitude (m)')
    title(["Temperature v Altitude; " num2str(dates(i,:)) "UTC"])
    legend({'(in-situ)','(theta)', 'Sounding Data'},'Location','NE')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75])
    hold off
%     currentfig = pwd;
%     filepath = append(currentfig,'/figs/',dates(i,:),'.png');
%     saveas(gcf,filepath)
end
%% Wind direction
s = scatter(metwinddirection(5,:),metalts(2,:),100)
s.Marker='.'
xticks([0:45:460])
xlim([0,360])
xlabel('Wind Direction (^o)')
ylabel('Altitude')
grid on

%put degrees on xticks
xt=get(gca,'xtick');
for k=1:numel(xt);
xt1{k}=sprintf('%d°',xt(k));
end
set(gca,'xticklabel',xt1);
%% Get Data for Shaded Plot -- Cold Pool
tic
for i = 1:24
    hours(i) = datenum(append("22-Feb-2020 " ,int2str(i-1), ":00:00)"));
    datestrings(i) = {datestr(hours(i),'dd-mmm-yyyy HH:MM:SS')};
end

for i=1:24 % hourly
    bb = datestrings{i};
    disp(bb)
    for j=1:numel(newstruct)
        [minn(i,j), indd(i,j)] = min(abs(hours(i)-datenum(newstruct(j).time(:))));
        
        % get time diff betw desired hour and closest time val for ea site
        timedeltaprofs(i,j) = between(bb,newstruct(j).time(indd(i,j)));
        
        % get temp profiles
        try
            tempprofs(j,i) =  newstruct(j).temperature(indd(i,j));
        catch
            continue
        end
    end
end
clearvars minn bb i j k 
%% Plot Shaded Plot
figure(9)
[h,alt]=meshgrid(hours,metalts(1,:)); % meshgrid creates a grid wrt dim of x,y
scatter(h(:),alt(:),50,tempprofs(:),'filled')
datetick('x','mm-dd HH:MM')
l = colorbar;
l.Label.String = '(^oC)';
xlabel('Time (UTC)')
ylabel('Altitude (m)')
title('Temperature Time Series (Leeward Sites)')
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75])
% saveas(gcf,append(pwd,'/figs/','shaded_plot_Feb29.png'))