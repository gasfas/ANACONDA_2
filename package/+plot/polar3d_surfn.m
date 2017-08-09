function [Xi,Yi,Zi, hSurf] = polar3d_surfn(ax, theta, R, Zp)
% POLARPLOT3D  Plot a 3D surface from polar coordinate data
%   [Xi,Yi,Zi] = polarplot3d(ax, Zp,varargin)
%
% Input
%	ax Axis handle to be plot into.
%   Zp        A two dimensional matrix of input magnitudes or intensities.
%      Each column of Zp contains information along a single meridian. Each row
%      of Zp contains information at a single radius. The direction sense of the
%      rows and columns is determined by the relative order of the angular and
%      radial range vectors.  By default Zp is increasing in radius down each
%      column and increasing in angle along each row in the counter-clockwise
%      direction. The default plot is a full 360 degree surface plot with unit
%      radius.
%
%   varargin  'property',value pairs that modify plot characteristics.
%      Property names must be specified as quoted strings. Property names and
%      their values are not case sensitive. For each property the default value
%      is given below.  All properties are optional.  They may be given in any
%      order. 
%
%   'PlotType'       'surfn'   surface plot,               no mesh (default)
%                    'surfcn'  surface plot with contours, no mesh
%                    'surfc'   surface plot with contours
%                    'surf'    surface plot
%                    'mesh'    mesh    plot
%                    'meshc'   mesh    plot with contours
%                    'contour' 2D contour plot
%                       Use 'ContourLines' to set the number of contours.
%                    'wire'    wireframe polar grid plot only, no surface plot
%                       A wireframe polar grid is plotted without a surface.
%                    'off'     no surface plot
%                       The data is interpolated to a new grid according to
%                       the 'MeshScale' property and transformed to Cartesian
%                       coordinates.

[Rmin, Rmax]		= deal(min(R), max(R));
[Amin, Amax]		= deal(min(theta), max(theta));
%-- Create polar grid and interpolate data

% Create radius and angle vectors and polar grid for input data matrix
[theta_g,R_g] = meshgrid(theta,R);                   % mesh   matrices
Zi = Zp;                                             % z's == input data

Xi = R * cos(theta.');                           % matrix of x's
Yi = R * sin(theta.');                           % matrix of y's

%-- Plot the surface
hSurf = surf (ax, Xi,Yi,Zi',Zp','LineStyle','none');
view(0, 90)
end

