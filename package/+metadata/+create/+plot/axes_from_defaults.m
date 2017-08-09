function axes_md = axes_from_defaults(axes_md, dim)
% This convenience function gives the given axes_md missing field values,
% from a list of default values.
% Inputs:
% axes_md	The axes metadata struct.
% dim		The dimension of the plot.
% Outputs
% axes_md	The axis metadata struct, with (missing) default values added.

%% default values:
def.grid		= 'on';
def.hold		= 'on';
def.Color		= 'none';
def.Position	= plot.ax.Position('full');
def.XAxisLocation = 'bottom';
def.YAxisLocation = 'left';
def.XTickLabelRotation = 45;
def.YTickLabelRotation = 45;
def.Fontsize	= 40;

if ~isfield(axes_md, 'Type')
	axes_md.Type = 'axes';
end

switch dim
	case 1
		def.YLabel.String	= 'Intensity';
	case 2
		switch axes_md.Type
			case 'polaraxes'
				try def.Title	= axes_md.RLabel; end
		end
		def.colormap		= plot.custom_RGB_colormap;
	case 3
		def.colormap		= plot.custom_RGB_colormap;		
end

%% Fill in the defaults
%  if the fieldname is not yet defined by the given metadata
axes_md = general.struct.catstruct(def, axes_md);

end