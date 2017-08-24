function plot_md = data_pointer_2_md(exp, data_pointers, plot_md)
% This convenience function creates metadata from data pointers.
% Inputs: 
% data_pointers		cell of strings, pointing to the signal. For example: 'e.det1.TOF'.
% plot_md	The so-far defined plot metadata. The given metadata will be 
% overwritten by the metadata defined by the signal, if fields overlap.
% Outputs:
% plot_md	The plot_md with the signals added.

if ~iscell(data_pointers)
	% There is only one signal defined:
	data_pointers = {data_pointers};
end

%% Defining the signal metadata
% we loop over all signals:
for i = 1:numel(data_pointers)
	data_pointer = data_pointers{i};
	% First, we check the data pointers:
	% Find whether event or hit signals are given:
	isevent(i)	= metadata.data_pointer.is_event_signal( data_pointer );
	% Find from which detector the signals come:
	detnr(i)	= metadata.data_pointer.fetch_det_nr( data_pointer );
TODO	
	% Then, we define the signal metadata:
	% Histogram data:
	d1.signal.TOF.hist.binsize	= 10;% [ns] binsize of the variable. 
d1.signal.TOF.hist.range	= [0 1e5];% [ns] range of the variable. 
% Axes metadata:
d1.signal.TOF.axes.XLim		= [0 1e5];% [ns] XLim of the axis that shows the variable. 
d1.signal.TOF.axes.XTick	= convert.m2q_2_TOF(exp_md.sample.fragment.masses, ...
								exp_md.conv.det1.TOF_2_m2q.factor, ...
								exp_md.conv.det1.TOF_2_m2q.t0);% [ns] XTick of the axis that shows the variable. 
d1.signal.TOF.axes.XLabel	= 'TOF [ns]'; %The label of the variable
% Condition metadata:
d1.signal.TOF.cond			= exp_md.cond.monomer;
end
% Checking whether the specified data are compatible:
% If they are all coming from events or all from hits:
if sum(isevent) < i && sum(~isevent) < i 
	error('the combination of signals are not all coming from either events or hits')
end
% If they are all coming from the same detector:
if sum(diff(detnr)) > 0
	error('the signals are not coming from the same detector, and can therefore not be combined.')
end

% preparing ararys:
dim = 0; % the dimension of the plot.
hist_range = {}; hist_binsize = []; % The ranges of the signal.
axes_Lim = {}; axes_Tick = {}; axes_Label = {};
cond = {};

%% Combining the signal metadata to plot metadata:
plot_md = metadata.create.plot.signal_2_md(signal_md, plot_md);

