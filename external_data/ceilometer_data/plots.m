% Plot ceilometer backscatter and extinction data
clc;clear;close
load('~/Documents/Summer2020/external_data/ceilometer_data/comp75/CL51_composite.mat')
% load('~/Documents/Summer2020/external_data/ceilometer_data/pm_same_days/CL51_composite.mat')

x = linspace(0,24,5400);

% plot Backscatter



mx = max(Bs(:));
Bs = Bs./mx;
% Bs(Bs<0) = 0;
% Bs = log(Bs);
% %
% plot backscatter
imagesc(x,z,Bs);
grid;hold on
set(gca,'ydir','normal')
c = colorbar;
ylabel(c,'Concentration','Interpreter','latex');
c.TickLabelInterpreter = 'latex';
% set(gca, 'YScale', 'log')
caxis([0,1])
% plot(x,Blh(1,:),'LineWidth',0.001,'Color','red')
% title('Backscatter composite','Interpreter','latex');
xlabel('Hour (PST)','Interpreter','latex');
ylabel('Altitude (m)','Interpreter','latex')
set(gca,'ticklabelinterpreter','latex')
xticks([0:2:24]);
% legend('Boundary Layer Height','interpreter','latex','Location','NW')
% saveas(gcf,'/Users/tyler/Documents/Summer2020/external_data/poster_figs/bs.png')
%%

% plot extinction coefficient
imagesc(x,z,log(Ec))
set(gca,'ydir','normal')
colorbar
mx = max(log(Ec(:)));
% caxis([-2,1]) % log(0.01) = -2,log(1)=0, log(10)=1
% caxis([0,1]);
% plot(x,Blh(1,:),'r')
title('Extinction Coefficient composite');xlabel('Hour (PST)');ylabel('z (m)')
xticks([0:2:24])
%% plot lower most level of Ec and B
x = 0:0.5:23.5;
a = Bs(4,:);
b = Ec(4,:);
numtime = hour(t1) + minute(t1)/60;
for i=1:numel(x)
    g=find(numtime>=x(i) & numtime<=x(i)+0.5);
    
    if ~isempty(g); Bs_mean(i) = nanmean(a(g));end
    if ~isempty(g); Ec_mean(i) = nanmean(b(g));end
end

%%
subplot(2,1,1)
plot(x,smooth(Bs(4,:),19))
% plot(x,Bs_mean)
set(gca,'ydir','normal');ylabel('Bs');title(['Backscatter at ',num2str(z(4)),'m composite']);xlabel('Hour (PST)');grid
xticks([0:2:24])
subplot(2,1,2)
plot(x,smooth(Ec(4,:),19))
% plot(x,Ec_mean)
set(gca,'ydir','normal');ylabel('Ec');title(['Extinction Coefficient at ',num2str(z(4)),'m composite']);xlabel('Hour (PST)');grid
xticks([0:2:24])