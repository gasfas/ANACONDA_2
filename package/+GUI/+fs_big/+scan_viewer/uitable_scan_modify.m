function uitable_scan_modify(UI_obj, exp_data)
        % Modify the table that lists the scans.
        scan_names                              = fieldnames(exp_data.scans);
        % Fill the metadata into the table:
        UI_obj.main.scans.uitable.Data = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('scans', UI_obj, exp_data);
    end