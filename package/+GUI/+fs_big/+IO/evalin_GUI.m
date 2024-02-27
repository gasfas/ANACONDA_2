function varargout = evalin_GUI(GUI_nr)
% Fetch the GUI variables from workspace.
GUI_settings_name   = ['GUI_settings_' , num2str(GUI_nr, '%03.f')];
exp_data_name       = ['exp_data_' , num2str(GUI_nr, '%03.f')];
UI_obj_name         = ['UI_obj_' , num2str(GUI_nr, '%03.f')];

if nargout >= 1
    varargout{1}            = general.evalin('base', GUI_settings_name);
end
if nargout >= 2
    varargout{2}            = general.evalin('base', UI_obj_name);
end
if nargout == 3
    varargout{3}            = general.evalin('base', exp_data_name);
end
end