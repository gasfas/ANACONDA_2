function [h_axes, h_figure, varargin] = check_varargin_handles(varargin)
% This convenience function checks whether the first arguments given to a
% function are handles of axes or figures, and if they are, they are
% returned (with the corresponding axes/figure parent/child. 
% If not, a new axes and figure is returned.
% Input:
% varargin	The input arguments, with the possible figure or axes handle as
%			first argument.
% Output:
% h_axes	The found, or created axes handle
% h_figure	The found, or created figure handle
% varargin	The input arguments, possibly stripped from the first argument.

h_figure	= [];
h_axes		= [];
varargin	= varargin{1};

if ishandle(varargin{1})
	handle	= varargin{1};
	varargin = varargin(2:end);
	if isgraphics(handle(1), 'Axes') || isgraphics(handle(1), 'polaraxes')
		h_axes = handle;
		h_figure = h_axes.Parent;
	elseif isgraphics(handle, 'Figure')
		h_figure = handle;
	else
		error('no valid handle given')
	end
end

end