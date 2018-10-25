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
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Initialize emtpy variables:
h_figure	= [];
h_axes		= [];
varargin	= varargin{1};

% check if the first argument is a handle of any kind:
if ishandle(varargin{1})
	handle	= varargin{1};
	% return the rest of the arguments:
	varargin = varargin(2:end);
	% check which kind it is:
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