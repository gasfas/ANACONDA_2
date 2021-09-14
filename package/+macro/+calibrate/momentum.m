function [h_GraphObj] = momentum(exp, detnr, exp_md)
% Plot 2D momentum image for the calibration.
% Inputs
% exp		The experimental data struct
% detnr		The detector number of the signal to be calibrated
% exp_md	The experimental metadata
% Outputs
% h_GraphObj The handle of the graphical object
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

det_data = exp.h.(['det' num2str(detnr)]);
plot_metadata = exp_md.calib.(['det' num2str(detnr)]).momentum;

rows = 2; cols = 3;
figure; subplot(rows, cols, 1);
% set(gcf, 'Position', [961   529   960   445])


%Note: In this case plot_metadata refers to the calib metadata, not the
%plot metadata, so specifications are given in the metadata file calib-m
labels_2_plot   = plot_metadata.labels_to_show; 
binsize         = plot_metadata.binsize;
x_range         = plot_metadata.x_range;
y_range         = plot_metadata.y_range;

dp              = det_data.dp;
dpx             = dp(:,1);
dpy             = dp(:,2);
dpz             = dp(:,3);

pol             = acos(dpx./sqrt(dpx.^2 + dpy.^2 + dpz.^2));
az              = atan2(dpz,dpy);
az_neg          = find(az <= 0);

az(az_neg)      =  2*pi + az(az_neg);

m2q_l           = det_data.m2q_l;
dp_norm         = general.vector.norm_vectorarray(dp, 2);
% dp_norm         = general.vector.sum_vectorarray(dp, 2);
filt            = filter.hits.labeled_hits(m2q_l, labels_2_plot);


data            = [dp dp_norm pol az];
names           = {'$p_x [amu]$', '$p_y [amu]$', '$p_z [amu]$', '$|p| [amu]$', 'phi', 'theta'};
ranges          = [x_range; x_range; x_range; [0 x_range(2)]; [0 x_range(2)]; [0 x_range(2)]];
y_ranges        = [y_range; y_range; y_range; [0 max(x_range)];  [-pi pi]; [0 2*pi]]; 
x_data_idx      = [2, 3, 3, 1, 2, 3, 4, 4, 4];
y_data_idx      = [1, 1, 2, 4, 4, 4, 6, 5, 6];
plot_circle     = [1, 1, 1, 0, 0, 0, 0, 0, 0];
plot_hor        = [0, 0, 0, 1, 1, 1, 0, 0, 0];




if isfield(plot_metadata, 'cond')
	e_f = macro.filter.conditions_2_filter(exp, plot_metadata.cond);
	h_f = filter.events_2_hits_det(e_f, exp.e.raw(:,detnr), size(dp, 1),plot_metadata.cond,exp);
	filt = filt & h_f;
end


for plotnr = 1:(rows*cols )
    x_edges = hist.bins(x_range, binsize(1));
    y_edges = hist.bins(y_ranges(y_data_idx(plotnr),:), binsize(2));
    ax = subplot(rows,cols,plotnr); 
	set(gcf, 'Colormap', parula); %can also be jet
%     set(gcf,'Position', [250, 0, 1150, 1150]);
	% Make the histogram:
	
    [Count, mids.dim1, mids.dim2] = hist.H_2D(data(filt,x_data_idx(plotnr)), data(filt,y_data_idx(plotnr)), x_edges, y_edges);
	% Plot it:
	[h_GraphObj] = plot.hist.axes.H_2D.imagesc(ax, mids, Count);
	set(gca, 'YDir', 'normal')

    xlabel(names{x_data_idx(plotnr)});
    ylabel(names{y_data_idx(plotnr)});
    xlim(ranges(x_data_idx(plotnr),:)); 
    ylim(y_ranges(y_data_idx(plotnr),:)); 
%     plot.colored_minor_grid('w')
    hold on; 
    if plot_circle(plotnr) % If we need to plot a reference circle in the plot:
        circle_radius = (0:0.2:1) * min([plot_metadata.x_range plot_metadata.y_range]); 
        plot.circle(gca, 0, 0, circle_radius, [1 1 1]);
    elseif plot_hor(plotnr) % we plot a rectangular grid:
		plot.grid([ax.XLim(1), ax.YLim(1)], ...
					[ax.XLim(1), ax.YLim(2)], ...
					[ax.XLim(2), ax.YLim(1)], ...
					[ax.XLim(2), ax.YLim(2)], 10, 10, 'Color', 'w', 'LineWidth', 0.1);
    else
        plot.grid([ax.XLim(1), ax.YLim(1)], ...
					[ax.XLim(2), ax.YLim(1)], ...
					[ax.XLim(1), ax.YLim(2)], ...
					[ax.XLim(2), ax.YLim(2)], 10, 10, 'Color', 'w', 'LineWidth', 0.1);
    end

end



subplot(rows,cols,ceil(cols/2));
try
title(num2str(plot_metadata.cond.type.hit_to_show.value),'FontSize',20)
end
if length(labels_2_plot)<5
	try title(['Bfield:' num2str(exp_md.spec.Bfield) ' . TOF_factor' num2str(exp_md.conv.(['det' num2str(detnr)]).TOF_2_m2q.factor) ' . Efield:' num2str(exp_md.spec.Efield) ' .']); end
else
	try title(['Bfield:' num2str(exp_md.spec.Bfield) ' . TOF_factor' num2str(exp_md.conv.(['det' num2str(detnr)]).TOF_2_m2q.factor) ' .  Efield:' num2str(exp_md.spec.Efield) ' .' ]); end
end



end
