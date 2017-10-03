function after(ax, xdata, I_fit)
% This function visualizes the m2q-fitting for each group, after the
% fitting is done.
% Inputs:
% ax		The axes in which to plot
% xdata		[n,1] The x-values (m2q) to plot.
% I_fit		[n, 1] The final fit intensity

hold(ax, 'on'); grid(ax, 'on')			
% plot.textul(['$p_m = ' num2str(fit_param.result(groupnr,5),2) '$'], 0.18, 0.05, 'k');
plot(xdata, I_fit);
legend boxoff
hlgd = findobj(gcf, 'Type','legend','Tag','legend');
hlgd.String{end} = 'Fit';
xlabel('m2q [a.m.u.]'); ylabel('Intensity [arb. u.]')
pause
end
		
