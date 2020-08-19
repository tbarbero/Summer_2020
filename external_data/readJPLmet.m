% function to make JPL data into table

function [JPL] = readJPLmet
for i=1:7
a(i) = strcat("JPL",num2str(i),"= importdata('2020_ss1_", int2str(i),"_m.met',' ',4);");
eval(a(i));
end

mdyall=[];hmsall=[];wspdall=[];wdirall=[];
for i=1:7
a = strcat("mdy = JPL",int2str(i),".textdata(5:end,1);");
eval(a);
mdyall = [mdyall; mdy];
b = strcat("hms = JPL",int2str(i),".textdata(5:end,2);");
eval(b);
hmsall = [hmsall; hms];
c = strcat("windspeed = JPL",int2str(i),".data(:,1);");
eval(c);
wspdall = [wspdall; windspeed];
d = strcat("winddirection = JPL",int2str(i),".data(:,2);");
eval(d);
wdirall = [wdirall; winddirection];
end
datestrs = append(mdyall, ' ',hmsall);
time = datetime(datestrs, 'InputFormat', 'MM-dd-yyyy HH:mm:ss'); % UTC time
clearvars hms hmsall mdy winddirection windspeed i  a b c d ...
    JPL1 JPL2 JPL3 JPL4 JPL5 JPL6 JPL7 

JPL.time = time;
JPL.wspd = wspdall;
JPL.wdir = wdirall;
end