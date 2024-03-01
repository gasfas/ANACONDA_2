function [GUI_settings] = load_GUI_settings(GUI_settings)
% Set some initial GUI_settings for the GUI:

GUI_settings.load_scan.browse_dir                   = 'D:\DATA\2023\PETRA P04\';
GUI_settings.load_scan.setup_type                   = 'Spektrolatius';
GUI_settings.load_scan.tooltips.re_bin_factor       = 'The re-bin factor reduces the amount of (m2q) datapoints by calculating the average of every bunch of ''re-bin factor'' values.';
GUI_settings.load_scan.tooltips.sample_name         = 'Fill in the name of the sample or run you are loading. For example: ""MetEnk_Desirs"" ';
GUI_settings.load_scan.tooltips.Remove_scan         = 'Removes the selected scan(s) in the table from memory.';
GUI_settings.load_scan.tooltips.Modify_scan         = 'Adapt an already-loaded scan, e.g. by adding or removing spectra or changing the name.';
GUI_settings.load_scan.tooltips.calibrate           = 'Normalizing either a scan or spectrum. The normalized data will be added as one of the scans or spectra.';
GUI_settings.load_scan.tooltips.subtract            = 'Subtract a spectrum/scan by a spectrum/(spectrum/scan)'
GUI_settings.load_scan.tooltips.plot_m2q            = 'Visualize the mass spectra of selected scan(s). If no scans are selected, all of them will be available.';
GUI_settings.load_scan.tooltips.plot_scan           = 'Visualize the yields of selected scan(s). If no scans are selected, all of them will be considered.';
GUI_settings.load_scan.tooltips.define_channels     = 'Select the fragments from an averaged mass spectru';
GUI_settings.load_scan.tooltips.Save_workspace      = 'Save the current workspace to disk, to be loaded at a later stage.';
GUI_settings.load_scan.tooltips.Load_workspace      = 'Load a previously used workspace from disk. Note that the currently loaded workspace will be cleared.';
GUI_settings.load_scan.tooltips.Data_type_radio     = 'Do the data files form a common scan (only if all have a defined photon energy), or are they a collection of individual spectra?';

GUI_settings.load_scan.tooltips.Add                 = 'Load a spectrum (or scan of spectra) from disk to memory. The spectrum name will appear as a row in the table.';
GUI_settings.load_scan.tooltips.Remove_spectrum     = 'Removes the selected spectrum/spectra in the table from memory.';
GUI_settings.load_scan.tooltips.Modify_spectrum     = 'Adapt an already-loaded scan, e.g. by adding or removing spectra or changing the name.';
GUI_settings.load_scan.sample_number                = 0; % 


end