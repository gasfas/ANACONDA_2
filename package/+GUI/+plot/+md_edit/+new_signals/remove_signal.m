% Description: Removes the selected user defined/customized signal for the selected experiment(s)
%   - inputs:
%           Selected signal name
%           Experiment metadata
%   - outputs:
%           New experiment metadata
% Date of creation: 2017-08-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [] = remove_signal()
md_GUI = evalin('base', 'md_GUI');
signal_sel_name = char(md_GUI.UI.UIPlot.new_signal.signals_list.String(md_GUI.UI.UIPlot.new_signal.signals_list.Value));
sel_exp_nums = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
for lx = 1:length(sel_exp_nums)
    exp_names(lx) = cellstr(['exp', int2str(sel_exp_nums(lx))]);
    try md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user.(signal_sel_name);
        fields_exist = fieldnames(md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user);
        if length(fields_exist) == 1 %remove .user
            md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal = rmfield(md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal, 'user');
        else %remove signal_sel_name from .user
            md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user = rmfield(md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user, signal_sel_name);
        end
    catch
        GUI.log.add(['Did not find the signal ', signal_sel_name, 'for exp', int2str(sel_exp_nums(lx)), '.']);
    end
end
assignin('base', 'md_GUI', md_GUI)
GUI.plot.data_selection.Radiobutton_Custom_Signal;
end