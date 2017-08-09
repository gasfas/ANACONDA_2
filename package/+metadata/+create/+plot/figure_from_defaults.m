function fig_md = figure_from_defaults(fig_md)
% This convenience function gives the given figure metadata missing field values,
% from a list of default values.
% Inputs:
% fig_md	The axes metadata struct.
% Outputs
% fig_md	The axis metadata struct, with (missing) default values added.

%% default values:
def.Position		= plot.fig.Position('NE');
def.Color			= 0.95*[1 1 1];

%% Fill in the defaults
%  if the fieldname is not yet defined by the given metadata
fig_md = general.struct.catstruct(def, fig_md);

end
