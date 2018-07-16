function [degrees] = pixels2degrees(pixX, pixY)
% screenRes - the resolution of the monitor
% screenSize - the size of the monitor in cm
% (these values can either be along a single dimension or for both the width and height)
% distance - the viewing distance in cm.
% degs - the amount of degress that should be transformed to a number of pixels

screenSizeX = evalin('base', 'screenSizeX');
screenSizeY = evalin('base', 'screenSizeY');

screenResX = evalin('base', 'screenResX');
screenResY = evalin('base', 'screenResY');
distance = evalin('base', 'distance');

pixSizeCmX = screenSizeX./screenResX; %calculates the size of a pixel in cm
pixSizeCmY = screenSizeY./screenResY;

degperpixX=(2*atan(pixSizeCmX./(2*distance))).*(180/pi);
degperpixY=(2*atan(pixSizeCmY./(2*distance))).*(180/pi);

degrees.degX = degperpixX.*pixX;
degrees.degY = degperpixY.*pixY;

end