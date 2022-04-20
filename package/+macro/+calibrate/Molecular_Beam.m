function [] = Molecular_Beam(exp, detnr, calib_md)
% Plot 2D X-TOF and Y-TOF histograms for calibrating. See the package
% documentation for a more detailed description of the calibration
% Inputs
% exp	The experimental data struct
% detnr	The detector number of the signal to be calibrated
% calib_md	The calibration metadata
% Outputs
% -
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

plot_md = calib_md.plot;

TOF				= general.data.pointer.read(plot_md.X.hist.pointer{1}, exp);
X				= general.data.pointer.read(plot_md.Y.hist.pointer{1}, exp);
Y				= general.data.pointer.read(plot_md.Y.hist.pointer{2}, exp);
% create the figure:
fig				= macro.plot.create.fig(plot_md.X.figure);

if isfield(calib_md, 'cond')
	filt = macro.filter.conditions_2_filter(exp, calib_md.cond);
else
	filt = true(size(exp.e.raw,1), 1);
end
coors = {'X', 'Y'};
for i = 1:2
	coor = coors{i};
	ax(i) = subplot(2,1,i);
	plot_md.(coor).axes.Position = ax(i).Position;
	ax(i) = macro.plot.fill.ax(ax(i), plot_md.(coor).axes);
	
	if isfield(plot_md.(coor), 'cond')
		% Calculate the filter from a condition:
		[e_filter, exp]	= macro.filter.conditions_2_filter(exp, plot_md.(coor).cond);
		% Calculate the histogram with the filter:
		histogram	= macro.hist.create.hist(exp, plot_md.(coor).hist, e_filter);
	else
		% Calculate the histogram:
		histogram	= macro.hist.create.hist(exp, plot_md.(coor).hist);
	end

	% And plot the Graphical Object in it:
	h_GraphObj	= macro.hist.create.GraphObj(ax(i), histogram, plot_md.(coor).GraphObj);
	
end

linkaxes(ax, 'x')

end
