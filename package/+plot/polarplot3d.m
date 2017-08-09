function [Xi,Yi,Zi, hSurf] = polarplot3d(ax, Theta, R, Zp, GraphObj_md)
% POLARPLOT3D  Plot a 3D surface from polar coordinate data
%   [Xi,Yi,Zi] = polarplot3d(ax, Theta, R, Zp,varargin)
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
%
%   'ThetaRange'   scalar or vector, radians (default = [0 2*pi])
%   'RRange'    scalar or vector          (default = [0 1])
%      If a scalar is given for either range it is used as the maximum value and
%      zero is used for the minimum.  If a two element vector is given, columns
%      (or rows) are evenly spaced between these values.  Otherwise the number
%      of elements must match the size of the corresponding dimension of Zp and
%      specifies the location of each column (or row).  If the vector values are
%      decreasing the corresponding dimension of Zp is reversed.
%
%   'ColorData'      Matrix of color values, size must be equal to size(Zp)
%      The default coloring is according to the magnitude of Zp.  For example
%      specifying gradient(Zp) colors the plot according to slope in the radial
%      direction.  Similarly gradient(Zp.').' colors the surface according to
%      slope in the azimuthal direction.
%
%   'CartOrigin'     Cartesian axis origin, 3 element vector (default = [0 0 0])
%      The center of the polar plot is translated to this location.
%
%   'MeshScale'      Mesh scale factors, 2 element vector (default = [1 1])
%      The data is interpolated to a new mesh size. Values > 1 increase mesh
%      element size and values < 1 decrease mesh element size.
%
%   'TickSpacing'    Spacing of polar tick marks in degrees (default = 10)
%      Every other tick mark is labeled. To supress tick marks specify zero,
%      an empty vector or an increment value greater than 180.
%
%   'PolarGrid'      Polar grid density (2 element cell array) (default = {10 8})
%      Number of grid sections in the radial and azimuthal directions.  A value
%      of 1 eliminates a grid direction from the plot. If a vector is specified
%      for a direction, gridlines are drawn at the specified locations. 
%
%   'GridScale'      Smoothness of contoured grid lines (default = [40 40])
%      Larger values make the grid lines smoother.
%
%   'GridStyle'      Style of polar grid lines (default = ':' dotted line)
%      Plotting style for the radial and azimuthal grid lines.  Any format
%      supported by the plot function can be used: '-' solid, ':' dotted, 
%      '-.' dashdot or '--' dashed.
%
%   'ContourLines'   Scalar (number of contours) or a vector (contour locations)
%      Either the number of contours or the location of contour lines is specified.
%      The default is auto selection by the contour function.
%
%   'AxisLocation'   'surf'    polar axis along edge of surface     (default)
%                    'min'     polar axis at minimum Zp for largest radius
%                    'max'     polar axis at maximum Zp for largest radius
%                    'mean'    polar axis at mean    Zp for largest radius
%                    'top'     polar axis at top     of plot box
%                    'bottom'  polar axis at bottom  of plot box
%                    value     polar axis is drawn at specified height
%                    'off'     no polar axis
%
%   'RadLabels'   Number of radial labels (default = 0)
%      The inner and outer most radii are not labeled. Labels are equally spaced
%      within the radial range of the data.
%
%   'RadLabelLocation'  Radial label location (2 element cell array) (default = {0 'max'})
%      The first elemenent is the azimuthal location of the radial labels in
%      degrees. The second element is the sagittal location of the labels. The
%      following values are allowed. If a value is given it can be a scalar or
%      a vector the same length as the value of the 'RadLabels' property.
%
%                    'surf'    above the surface at each theta,R
%                    'min'     at minimum value of Zp
%                    'max'     at maximum value of Zp (default)
%                    'mean'    at mean    value of Zp
%                    'top'     at the top    of the plot box
%                    'bottom'  at the bottom of the plot box
%                    value     at the specified height(s)
%                    'off'     no radial labels
%
%   'PolarDirection' 'ccw'     0 degs along +x axis, angles increase ccw (default)
%                    'cw'      0 degs along +y axis, angles increase cw
%                              This makes a compass-style polar grid.
%
%   'InterpMethod'   'cubic'   bicubic          interpolation on Zp (default)
%                    'linear'  bilinear         interpolation on Zp
%                    'spline'  spline           interpolation on Zp
%                    'nearest' nearest neighbor interpolation on Zp
%
%   'PolarAxisColor' color of the polar axis    (default = 'black')
%   'GridColor'      color of polar grid lines  (default = 'black')
%   'TickColor'      color of polar tick marks  (default = 'black')
%   'TickLabelColor' color of polar tick labels (default = 'black')
%   'RadLabelColor'  color of radial labels     (default = 'black')
%
%   Additional 'property',value pairs are applied to the current
%   axis using the set() command after the polar plot is drawn.
%
% Output
%   Xi,Yi,Zi   Cartesian locations corresponding to polar coordinates (T,R,Zp)
%              T and R are created from ThetaRange and RRange arguments
%              using meshgrid and converted to Cartesian coordinates with
%              pol2cart.  Xi,Yi,Zi are square matrices with size equal to the
%              dimensions of Zp after interpolation.  Matrix sizes are reduced
%              or enlarged by the MeshScale property.
%
% Notes        Zp is the only required input argument
%              If no input arguments are given an example plot is produced
%              and this help text is displayed in the command window.
%
% ----
% Example
%    [t,r] = meshgrid(linspace(0,2*pi,361),linspace(-4,4,101));
%    [x,y] = pol2cart(t,r);
%    P = peaks(x,y);                       % peaks function on a polar grid
% 
%                                          % draw 3d polar plot
%    figure('Color','white','NumberTitle','off','Name','PolarPlot3d v4.3');
%    polarplot3d(P,'PlotType','surfn','PolarGrid',{4 24},'TickSpacing',8,...
%                  'ThetaRange',[30 270]*pi/180,'RRange',[.8 4],...
%                  'RadLabels',3,'RadLabelLocation',{180 'max'},'RadLabelColor','red');
% 
%                                          % set plot attributes
%    set(ax,'DataAspectRatio',[1 1 10],'View',[-12,38],...
%            'Xlim',[-4.5 4.5],'Xtick',[-4 -2 0 2 4],...
%            'Ylim',[-4.5 4.5],'Ytick',[-4 -2 0 2 4]);
%    title('polarplot3d example');
%
% ----
% Versions
% 1    Original function based on POLAR3D by J De Freitas
% 2    Changed argument method to 'property',value pairs using PARSE_PV_PAIRS by J. D'Errico
% 2.1  Added 'ColorData' property
% 2.2  Updated contour plot implementation for meshc, surfc and surfcn plot types
% 2.3  Added radial and azimuthal mesh scale factors
% 2.4  Added 'CartOrigin' property
% 2.5  Added 'PolarAxisColor', 'GridColor', 'TickColor' and 'TickLabelColor' properties
% 2.6  Added 'PolarDirection' and 'GridScale' properties
% 3    Removed PARSE_PV_PAIRS dependency
% 4    Support for non-uniform grid spacing. Removed redundant 'MeshL' plot type
% 4.1  Replaced optional 'PlotProps' cell argument with 'property',value list
% 4.2  Added 'RadLabels', 'RadLabelLocation' and 'RadLabelColor' properties

% -- Help

% Polarplot3d was called without arguments
% Draw an example in a new figure and display help text

if nargin < 1
   [t,r] = meshgrid(linspace(0,2*pi,361),linspace(-4,4,101));
   [x,y] = pol2cart(t,r);
   P = peaks(x,y);                       % peaks function on a polar grid

                                         % draw 3d polar plot
   figure('Color','white','NumberTitle','off','Name','PolarPlot3d v4.3');
   plot.polarplot3d(P,'PlotType','surfn','PolarGrid',{4 24},'TickSpacing',8,...
                 'ThetaRange',[30 270]*pi/180,'RRange',[.8 4],...
                 'RadLabels',3,'RadLabelLocation',{180 'max'},'RadLabelColor','red');

                                         % set plot attributes
   set(ax,'DataAspectRatio',[1 1 10],'View',[-12,38],...
           'Xlim',[-4.5 4.5],'Xtick',[-4 -2 0 2 4],...
           'Ylim',[-4.5 4.5],'Ytick',[-4 -2 0 2 4]);
   title('polarplot3d example');
                                         % display help text
   error(['No input arguments given\n'...
          'Please consult the help text and the example plot\n'...
          '--------\n%s'],help(mfilename));
end


%-- Parse and validate input arguments

% Allowed argument string for property values
plst = {'mesh','meshc','wire',...
        'surf','surfc','surfn','surfcn','contour','imagesc','off'};
alst = {'off','const','min','max','mean','surf','top','bottom'};
rlst = {'off','const','min','max','mean','surf','top','bottom'};
mlst = {'cubic','linear','spline','nearest'};
dlst = {'ccw','cw'};
glst = {'-',':','-.','--'};

% Set up property structure with default values
def.plottype		= 'surfcn';
def.ThetaRange      = [min(Theta), max(Theta)];   % angular range
def.RRange			= [min(R) max(R)];      % radial  range
def.Type			  = 'surfn';    % surface plot, no rectangular grid
def.meshscale         = [1 1];      % no mesh scaling
def.polargrid         = {0 0};     % number of radial and azimuthal sections
def.gridscale         = [40 40];    % 40x scaling for smooth grid interpolation
def.cartorigin        = [0 0 0];    % Cartesian origin
def.tickspacing       = 10;         % ten degree tick mark spacing
def.tickrange			= def.ThetaRange; % default angular tick range;
def.radlabels         =  0;         % number of radial grid labels
def.axislocation      = '';         % polar axis location
def.radlabellocation  = '';         % radial label location
def.polardirection    = 'ccw';      % default polar axis direction
def.interpmethod      = 'cubic';    % bicubic interpolation
def.colordata         = [];         % default coloring according to Zp values
def.contourlines      = '';         % default contour specification
def.gridcolor         = 'black';    % default overlay grid line color
def.gridstyle         = '';         % style of grid lines: '-' ':' '-.' '--'
def.polaraxiscolor    = 'black';    % default polar axis color
def.tickcolor         = 'black';    % default polar tick color
def.ticklabelcolor    = 'black';    % default polar tick label color
def.radlabelcolor     = 'black';    % default radial label color
def.plotprops         = {};         % no additional plot properties

% Fill up the missing metadata fields with defaults:
GraphObj_md = general.struct.catstruct(def, GraphObj_md);

% Check input data size
[Zrows,Zcols] = size(Zp);
if (Zrows < 5) || (Zcols < 5)
   error('Input matrix size must be greater than 4 x 4');
end

% Check plot type specification
if ~ischar(GraphObj_md.plottype) || isempty(matchstr2lst(lower(GraphObj_md.plottype),plst))
   error('Invalid ''PlotType'' property value');
end
GraphObj_md.plottype = lower(GraphObj_md.plottype);

% Choose default polar axis location
if isequal(GraphObj_md.axislocation,'')            
   if ~isempty(matchstr2lst(GraphObj_md.plottype,{'meshc','surfc','surfcn'}))
        GraphObj_md.axislocation = 'bottom';       % plot box bottom for contour plots
   else GraphObj_md.axislocation = 'surf';         % along perimeter of surface otherwise
   end
end

% User specified polar axis location as a numeric value
if isnumeric(GraphObj_md.axislocation)
   [r,c] = size(GraphObj_md.axislocation);
   if (((r ~= 1) || (c ~= 1)) || ~isnumeric(GraphObj_md.axislocation))
      error('''AxisLocation'' property value must be scalar, positive and real');
   end
   polax          = GraphObj_md.axislocation;
   GraphObj_md.axislocation = 'const';
end

% Check polar axis location specification
if ~ischar(GraphObj_md.axislocation) || isempty(matchstr2lst(lower(GraphObj_md.axislocation),alst))
   error('Invalid ''AxisLocation'' property value');
end
GraphObj_md.axislocation = lower(GraphObj_md.axislocation);

% Check polar axis direction specification
if ~ischar(GraphObj_md.polardirection) || isempty(matchstr2lst(lower(GraphObj_md.polardirection),dlst))
   error('Invalid ''PolarDirection'' property value');
end
GraphObj_md.polardirection = lower(GraphObj_md.polardirection);

% Check grid scaling specification
GraphObj_md.gridscale = GraphObj_md.gridscale(:)';
if ~isnumeric(GraphObj_md.gridscale) || any(GraphObj_md.gridscale <= 0)
   error('Non-numeric or non-positive grid scale parameter');   
end
if length(GraphObj_md.gridscale) ~= 2
   error('''GridScale'' property must be a two element numeric vector');
end

% Check angular range vector
GraphObj_md.ThetaRange = GraphObj_md.ThetaRange(:);
if ~isnumeric(GraphObj_md.ThetaRange)
   error('''ThetaRange'' property value must be numeric');
end
if isscalar(GraphObj_md.ThetaRange), GraphObj_md.ThetaRange = [0; GraphObj_md.ThetaRange]; end
if length(GraphObj_md.ThetaRange) == 2
   GraphObj_md.ThetaRange = linspace(GraphObj_md.ThetaRange(1),GraphObj_md.ThetaRange(2),Zcols).';
end
if ~ismono(GraphObj_md.ThetaRange)
   error('''ThetaRange'' vector must be monotonic');
end
if length(GraphObj_md.ThetaRange) ~= Zcols
   error('''ThetaRange'' size must match number of columns in input matrix');
end

% Check radial range vector
GraphObj_md.RRange = GraphObj_md.RRange(:);
if ~isnumeric(GraphObj_md.RRange)
   error('''RRange'' property value must be numeric');
end
if isscalar(GraphObj_md.RRange), GraphObj_md.RRange = [0; GraphObj_md.RRange]; end
if length(GraphObj_md.RRange) == 2
   GraphObj_md.RRange = linspace(GraphObj_md.RRange(1),GraphObj_md.RRange(2),Zrows).';
end
if ~ismono(GraphObj_md.RRange)
   error('''RRange'' vector must be monotonic');
end
if length(GraphObj_md.RRange) ~= Zrows
   error('''RRange'' size must match number of rows in input matrix');
end

% Angular and radial range vectors define data order
[Tmin,Tmax] = deal(min(GraphObj_md.ThetaRange),max(GraphObj_md.ThetaRange));   % Tmin < Tmax
[Rmin,Rmax] = deal(min(GraphObj_md.RRange ),max(GraphObj_md.RRange ));   % Rmin < Rmax

% Reflect Zp left-right and/or up-down depending on angular and radial ranges
if GraphObj_md.ThetaRange(1) > GraphObj_md.ThetaRange(end), Zp = fliplr(Zp); end
if GraphObj_md.RRange (1) > GraphObj_md.RRange (end), Zp = flipud(Zp); end

% Angular range cannot be more than one full circumference
if abs(Tmax - Tmin) > 2*pi
   error('Angular range cannot be greater than 2*pi');
end

% Check radial and azimuthal polar grid density
GraphObj_md.polargrid = GraphObj_md.polargrid(:);
if length(GraphObj_md.polargrid) ~= 2 || ~iscell(GraphObj_md.polargrid)
   error('''PolarGrid'' property value must be a two element numeric cell array');
end
[radgrid,azmgrid] = deal(GraphObj_md.polargrid{1},GraphObj_md.polargrid{2});

% Check azimuthal grid density
if ~isnumeric(azmgrid)
   error('Non-numeric azimuthal grid parameter');
end
if isempty(azmgrid) || (length(azmgrid)==1 && azmgrid == 0)
   azmgrid = 1;
end
if length(azmgrid) == 1
   azmgrid = linspace(Tmin,Tmax,azmgrid+1).';
end

% Check radial grid density
if ~isnumeric(radgrid)
   error('Non-numeric radial grid parameter');
end
if isempty(radgrid) || (length(radgrid)==1 && radgrid==0)
   radgrid = 1;
end
if length(radgrid) == 1
	% we assume radgrid to hold the number of radial lines to give:
   radgrid = linspace(Rmin,Rmax,radgrid+1).';
end

% Check mesh scale factor property value
if isscalar(GraphObj_md.meshscale), GraphObj_md.meshscale = [GraphObj_md.meshscale GraphObj_md.meshscale]; end
if ~isnumeric(GraphObj_md.meshscale) || any(GraphObj_md.meshscale <= 0)
   error('''MeshScale'' property values must be positive and real');
end


% Check contour lines property value
if ~isnumeric(GraphObj_md.contourlines) && ~isequal(GraphObj_md.contourlines,'')
   error('''ContourLines'' property value must be numeric');
end
GraphObj_md.contourlines = GraphObj_md.contourlines(:);

% Check grid line style property value, default depends on plottype
if isempty(GraphObj_md.gridstyle)
   if isequal(GraphObj_md.plottype,'contour'), GraphObj_md.gridstyle = ':';    % dotted line
   else                              GraphObj_md.gridstyle = '-';    % solid  line
   end
end
if ~ischar(GraphObj_md.gridstyle) || isempty(matchstr2lst(lower(GraphObj_md.gridstyle),glst))
   error('Invalid ''GridStyle'' property value');
end

% Check interpolation method
GraphObj_md.interpmethod = lower(GraphObj_md.interpmethod);
if ~ischar(GraphObj_md.interpmethod) || isempty(matchstr2lst(GraphObj_md.interpmethod,mlst))
   error('Invalid ''InterpMethod'' property value');
end

% Check if mesh scale factor is compatible with input data dimension
if round(min([Zrows Zcols]./GraphObj_md.meshscale)) < 4
   error('Mesh scale factor is too large, not enough data remaining to plot');
end

% Choose default color matrix
if isempty(GraphObj_md.colordata), GraphObj_md.colordata = Zp; end       % surface height coloring

% Check color matrix
if ~isnumeric(GraphObj_md.colordata) || ~isequal(size(GraphObj_md.colordata),[Zrows,Zcols])
   error('Color matrix must be numeric and the same size as Zp');
end

% Polar axis z location is a constant for contour plots
if isequal(GraphObj_md.plottype,'contour') && ~isequal(GraphObj_md.axislocation,'off')
   polax = 0;
   GraphObj_md.axislocation = 'const';
end

% Check Cartesian origin
if isempty(GraphObj_md.cartorigin) || ~isnumeric(GraphObj_md.cartorigin)
   error('Cartesian origin must be numeric');
end
if length(GraphObj_md.cartorigin)<3, GraphObj_md.cartorigin(3) = 0; end


%-- Create polar grid and interpolate data

% Create radius and angle vectors and polar grid for input data matrix
rho  = GraphObj_md.RRange;                                % radius vector
angl = GraphObj_md.ThetaRange;                               % angle  vector
[xx,yy] = meshgrid(angl,rho);                        % mesh   matrices
Zi = Zp;                                             % z's == input data
Ci = GraphObj_md.colordata;                                    % colormap

% No interpolation for uniform scaling
if isequal(GraphObj_md.meshscale,[1 1])                        % uniform scaling
   Xi = rho * cos(angl.');                           % matrix of x's
   Yi = rho * sin(angl.');                           % matrix of y's

% Create a new grid and interpolation data
else
   q    = fix([Zrows Zcols]./GraphObj_md.meshscale);           % new mesh size
   rho  = linspace(Rmin,Rmax,q(1));                  %     radius vector
   angl = linspace(Tmin,Tmax,q(2));                  %     angle  vector
   [theta,rad] = meshgrid(angl,rho);                 % create polar grid
   T  = interp2(xx,yy,Zp,theta,rad,GraphObj_md.interpmethod);  % interpolate Zp to grid
   Ci = interp2(xx,yy,Ci,theta,rad,GraphObj_md.interpmethod);  % interpolate color
   [Xi,Yi,Zi] = pol2cart(theta,rad,T);               % convert to Cartesian
end

% Swap x,y for clockwise polar plot
if isequal(GraphObj_md.polardirection,'cw')
   [Xi,Yi] = deal(Yi,Xi);
end

% Offset grid data to Cartesian origin
Xi = Xi + GraphObj_md.cartorigin(1);
Yi = Yi + GraphObj_md.cartorigin(2);
Zi = Zi + GraphObj_md.cartorigin(3);


%-- Plot the surface

switch GraphObj_md.plottype
   case 'wire',    grid on;
   case 'meshc',   hSurf = mesh(ax, Xi,Yi,Zi,Ci);
                   addcontours(ax, Xi,Yi,Zi,GraphObj_md.contourlines);
   case 'mesh',    hSurf = mesh (ax, Xi,Yi,Zi,Ci);
   case 'surf',    hSurf = surf (ax, Xi,Yi,Zi,Ci);
   case 'surfc',   hSurf = surf (ax, Xi,Yi,Zi,Ci);
                   addcontours(ax, Xi,Yi,Zi,GraphObj_md.contourlines);
   case 'surfn',   hSurf = surf (ax, Xi,Yi,Zi,Ci,'LineStyle','none');
   case 'surfcn',  hSurf = surf (ax, Xi,Yi,Zi,Ci,'LineStyle','none');
                   addcontours(ax, Xi,Yi,Zi,GraphObj_md.contourlines);
   case 'contour', [~, hSurf] = contour(ax, Xi,Yi,Zi,GraphObj_md.contourlines);
                   axis equal; xlim(ax, xlim*1.1); ylim(ax, ylim*1.1);
                   set(ax,'visible','off');
                   set(get(ax,'xlabel'),'visible','on');
                   set(get(ax,'ylabel'),'visible','on');
                   set(get(ax,'title'), 'visible','on');       
% 	case 'imagesc';% TODO
% 					hSurf = imagesc(ax, Xi,Yi,Zi);
end 

view(0, 90);
end


%%-- Local functions

% Add a contour plot to the current surface or mesh plot
function addcontours(ax, x,y,z,levels)

if isempty(levels), levels = 16; end
hold on;
a    = get(ax,'zlim');
zpos = a(1);               % find smallest z value in 3d plot

% Add contours
[~,hh] = contour3(x,y,z,levels);

% Change all contour group positions to bottom of plot
for j = 1:length(hh)
   zz = get(hh(j),'Zdata');
   set(hh(j),'Zdata',zpos*ones(size(zz)));
end
end

% Structure reconciliation with a template
function [T,S] = structrecon(S,D)

% Check arguments, must have two structures
if ~(isstruct(S) && isstruct(D))
   error('input arguments must be structures');
end
   
T     = D;             % copy the template
fname = fields(T);     % make a list of field names

% Loop over all fields in the template, copy matching values from S
for k = 1:length(fname)
   % Process matching field names in S
   if isfield(S,fname{k})
      % Is this a substructure ?
      if isstruct(T.(fname{k})) && isstruct(S.(fname{k}))
         % Recursively process the substructure
         T.(fname{k}) = structrecon(S.(fname{k}),T.(fname{k}));
      % Not a substructure, copy field value from S
      else T.(fname{k}) = S.(fname{k});
      end
      S = rmfield(S,fname{k});
   end
end
end

% Convert an argument pairs cell array to a structure
function S = pv2struct(varargin)

% No inputs, return empty structure
if isempty(varargin), S = struct(); return; end

% Need pairs of inputs
if mod(length(varargin),2)==1
   error('number of arguments must be even');
end

% Odd elements of varargin are fields, even ones are values
% Store all field names in lower case
for k = 1:2:length(varargin)
   S.(lower(varargin{k})) = varargin{k+1};
end
end

% Convert a structure to an argument pairs cell array
function P = struct2pv(S)

% Check input argument
if ~isstruct(S), P = {}; return; end

% Get field names
n = fieldnames(S);

% Convert structure values to cell array
v = struct2cell(S);

% Combine names and values, return a 1xN cell array
P = {n{:}; v{:}};
P = P(:).';
end

% Match a string with a list of strings
function idx = matchstr2lst(str,strarray,opt)

if nargin < 2, return; end
idx = find(strncmpi(str,strarray,length(str))==1);
idx = idx(:);

if nargin > 2
   if     strcmpi(opt,'first'), idx = idx(1);
   elseif strcmpi(opt,'last'),  idx = idx(end);
   end
end
end

% Test monotonicity of a vector
function m = ismono(v)

[r,c] = size(v);       % size of input
if r == 1,             % row vector
   v = v';             %   transpose
   r = c; c = 1;       %   size
end

sgn   = sum(sign(diff(v,1,1)),1);  % sgn is r+1 or -(r+1) for monotonic columns
up    = sgn - repmat(r,1,c);       % subtract r to detect increasing (-1)
down  = sgn + repmat(r,1,c);       % add      r to detect decreasing (+1)
up  (up   < -1) = 0;               % force non-monotonic entries to zero
down(down >  1) = 0;

m = -(up + down);                  % flip sense of output so +1 is increasing
end
