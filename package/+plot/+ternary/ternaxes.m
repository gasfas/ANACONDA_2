% TERNAXES create ternary axis
%   HOLD_STATE = TERNAXES(fig, MAJORS, axLim) creates a ternary axis system using the system
%   defaults and with MAJORS major tickmarks.
% Inputs:
% fig		handle of the figure to create the axes in
% MAJORS	number of ticks on the axis
% axLim		(optional) min and max value on the axis. Default = [0 1];

% Author: Carl Sandrock 20050211

% To Do

% Modifications
% 20160405 (SA) Added lines to change the order/direction of axes (i.e.
%               clockwise or counter-clockwise) cooresponding to user-specified 
%               option on terncoords

% Modifiers
% (CS) Carl Sandrock
% (SA) Shahab Afshari

function [hold_state, ax, next] = ternaxes(fig, majors, axLim)
if nargin < 1
    majors = 10;
end

% TODO: Handle these as options
direction = 'clockwise';
percentage = false;

if ~exist('axLim', 'var')
	axLim = [0 1];
end

%TODO: Get a better way of offsetting the labels
xoffset = 0.25;
yoffset = 0.01;

% % get hold state
% cax = newplot;
% next = lower(get(cax,'NextPlot'));
% hold_state = ishold;
figure(fig)
ax = gca;
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(ax,'xcolor');
ls = get(ax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(ax, 'DefaultTextFontAngle');
fName   = get(ax, 'DefaultTextFontName');
fSize   = get(ax, 'DefaultTextFontSize');
fWeight = get(ax, 'DefaultTextFontWeight');
fUnits  = get(ax, 'DefaultTextUnits');

set(ax, 'DefaultTextFontAngle',  get(ax, 'FontAngle'), ...
         'DefaultTextFontName',   get(ax, 'FontName'), ...
         'DefaultTextFontSize',   get(ax, 'FontSize'), ...
         'DefaultTextFontWeight', get(ax, 'FontWeight'), ...
         'DefaultTextUnits','data')

	 %% Axis lines
	 
% only do grids if hold is off
if ~hold_state
	%plot axis lines
	triangle_size = 1;
	hold on;
	plot ([0 triangle_size triangle_size/2 0],[0 0 triangle_size*sin(1/3*pi) 0], 'color', tc, 'linewidth',1,...
                   'handlevisibility','off');
	set(gca, 'visible', 'off');
    % plot background if necessary
    if ~ischar(get(ax,'color'))
       patch('xdata', [0 triangle_size triangle_size/2 0], 'ydata', [0 0 triangle_size*sin(1/3*pi) 0], ...
             'edgecolor',tc, ...
             'facecolor',get(gca,'color'),...
             'facealpha', 0, ...
             'handlevisibility','off');
	end

	%% Tick labels
	% Generate labels
	
    majorticks	= linspace(axLim(1), axLim(2), majors + 1); 
    majorpos	= linspace(0, triangle_size, majors + 1);

    majorticks	= majorticks(1:end-1);
 	majorpos	= majorpos(1:end-1);

    if percentage
        multiplier = 100;
    else
        multiplier = 1;
    end
    
    if ~strcmp(direction, 'clockwise')
        labels = num2str(majorticks'*multiplier);
    else
        labels = num2str(majorticks(end:-1:1)'*multiplier);
	end
    
    zerocomp = zeros(size(majorticks)); % represents zero composition
	
    a_l = 0.02; % length of the arrow
    
	% Plot bottom labels (no c - only b a)
    [lxc,       lyc]        = plot.ternary.terncoords(triangle_size-majorpos, majorpos, zerocomp);
    [arrow_xc,  arrow_yc]        = plot.ternary.terncoords(triangle_size-majorpos, majorpos - a_l, zerocomp + a_l);
	text(ax, lxc+0.12, lyc-0.015, [repmat('  ', size(labels,1), 1) labels], 'VerticalAlignment', 'Top', 'HorizontalAlignment', 'left', 'Rotation', -60);
    
	% Plot left labels (no b - only a c)
    [lxb, lyb] = plot.ternary.terncoords(majorpos, zerocomp, triangle_size-majorpos); % fB = 1-fA
    [arrow_xb, arrow_yb] = plot.ternary.terncoords(majorpos - a_l, zerocomp + a_l, triangle_size-majorpos); % fB = 1-fA
    text(ax, lxb-0.12, lyb-0.075, labels, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Rotation', 0);

	% Plot right labels (no a, only c b)
	[lxa, lya] = plot.ternary.terncoords(zerocomp, triangle_size-majorpos, majorpos);
    [arrow_xa, arrow_ya] = plot.ternary.terncoords(zerocomp + a_l, triangle_size-majorpos, majorpos - a_l);
	text(ax, lxa, lya+0.115, labels, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Rotation', 60);
	
	nlabels = length(labels)-1;
	for i = 1:nlabels
        plot(ax, [lxa(i+1) lxb(nlabels - i + 2)], [lya(i+1) lyb(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',0.01,...
           'handlevisibility','off');
        plot(ax, [lxa(i+1) lxb(nlabels - i + 2)], [lya(i+1) lyb(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',0.01,...
           'handlevisibility','off');       
        plot(ax, [lxb(i+1) lxc(nlabels - i + 2)], [lyb(i+1) lyc(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',0.01,...
           'handlevisibility','off');
        plot(ax, [lxc(i+1) lxa(nlabels - i + 2)], [lyc(i+1) lya(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',0.01,...
           'handlevisibility','off');
        % arrows:
        plot(ax, [lxa(i+1) arrow_xa(i+1)], [lya(i+1) arrow_ya(i+1)], ls, 'color', [0, 0, 0, 1], 'linewidth',2,...
           'handlevisibility','off');
        plot(ax, [lxb(i+1) arrow_xb(i+1)], [lyb(i+1) arrow_yb(i+1)], ls, 'color', [0, 0, 0, 1], 'linewidth',2,...
           'handlevisibility','off');
        plot(ax, [lxc(i+1) arrow_xc(i+1)], [lyc(i+1) arrow_yc(i+1)], ls, 'color', [0, 0, 0, 1], 'linewidth',2,...
           'handlevisibility','off');
	end
end

% Reset defaults
set(ax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits', fUnits );
