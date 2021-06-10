clear;close;clc
figure(1); hold
valleyflow_bottom_wsps_JPL_SSMET_CARB("CARB");

valleyflow_bottom_wsps_JPL_SSMET_CARB("JPL");

valleyflow_bottom_wsps_JPL_SSMET_CARB("SS");
path = "/Users/tyler/Documents/Summer2020/external_data/figs/met_site_composites_50/";
fig = strcat(path,'metsites_bottom_wsps_analysis','.png');
saveas(gcf,fig)