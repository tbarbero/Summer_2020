% plot 29 met data from our station
clear;clc;

load('202002.mat')

% change wsps to m/s 0.5144
% change to pst time
datetimes = datetime(time,'TimeZone','UTC');
datetimes = datetime(time,'TimeZone','America/Los_Angeles');

g = find(month(datetimes)==2 & day(datetimes)==29);

datetimes = datetimes(g);
T = T(g);
wspd = 0.5144.*wspd(g);
wdir = wdir(g);
rh = rh(g);


subplot(4,1,1);plot(datetimes,T);axis_options;ylabel('T ($^o$C)','Interpreter','latex')
yticks([0:10:30]);ylim([0,30])
subplot(4,1,2);plot(datetimes,wspd);axis_options;ylabel('U (ms$^{-1}$)','Interpreter','latex')
subplot(4,1,3);plot(datetimes,wdir);axis_options;ylabel('wdir ($^o$)','Interpreter','latex')
yticks([0:90:360])
subplot(4,1,4);plot(datetimes,rh);axis_options;ylabel('rh (\%)','Interpreter','latex')
ylim([0,100])

% print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/29met.eps')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get obs of site indicating downslope windstorm
% lat = 
tbl = readMESOWEST('KL08.csv');
% tbl = tbl(68:79,:);
datetimes = datetime(tbl.Datetime,'TimeZone','UTC');
datetimes = datetime(datetimes,'TimeZone','America/Los_Angeles','Format','dd-MMM-yyyy HH:mm:ss');
temperature = tbl.Temperature;
windspeed = tbl.Windspeed;
winddirection = tbl.Winddirection;
T = table(datetimes,temperature,windspeed,winddirection);
T.Properties.VariableNames = {'Datetime','Temperature',...
    'Wind_speed', 'Wind_direction'};

% Get the table in string form.
TString = evalc('disp(T)');
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>','\rm');
TString = strrep(TString,'_','\_');
% Get a fixed-width font.
FixedWidth = get(0,'FixedWidthFontName');
% Output the table using the annotation command.
dim = [.2 .4 .1 .1 ];
annotation(gcf,'Textbox',dim,'String',TString,'Interpreter','Tex',...
    'FontName',FixedWidth,'Units','Normalized','FitBoxToText','on');

% fig = uifigure;
% uit = uitable(fig,'Data',T)

% print(gcf,'-depsc', '~/Documents/Summer2020/external_data/figs/29table.eps')





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function axis_options
grid;datetick
xlabel('Time (PST)','Interpreter','latex')
set(gca,'TickLabelInterpreter','Latex')
end


