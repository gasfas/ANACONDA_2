function fetch_Scale_Offset(username, datatype, UI_offset, UI_scale, GUI_settings)
% Function to find the Offset and Yscale for a given username and datatype.
% This function will write the fetched values in the UI fields.

% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Read the internal names of the spectra/scans:
data_name = GUI.fs_big.get_intname_from_username(exp_data.(datatype), username);

fetched_data   = exp_data.(datatype).(data_name);

% Then fill it into the editable fields (if the user still wants to change it):
UI_scale.Value      = fetched_data.Data.hist.spectr_001.Scale;
UI_offset.Value     = fetched_data.Data.hist.spectr_001.dY;

end