% This functions computes vectors of X- and Y-coordinates for a specified
% number of positions on a circle with a pre-defined center and start
% angle. The default start angle is zero and reffers to top of a circle.

function [Xpos, Ypos] = circlePositions(center,nPositions,radius,startDeg)
%% Set default values
if ~exist('startDeg','var')
    startDeg = 0;
elseif isempty(startDeg)
    startDeg = 0;
end

%% Compute X- and Y-coordinates
% Extract the X and Y-coordinates from the center variable
centerX = center(1);
centerY = center(2);

% Compute the angle Positions in degrees and pi
anglesDeg = linspace(startDeg,startDeg+360-(360/nPositions), nPositions);
anglesRad = anglesDeg*(pi/180);

% Compute X and Y-positions via trigonmetric functions and add the center
% coordinates to these coordinates
Xpos = sin(anglesRad).* radius + centerX;
Ypos = -cos(anglesRad).* radius + centerY;

%% End of Function
% This function was programmed by Gidon T. Frischkorn, as part of a
% template for MATLAB experiments. If you have any questions please contact
% me via mail: gidon.frischkorn@psychologie.uni-heidelberg.de