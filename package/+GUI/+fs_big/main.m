function main()
% main GUI file for the FS-BIG data viewer

% Assign a GUI number to this GUI run:
[GUI_settings]  = GUI.fs_big.init.determine_GUI_nr();

% Initialize the defaults and settings:
GUI_settings    = GUI.fs_big.init.load_GUI_settings(GUI_settings);

% Initialize the main window:
[GUI_settings, UI_obj] = GUI.fs_big.scan_viewer.start_scan_viewer(GUI_settings);

% Initiate the experiment struct:
exp_data                                = struct('scans', struct(), 'spectra', struct());

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)

% [exp_data, settings, UI_obj] = GUI.fs_big.main_GUI_view_scan();
% Build the standalone application:
% buildResults = compiler.build.standaloneApplication('main.m')

% Todo: 
% - Corrections: M/q shift, photon energy shift, 
% - Make option to change color for each channelgroup, instead of channel.
% - Remove channel should update table. Also when it is the last removed
% channel.
% - Make shift in m2q possible (or in TOF ?)
% - Make 'Visible' column in main scan viewer window.
% - dY and scale of the channels are not saved?
% - Read ESI_only, Photon_only, etc columns.
% - Read the photon flux.
% - Also save time-of-flight information.
% - Implement peakfinder in define_channels.
% - Implement peak fitter in branching ratio calculation.
% - For each modification of data (correct, normalize, subtract), write a
% note in the 'data treatment log' of the file. 
end