function plot_md = signal_2_md(signal_md, plot_md)
% This convenience function creates metadata from a signal plotting metadata
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
	plot_md = [];
end

% preparing ararys:
dim = 0; % the dimension of the plot.
cond = {}; plot_md.hist.pointer = {};
% Define the axes, if it is not already done:
switch general.struct.probe_field(plot_md, 'axes.Type')
case 'polaraxes'
		Coords = {'Theta', 'R'};
otherwise
		plot_md.axes.Type = 'axes';
		Coords = {'X', 'Y', 'Z'};	
end

%% Fetching: we loop over all signals:
for sign_nr = 1:numel(signal_md)
	signal_cur = signal_md{sign_nr};
	
	% Define the coordinate name(s):
	coord_names = Coords(sign_nr:sign_nr+length(signal_cur.hist.binsize)-1);
	signal_coord_nr = 0;
	% Fill in the data pointer in the metadata:
	plot_md.hist.pointer = {plot_md.hist.pointer{:}, signal_cur.hist.pointer};
	% loop over all coordinates if there are multiple in one signal:
	for coord_name_c = coord_names
		signal_coord_nr = signal_coord_nr+1; % The coordinate number in the current signal.
		dim = dim + 1; % The overall dimension of the plot.
		coord_name = coord_name_c{:};
		
		% We copy the metadata: (unconditional, they have to be in the metadata):
		% Histogram data:
		plot_md.hist.binsize(sign_nr+signal_coord_nr-1) = signal_cur.hist.binsize(signal_coord_nr);
		plot_md.hist.Range(sign_nr+signal_coord_nr-1,:) 	= signal_cur.hist.Range(signal_coord_nr,:);

		% Axes data:
		if isfield(signal_cur, 'axes')
			try	plot_md.axes.([coord_name 'Lim']) = signal_cur.axes.Lim(signal_coord_nr,:);	 catch; end
			try	plot_md.axes.([coord_name 'Tick']) = signal_cur.axes.Tick(signal_coord_nr,:);	 catch; end
			try		if ~iscell(signal_cur.axes.Label.String) && length(coord_names) == 1
						plot_md.axes.([coord_name 'Label']).String = signal_cur.axes.Label.String; 
					else plot_md.axes.([coord_name 'Label']).String = signal_cur.axes.Label.String{signal_coord_nr};
					end; catch; end
		end
	end
	% Condition data: (only one defined for every signal)
	try plot_md.cond.(['sign' num2str(sign_nr)]) = signal_cur.cond;			catch; end
end

% Fill in Histogram dimension:
plot_md.hist.dim = dim;

%% Default Figure properties:
plot_md.figure.Position		= plot.fig.Position('NE');
plot_md.figure.Color		= [1 1 1];

%% Default axes/Graphical object properties:
switch dim
	case 1
		plot_md.axes.YLabel.String	= 'Intensity';
		plot_md.GraphObj.Type		= 'line';% Type of graphical object to be created. 
		plot_md.GraphObj.LineStyle	= '-';% Linestyle of the graphical object. 
		plot_md.GraphObj.color		= 'b';% Color of the line.
	case 2
		plot_md.axes.XDir				= 'normal';
		plot_md.axes.YDir				= 'normal';
		plot_md.GraphObj.Type			= 'imagesc';% Type of graphical object to be created. 
		plot_md.GraphObj.colormap.type	= 'custom';% Colormap type;
		plot_md.GraphObj.colormap.RGB	= plot.custom_RGB_colormap('w','r',0,1); % The colormap RGB values.
	case 3
		plot_md.GraphObj.Type			= 'patch';% Type of graphical object to be created. 
		plot_md.GraphObj.FaceColor		= 'red'; % Color of the graphical object
		plot_md.GraphObj.EdgeColor		= 'none'; % Color of the graphical object
end