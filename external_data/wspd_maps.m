% Amato's code
% Make a movie of changes in surface wind speeds over the course of the day
clearvars

% gif variables
h = figure
axis tight manual
filename = 'windsmap.gif';

% load the DEM to plot this first
% contour(dem.lon,dem.lat,dem.z',0:250:2500)
% contour(dem.lon,dem.lat,dem.z',[-66. -66.],'k','linewidth',2);
dem = load('dem.mat');

dem.z = double(dem.z);
ix = dem.lon > -116.8 & dem.lon < 114.8;
iy = dem.lat > 32.5 & dem.lat < 34;
dem.lon = dem.lon(ix)';
dem.lat = dem.lat(iy)';
dem.z = double(dem.z(ix,iy));
clearvars ix iy


% Load data
%   meta      4x3              1906  table               
%   wdir      4x24              768  double              
%   wspd      4x24              768  double 
% 
% meta =
%   4×3 table
%      sites      latt      lonn  
%     _______    ______    _______
% 
%     "KTRM"     33.627    -116.16
%     "CQ047"    33.708    -116.22
%     "KIPL"     32.834    -115.58
%     "MXCB1"    32.667    -115.46
load('schematic_data.mat')


% get lats/lons
x = meta.lonn;
y = meta.latt;


% plot winds at time t

for i = 1:24
            
%     subplot(6,4,i)
    
    % plot the DEM
    contour(dem.lon,dem.lat,dem.z',0:500:2500,'LineColor',ones(3,1)*.7)
    hold on
    contour(dem.lon,dem.lat,dem.z',[-66. -66.],'k')
    
    for j = 1:size(meta,1)

        scatter(x(j),y(j),'k','fill')
        
        % Wind barbs
        D = 1/2; % barb fractional length
        sf = 1/6; % scale factor
        t = deg2rad(90-wdir(j,i));

        % start and end points
        sx = x(j);
        sy = y(j);
        px = sx + sf*cos(t);
        py = sy + sf*sin(t);
        plot([sx px],[sy py],'k','linewidth',1)

        u = 1.95*wspd(j,i);
        u = 5*round(u/5);
        if u>=50
            stop
        end

        if u >= 10 && u < 50
            for k = 1:floor(u/10)
                [xx,yy] = p10(px,py,t,D,k-1,sf);
                plot(xx,yy,'k','linewidth',1)
            end
            if ceil((u-5)/10) > floor(u/10)
                [xx,yy] = p5(px,py,t,D,k,sf);
                plot(xx,yy,'k','linewidth',1)
            end
        end
        
        if u==5
            [xx,yy] = p5(px,py,t,D,1,sf);
            plot(xx,yy,'k','linewidth',1)
        end                
    end
    
    grid on; box on; hold off
    title([round(num2str(i-1)) 'PST'])
    set(gca,'XLim',[-116.5 -115.25],'YLim',[32.5 34])
    set(gcf,'color','w');
    
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File 
      if i == 1
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end     
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.32, 0.6, 0.55])
%     print(gcf,'-djpeg',['cmp_sfc_wspd/t' num2str(i) '.jpg'])
%     close(f1)
end
saveas(gcf,'/Users/tyler/Desktop/wspd_maps.png')





% Wind barb functions
function [xx,yy] = p10(px,py,theta,D,pos,sf)
px = px - sf*cos(theta)*pos/6;
py = py - sf*sin(theta)*pos/6;
xx = [px px + sf*D*cos(theta-pi/2)];
yy = [py py + sf*D*sin(theta-pi/2)];
end


function [xx,yy] = p5(px,py,theta,D,pos,sf)
px = px - sf*cos(theta)*pos/6;
py = py - sf*sin(theta)*pos/6;
xx = [px px + sf*D/2*cos(theta-pi/2)];
yy = [py py + sf*D/2*sin(theta-pi/2)];
end