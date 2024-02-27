function [GUI_settings, UI_obj] = start_scan_viewer(GUI_settings)
% Initiate the scan viewer.

% GUI main view to load and visualize a Spektrolatius/Desirs/... scan

UI_obj                                  = struct(); %All Ui objects stored in this struct.

% Some initial values for the GUI_settings:
GUI_settings.filelist.color_counter     = 1;
GUI_settings.scans.scan_nr_cur          = 1;
GUI_settings.spectra.spectrum_nr_cur    = 1;

% Set up the display, Initiate the uifigure:
UI_obj.main.uifigure                    = uifigure('Name', 'Scan viewer','NumberTitle','off','position',[100 100 590 470], 'CloseRequestFcn', {@GUI.fs_big.scan_viewer.callback.close_all_GUI_windows, GUI_settings});

% Create the uitable containing the list of scans:
UI_obj                                  = GUI.fs_big.scan_viewer.uitable_spectra_create(GUI_settings, UI_obj);
UI_obj                                  = GUI.fs_big.scan_viewer.uitable_scan_create(GUI_settings, UI_obj);

% Initialize the interaction buttons for the spectra:
UI_obj.main.Add                         = uibutton(UI_obj.main.uifigure, "Text", "Add", "Position", [480, 430, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.Add, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.load_scan_GUI, GUI_settings});
UI_obj.main.Remove_spectrum             = uibutton(UI_obj.main.uifigure, "Text", "Remove spectrum", "Position", [480, 400, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.Remove_spectrum, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.remove_spectrum_scan_GUI,1, GUI_settings});

% Initialize the interaction buttons (load, delete, view spectra) for the
% scan:
UI_obj.main.Remove_scan             = uibutton(UI_obj.main.uifigure, "Text", "Remove scan", "Position", [480, 170, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.Remove_scan, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.remove_spectrum_scan_GUI,2, GUI_settings});
UI_obj.main.Modify_scan             = uibutton(UI_obj.main.uifigure, "Text", "Modify scan", "Position", [480, 140, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.Modify_scan, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.modify_scan_GUI, GUI_settings});
UI_obj.main.plot_m2q.uibutton       = uibutton(UI_obj.main.uifigure, "Text", "Plot M/Q", "Position", [480, 110, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.plot_m2q, "ButtonPushedFcn", @GUI.fs_big.scan_viewer.callback.plot_spectra_GUI);

UI_obj.main.plot_scan.uibutton      = uibutton(UI_obj.main.uifigure, "Text", "Plot scan", "Position", [480, 80, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.plot_scan, "ButtonPushedFcn", @GUI.fs_big.scan_viewer.callback.define_channel_callback);

UI_obj.main.Save_workspace.uibutton = uibutton(UI_obj.main.uifigure, "Text", "Save workspace", "Position", [10, 10, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.Save_workspace, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.Save_workspace, GUI_settings});
UI_obj.main.Load_workspace.uibutton = uibutton(UI_obj.main.uifigure, "Text", "Load workspace", "Position", [120, 10, 100, 20], ...
                                            'Tooltip', GUI_settings.load_scan.tooltips.Load_workspace, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.Load_workspace, GUI_settings});

% Turn off Java warnings (we have no alternative before Matlab 2023):
warning('off', 'MATLAB:ui:javacomponent:FunctionToBeRemoved');

end