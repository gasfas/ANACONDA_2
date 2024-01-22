function [h_GraphObj] = plot_fit_components(ax, xdata, FP)
% This function plots the individual components of a fit, from the user-given
% results
% Inputs: 
%   ax  The to plot the curves into
%   FP  The fit parameters of the past performed fit
%   fit_type The type of fite, either 'Gayss' or 'edge'
% Outputs:
%   h_GraphObj  cell of graphical object axes of the lines.
nof_peaks       = length(general.struct.probe_field(FP, 'mu.value'));
h_GraphObj    = cell(nof_peaks, 1);

for peak_nr = 1:nof_peaks
    yfit    = theory.function.gauss_PDF(xdata, FP.mu.value(peak_nr), FP.sigma.value(peak_nr), FP.PH.value(peak_nr));
    h_GraphObj{peak_nr} = plot(ax, xdata, yfit);
end
end