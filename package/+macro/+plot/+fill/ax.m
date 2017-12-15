function h_axes = ax(h_axes, axes_md)
% This function takes an axes handle, and fills in the axes metadata from
% the given struct.

axes_md = rmfield(axes_md, 'Type');

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
	h_axes = general.handle.fill_struct(h_axes, axes_md);
end