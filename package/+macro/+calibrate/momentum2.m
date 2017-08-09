function [] = momentum2(exp, calib_md)
% Plot 2D momentum image for the calibration.

% macro.plot.create.plot(exp, calib_md.p)

rows = 2; cols = 3;
h_fig = figure; subplot(rows, cols, 1);
set(gcf, 'Position', [961   529   960   445])

plot_md			= calib_md;
x_range			= plot_md.hist.Range;
binsize			= plot_md.hist.binsize;

dp              = eval(['exp.' plot_md.hist.pointer]);
detnr			= IO.det_nr_from_fieldname(plot_md.hist.pointer);

if isfield(plot_md, 'cond')
	e_filter	= macro.filter.conditions_2_filter(exp, plot_md.cond);
	h_filter	= filter.events_2_hits_det(e_filter, exp.e.raw(:,detnr), size(dp,1));
	dp			= dp(h_filter);
end

dp_norm         = general.vector.norm_vectorarray(dp, 2);

data            = [dp dp_norm];
names           = {'$p_x [amu]$', '$p_y [amu]$', '$p_z [amu]$', '$|p| [amu]$'};
ranges          = [x_range; x_range; x_range; [0 x_range(2)]];
x_data_idx      = [1, 1, 2, 1, 2, 3];
y_data_idx      = [2, 3, 3, 4, 4, 4];
plot_circle     = [1, 1, 1, 0, 0, 0];


for plotnr = 1:rows*cols
    
    ax			= subplot(rows,cols,plotnr); 
	data_cur	= [data(:,x_data_idx(plotnr)), data(:,y_data_idx(plotnr))];
% 	edges.dim1	= hist.bins(x_range, binsize);
	
	plot_md.hist.Range = ranges([x_data_idx(plotnr) y_data_idx(plotnr)],:);

	plot_md.axes.XLabel = names{x_data_idx(plotnr)}; 
	plot_md.axes.YLabel = names{y_data_idx(plotnr)}; 
	plot_md.axes.XLim	= ranges(x_data_idx(plotnr),:); 
	plot_md.axes.YLim	= ranges(y_data_idx(plotnr),:); 
	
	% prepare the histogram:
% 	hist.H_2D
    plot.quickhist(h_fig, ax, data_cur, 'plot_md', plot_md);

    plot.colored_minor_grid('w')
    hold on; 
    if plot_circle(plotnr) % If we need to plot a reference circle in the plot:
        circle_radius = (0:0.2:1) * min(plot_md.hist.Range(:)); 
        plot.circle(gca, 0, 0, circle_radius,'w');
    end
    
end
subplot(rows,cols,ceil(cols/2))

end
