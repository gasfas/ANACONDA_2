function uitable_spectra_modify(UI_obj, exp_data)
    % Modify the table that lists the spectra.
    % FIll the metadata into the table:
    [UI_obj.main.spectra.uitable.Data, UI_obj]             = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('spectra', UI_obj, exp_data);
end