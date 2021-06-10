% schematic map
SS = readSSmet;
subplot(1,2,1)
geoscatter(SS.lat,SS.lon,'MarkerEdgeAlpha',0)
geobasemap 'colorterrain'
gx=gca;
gx.LongitudeLabel.String = 'Longitude (E)';
gx.LatitudeLabel.String = 'Latitude (N)';
gx.Title.String = 'Nighttime';
gx.GridColor = 'w';
gx.GridAlpha = 0.5;
geolimits([32.42 34.3],[-116.5 -115.5])

subplot(1,2,2)
geoscatter(SS.lat,SS.lon,'MarkerEdgeAlpha',0)
geobasemap 'colorterrain'
gx=gca;
gx.Title.String = 'Daytime';
gx.LongitudeLabel.String = 'Longitude (E)';
gx.LatitudeLabel.String = ' ';
gx.GridColor = 'w';
gx.GridAlpha = 0.5;
geolimits([32.42 34.3],[-116.5 -115.5])

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])

saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/schematic.png')