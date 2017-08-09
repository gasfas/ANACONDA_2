% Description: Resets all predefined values to starting conditions. Use for
% total reset of the session.
%   - inputs: none.
%   - outputs: none.
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function Reset
check_to_reset = questdlg('Are you sure you want to reset the whole work session? All MATLAB windows / figures will be closed and values cleared. The GUI will then be restarted.',...
    'Reset all', 'Yes', 'No', 'No');
switch check_to_reset
    case 'Yes'
        disp('Reset/Start Button pressed');
        close all
        clear all
        GUI.main
    otherwise
        disp('Reset cancelled.')
end
end