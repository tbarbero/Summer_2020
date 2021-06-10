clc
clear all

monthly_average_SSMET
hold on
monthly_average_CARB
importJPL
figure(1)
subplot(1,2,1)
legend({'SS','CARB','JPL'},'Location','NW')
subplot(1,2,2)
legend({'SS','CARB','JPL'})

% saveas(gcf,'wspdwdirAverages.png')
%%
figure(2)
subplot(1,2,1)
diurnal
hold on
subplot(1,2,2)
monthly_average_PM10
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
% saveas(gcf,'AODPM10Averages.png')