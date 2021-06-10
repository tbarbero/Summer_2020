% get nice map of Salton Basin

clc;clear;close

SS = readSSmet;
CARB = readCARBmet;
JPL = readJPLmet;

% "KL08.csv"
sites = ["KL08.2020-08-10.csv","CQ125.2020-08-10.csv","KTRM.2020-08-07.csv","KIPL.2020-08-10.csv","MXCB1.2020-08-10.csv","CQ047.2020-08-10.csv"]
for i=1:numel(sites)
    % get metadata for site
tbl = readMESOWEST(sites(i));

tmp = tbl.stationID{4};
j = find(tmp==':');
site = tmp(j+2:end);

tmp = tbl.stationID{6};
j = find(tmp==':');
lat = tmp(j+2:end);
lat = str2double(lat);

tmp = tbl.stationID{7};
j = find(tmp==':');
lon = tmp(j+2:end);
lon = str2double(lon);

clearvars tmp j 

geoscatter(lat,lon,'w','filled','MarkerEdgeColor','k','HandleVisibility','off');hold on
legend('Met Sites')
site_name = strcat("\leftarrow",site);
% text(lat,lon+0.03,site_name, 'FontSize',8);
end



% text(SS.lat,SS.lon+0.02,"\leftarrow Our Site",'FontSize',8)
% text(SS.lat,SS.lon-0.22,"CARB\rightarrow",'FontSize',8)
geoscatter(JPL.lat,JPL.lon,'w','filled','MarkerEdgeColor','k');

% plot NKX site 
geoscatter(32.887299, -117.119843,'g','filled','MarkerEdgeColor','k');
% text(32.887299, -117.119843+0.03,"\leftarrow NKX",'FontSize',8)

% text(JPL.lat,JPL.lon-0.18,"JPL \rightarrow",'FontSize',8)
geoscatter(SS.lat,SS.lon,'r','filled','MarkerEdgeColor','k');
legend('Met Stations','NKX Sounding Site','Our Site')

gx=gca;
gx.LongitudeLabel.String = 'Longitude (E)';
gx.LatitudeLabel.String = 'Latitude (N)';
gx.GridColor = 'w';
gx.GridAlpha = 0.5;
% gx=geoaxes;
% gx.LatitudeAxis.TickLabelInterpreter  = 'Latex';
% gx.LongitudeAxis.TickLabelInterpreter = 'Latex';
% gx.LatitudeAxis.TickLabelFormat = 'dd';
% gx.LongitudeAxis.TickLabelFormat = 'dd';
geobasemap 'colorterrain';
geolimits([32.42 34.3],[-116.5 -115.5])

% define topography
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
h=text(33.3,-116.5,'\bf Peninsular Range','FontSize',12,'BackgroundColor','white');

set(h,'Rotation',310)
f=text(33.45,-115.95,'\bf Salton Sea ','BackgroundColor','white');
set(f,'Rotation',315)
a = sprintf('Coachella\n    Valley')
b = strcat('\bf',a);
g=text(33.9,-116.5,b,'BackgroundColor','white');
% g=text(33.9,-116.5,b,'Color','red','BackgroundColor','white');
set(g,'Rotation',320)

% print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/basin_map_blank')

% saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/map.png')