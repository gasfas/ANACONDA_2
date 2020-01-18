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
% Count = permute(Count, [2 1 3]);
contourvalue = GraphObj_md.contourvalue;
% contourvalue = midpoints.contourvalue;
h_GraphObj =figure(143);
xyt = smooth3(Count,'box',5);
p3 = patch(isosurface(x, y, z, xyt,max(max(max(xyt)))*.9));
p3.FaceColor = [1 0 0];p3.EdgeColor = 'none';p3.FaceAlpha = 1;
p4 = patch(isosurface(x, y, z, xyt,max(max(max(xyt)))*.5));
p4.FaceColor = [0.5 0 0];p4.EdgeColor = 'none';p4.FaceAlpha = .2;
p5 = patch(isosurface(x, y, z, xyt,max(max(max(xyt)))*.2));
p5.FaceColor = [0.3 0 0];p5.EdgeColor = 'none';p5.FaceAlpha = .1;

lightangle(0,90);
lightangle(90,0);
lightangle(0,0);
view(35,35)
camlight;

% h_GraphObj = patch(h_axes, isosurface(x, y, z, xyt));
% h_GraphObj.Facecolor=[0.5 0 0];
% isonormals(x,y,z,Count,h_GraphObj);

%old
%  cross section view if requested:
% if general.struct.issubfield(GraphObj_md, 'contourslice')
% % 	contourslice(h_axes, mids_x,mids_y,mids_z,Count,[],[],0, GraphObj_md.contourslice.lvls)
% 	Count(mids_x<0,mids_y<0,mids_z>0) = 0;
% 	contourf(mids_x(mids_x>0),mids_y(mids_y>0),mids_z(mids_z>0),v)
% end
% 
% h_GraphObj = patch(h_axes, isosurface(x, y, z, Count, contourvalue));
% [h_GraphObj = isonormals(x,y,z,Count,p);
% [faces,verts,colors]=isosurface(x, y, z, xyt,20, x);
% h_GraphObj = patch(h_axes,'Vertices',verts,'Faces',faces,'FaceVertexCData',colors,...
%     'FaceColor','interp','EdgeColor','interp' );
% view(30,-15)
% axis vis3d
% colormap copper
% max(max(max(xyt)))*.5

% p1 = patch(isosurface(x, y, z, xyt, 0),'FaceColor','red',...
% 	'EdgeColor','none');
% p2 = patch(isocaps(x, y, z, xyt, 0),'FaceColor','interp',...
% 	'EdgeColor','none');
% view(3)
% axis tight
% daspect([1,1,.4])
% colormap(gray(100))
% camlight left
% camlight
% lighting gouraud
% h_GraphObj =isonormals(x, y, z, xyt,p1);
end
