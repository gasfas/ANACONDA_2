function [h_GraphObj] = patch(h_axes, midpoints, Count, GraphObj_md)

mids_x = midpoints.dim1;
mids_y = midpoints.dim2;
mids_z = midpoints.dim3;

% plot it:
[x, y, z] = meshgrid(mids_x, mids_y, mids_z);
Count = permute(Count, [2 1 3]);
contourvalue = GraphObj_md.contourvalue;
% contourvalue = midpoints.contourvalue;

h_GraphObj = patch(h_axes, isosurface(x, y, z, Count, contourvalue));
% [h_GraphObj = isonormals(x,y,z,Count,p);
camlight
view(3);
end
