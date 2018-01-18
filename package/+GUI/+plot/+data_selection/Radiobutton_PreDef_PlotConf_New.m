% Description: Show pre-defined plot configurations for selected experiment(s). 
%   - inputs:
%           None.
%   - outputs:
%           New list of plot configurations.
% Date of creation: 2017-12-30.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% The pre-defined plot configurations radiobutton function
% Subtab: New plot conf
function [] = Radiobutton_PreDef_PlotConf_New()
md_GUI = evalin('base', 'md_GUI');
UIPlot = md_GUI.UI.UIPlot;
sel_exp_nums = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
for lx = 1:length(sel_exp_nums)
    exp_names(lx) = cellstr(['exp', char(int2str(sel_exp_nums(lx)))]);
end
signals_list = fieldnames(md_GUI.mdata_n.([char(exp_names(1))]).plot.signal);
set(UIPlot.new.signals_list, 'Enable', 'on');
set(UIPlot.new.signals_list, 'String', signals_list);
set(UIPlot.new.btn_set_x_sign_pointer, 'Enable', 'on');
if UIPlot.new.y_signals_checkbox.Value == 1
    set(UIPlot.new.btn_set_y_sign_pointer, 'Enable', 'on');
else
    set(UIPlot.new.btn_set_y_sign_pointer, 'Enable', 'off');
end
set(UIPlot.new.save_plot_conf, 'Enable', 'on');
set(UIPlot.new.edit_plot_conf, 'Enable', 'on');
set(UIPlot.new.y_signals_checkbox, 'Enable', 'on');
end