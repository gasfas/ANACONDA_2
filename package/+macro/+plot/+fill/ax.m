function h_axes = ax(h_axes, axes_md)
% This function takes an axes handle, and fills in the axes metadata from
% the given struct.
% Inputs
% h_axes	The axes handle
% axes_md	The metadata of the axes
% Output:
% h_axes	The axes handle, with the metadata filled in
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if general.struct.probe_field(axes_md, 'Type')
    axes_md = rmfield(axes_md, 'Type'); % Remove 'Type' field if present.
end

% Some fields cannot be directly copied from struct to handle, for some
% mysterious reason MATLAB decided to not store those properties in
% the handle directly:
	if isfield(axes_md, 'grid')% If a gridstyle is defined:
		grid(h_axes, axes_md.grid)
	end
	if isfield(axes_md, 'hold')% If hold is defined:
		hold(h_axes, axes_md.hold)
	end
	if isfield(axes_md, 'axis')% If a axis style is defined:
		axis(h_axes, axes_md.axis)
	end
	if isfield(axes_md, 'colormap')% If a colormap is defined:
		colormap(h_axes, axes_md.colormap);
	end
	if isfield(axes_md, 'camroll')% If a camroll is defined:
		camroll(h_axes, axes_md.camroll);
	end
	if isfield(axes_md, 'colorbar')% If a colorbar is defined:
		colorbar('peer', h_axes);
	end
	if ~isempty(axes_md)
		h_axes = general.handle.fill_struct(h_axes, axes_md);
	end
end