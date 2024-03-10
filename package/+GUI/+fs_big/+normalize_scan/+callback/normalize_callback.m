function normalize_callback(hObj, event, GUI_settings)
% This function performs the normalization as requested by the user, and
% saves the spectrum/scan as a new channel in memory.
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Check if a valid name has been chosen:
% Check if chosen name is valid:
if ~GUI.fs_big.check_validity_name(exp_data, UI_obj.normalize.data_output_name.Value)
    msgbox('Incorrect name of new spectrum/scan, either duplicate or empty. Please check and try again.')
else

% Read the state of the UIs to know what and how to subtract

if UI_obj.normalize.radioswitch_scan.Value
    datatype_name = 'scans';
    field_subname = 'scan';
else
    datatype_name = 'spectra';
    field_subname = 'spectr';
end
data_name = GUI.fs_big.get_intname_from_username(exp_data.(datatype_name), UI_obj.normalize.dropdown_dataselection.Value);

d_raw   = exp_data.(datatype_name).(data_name);
% Copy the struct to a new one, where the normalized data will be stored:
d_norm  = d_raw;

spectrum_names = fieldnames(d_raw.Data.hist);
i = 0;

% Normalize the spectra one at a time:
for sp_name_cur = spectrum_names'
    i = i + 1;
    M2Q_I_unnorm         = d_raw.Data.hist.(sp_name_cur{:}).M2Q.I;
    M2Q_bins_unnorm      = d_raw.Data.hist.(sp_name_cur{:}).M2Q.bins;
    % Check the normalization method:
    if UI_obj.normalize.radioswitch_norm_maximum.Value
        % Find the maximum:
        norm_denominator = max(M2Q_I_unnorm);
    elseif UI_obj.normalize.radioswitch_norm_channel.Value
        % Find the user-specified channel details and integrate over the mass limits:
        Channel_username     = UI_obj.normalize.Channel_choose_dropdown.Value;
        Channel_intname      = GUI.fs_big.get_intname_from_username(GUI_settings.channels.list, Channel_username);
        % Find where the m/q minima and maxima can be found index-wise:
        [~, min_idx]       = min(abs(M2Q_bins_unnorm - GUI_settings.channels.list.(Channel_intname).minMtoQ));
        [~, max_idx]       = min(abs(M2Q_bins_unnorm - GUI_settings.channels.list.(Channel_intname).maxMtoQ));
        % Calculate the integrated channel:
        norm_denominator      = trapz(M2Q_bins_unnorm(min_idx:max_idx),M2Q_I_unnorm(min_idx:max_idx));
    elseif UI_obj.normalize.radioswitch_norm_total.Value
        % Integrate over the entire spectrum:
        norm_denominator      = trapz(M2Q_bins_unnorm, M2Q_I_unnorm);
    elseif UI_obj.normalize.radioswitch_norm_photon_flux.Value
        % Fetch the photon flux for this spectrum:
        norm_denominator = d_raw.Data.photon.flux(i);
    end
    % and divide the intensity by the denominator:
    d_norm.Data.hist.(sp_name_cur{:}).M2Q.I = d_raw.Data.hist.(sp_name_cur{:}).M2Q.I./norm_denominator;
    % Make a new intname, make sure it is not in use yet:
    new_datatype_name = GUI.fs_big.make_new_intname(exp_data.(datatype_name), field_subname);
end

% Store the new spectrum/channel in the exp_data struct:
exp_data.(datatype_name).(new_datatype_name) = d_norm;
% And overwrite the name for a new one:
exp_data.(datatype_name).(new_datatype_name).Name       = (UI_obj.normalize.data_output_name.Value);

% If a scan, also make up new plot properties for it:
if strcmpi(datatype_name, 'scans') && general.struct.issubfield(GUI_settings, 'channels.list')
    Channelgroup_names   = fieldnames(GUI_settings.channels.list);
    for chgroupname_cur_cell = Channelgroup_names'
        chgroupname_cur     = chgroupname_cur_cell{:};
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).Color         = exp_data.(datatype_name).(new_datatype_name).Color;
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).LineStyle     = '-.';
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).Marker        = '*';
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).Visible       = 1;
    end
end

% update the tables in the main scan viewer:
UI_obj.main.scans.uitable.Data                  = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('scans', UI_obj, exp_data);
UI_obj.main.spectra.uitable.Data                = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('spectra', UI_obj, exp_data);

% close the normalize window:
UI_obj.normalize.main.Visible = 'off';

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end
end