function [h_GraphObj] = patch(h_axes, midpoints, Count, GraphObj_md)

mids_x = midpoints.dim1;
mids_y = midpoints.dim2;
mids_z = midpoints.dim3;

% plot it:
[x, y, z] = meshgrid(mids_x, mids_y, mids_z);
Count = permute(Count, [2 1 3]);

contourvalue = midpoints.contourvalue;

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
