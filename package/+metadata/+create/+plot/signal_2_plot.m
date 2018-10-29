function plot_md = signal_2_plot(signal_md, plot_md)
% This function creates metadata from a signal plotting metadata
% Inputs: 
% signal_md		The metadata concerned with the signal. can be a cell of
% different structs, if multiple signals are plotted in one.
% plot_md	The so-far defined metadata. The given metadata will be 
% overwritten by the metadata defined by the signal.
% Outputs:
% plot_md	The plot_md with the signals added.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~iscell(signal_md)
	% There is only one signal defined:
	signal_md = {signal_md};
end
if ~exist('plot_md', 'var')
	plot_md = struct('figure', [], 'axes', [], 'hist', [], 'GraphObj', []);
else
	if ~general.struct.issubfield(plot_md, 'figure')
		plot_md.figure = [];
	end
	if ~general.struct.issubfield(plot_md, 'axes')
		plot_md.axes = [];
	end
	if ~general.struct.issubfield(plot_md, 'GraphObj')
		plot_md.GraphObj = [];
	end
end

% preparing ararys:
dim = 0; % the dimension of the plot.
cond = {}; plot_md.hist.pointer = {};
% Define the axes, if it is not already done:
switch general.struct.probe_field(plot_md, 'axes.Type')
case 'polaraxes'
		Coords = {'Theta', 'R'};
otherwise
		Coords = {'X', 'Y', 'Z'};	
end

%% Fetching: we loop over all signals:
for sign_nr = 1:numel(signal_md)
	signal_cur = signal_md{sign_nr};
	
	% Define the coordinate name(s):
	coord_names = Coords(sign_nr:sign_nr+length(signal_cur.hist.binsize)-1);
	signal_coord_nr = 0;
	% Fill in the data pointer in the metadata:
	try plot_md.hist.pointer = {plot_md.hist.pointer{:}, signal_cur.hist.pointer}; catch; end
	% loop over all coordinates if there are multiple in one signal:
	for coord_name_c = coord_names
		signal_coord_nr = signal_coord_nr+1; % The coordinate number in the current signal.
		dim = dim + 1; % The overall dimension of the plot.
		coord_name = coord_name_c{:};
		% Write the values in plot_md:
		plot_md = metadata.create.plot.add_plot_dimension(plot_md, signal_cur, dim, coord_name, signal_coord_nr);
	end
	% Condition data: (only one defined for every signal)
	try plot_md.cond.(['sign' num2str(sign_nr)]) = signal_cur.cond;			catch; end
end

% If the requested plot is a ternary one, this should be written in the
% GraphObj, hist and axes metadata:
if strcmp(general.struct.probe_field(plot_md, 'Type'), 'ternary')
	plot_md.GraphObj.Type	= 'ternary';
	plot_md.hist.Type		= 'ternary';
	plot_md.axes.Type		= 'ternary';
end

% Fill in Histogram dimension:
plot_md.hist.dim = dim;

%% Default Plot metadata properties:
plot_md.figure		=  metadata.create.plot.figure_from_defaults(plot_md.figure);
plot_md.axes		=  metadata.create.plot.axes_from_defaults(plot_md.axes, dim);
plot_md.GraphObj	=  metadata.create.plot.GraphObj_from_defaults(plot_md.GraphObj, dim);

end