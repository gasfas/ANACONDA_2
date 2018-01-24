% Description: Show pre-defined signals for selected experiment(s). 
%   - inputs:
%           None.
%   - outputs:
%           New list of signals
% Date of creation: 2017-12-30.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% The pre-defined signals radiobutton function
function [] = Radiobutton_PreDef_Signal()
md_GUI = evalin('base', 'md_GUI');
UIPlot = md_GUI.UI.UIPlot;
sel_exp_nums = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
for lx = 1:length(sel_exp_nums)
    exp_names(lx) = cellstr(['exp', char(int2str(sel_exp_nums(lx)))]);
end
signals_list = fieldnames(md_GUI.mdata_n.([char(exp_names(1))]).plot.signal);
set(UIPlot.new_signal.new_signal, 'Enable', 'off');
set(UIPlot.new_signal.edit_signal, 'Enable', 'off');
set(UIPlot.new_signal.remove_signal, 'Enable', 'off');
set(UIPlot.new_signal.duplicate_signal, 'Enable', 'on');
set(UIPlot.new_signal.signals_list, 'Enable', 'on');
set(UIPlot.new_signal.signals_list, 'String', signals_list)
end