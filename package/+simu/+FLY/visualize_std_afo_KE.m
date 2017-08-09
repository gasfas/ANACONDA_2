function [xdata, ydata] = visualize_std_afo_KE(Geometry_file, settings)
% This function is written to visualize the standard deviation as a function
% of kinetic energy. 

settings = write_FLY2(settings); settings = write_lua_file(settings);
%% Simulate
[SIMU_data, settings] = run_simulation(settings);
%% Visualize

settings.plot.el_nr_to_plot = 1;
settings.plot.nofbins = 100;
settings.plot.plottype = 'std_overall_afo_ke';%'R_afo_ke';%'TOF_vs_d_y';'y_splat_afo_el';%
settings.plot.print = 0;
[xdata, ydata] = plot_results(SIMU_data, settings); grid on