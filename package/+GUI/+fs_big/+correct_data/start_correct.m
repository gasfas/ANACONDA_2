function start_correct(GUI_settings, Data_type)
% Fetch variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Define the tooltips:
GUI_settings.correct.tooltips.main          = 'Correcting the spectrum/a or scan(s) currently selected by shifting/scaling the mass-to-charge range or photon energy. Multiple corrections can be performed simultaneously, only in the following order: M2Q correction, then Intensity shift, (then photon energy shift for scans).';
GUI_settings.correct.tooltips.m2q_tab.main  = 'The mass spectrum needs calibration. Optionally choose a reference spectrum to compare to';
GUI_settings.correct.tooltips.I_tab.main    = 'The Intensity needs to be calibrated, either by adding/subtracting a constant or linear slope.';
GUI_settings.correct.tooltips.Correct_and_close = 'Execute the correction and close this window.';
GUI_settings.correct.tooltips.ref_spec_label    = 'Select which reference spectrum to view in the plot. This spectrum does not change with corrections, so makes it easier to see changes.';
GUI_settings.correct.tooltips.constant_shift_value_m2q = 'This single-valued shift (in Da/elementary charge units) is applied across the entire range of the spectrum';
GUI_settings.correct.tooltips.constant_shift_value_I = 'This single-valued intensity shift (in arbitrary units) is applied across the entire range of the spectrum';
GUI_settings.correct.tooltips.linear_correction = 'Linear correction, useful for mass spectra recorded with TOF-type spectrometers.';


% Initiate the window:
UI_obj.correct.main             = uifigure('Name', ['Correct ' Data_type],'NumberTitle','off', ...
                                    'Position',[100 100 350 300]);

% The window has 'tabs' with different correction options. photon energy
% shift only relevant for spectra:
UI_obj.correct.uitabgroup.main         = uitabgroup(UI_obj.correct.main, "Position", [5, 75, 340, 220]);

% Initiate the tabgroup for M2Q correction:
UI_obj.correct.uitabgroup.M2Q_shift.tab      = uitab(UI_obj.correct.uitabgroup.main, "Title",   "M/Q", 'Tooltip', GUI_settings.correct.tooltips.m2q_tab.main);

% Initiate the tabgroup for Intensity correction:
UI_obj.correct.uitabgroup.Intensity.tab      = uitab(UI_obj.correct.uitabgroup.main, "Title",   "Intensity", 'Tooltip', GUI_settings.correct.tooltips.I_tab.main);

if strcmp(Data_type, 'spectra')
    % If the user wants to correct spectrum/spectra:
    % Read which ones are selected:
    spectrum_names      = fieldnames(exp_data.spectra);
    spectra_selected    = spectrum_names(UI_obj.main.spectra.uitable.Selection(:,1));
    UI_obj.plot.m2q.uitabgroup.photon_energy.tab      = uitab(UI_obj.correct.uitabgroup.main, "Title",   "Photon energy");
end

UI_obj.plot.m2q.clear_graph_pushbtn = uibutton(UI_obj.correct.main, 'Text', 'OK', 'Position', [10, 10, 80, 25], ...
                        'ButtonPushedFcn', @close_both_M2Q_windows, 'Tooltip', GUI_settings.correct.tooltips.Correct_and_close);


% Add the possibility for the viewing of a reference spectrum in the plot:
UI_obj.correct.uitabgroup.M2Q_shift.ref_spec_label  = uilabel(UI_obj.correct.main, "Text", ...
    "Reference spectrum view", "Position", [120, 40, 150, 20], "Tooltip", GUI_settings.correct.tooltips.ref_spec_label);
% Dropdown items as reference spectra (for now only spectra, no scans):
ref_spectra_names = [{'none'}; GUI.fs_big.get_user_names(exp_data.spectra)];
UI_obj.correct.uitabgroup.M2Q_shift.ref_spec_list   = uidropdown(UI_obj.correct.main, 'Items', ref_spectra_names, ...
        'Position', [120, 10, 150, 25], 'ValueChangedFcn', {@GUI.fs_big.correct_data.callback.plot_ref_spectra, GUI_settings});

%% Mass-to-charge correction

% TODO: if a spectrum is to be corrected, load the original spectrum by default. 
% constant shift:
UI_obj.correct.uitabgroup.M2Q_shift.constant_shift_label  = uilabel(UI_obj.correct.uitabgroup.M2Q_shift.tab, "Text", 'Constant shift [Da]:', ...
    'Tooltip', GUI_settings.correct.tooltips.constant_shift_value_m2q, 'Position', [10, 170, 150, 25]);
UI_obj.correct.uitabgroup.M2Q_shift.constant_shift_value = uieditfield(UI_obj.correct.uitabgroup.M2Q_shift.tab, "numeric", ...
    'Value', 0, 'Tooltip', GUI_settings.correct.tooltips.constant_shift_value_m2q, ...
    'Position', [10, 140, 150, 25]);
% , T0 and M/q factor:
% First, we generate the panel in which we write these parameters:
UI_obj.correct.uitabgroup.M2Q_shift.linear_shift_panel =  uipanel(UI_obj.correct.uitabgroup.M2Q_shift.tab, ...
    "Position", [180, 80, 150, 100], "Title", "Linear (TOF) correction", "Tooltip", GUI_settings.correct.tooltips.linear_correction);

%% Intensity correction
% Add the possibility for the viewing of a reference spectrum in the plot:
UI_obj.correct.uitabgroup.Intensity.Constant_shift_label  = uilabel(UI_obj.correct.uitabgroup.Intensity.tab, "Text", ...
    "Constant shift [arb.u.]", "Position", [10, 170, 150, 25], "Tooltip", GUI_settings.correct.tooltips.ref_spec_label, ...
    'Tooltip', GUI_settings.correct.tooltips.constant_shift_value_I);
UI_obj.correct.uitabgroup.Intensity.constant_shift_value = uieditfield(UI_obj.correct.uitabgroup.Intensity.tab, "numeric", ...
    'Value', 0, 'Tooltip', GUI_settings.correct.tooltips.constant_shift_value_m2q, ...
    'Position', [10, 140, 150, 25]);


end