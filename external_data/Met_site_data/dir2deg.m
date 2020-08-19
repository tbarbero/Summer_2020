function deg = dir2deg(input)
% Convert wind direction to degrees
% input: categorical array

deg = NaN(size(input));

deg(input=='N') = 0.0;
deg(input=='NNE') = 22.5;
deg(input=='NE') = 45.;
deg(input=='ENE') = 67.5;
deg(input=='E') = 90.0;
deg(input=='ESE') = 112.5;
deg(input=='SE') = 135.0;
deg(input=='SSE') = 157.5;
deg(input=='S') = 180.0;
deg(input=='SSW') = 202.5;
deg(input=='SW') = 225.0;
deg(input=='WSW') = 247.5;
deg(input=='W') = 270.0;
deg(input=='WNW') = 292.5;
deg(input=='NW') = 315.0;
deg(input=='NNW') = 337.5;

end


