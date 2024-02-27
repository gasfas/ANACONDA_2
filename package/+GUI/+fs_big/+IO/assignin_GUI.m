function assignin_GUI(GUI_settings, UI_obj, exp_data)
% Assign variables to the base workspace, so that they are available to the user
% at any time during GUI usage.
% Inputs: 
% GUI_settings
% exp_data
% UI_obj

GUI_nr = GUI_settings.GUI_nr;

if nargin >= 1
    local1('GUI_settings', GUI_settings, GUI_nr);
end
if nargin >= 2
    local1('UI_obj', UI_obj, GUI_nr);
end
if nargin == 3
    local1('exp_data', exp_data, GUI_nr);
end

function local1(varname, var, GUI_nr)
    varnumberedname = [varname, '_' , num2str(GUI_nr, '%03.f')];
    assignin('base', varnumberedname, var)
end 

end