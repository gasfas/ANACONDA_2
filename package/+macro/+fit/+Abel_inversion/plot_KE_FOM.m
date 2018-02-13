function [h_figure, h_axes, h_GraphObj] = plot_KE_FOM(fit_md)
% Function that visualizes the KER plot from a previous executed FOM Abel
% inversion.

% The user wants to show a kinetic energy histogram from the inverted image:
% Fetch R, theta coordinates:
im_pol			= load(fullfile(fileparts(which('fit.Abel_inversion.FOM.execute_IterativeInversion')), 'it_3dpol0001.dat'));
% Integrate along theta:
I				= sum(im_pol, 2);
p_norm			= linspace(0, fit_md.plot.hist.Range(1,2), length(I))';
KE				= convert.p_2_KE(0, p_norm, fit_md.Mass);
% Plot with given metadata:
% Create a new figure:
h_figure	= macro.plot.create.fig(fit_md.plot_KE.figure);
% Then create the new axes:
h_axes	= macro.plot.create.ax(h_figure, fit_md.plot_KE.axes);
% And plot the Graphical Object in it:
h_GraphObj= plot(h_axes(1), KE, I);
% fill the graphical object metadata:
h_GraphObj	= general.handle.fill_struct(h_GraphObj, fit_md.plot_KE.GraphObj);
end