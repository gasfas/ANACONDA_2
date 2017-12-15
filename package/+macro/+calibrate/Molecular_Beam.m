function [] = Molecular_Beam(exp, detnr, calib_md)
% Plot 2D X-TOF and X-TOF histograms for calibrating.

plot_md = calib_md.plot;

TOF				= IO.read_data_pointer(plot_md.X.hist.pointer{1}, exp);
X				= IO.read_data_pointer(plot_md.X.hist.pointer{2}, exp);
Y				= IO.read_data_pointer(plot_md.Y.hist.pointer{2}, exp);
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
	
	% Calculate the histogram:
	histogram	= macro.hist.create.hist(exp, plot_md.(coor).hist, filt);
	% And plot the Graphical Object in it:
	h_GraphObj	= macro.hist.create.GraphObj(ax(i), histogram, plot_md.(coor).GraphObj);
	
end

end
