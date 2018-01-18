function before(ax, xdata, I_data, I_bgr, I_IG)
% This function visualizes the m2q-fitting for each group, before the
% fitting is done.
% Inputs:
% ax		The axes in which to plot
% xdata		[n,1] The x-values (m2q) to plot.
% I			[n,1] The y-values (Intensity) to be fitted
% ybgr		[n, 1] The background intensity
% fit_md	struct, the fitting metadata.
% IG		struct, containing information of the initial guess.
try cla(ax); end
hold(ax, 'on')
if any(size(I_bgr) ~= size(xdata))
	I_bgr = I_bgr(1)*ones(size(xdata));
end
hLines = plot(ax, xdata, [I_data, I_bgr, I_IG]);
hLines(1).LineStyle = 'none';
hLines(1).Marker = '*';
hLines(1).Color = 'r';
hLines(2).LineStyle = ':';
hLines(3).LineStyle = ':';
legend(ax, 'Raw data', 'Background level', 'Initial guess')
set (ax.Parent, 'Position', plot.fig.Position('se'));
xlim([min(xdata), max(xdata)])
end
