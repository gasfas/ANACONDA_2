function [h] = grid_3D(ax, x, y, z, color)
%Convenience function to plot a rectangular grid in a 3D plot
% Inputs:
% ax	The handle of the axes to plot the grid into
% x		The grid line coordinates in x-direction
% y		The grid line coordinates in y-direction
% z		The grid line coordinates in z-direction
% color	The color of the grid (optional)
% Outputs
% h		handle of the grid lines
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[X1, Y1, Z1] = meshgrid(x([1 end]),y,z);
X1 = permute(X1,[2 1 3]); Y1 = permute(Y1,[2 1 3]); Z1 = permute(Z1,[2 1 3]);
X1(end+1,:,:) = NaN; Y1(end+1,:,:) = NaN; Z1(end+1,:,:) = NaN;
[X2, Y2, Z2] = meshgrid(x,y([1 end]),z);
X2(end+1,:,:) = NaN; Y2(end+1,:,:) = NaN; Z2(end+1,:,:) = NaN;
[X3, Y3, Z3] = meshgrid(x,y,z([1 end]));
X3 = permute(X3,[3 1 2]); Y3 = permute(Y3,[3 1 2]); Z3 = permute(Z3,[3 1 2]);
X3(end+1,:,:) = NaN; Y3(end+1,:,:) = NaN; Z3(end+1,:,:) = NaN;

h = line(ax, [X1(:);X2(:);X3(:)], [Y1(:);Y2(:);Y3(:)], [Z1(:);Z2(:);Z3(:)]);

if exist(color, 'var')
set(h, 'Color',color)
end

end

