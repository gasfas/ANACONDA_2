% TERNSURF plot surface diagram for ternary phase diagram
%   TERNSURF(A, B, Z) plots surface fitted over Z on ternary phase diagram for three components.  C is calculated
%      as 1 - A - B. Number of steps in axes will be enter by user as MAJORS
%
%   TERNSURF(A, B, C, Z) plots surface of Z on ternary phase data for three components A B and C.  If the values 
%       are not fractions, the values are normalised by dividing by the total. Number of steps in axes will be enter by user as MAJORS
%   
%   NOTES
%   - An attempt is made to keep the plot close to the default trisurf type.  The code has been based largely on the
%     code for TERNPLOT.
%   - The regular TITLE and LEGEND commands work with the plot from this function, as well as incrimental plotting
%     using HOLD.  Labels can be placed on the axes using TERNLABEL
%
%   See also TERNCONTOURF TERNPLOT TERNLABEL PLOT POLAR CONTOUR CONTOURF 

%       b
%      / \
%     /   \
%    c --- a 

% Author: Peter Selkin 20030507 based on TERNPLOT by Carl Sandrock 20020827
% Modified heavily by Carl Sandrock on resubmission

% To do
% Make TERNCONTOURF and TERNSURF

% Modifications
% 20031006 (CS) Added call to SIMPLETRI to plot triangular surface
% 20070107 (CS) Modified to use new structure (more subroutines)
% 20160405 (SA) Added an input argument 'major', and an output argument 'handle'

% Modifiers
% CS Carl Sandrock
% SA Shahab Afshari

function handle = ternsurf(A, B, C, Z, varargin)

if nargin < 4
    Z = C;
    C = 1 - (A+B);
end;

% Fetch the number of majors, if given as argument (default = length(A)/2):
[varargin, majors] = plot.ternary.extractpositional(varargin, 'majors', ceil(length(A)/2));
% normalize, if necessary:
[fA, fB, fC] = plot.ternary.fractions(A, B, C);
% retrieve the plotting coordinates (rotating 60 degrees):
[x, y] = plot.ternary.terncoords(fA, fB, fC);
% (note that these have now become actual x and y coordinates)

% Sort data points in x order
[x, i] = sort(x);
% Apply the same sorting to y and Z:
y = y(i);
Z = Z(i);

% The matrixes we work with should be square for the triangulation to work
N = majors+1;

% Now we have X, Y, Z as vectors. 

% We have to structure it

plot.hist.H_2D

% % use meshgrid to generate a grid
% Ar = linspace(min(fA), max(fA), N);
% Br = linspace(min(fB), max(fB), N);
% % turn these vectors into a meshgrid:
% [Ag, Bg] = meshgrid(Ar, Br);
% % Rotate these points to x,y coordinates as well:
% [xg, yg] = plot.ternary.terncoords(Ag, Bg);
% 
% % ...then use griddata to get a plottable array
% zg = griddata(x, y, Z, xg, yg, 'linear');
% % remove the values out of range:
% zg(Ag + Bg > (1 + 1/majors)) = nan;
% 
% % plot data
% % Create a trianglular grid
% tri = plot.ternary.simpletri(N);
% 
% %tri = delaunay(xg, yg, zg);
% % Use this grid to create a triangular surface onto:
% handle = trisurf(tri, xg, yg, zg);
% 
% % Esthetics:
% handle.EdgeAlpha = 0;
% handle.EdgeColor = [1 1 1];
% handle.FaceAlpha = 0.5;
% custom_map = [linspace(1, 1, 256)' ...
%               linspace(1, 0, 256)' ...
%               linspace(1, 0, 256)'];
% colormap(custom_map)
% %h = trimesh(tri, xg, yg, zg);
% view([-37.5, 30]);
% 
% % Make ternary axes
% [hold_state, cax] = plot.ternary.ternaxes(majors);

% if ~hold_state
%     set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
% end
