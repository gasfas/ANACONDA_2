function [cmap]=buildcmap(colors, values)
% [cmap]=buildcmap(colors)
%
% This function can be used to build your own custom colormaps. Imagine if
% you want to display rainfall distribution map. You want a colormap which
% ideally brings rainfall in mind, which is not achiveved by colormaps such
% as winter, cool or jet and such. A gradient of white to blue will do the
% task, but you might also use a more complex gradient (such as
% white+blue+red or colors='wbr'). This function can be use to build any
% colormap using main colors rgbcmyk. In image processing, w (white) can be
% used as the first color so that in the output, the background (usually
% with 0 values) appears white. In the example of rainfall map, 'wb' will
% produce a rainfall density map where the background (if its DN values are
% 0) will appear as white.
%
% Inputs:
%  colors: string (char) of color codes, any sequence of rgbcmywk
%  representing different colors (such as 'b' for blue) is acceptable. If a
%  gradient of white to blue is needed, colors would be 'wb'; a rainbow of
%  white+blue+red+green would be 'wbrg'.
%
% Example:
%  [cmap]=buildcmap('wygbr');
% %try the output cmap:
% im=imread('cameraman.tif');
% imshow(im), colorbar
% colormap(cmap) %will use the output colormap
%
% First version: 14 Feb. 2013
% sohrabinia.m@gmail.com
%--------------------------------------------------------------------------

if nargin<1
    colors='wrgbcmyk';
end

if ~ischar(colors)
    error(['Error! colors must be a variable of type char with '...
        'color-names, such as ''r'', ''g'', etc., type ''help buildcmap'' for more info']);
end

if ~exist('values', 'var')
	values = linspace(0, 1, length(colors));
end
idx_values = round(interp1([0 1], [1 301], values));

ncolors=length(colors)-1;
nof_bins=round(255/ncolors);
cmap=zeros(300,3);

% Fill up the lower end:
cmap(1:idx_values(1), :) = repmat(plot.color.convert_2_RGB(colors(1)), idx_values(1), 1);
% Fill up the higher end:
cmap(idx_values(end):end, :) = repmat(plot.color.convert_2_RGB(colors(end)), 301-idx_values(end), 1);

for i=1:ncolors
%  beG=(i-1)*bins+1;
 beG=idx_values(i);
%  enD=i*bins+1; %beG,enD
 enD=idx_values(i+1);
 nof_bins = enD - beG;
%  switch colors(i+1)
	RGB_color =  plot.color.convert_2_RGB(colors(i+1));
	cmap(beG:enD,1)=linspace(cmap(beG,1),RGB_color(1),nof_bins+1)';
	cmap(beG:enD,2)=linspace(cmap(beG,2),RGB_color(2),nof_bins+1)';
	cmap(beG:enD,3)=linspace(cmap(beG,3),RGB_color(3),nof_bins+1)';
end
end %end of buildcmap
