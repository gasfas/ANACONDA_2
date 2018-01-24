% Description: Duplicates the selected plot configurations for the selected experiment(s)
%   - inputs:
%           Selected signal name
%           Experiment metadata
%   - outputs:
%           New experiment metadata
% Date of creation: 2017-08-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = duplicate_plotconf()
md_GUI = evalin('base', 'md_GUI');
sel_plot_conf = strsplit(char(md_GUI.UI.UIPlot.def.Popup_plot_type.String(md_GUI.UI.UIPlot.def.Popup_plot_type.Value)), '.');
sel_exps_nums = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
for lx = 1:length(sel_exps_nums)
    exp_names(lx) = cellstr(['exp', num2str(sel_exps_nums(lx))]);
end
if length(sel_plot_conf) == 2
    for ly = 1:length(exp_names)
        current_det_name = char(sel_plot_conf(1));
        hr_detnames = md_GUI.mdata_n.([char(exp_names(ly))]).spec.det_modes;
        for lz = 1:length(hr_detnames)
            if strcmp(char(hr_detnames(lz)), current_det_name)
                detnr = lz;
            end
        end
        sel_plot_conf = char(sel_plot_conf(2));
        if md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_built_in.Value == 1
            md_GUI.mdata_n.([char(exp_names(ly))]).plot.user.(['det', num2str(detnr)]).(sel_plot_conf) = md_GUI.mdata_n.([char(exp_names(ly))]).plot.(['det', num2str(detnr)]).(sel_plot_conf);
        elseif md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_customized.Value == 1
            newname = char(inputdlg(['Give the name for the duplicate of ', sel_plot_conf, ':'], 'New plot configuration name'));
            md_GUI.mdata_n.([char(exp_names(ly))]).plot.user.(['det', num2str(detnr)]).(newname) = md_GUI.mdata_n.([char(exp_names(ly))]).plot.user.(['det', num2str(detnr)]).(sel_plot_conf);
        end
    end
    if md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_customized.Value == 0
        md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_customized.Value = 1;
    end
    GUI.plot.data_selection.Radiobutton_Custom_Plotconf;
    assignin('base', 'md_GUI', md_GUI)
end
end