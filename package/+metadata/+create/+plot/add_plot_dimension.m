function plot_md = add_plot_dimension(plot_md, signal_md, dim_nr, coord_name, signal_coord_nr)
% This function adds an extra dimension to a plot configuration.
% Inputs:
% plot_md		The metadata struct without the extra dimension
% signal_md		The signal metadata
% dim_nr		The dimension number that is added.
% signal_coord_nr (optional) The coordinate number in the signal that should be added.
%				Default: 1
% Outputs:
% plot_md		The new plot metadata, with added dimension
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('signal_coord_nr', 'var')
	signal_coord_nr = 1;
end

% We copy the metadata: (unconditional, they have to be in the metadata):
% Histogram data:
plot_md.hist.binsize(dim_nr) = signal_md.hist.binsize(signal_coord_nr);
plot_md.hist.Range(dim_nr,:) 	= signal_md.hist.Range(signal_coord_nr,:);

if general.struct.probe_field(signal_md, 'hist.ifdo.Solid_angle_correction')
	plot_md.hist.ifdo.Solid_angle_correction = true;
	plot_md.hist.Solid_angle_correction.Dim_nr = dim_nr+signal_coord_nr-1;
end

% Axes data:
if isfield(signal_md, 'axes')
	try	
		plot_md.axes.([coord_name 'Lim']) = signal_md.axes.Lim(signal_coord_nr,:);	 
	catch 
	end
	try		plot_md.axes.([coord_name 'Tick']) = signal_md.axes.Tick;	 
	catch;  end
	try		plot_md.axes.([coord_name 'TickLabel']) = signal_md.axes.Tick;	 
	catch; 	end
	try		
		if ~iscell(signal_md.axes.Label.String)
			plot_md.axes.([coord_name 'Label']).String = signal_md.axes.Label.String; 
		else 
			plot_md.axes.([coord_name 'Label']).String = signal_md.axes.Label.String{signal_coord_nr};
		end
	catch
	end
end

end