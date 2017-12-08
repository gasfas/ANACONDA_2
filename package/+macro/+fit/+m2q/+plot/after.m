function after(ax, xdata, I_fit_total, I_fit_comp)
% This function visualizes the m2q-fitting for each group, after the
% fitting is done.
% Inputs:
% ax		The axes in which to plot
% xdata		[n,1] The x-values (m2q) to plot.
% I_fit		[n, 1] The final fit intensity

hold(ax, 'on'); grid(ax, 'on')			
% plot.textul(['$p_m = ' num2str(fit_param.result(groupnr,5),2) '$'], 0.18, 0.05, 'k');
hlgd = findobj(ax.Parent, 'Type','legend','Tag','legend');
if size(I_fit_comp, 2) > 1
	hLines = plot(xdata, [I_fit_comp, I_fit_total], 'LineStyle', '-.');
	nof_comps = size(I_fit_comp, 2);
	hlgd.String(end-nof_comps:end-1) = general.cell.pre_postscript_to_cellstring(num2cell(1:nof_comps), 'fit', '');
	hLines(end).LineStyle = '-';
	hLines(end).Color = 'k';
else
	plot(xdata, I_fit_total);
end
legend boxoff
hlgd.String{end} = 'Fit Total';
xlabel('m2q [a.m.u.]'); ylabel('Intensity [arb. u.]')
pause
end