% find normal-mode day in ceilometer data
clc;clear;close
% load in huge data sets
load('pre_composite.mat','Bs1');
load('bottomdays.mat')
load('bottom_NTB_wspd.mat','NTBbottomdays')
load('/Users/tyler/Documents/Summer2020/external_data/ceilometer_data/comp75/CL51_composite.mat','z','t1','t2');
x = linspace(0,24,5401);
%%
% look at low wind speed days(g)
g = ismember(bottom_days,NTBbottomdays);  % use low wspd days from NTB 

% get datestrings to see what day it is
normal_days = bottom_days(g);
normal_str = datestr(normal_days); 
for i=1:size(normal_str,1)
normal_strs(i) = string(normal_str(i,:));end
normal_strs = normal_strs';
clearvars normal_str
ind = find(g==1);
%%
c = 0;
% for i=1:numel(ind)
% for i=72:74
% for i=40:65 
for i=121 :123

  

    tmp = Bs1(:,:,ind(i));
    mx = max(tmp(:));
    tmp = tmp/mx;
%     if mx==0 % erroneous
%         continue
%     elseif mx>4000 % erroneous
%     else 
% %       figure(i)
        subplot(1,3,i-120)
        imagesc(x,z,tmp)
        set(gca,'ydir','normal');xticks([0:2:24]);grid;
        colorbar
        caxis([0,1])
        title([normal_strs(i),num2str(mx)])
        xlabel('Hour (UTC)')
        ylabel('z (m)')
        pause
        pc = c+1;
%     end
end