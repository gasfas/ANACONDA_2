function plot_md = write_plot_md(signal_md, plot_md)
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

% preparing ararys:
dim = 0; % the dimension of the plot.
hist_range = {}; hist_binsize = []; % The ranges of the signal.
axes_Lim = {}; axes_Tick = {}; axes_Label = {};
cond = {};

%% Fetching: we loop over all signals:
for i = 1:numel(signal_md)
	signal_cur = signal_md{i};
	% First, we check the data pointers:
	% Find whether event or hit signals are given:
	isevent(i)	= IO.data_pointer.is_event_signal( signal_cur.data_pointer );
	% Find from which detector the signals come:
	detnr(i)	= metadata.data_pointer.fetch_det_nr( signal_cur.data_pointer );
	
	% Then, we copy the metadata:
	% Histogram data:
	if isfield(signal_cur, 'hist')
		dim = dim + length(signal_cur.hist.binsize);
		hist_range = {hist_range{:} signal_cur.hist.range};
		hist_binsize = [hist_binsize signal_cur.hist.binsize(:)];
	end
	% Axes data:
	if isfield(signal_cur, 'axes')
		axes_Lim = [axes_Lim signal_cur.axes.XLim];
		axes_Tick = {axes_Tick{:}, signal_cur.axes.XTick};
		axes_Label = {axes_Label{:}, signal_cur.axes.XLabel};
	end
	% condition data:
	if isfield(signal_cur, 'cond')
		cond = {cond{:}, signal_cur.cond};
	end
end
% Checking whether the specified data are compatible:
% If they are all coming from events or all from hits:
if sum(isevent) < i && sum(~isevent) < i 
	error('the combination of signals are not all coming from either events or hits')
end
% If they are all coming from the same detector:
if sum(diff(detnr)) > 0
	error('the signals are not coming from the same detector, and can therefore not combined.')
end
%% Filling into plot_md:
% TODO: add polaraxes option.
% Histogram and axes data:
if dim >= 1
	plot_md.hist.XRange = hist_range{1};
	plot_md.hist.binsize(1) = hist_binsize(1);
	plot_md.axes.XLim	= axes_Lim{1};
	plot_md.axes.XTick	= axes_Tick{1};
	plot_md.axes.YLabel	= axes_Label{1};
end
if dim >= 2
	plot_md.hist.YRange = hist_range{2};
	plot_md.hist.binsize(2) = hist_binsize(2);
	plot_md.axes.YLim	= axes_Lim{2};
	plot_md.axes.YTick	= axes_Tick{2};
	plot_md.axes.YLabel	= axes_Label{2};
end
if dim >= 3
	plot_md.hist.YRange = hist_range{3};
	plot_md.hist.binsize(3) = hist_binsize(3);
	plot_md.axes.ZLim	= axes_Lim{3};
	plot_md.axes.YTick	= axes_Tick{3};
	plot_md.axes.ZLabel	= axes_Label{3};
end	
% Condition data:
if length(cond) == 1
	% This means that only one condition is defined:
	plot_md.cond	= cond{1};
elseif length(cond) > 1
	% This means that more than one condition is defined, 
	% so we place them as metaconditions next to each other:
	for cond_nr = 1:length(cond)
		plot_md.cond.(['sign' num2str(cond_nr)]) = cond{cond_nr};
	end
end