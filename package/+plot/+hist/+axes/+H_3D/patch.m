function [h_GraphObj] = patch(h_axes, midpoints, Count, GraphObj_md)
% This function draws a 3-D patch map, with the border of the patch set at
% a specified contourvalue.
% Inputs:
% h_axes	the axes handle of the plot
% midpoints	struct, the midpoints in the histogram, stored as
%			midpoints.dim1 and midpoints.dim2 (for x and y, respectively)
% Count		The histogram count matrix
% GraphObj_md	The metadata describing the graphical object.
% Outputs:
% hLine		The handle of the Patch Object
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

mids_x = midpoints.dim1;
mids_y = midpoints.dim2;
mids_z = midpoints.dim3;

% plot it:
[x, y, z] = meshgrid(mids_x, mids_y, mids_z);
Count = permute(Count, [2 1 3]);
contourvalue = GraphObj_md.contourvalue;
% contourvalue = midpoints.contourvalue;

% cross section view if requested:
% if general.struct.issubfield(GraphObj_md, 'contourslice')
% % 	contourslice(h_axes, mids_x,mids_y,mids_z,Count,[],[],0, GraphObj_md.contourslice.lvls)
% 	Count(mids_x<0,mids_y<0,mids_z>0) = 0;
% 	contourf(mids_x(mids_x>0),mids_y(mids_y>0),mids_z(mids_z>0),v)
% end

h_GraphObj = patch(h_axes, isosurface(x, y, z, Count, contourvalue));
% [h_GraphObj = isonormals(x,y,z,Count,p);
camlight
view(3);
end
