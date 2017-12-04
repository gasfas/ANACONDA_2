function [] = momentum(exp, detnr, plot_metadata)
% Plot 2D momentum image for the calibration.

det_data = exp.h.(['det' num2str(detnr)]);

rows = 2; cols = 3;
figure; subplot(rows, cols, 1);
set(gcf, 'Position', [961   529   960   445])

labels_2_plot   = plot_metadata.labels_to_show;
binsize         = plot_metadata.binsize;
x_range         = plot_metadata.x_range;
y_range         = plot_metadata.y_range;

dp              = det_data.dp;
m2q_l           = det_data.m2q_l;
dp_norm         = general.vector.norm_vectorarray(dp, 2);
filt            = filter.hits.labeled_hits(m2q_l, labels_2_plot);

data            = [dp dp_norm];
names           = {'$p_x [amu]$', '$p_y [amu]$', '$p_z [amu]$', '$|p| [amu]$'};
ranges          = [x_range; x_range; x_range; [0 x_range(2)]];
x_data_idx      = [1, 1, 2, 1, 2, 3];
y_data_idx      = [2, 3, 3, 4, 4, 4];
plot_circle     = [1, 1, 1, 0, 0, 0];

if isfield(plot_metadata, 'cond')
	e_f = macro.filter.conditions_2_filter(exp, plot_metadata.cond);
	h_f = filter.events_2_hits_det(e_f, exp.e.raw(:,detnr), size(dp, 1));
	filt = filt & h_f;
end

for plotnr = 1:rows*cols
    
    ax = subplot(rows,cols,plotnr); 
	
	% Make the histogram:
	x_edges = hist.bins(x_range, binsize(1)); y_edges = hist.bins(y_range, binsize(2));
    [Count, mids.dim1, mids.dim2] = hist.H_2D(data(filt,x_data_idx(plotnr)), data(filt,y_data_idx(plotnr)), x_edges, y_edges);
	% Plot it:
	plot.hist.axes.H_2D.imagesc(ax, mids, Count);
	set(gca, 'YDir', 'normal')

    xlabel(names{x_data_idx(plotnr)});
    ylabel(names{y_data_idx(plotnr)});
    xlim(ranges(x_data_idx(plotnr),:)); 
    ylim(ranges(y_data_idx(plotnr),:)); 
    plot.colored_minor_grid('w')
    hold on; 
    if plot_circle(plotnr) % If we need to plot a reference circle in the plot:
        circle_radius = (0:0.2:1) * min([plot_metadata.x_range plot_metadata.y_range]); 
        plot.circle(gca, 0, 0, circle_radius, [1 1 1]);
	end
end
subplot(rows,cols,ceil(cols/2))
if length(labels_2_plot)<5
title(['labels shown: ' sprintf('%0.0f ', labels_2_plot)])
else
title(['labels shown: ' sprintf('%0.0f ', labels_2_plot(1)) '-' sprintf('%0.0f ', labels_2_plot(end))])
end
end
