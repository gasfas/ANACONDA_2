% TERNAXES create ternary axis
%   HOLD_STATE = TERNAXES(MAJORS) creates a ternary axis system using the system
%   defaults and with MAJORS major tickmarks.

% Author: Carl Sandrock 20050211

% To Do

% Modifications
% 20160405 (SA) Added lines to change the order/direction of axes (i.e.
%               clockwise or counter-clockwise) cooresponding to user-specified 
%               option on terncoords

% Modifiers
% (CS) Carl Sandrock
% (SA) Shahab Afshari

function [hold_state, cax, next] = ternaxes(majors, lim)
if nargin < 1
    majors = 10;
end

% TODO: Handle these as options
direction = 'clockwise';
percentage = false;

if ~exist('lim', 'var')
	lim = [0 1];
end

%TODO: Get a better way of offsetting the labels
xoffset = 0.25;
yoffset = 0.01;

% % get hold state
% cax = newplot;
% next = lower(get(cax,'NextPlot'));
% hold_state = ishold;
cax = gca;
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');

set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
         'DefaultTextFontName',   get(cax, 'FontName'), ...
         'DefaultTextFontSize',   get(cax, 'FontSize'), ...
         'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
         'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state
	%plot axis lines
	hold on;
	plot ([0 lim(2) lim(2)/2 0],[0 0 lim(2)*sin(1/3*pi) 0], 'color', tc, 'linewidth',1,...
                   'handlevisibility','off');
	set(gca, 'visible', 'off');
    % plot background if necessary
    if ~ischar(get(cax,'color'))
       patch('xdata', [0 lim(2) lim(2)/2 0], 'ydata', [0 0 lim(2)*sin(1/3*pi) 0], ...
             'edgecolor',tc, ...
             'facecolor',get(gca,'color'),...
             'facealpha', 0, ...
             'handlevisibility','off');
    end

	% Generate labels

    if majors < 10
        majorticks = linspace(lim(1), lim(2), majors + 1); 
    else
        majorticks = linspace(lim(1), lim(2), 10 + 1); 
    end
    
    majorticks = majorticks(1:end-1);

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
    
	% Plot bottom labels (no c - only b a)
    a_l = 0.02; % length of the arrow
    
    [lxc,       lyc]        = plot.ternary.terncoords(lim(2)-majorticks, majorticks, zerocomp);
    [arrow_xc,  arrow_yc]        = plot.ternary.terncoords(lim(2)-majorticks, majorticks - a_l, zerocomp + a_l);
	text(lxc+0.1, lyc-0.025, [repmat('  ', size(labels,1), 1) labels], 'VerticalAlignment', 'Top', 'HorizontalAlignment', 'left');
    
	% Plot left labels (no b - only a c)
    [lxb, lyb] = plot.ternary.terncoords(majorticks, zerocomp, lim(2)-majorticks); % fB = 1-fA
    [arrow_xb, arrow_yb] = plot.ternary.terncoords(majorticks - a_l, zerocomp + a_l, lim(2)-majorticks); % fB = 1-fA
    text(lxb-0.115, lyb-0.065, labels, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');

	% Plot right labels (no a, only c b)
	[lxa, lya] = plot.ternary.terncoords(zerocomp, lim(2)-majorticks, majorticks);
    [arrow_xa, arrow_ya] = plot.ternary.terncoords(zerocomp + a_l, lim(2)-majorticks, majorticks - a_l);
	text(lxa, lya+0.115, labels, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center');
	
	nlabels = length(labels)-1;
	for i = 1:nlabels
        plot([lxa(i+1) lxb(nlabels - i + 2)], [lya(i+1) lyb(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',1,...
           'handlevisibility','off');
        plot([lxa(i+1) lxb(nlabels - i + 2)], [lya(i+1) lyb(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',1,...
           'handlevisibility','off');       
        plot([lxb(i+1) lxc(nlabels - i + 2)], [lyb(i+1) lyc(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',1,...
           'handlevisibility','off');
        plot([lxc(i+1) lxa(nlabels - i + 2)], [lyc(i+1) lya(nlabels - i + 2)], ls, 'color', [0, 0, 0, 0.1], 'linewidth',1,...
           'handlevisibility','off');
        % arrows:
        plot([lxa(i+1) arrow_xa(i+1)], [lya(i+1) arrow_ya(i+1)], ls, 'color', [0, 0, 0, 1], 'linewidth',2,...
           'handlevisibility','off');
        plot([lxb(i+1) arrow_xb(i+1)], [lyb(i+1) arrow_yb(i+1)], ls, 'color', [0, 0, 0, 1], 'linewidth',2,...
           'handlevisibility','off');
        plot([lxc(i+1) arrow_xc(i+1)], [lyc(i+1) arrow_yc(i+1)], ls, 'color', [0, 0, 0, 1], 'linewidth',2,...
           'handlevisibility','off');
	end;
end;

% Reset defaults
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits', fUnits );
