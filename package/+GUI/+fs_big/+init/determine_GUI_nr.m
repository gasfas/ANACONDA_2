function [GUI_settings] = determine_GUI_nr()
% Find how many GUIs have been opened in the past, and determine the GUI
% number under which the variables should be stored here.
% Outputs: 
% GUI_settings: (struct) settings with the GUI number as field.

% give the variables distinguishable names if multiple GUIs are opened:
nof_GUIs_open   = general.evalin('base', 'nof_GUIs_open');
if isempty(nof_GUIs_open) % This means no GUI has been opened yet:
    nof_GUIs_open = 1;
else % There is already another GUI open:
    nof_GUIs_open = nof_GUIs_open + 1;
end
assignin('base', 'nof_GUIs_open', nof_GUIs_open);

GUI_nr = nof_GUIs_open;

GUI_settings.GUI_nr     = GUI_nr;
end