% Windward sites
clc;
clear all;

% parse surface met station station
tic
read;
file = load('MesoWest.mat');
sites = fieldnames(file); % get array of site names

for i = 1:numel(sites)
    site = sites{i};
    malt = file.(site).elev;
    mlat = file.(site).lat;
    mlon = file.(site).lon;
    mtime = file.(site).time(:);
    
    newstruct(i).name = site
    newstruct(i).altitudeft = malt
    newstruct(i).altitudem = unitsratio('m','feet') * newstruct(i).altitudeft;
    newstruct(i).lat = mlat
    newstruct(i).lon = mlon
    newstruct(i).time = mtime
    
    for j = 1:numel(file.(site).vars)
        if ismember(file.(site).vars(j,1), {'wind_speed_set_1'})
            mWS = file.(site).data(j,:);
            newstruct(i).windspeed = mWS
        elseif ismember(file.(site).vars(j,1), {'air_temp_set_1'})
            mtemp = file.(site).data(j,:);
            newstruct(i).temperature = mtemp
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
%%
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
clearvars -except file newstruct sites
%% Plot sites using GEOBASEMAP
for i=1:numel(newstruct)
    lat(i) = newstruct(i).lat;
    lon(i) = newstruct(i).lon;
end
geoscatter(lat, lon)
geobasemap 'colorterrain'
geolimits([32.4 34],[-117 -116])
print -depsc windwardsitemap
currentfig = pwd;
filepath = append(currentfig,'/figs/','site_map','.png');
% print -depsc leewardsitemap
saveas(gcf,filepath);
%% Parse Sounding Data
fileID1 = fopen('NKX_22Feb_00Z.txt','r'); 
fileID2 = fopen('NKX_22Feb_12Z.txt','r');
fileID3 = fopen('NKX_23Feb_00Z.txt','r');
fileID4 = fopen('NKX_29Feb_00Z.txt','r');
fileID5 = fopen('NKX_29Feb_12Z.txt','r');
fileID6 = fopen('NKX_01Mar_00Z.txt','r');

sizeA = [11 Inf];

for i=1:6
    eval(['sounding' int2str(i) '=fscanf(fileID' int2str(i) ', "%f",sizeA);'])
    eval(['sounding' int2str(i) '=transpose(sounding' int2str(i) ');']) 
    eval(['s' int2str(i) 'altitude = sounding' int2str(i) '(:,2);'])
    eval(['s' int2str(i) 'windspeed = 0.5144.*sounding' int2str(i) '(:,8);'])
    eval(['s' int2str(i) 'temperature = sounding' int2str(i) '(:,3);'])
    eval(['clearvars fileID' int2str(i)])
end
fclose('all');
%% Parsing Met Station Data
dates = ['22-Feb-2020 00:00:00';'22-Feb-2020 12:00:00';'23-Feb-2020 00:00:00';...
    '29-Feb-2020 00:00:00';'29-Feb-2020 12:00:00';'01-Mar-2020 00:00:00']

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
for i=1:numel(dates(:,1))
% for i=6 % change this to look at certain plots
    eval(['figure(' int2str(i) ')'])
    subplot(1,2,1)
    eval(['s=scatter(metws(' int2str(i) ',:),metalts(2,:),300);'])
    s.Marker='.';
    hold on
    eval(['plot(s' int2str(i) 'windspeed,s' int2str(i) 'altitude)'])
    ylim([-Inf 2000])
    grid on
    xlabel('Windspeed (m/s)')
    ylabel('Altitude (m)')
    title(["Windspeed v Altitude; " num2str(dates(i,:)) "UTC"])
    legend({'Met Station Data', 'Sounding Data'},'Location','SE')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75])
    
    subplot(1,2,2)
    hold on
    eval(['s1=scatter(mettemps(' int2str(i) ',:),metalts(2,:),300);'])
    eval(['s2=scatter(mettheta(' int2str(i) ',:),metalts(2,:),300);'])
    s1.Marker=".";
    s2.Marker='.';
    eval(['plot(s' int2str(i) 'temperature,s' int2str(i) 'altitude)'])
    ylim([-Inf 2000])
    grid on
    xlabel('Temperature (^oC)')
    ylabel('Altitude (m)')
    title(["Temperature v Altitude; " num2str(dates(i,:)) "UTC"])
    legend({'(in-situ)', '(theta)','Sounding Data'},'Location','NE')
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.07, 0.8, 0.75])
    
%     currentfig = pwd;
%     filepath = append(currentfig,'/figs/',dates(i,:),'.png');
%     saveas(gcf,filepath)
end
%% wind direction?
s = scatter(metwinddirection(1,:),metalts(1,:),100)
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
    hours(i) = datenum(append("29-Feb-2020 " ,int2str(i-1), ":00:00)"));
    datestrings(i) = {datestr(hours(i),'dd-mmm-yyyy HH:MM:SS')};
end

for i=1:24 % hourly
    bb = datestrings{i};
    b=hours(i);
    disp(bb)
    
    for j=1:numel(newstruct)
        [minn(i,j), indd(i,j)] = min(abs(hours(i)-datenum(newstruct(j).time(:))));
        
        % get time diff betw desired hour and closest time val for ea site
        timedeltaprofs(i,j) = between(bb,newstruct(j).time(indd(i,j)));
 
        % get temp profs
        try
            tempprofs(j,i) =  newstruct(j).temperature(indd(i,j));
        catch
            continue
        end
    end
end
% figure out which index of time closest to each hour (1-24). Take index
% and get corresp temp for all altitudes for each profile.
toc
clearvars minn a ugh b bb i j k 
%%
% %%
% x=1:50;
% y=x;
% [X,Y] = meshgrid(x);
% z=rand(50,50);
% scatter(X(:),Y(:),50,z(:),'fill')
figure
[h,alt]=meshgrid(hours,metalts(1,:)); % meshgrid creates a grid wrt dim of x,y
scatter(h(:),alt(:),50,tempprofs(:),'filled')
datetick('x','mm-dd HH:MM')
l = colorbar;
l.Label.String = '(^oC)';
xlabel('Time (UTC)')
ylabel('Altitude (m)')
title('Temperature Time Series (Windward Sites)')
saveas(gcf,append(pwd,'/figs/','shaded_plot_Feb29.png'))