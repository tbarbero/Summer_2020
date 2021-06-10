% s<0 p>0
% p = [270,20,30];
% % both pos
p = [10,20,30];
% c<0
% p=[75,85,180];

p = p*pi/180;
s = sum(sin(p))/numel(p);
c = sum(cos(p))/numel(p);
if s<0 & c>0
    tmp = atan(s/c) + (2*pi); % in rad
    theta = tmp *(180/pi);
elseif c<0
    tmp = atan(s/c) + pi;
    theta = tmp *(180/pi);
elseif s>0 & c>0
    tmp = atan(s/c); % in rad
    theta = tmp *(180/pi);
end
disp(theta)
