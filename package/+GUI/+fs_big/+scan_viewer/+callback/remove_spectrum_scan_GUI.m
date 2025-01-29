function remove_spectrum_scan_GUI(~, ~,selection, GUI_settings)

%Fetch the variables from workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

        % This function removes either a spectrum (selection = 1) or a scan
        % (selection = 2).
    switch selection 
        case 1 % Spectra/um to be removed:
        d_name = 'spectra';
        case 2
        d_name = 'scans';
    end
    % Read which scan was selected:
    if isempty(fieldnames(exp_data.(d_name)))
        UI_obj.main.remove_scan.empty_data_msgbox = msgbox('Cannot remove data, since there are no data files loaded yet. Nice try.');
    elseif isempty(UI_obj.main.(d_name).uitable.Selection)
        UI_obj.main.remove_scan.no_data_selected_msgbox = msgbox('No data selected. Please select the sample you want to remove and try again.');
    else
        rownrs              = unique(UI_obj.main.(d_name).uitable.Selection(:,1));
        for sample_nr       = 1:length(rownrs)
            % Check which run is selected.
            sel_username        = UI_obj.main.(d_name).uitable.Data{rownrs(sample_nr),1};
            % Identify which internal name this scan has gotten:
            intname             = GUI.fs_big.get_intname_from_username(exp_data.(d_name), sel_username);
            % Remove from exp data:
            exp_data.(d_name)        = rmfield(exp_data.(d_name), intname);
            % If fragments are defined, also remove the scans from the
            % fragment lists:
            if strcmp(d_name, 'scans') && general.struct.issubfield(GUI_settings, 'channels.list')
                % remove the scan from all channels:
                fragment_channels = fieldnames(GUI_settings.channels.list);
                for fragment_channel_cur = fragment_channels'
                    try 
                        GUI_settings.channels.list.(fragment_channel_cur{:}).scanlist = ...
                            rmfield(GUI_settings.channels.list.(fragment_channel_cur{:}).scanlist, intname); 
                    catch
                        warning("Could not delecte all requested scans")
                    end
                end
            end
        end
        % Update the tables:
        GUI.fs_big.scan_viewer.uitable_scan_modify(UI_obj, exp_data);
        GUI.fs_big.scan_viewer.uitable_spectra_modify(UI_obj, exp_data);
    end
% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end