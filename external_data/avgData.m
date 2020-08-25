% function to average wspd, wdir into monthly averages % or daily averages
% for minute resolution data
function [wsps, wdirs, x] = avgData(time, wspd, wdir)
numtime = hour(time)+minute(time)/60;

temporalres = abs(time(1)-time(2));
if temporalres == duration(1,0,0)
    x = 0:23;
    step = 1;
elseif temporalres == duration(0,1,0)
    x = 0:0.5:23.5;
    step = 0.5;
else % any higher resolution use 30min avgs
    x = 0:0.5:23.5;
    step = 0.5;
end

% x  = 0:0.5:23.5;
% step = 0.5;


% get monthly avg windspds for each 1/2hr
for i=1:numel(x)
   
    % gets indices corresp to data for each halfhour
    
    g = find(numtime>=x(i) & numtime<=x(i)+step);

     % g changes, hold indices of data for each desired half hour. 
    if ~isempty(g)

        A = wspd(g);
        B = A(~isnan(A));
        % B has windspeed data w/o NaNs
        wsps(i) = mean(B);
        
       
        C = wdir(g);
        D = C(~isnan(C));
        wdirs(i) = mean(D);
    end
end
end