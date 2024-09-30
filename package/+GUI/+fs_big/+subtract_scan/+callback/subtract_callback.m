function subtract_callback(hObj, event, GUI_settings)
% This function performs the subtraction as requested by the user, and
% saves the spectrum/scan as a new channel in memory.
% Subtraction depends on a few variables:
% - User wants subtraction of a spectrum:
%       - Subtracted data can only be a spectrum.
% - User wants subtraction of a scan:
%       - Subtracted data can be a spectrum or a scan.
% - Subtraction methods:
%       'Spectrum' subtracts all intensity points (of all spectra in a scan) by the intensity of a spectrum, ' ...
%       'Scan' subtracts all intensity points of all spectra in a scan with the intensity of spectra in another scan. 
% Note that this option only works when the scan energies of the subtracting scan overlap the subtracted scan range.

[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Check if chosen name is valid:
if ~GUI.fs_big.check_validity_name(exp_data, UI_obj.subtract.data_output_name.Value)
    msgbox('Incorrect name of new spectrum/scan, either duplicate or empty. Please check and try again.')
else

%% Input data (minuent)
% Read the state of the UIs to know what and how to subtract

if UI_obj.subtract.radioswitch_scan.Value
    datatype_min_name = 'scans';
    % Construct a photon energy matrix for interpolation later:
    [exp_data] = IO.SPECTROLATIUS_S2S.exp_struct_to_matrix(exp_data);
else
    datatype_min_name = 'spectra';
end
% Read the internal names of the spectra/scans:
data_name = GUI.fs_big.get_intname_from_username(exp_data.(datatype_min_name), UI_obj.subtract.dropdown_dataselection.Value);

d_min   = exp_data.(datatype_min_name).(data_name);

if strcmp(datatype_min_name, 'scans')
    % Fetch the matrix for the selected scan:
    I_min_mat       = d_min.matrix.M2Q.I;
    M2Q_min         = d_min.matrix.M2Q.bins; 
    hv_min          = d_min.Data.photon.energy;
    field_subname = 'scan';
else % This means the subtrahend musgt also be a single array (1d interp)
    M2Q_min     = d_min.Data.hist.spectr_001.M2Q.bins;
    I_min       = d_min.Data.hist.spectr_001.M2Q.I;
    field_subname = 'spectr';
end

% Read the Scale and offset value of the subtrahend:
dY_min      = UI_obj.subtract.minuend.offset_edit.Value;
Scale_min   = UI_obj.subtract.minuend.scale_edit.Value;

%% Subtracting data (subtrahend)
% Read the state of the subtraction UI to find out what to subtract.

if UI_obj.subtract.radioswitch_subtr_scan.Value
    datatype_subtr_name = 'scans';
else
    datatype_subtr_name = 'spectra';
end
% Read the internal names of the spectra/scans:
data_subtr_int_name = GUI.fs_big.get_intname_from_username(exp_data.(datatype_subtr_name), UI_obj.subtract.dropdown_dataselection_subtr.Value);

d_subtr   = exp_data.(datatype_subtr_name).(data_subtr_int_name);
if strcmp(datatype_subtr_name, 'scans')
    % Fetch the matrix for the selected scan:
    I_subtr_mat         = d_subtr.matrix.M2Q.I;
    M2Q_subtr           = d_subtr.matrix.M2Q.bins; 
    hv_subtr            = d_subtr.Data.photon.energy;
else
    M2Q_subtr     = d_subtr.Data.hist.spectr_001.M2Q.bins;
    I_subtr       = d_subtr.Data.hist.spectr_001.M2Q.I;
    if strcmp(datatype_min_name, 'scans') % We construct a matrix in case this has to be subtracted from a scan:
        % repeat the array to construct a matrix:
        I_subtr_mat     = repmat(I_subtr, 1, numel(hv_min));
        hv_subtr        = hv_min;
    end
end

% Read the Scale and offset value of the subtrahend:
dY_subtr      = UI_obj.subtract.subtrahend.offset_edit.Value;
Scale_subtr   = UI_obj.subtract.subtrahend.scale_edit.Value;

% Note that we assume here that the mass spectrum bins do not change over
% the different scan spectra.

%% Subtraction
% In case the mass spectra points of the subtrahend and minuend are not 
% coinciding, interpolation is required. 

% If both the subtrahend and minuend are spectrum, we only perform 1d
% interpolation.

% If the minuend is a scan, and the subtrahend a spectrum, we repeate the
% array at all the photon energies of the minuend scan, and then perform 2d
% interpolation:


% If both are scans, 2d interpolation can directly be performed:

% Copy the struct to a new one, where the subtracted data will be stored:
d_output  = exp_data.(datatype_min_name).(data_name);

if strcmp(datatype_min_name, 'spectra')
    % interpolate the subtrahend intensities to minuend M2Q abscissa:
    I_subtr_corrected   = I_subtr*Scale_subtr + dY_subtr;
    I_min_corrected     = I_min*Scale_min + dY_min;
    I_subtr_int         = interp1(M2Q_subtr, I_subtr_corrected, M2Q_min, 'linear', 'extrap');
    % Subtract the subtrahend from minuend:
    d_output.Data.hist.spectr_001.M2Q.I = I_min_corrected - I_subtr_int;
else % In case the photon energies of the subtrahend and minuend are not 
    % coinciding, interpolation is required. This is a 2-D interpolation for
    % both the photon energy and mass-to-charge. 
    % First perform the correction:
    I_subtr_mat_corrected   = I_subtr_mat * Scale_subtr + dY_subtr;
    I_min_mat_corrected     = I_min_mat * Scale_min + dY_min;
    [M2Q_subtr_MG, hv_subtr_MG] = meshgrid(double(M2Q_subtr), hv_subtr);
    [M2Q_min_MG, hv_min_MG] = meshgrid(double(M2Q_min), hv_min);
    I_subtr_mat_int         = interp2(M2Q_subtr_MG, hv_subtr_MG, I_subtr_mat_corrected', M2Q_min_MG, hv_min_MG, 'makima');
    I_subtracted            = I_min_mat_corrected - I_subtr_mat_int';
    % Place the spectra back into their struct fields:
    d_output                = IO.SPECTROLATIUS_S2S.matrix_to_exp_struct(I_subtracted, d_output);
    d_output.matrix.M2Q.I   = I_subtracted;         
end


%% Warning for out of range m2q:
if ~isequal(M2Q_min, M2Q_subtr)
    % The mass-to-charge bins are not equal, so we check whether the range
    % is sufficient:
    if min(M2Q_min) < min(M2Q_subtr) || max(M2Q_min) > max(M2Q_subtr)
        % The minuend spectrum has a smaller m2q range than the subtrahend,
        % so extrapolation is required. Make sure the user is aware:
        msgbox({['Warning: the range of the to-be-subtracted (minuend) spectrum/spectra is smaller than the range of the subtracting ' ...
            'spectrum (subtrahend). Extrapolation is done by subtracting using the last intensity point in the spectrum.']; ...
            ['Minimum m2q (minuend) : ', num2str(min(M2Q_min)), ' Minimum m2q (subtrahend) : ', num2str(min(M2Q_subtr))]; ...
            ['Maximum m2q (minuend) : ', num2str(max(M2Q_min)), ' Maximum m2q (subtrahend) : ', num2str(max(M2Q_subtr))];})
    end
end


% Make a new intname, make sure it is not in use yet:
new_datatype_name = GUI.fs_big.make_new_intname(exp_data.(datatype_min_name), field_subname);
% Store the new spectrum/channel in the exp_data struct:
exp_data.(datatype_min_name).(new_datatype_name) = d_output;
% And overwrite the name for a new one:
exp_data.(datatype_min_name).(new_datatype_name).Name       = (UI_obj.subtract.data_output_name.Value);

% If a scan, also make up new plot properties for it:
if strcmpi(datatype_min_name, 'scans') && general.struct.issubfield(GUI_settings, 'channels.list')
    Channelgroup_names   = fieldnames(GUI_settings.channels.list);
    for chgroupname_cur_cell = Channelgroup_names'
        chgroupname_cur     = chgroupname_cur_cell{:};
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).Color         = exp_data.(datatype_min_name).(new_datatype_name).Color;
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).LineStyle     = '-.';
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).Marker        = '*';
        GUI_settings.channels.list.(chgroupname_cur).scanlist.(new_datatype_name).Visible       = 1;
    end
end

% update the tables in the main scan viewer:
UI_obj.main.scans.uitable.Data                  = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('scans', UI_obj, exp_data);
UI_obj.main.spectra.uitable.Data                = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('spectra', UI_obj, exp_data);
% Main window up:
figure(UI_obj.main.uifigure)

% close the subtract window:
UI_obj.subtract.main.Visible = 'off';

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

end