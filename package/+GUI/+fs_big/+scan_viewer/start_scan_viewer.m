function [GUI_settings, UI_obj] = start_scan_viewer(GUI_settings)
% Initiate the scan viewer.

% GUI main view to load and visualize a Spektrolatius/Desirs/... scan

UI_obj                                  = struct(); %All Ui objects stored in this struct.

% Set up the display, Initiate the uifigure:
UI_obj.main.uifigure                    = uifigure('Name', 'Scan viewer','NumberTitle','off','position',[100 100 590 470]); %, ...
    % 'CloseRequestFcn', {@GUI.fs_big.scan_viewer.callback.close_all_GUI_windows, GUI_settings});

% Create the uitable containing the list of scans:
UI_obj                                  = GUI.fs_big.scan_viewer.uitable_scan_create(GUI_settings, UI_obj);
UI_obj                                  = GUI.fs_big.scan_viewer.uitable_spectra_create(GUI_settings, UI_obj);

button_xpos                             = 470;
button_width_x                          = 110;
button_height_y                         = 20;
% Initialize the interaction buttons for the spectra:

% Initialize the interaction buttons (load, delete, view spectra) for the
% scan:
UI_obj.main.Add                         = uibutton(UI_obj.main.uifigure, "Text", "Add scan/spectrum", "Position", [button_xpos, 430, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.Add, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.load_scan_GUI, GUI_settings});
UI_obj.main.correct.uibutton            = uibutton(UI_obj.main.uifigure, "Text", "Correct", "Position", [button_xpos, 400, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.correct_data, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.correct_data_GUI, GUI_settings});
UI_obj.main.normalize.uibutton          = uibutton(UI_obj.main.uifigure, "Text", "Normalize", "Position", [button_xpos, 370, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.calibrate, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.normalize_callback, GUI_settings});
UI_obj.main.subtract.uibutton           = uibutton(UI_obj.main.uifigure, "Text", "Subtract", "Position", [button_xpos, 340, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.subtract, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.subtract_callback, GUI_settings});
UI_obj.main.define_fragments.uibutton   = uibutton(UI_obj.main.uifigure, "Text", "Define channels", "Position", [button_xpos, 310, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.define_channels, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.define_channels_GUI, GUI_settings});

UI_obj.main.plot_m2q.uibutton           = uibutton(UI_obj.main.uifigure, "Text", "Plot M/Q", "Position", [button_xpos, 250, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.plot_m2q, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.plot_spectra_GUI, GUI_settings});
UI_obj.main.plot_scan.uibutton          = uibutton(UI_obj.main.uifigure, "Text", "Plot scan", "Position", [button_xpos, 220, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.plot_scan, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.plot_scan_callback, GUI_settings});
UI_obj.main.merge_scans.uibutton        = uibutton(UI_obj.main.uifigure, "Text", "Merge scans", "Position", [button_xpos, 190, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.plot_scan, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.merge_scans_callback, GUI_settings});

UI_obj.main.Remove_spectrum             = uibutton(UI_obj.main.uifigure, "Text", "Remove spectrum", "Position", [button_xpos, 100, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.Remove_spectrum, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.remove_spectrum_scan_GUI,1, GUI_settings});
UI_obj.main.Remove_scan                 = uibutton(UI_obj.main.uifigure, "Text", "Remove scan", "Position", [button_xpos, 70, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.Remove_scan, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.remove_spectrum_scan_GUI,2, GUI_settings});
UI_obj.main.Modify_scan             = uibutton(UI_obj.main.uifigure, "Text", "Modify scan", "Position", [button_xpos, 40, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.Modify_scan, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.modify_scan_GUI, GUI_settings});

UI_obj.main.Save_workspace.uibutton = uibutton(UI_obj.main.uifigure, "Text", "Save workspace", "Position", [10, 10, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.Save_workspace, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.Save_workspace, GUI_settings});
UI_obj.main.Load_workspace.uibutton = uibutton(UI_obj.main.uifigure, "Text", "Load workspace", "Position", [130, 10, button_width_x, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.Load_workspace, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.Load_workspace, GUI_settings});
UI_obj.main.Load_workspace.uibutton = uibutton(UI_obj.main.uifigure, "Text", "↻", "Position", [250, 10, 20, button_height_y], ...
                                            'Tooltip', GUI_settings.scan_view.tooltips.Refresh_table, "ButtonPushedFcn", {@GUI.fs_big.scan_viewer.callback.update_table, GUI_settings});

% Turn off Java warnings (we have no alternative before Matlab 2023):
warning('off', 'MATLAB:ui:javacomponent:FunctionToBeRemoved');

end