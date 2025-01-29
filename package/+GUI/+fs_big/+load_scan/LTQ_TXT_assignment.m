function [UI_obj] = LTQ_TXT_assignment(GUI_settings, filelist, filedir)
% Function that shows a pop-up window for the user to assign photon
% energies to selected textfiles.

% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

%%
UI_obj.load_scan.photon_energy_list_unordered = zeros(length(filelist'),1);
% Initiate a figure:
UI_obj.load_scan.Desirs.LTQ_TXT_assignmentwindow = uifigure('Name', 'Assign photon energies to LTQ textfiles', ...
    'NumberTitle', 'off', 'position', [100 100 400 500]);
uitextarea(UI_obj.load_scan.Desirs.LTQ_TXT_assignmentwindow, "Value", ["Files loaded from: " filedir], ...
     "Position", [20 420 360 60])
filecolumn = filelist';
% Write an interactive table in it with the loaded textfiles and photon energy column:
huitable = uitable(UI_obj.load_scan.Desirs.LTQ_TXT_assignmentwindow, "ColumnName", ...
    {"txt filename", "Photon E [eV]"}, "Position", [20 50 350 350], ...
    "Data", [filecolumn, num2cell(zeros(length(filelist'),1))], ...
    "ColumnEditable",[false true], ...
    "ColumnWidth", {190, 'auto'});
UI_obj.main.Add   = uibutton(UI_obj.load_scan.Desirs.LTQ_TXT_assignmentwindow, "Text", "Inter/Extrapolate", "Position", [10, 20, 120, 20], ...
    'Tooltip', "If you have filled in at least 2 points, this function will automatically fill in the photon energy in the points in between, assuming uniform mono-spaced numbering", ...
    "ButtonPushedFcn", {@autofill_photon_energies, filecolumn, huitable});
% copy to photon energy list upon OK:
uibutton(UI_obj.load_scan.Desirs.LTQ_TXT_assignmentwindow, "Text", "Reset", "Position", [140, 20, 120, 20], ...
    'Tooltip', "Set all photon energies back to zero.", ...
    "ButtonPushedFcn", {@Reset_uitable, huitable})

% copy to photon energy list upon OK:
uibutton(UI_obj.load_scan.Desirs.LTQ_TXT_assignmentwindow, "Text", "OK", "Position", [270, 20, 120, 20], ...
    'Tooltip', "Fill in the photon energies currently written in the table and close current window.", ...
    "ButtonPushedFcn", {@OK_close, UI_obj, GUI_settings, huitable})

photon_energy_list_unsorted = cat(1, huitable.Data{:,2});
end

%% Local functions
function autofill_photon_energies(~, ~, filecolumn, huitable)
% inter/extrapolate the photon energies from what the user has already
% filled in:
hv_in = cat(1, huitable.Data{:,2});
if length(find(hv_in)) > 1 % more than one photon energy filled in:
    hv_in_filled_idx   = find(hv_in);
    hv_in_filled       = hv_in(hv_in_filled_idx);
    hv_autofilled      = interp1(hv_in_filled_idx, hv_in_filled, 1:length(hv_in), "linear", "extrap");
    huitable.Data      = [filecolumn, num2cell(hv_autofilled')];
else
    msgbox('please fill in at least two photon energies')
end
end

function Reset_uitable(~, ~, huitable)
    % Set all photon energies back to zero:
    huitable.Data      = [huitable.Data(:,1), num2cell(zeros(size(huitable.Data,1),1))];
end

function OK_close(~, ~, UI_obj, GUI_settings, huitable)
    photon_energy_list_unordered = cat(1, huitable.Data{:,2});
    close(UI_obj.load_scan.Desirs.LTQ_TXT_assignmentwindow)
    
    % Fetch variables from workspace:
    [GUI_settings, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
    % Fill in photon energy values:
    UI_obj.load_scan.photon_energy_list_unordered = photon_energy_list_unordered;
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
end
