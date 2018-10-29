function plot_md = hist_from_data (plot_md, data)
% This convenience function gives the given Graphical Object metadata missing field values,
% from a list of default values.
% Inputs:
% plot_md	The plot metadata struct.
% data		The histogram matrix
% Outputs
% GraphObj_md	The plot metadata struct, with (missing) default values added.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

dim = size(data, 2);

switch general.struct.probe_field(plot_md, 'axes.Type')
case 'polaraxes'
		Coords = {'Theta', 'R'};
otherwise
		plot_md.axes.Type = 'axes';
		Coords = {'X', 'Y', 'Z'};	
end
nof_bins = 1e5;
%% default values:
% Initialize the default hist metadata:
def.hist.Range		= [-1 1];
def.hist.binsize	= 1;

% Overwrite data-dependent metadata:
for coor_nr = 1:dim
	try 
		signal_md.hist.Range = plot_md.hist.Range(dim, :);
    catch
        data(~isfinite(data)) = NaN;
		signal_md.hist.Range	= [min(data(:,coor_nr), [], 1, 'omitnan'), max(data(:,coor_nr),[], 1, 'omitnan')]; % Full range of data.
	end
	
	signal_md.hist.binsize	= min(diff(signal_md.hist.Range)*nthroot(nof_bins, dim), diff(signal_md.hist.Range)/100); % at least 100 bins.
	
	
	signal_md.axes.Lim		= signal_md.hist.Range;
	% Write the values in def_md:
	def = metadata.create.plot.add_plot_dimension(def, signal_md, coor_nr);
end

%% Fill in the defaults
%  if the fieldname is not yet defined by the given metadata
plot_md.hist = general.struct.catstruct(def.hist, plot_md.hist);
