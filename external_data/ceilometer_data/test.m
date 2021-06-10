% experimenting to find threshold value of clouds in BS2/BS2 data.
clear;clc;close
% load in huge data sets
load('pre_composite.mat');
load('bottomdays.mat');
load('/Users/tyler/Documents/Summer2020/external_data/ceilometer_data/comp50/CL51_composite.mat','t1','t2','z');
x = linspace(0,24,5401);
d = datetime(2020,8,10,'TimeZone','America/Los_Angeles');
Bs = nanmean(Bs1,3);


%% remove clouds
% check to see if threshold value of n=2000 works for days w-w/o clouds
for i=1:size(Bs1,3)
    a = Bs1(:,:,i);
    m(i) = max(a(:));
end
n=20000;
g = find(m<n); % g returns index of m that satisfies
%%
days_observed = bottom_days(g);
days_observed = datestr(days_observed);
for i=1:size(days_observed,1)
    days_strings(i) = string(days_observed(i,:));
end
%%
for i=1:5
    % plot with clouds
    figure(1)
    tmp = Bs1(:,:,g(i));
%     mx = max(tmp(:));
%     tmp = tmp./mx;
    subplot(2,1,1)
    imagesc(x,z,tmp)
    set(gca,'ydir','normal');xticks([0:2:24])
    colorbar
    caxis([0,2000])
    title([days_strings(i),' Raw Data'])
    
    % plot without clouds
    tmp(tmp>n)=NaN;
    subplot(2,1,2)
    imagesc(x,z,tmp)
    set(gca,'ydir','normal');xticks([0:2:24])
    colorbar
    caxis([0,2000])
    xlabel('Hour (UTC)')
    ylabel('z (m)')
    title('After Cloud Removal')
    pause(2)
%     clf
%     pause(5)
end



%% find a "normal" mode day...
for i=1:size(Bs1,3)
    a = Bs1(:,:,i);
    m(i) = max(a(:));
end
g = find(m<2000);
normal_days = bottom_days(g); % get dates
normal_str = datestr(normal_days); 
for i=1:size(normal_str,1)
normal_strs(i) = string(normal_str(i,:));end
normal_strs = normal_strs';
clearvars normal_str
%%
% plot stoof
for i=1:numel(g)
    tmp = Bs1(:,:,g(i));
    mx = max(tmp(:));
    tmp = tmp/mx;
    figure(1)
    imagesc(x,z,tmp)
    set(gca,'ydir','normal');xticks([0:2:24]);grid;
    colorbar
    caxis([0,1])
    title([normal_strs(i),num2str(mx)])
    pause(2)
end

%% plotting
for i=20:25
tmp = Bs1(:,:,g(i));
imagesc(x,z,tmp);
xlabel('Hour (UTC)');ylabel('z (m)');title([normal_strs(i),': Normal Days'])
set(gca,'ydir','normal');xticks([0:2:24]);grid;colorbar
pause(2)
end











%%
% find n (threshold value)
% n=prctile(Bs1(:),98);
n=2000;
% n = prctile(Bs1,90);
% get rid of clouds
Bs1(Bs1>n)=NaN;
Bs2(Bs2>n)=NaN;
% Bs1(Bs1<0)=NaN;
% Bs2(Bs2<0)=NaN;

% average
Bs1mean = nanmean(Bs1,3);
Bs2mean = nanmean(Bs2,3);
%%
% combine UTC indices from two days to get full PST day
ind1 = find(day(datetime(t1,'TimeZone','America/Los_Angeles'))==day((d-1)));
ind2 = find(day(datetime(t2,'TimeZone','America/Los_Angeles'))==day((d-1)));
Bs = [Bs1mean(:,ind1) Bs2mean(:,ind2)];
% Ec = [Ec1(:,ind1) Ec2(:,ind2)];

% scale data
mx = max(Bs(:));
Bs = Bs./mx;

%%
%plot

imagesc(x,z,Bs);
set(gca,'ydir','normal')
colorbar
caxis([0,1])
xlabel('Hour (PST)');ylabel('z (m)');title('Backscatter composite')
xticks(0:2:24);grid

%%

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
% caxis([0,1])
ylabel(c,'Concentration','Interpreter','latex');
c.TickLabelInterpreter = 'latex';
% set(gca, 'YScale', 'log')
caxis([0,1])
% plot(x,Blh(1,:),'LineWidth',0.001,'Color','red')
% title('Backscatter composite','Interpreter','latex');
xlabel('Hour (PST)','Interpreter','latex')
ylabel('Altitude (m)','Interpreter','latex')
set(gca,'ticklabelinterpreter','latex')
xticks([0:2:24]);