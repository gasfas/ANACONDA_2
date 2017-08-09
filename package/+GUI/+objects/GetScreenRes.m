% Description: Gets the screen resolution.
%   - inputs: none.
%   - outputs:
%           Screen resolution/size in pixels.           (screensize)
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [screensize] = GetScreenRes()
res = groot;
res.Units = 'pixels';
screensize = res.ScreenSize;
end