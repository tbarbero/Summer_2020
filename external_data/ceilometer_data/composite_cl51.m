% Composite CL51 Level 3 data around the dates in "bottomdays.mat"
clearvars

clpth = '~/data/SaltonSea/CL51/data/';
clst = 'L3_DEFAULT__';
clen = '0000_1_360_1_3120_10_30_4000_3_0_1_500_1000_4000_60.nc';
fmt = '%1.2i';

%tmp = load('bottomdays.mat');
tmp = load('pmdays.mat');

%days = tmp.bottom_days;
days = tmp.pmdays;

clearvars tmp

for i = 1:numel(days)
  % The day of (UTC)
  t1 = days(i);
  f1 = [clpth clst num2str(year(t1)) num2str(month(t1),fmt) num2str(day(t1),fmt) clen];

  % The day after (UTC)
  t2 = days(i)+1;
  f2 = [clpth clst num2str(year(t2)) num2str(month(t2),fmt) num2str(day(t2),fmt) clen];

  % Define Array size
  if i==1
    time = double(ncread(f1,'time'));
    z = double(ncread(f1,'range')) - 30.5; % correction for sub sea level
    Blh = double(ncread(f1,'bl_height'));
    Bs1 = NaN(numel(z),numel(time),numel(days));
    Bs2 = NaN(numel(z),numel(time),numel(days));
    Ec1 = NaN(numel(z),numel(time),numel(days));
    Ec2 = NaN(numel(z),numel(time),numel(days));
    Blh1 = NaN(size(Blh,1),size(Blh,2));
    Blh2 = NaN(size(Blh,1),size(Blh,2));
  end

  % populate the array - assuming there may just be one or two missing values
  if exist(f1)*exist(f2)~=0
    tmp1 = ncread(f1,'Bs_profile_data');
    tmp2 = ncread(f2,'Bs_profile_data');
    if size(tmp1,2)>5390 & size(tmp2,2)>5390
      Bs1(:,1:size(tmp1,2),i) = tmp1;
      Bs2(:,1:size(tmp2,2),i) = tmp2;
    end
    tmp1 = ncread(f1,'Ec_profile_data');
    tmp2 = ncread(f2,'Ec_profile_data');
    if size(tmp1,2)>5390 & size(tmp2,2)>5390
      Ec1(:,1:size(tmp1,2),i) = tmp1;
      Ec2(:,1:size(tmp2,2),i) = tmp2;
    end
    tmp1 = ncread(f1,'bl_height');
    tmp2 = ncread(f2,'bl_height');
    if size(tmp1,2)>5390 & size(tmp2,2)>5390
        Blh1(:,1:size(tmp1,2),i) = tmp1;
        Blh2(:,1:size(tmp2,2),i) = tmp2;
    end
    % clean and sort Blh
        Blh1(Blh1==-999)=NaN;
        Blh2(Blh2==-999)=NaN;
        Blh1 = sort(Blh1,'ascend');
        Blh2 = sort(Blh2,'ascend');
  end

end
clearvars clpth clst clen fmt tmp tmp1 tmp2 days i t1 t2 time 

% save test dataset
%save('pre_composite.mat','Bs1','Bs2', '-v7.3');


% choose n value by looking at histogram(Bs1)
% find n (threshold value)
%n=prctile(Bs1(:),98);
n = 2000;
% get rid of clouds and negative values
Bs1(Bs1>n)=NaN;
Bs2(Bs2>n)=NaN;
%Bs1(Bs1<0)=NaN;
%Bs2(Bs2<0)=NaN;

% get rid of Ec values that detect clouds in Bs
g = isnan(Bs1); % g/f should return indices, use to set same indices of EC data to NaN -- then perform averages
f = isnan(Bs2);

Ec1(g)==NaN;
Ec2(f)==NaN;

% average over all days
Bs1 = nanmean(Bs1,3);
Bs2 = nanmean(Bs2,3);
Ec1 = nanmean(Ec1,3);
Ec2 = nanmean(Ec2,3);
Blh1 = nanmean(Blh1,3);
Blh2 = nanmean(Blh2,3);


% Extract the 24-hour PDT times
t1 = double(ncread(f1,'time'));
t1 = t1/(24*60*60) + datenum('01/01/1970'); % days since 0000-01-01
[y,o,d,h,m,s] = datevec(t1);
t1 = datetime(y,o,d,h,m,s,'TimeZone','UTC');
t2 = double(ncread(f2,'time'));
t2 = t2/(24*60*60) + datenum('01/01/1970');
[y,o,d,h,m,s] = datevec(t2);
t2 = datetime(y,o,d,h,m,s,'TimeZone','UTC');

d = d(1);
ind1 = find(day(datetime(t1,'TimeZone','America/Los_Angeles'))==(d-1));
ind2 = find(day(datetime(t2,'TimeZone','America/Los_Angeles'))==(d-1));
Bs = [Bs1(:,ind1) Bs2(:,ind2)];
Ec = [Ec1(:,ind1) Ec2(:,ind2)];
Blh = [Blh1(:,ind1) Blh2(:,ind2)];

clearvars ans Bs1 Bs2 Ec1 Ec2 Blh1 Blh2 y o d h m s ind1 ind2 f1 f2 f g n t1 t2
save('CL51_composite.mat')
