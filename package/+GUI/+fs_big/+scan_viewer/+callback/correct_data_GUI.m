function correct_data_GUI(~, ~, GUI_settings)
% Initiate the GUI to let the user correct the spectrum or scan (depending
% on what is selected)

% Fetch variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Check what is currently selected:
if isempty(fieldnames(exp_data.scans)) && isempty(fieldnames(exp_data.spectra))
    UI_obj.main.plot_m2q.correct_data_msgbox = msgbox('Cannot normalize data, since no data is loaded yet. Nice try.');
    Data_type = 'none';
elseif isempty(UI_obj.main.spectra.uitable.Selection) && isempty(UI_obj.main.scans.uitable.Selection)
    UI_obj.main.plot_m2q.correct_data_msgbox = msgbox('Please select the spectra or data that you wish to correct');
    Data_type = 'none';
elseif ~isempty(UI_obj.main.spectra.uitable.Selection) && ~isempty(UI_obj.main.scans.uitable.Selection)
    UI_obj.main.plot_m2q.correct_data_msgbox = questdlg('Select Data you wish to correct', ...
        'Correction is only performed on the selected spectra or scan(s). Both one or more spectra and scans are selected. Please indicate which you want to correct', ...
        'Spectra', 'Scan(s)', 'Cancel', 'Spectra');
    switch UI_obj.main.plot_m2q.correct_data_msgbox
        case 'Spectra'
            Data_type = 'spectra';
        case 'Scan(s)'
            Data_type = 'scans';
        otherwise
            Data_type = 'none';
    end
elseif ~isempty(UI_obj.main.spectra.uitable.Selection)
    Data_type = 'spectra';
elseif ~isempty(UI_obj.main.scans.uitable.Selection)
    Data_type = 'scans';
else
    Data_type = 'none';
end
% Now we can assume either the spectra or scans are selected:
if strcmp(Data_type, 'spectra') || strcmp(Data_type, 'scans')
    GUI.fs_big.correct_data.start_correct(GUI_settings, Data_type)
end

end