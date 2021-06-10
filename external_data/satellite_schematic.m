% label satellite image
clear;clc;close
img = imread('SS_NASA_2.jpeg');
%%
x = [887,1011,933,1571,1627,1552];
y = [902,581,531,936,1430,1263];
imshow(img);hold on
scatter(x(:),y(:),150,'filled','MarkerEdgeColor','k','MarkerFaceColor','w')
scatter(149,1192,150,'filled','MarkerEdgeColor','k','MarkerFaceColor','g')

scatter(1336,997,150,'filled','MarkerEdgeColor','k','MarkerFaceColor','r')
lgd = legend('Met Stations','NKX Sounding Site','Our Site','fontsize',20,'interpreter','latex');

% saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/satellite_img.png')