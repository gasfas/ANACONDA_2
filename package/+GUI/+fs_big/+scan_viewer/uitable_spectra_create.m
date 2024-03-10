function UI_obj = uitable_spectra_create(GUI_settings, UI_obj)
% Create an emtpy uitable for the spectra.

% Create the table that lists the scans.
UI_obj.main.spectra.Properties.VariableNames = {'Spectrum name', 'Color', 'dY', 'Scale'};
UI_obj.main.spectra.uitable                  = uitable(UI_obj.main.uifigure , "ColumnName", UI_obj.main.spectra.Properties.VariableNames, "Position",[10 250 440 190]);
UI_obj.main.spectra.uitable.CellEditCallback = {@GUI.fs_big.scan_viewer.callback.uitable_scan_spectra_user_edit, GUI_settings, 'spectra'};
UI_obj.main.spectra.uitable.CellSelectionCallback = {@GUI.fs_big.scan_viewer.callback.uitable_scan_user_select, 1, GUI_settings};
UI_obj.main.spectra.uitable.ColumnWidth     = {180, 80, 40, 40};
UI_obj.main.spectra.uitable.ColumnEditable   = [true false];
UI_obj.main.spectra.uitable.ColumnFormat    = {'char', 'char'};

end