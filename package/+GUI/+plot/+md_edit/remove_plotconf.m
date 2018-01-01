function [ ] = remove_plotconf()
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
        if ly > 1
            % check if the 'user' field exists for given exp
            childrencheck1 = fieldnames(md_GUI.mdata_n.([char(exp_names(ly))]).plot);
            childrencheckval1 = 0;
            childrencheckval2 = 0;
            for llz = 1:length(childrencheck1)
                if strcmp(char(childrencheck1(llz)), 'user')
                    childrencheckval1 = 1;
                end
            end
            % check if the sel_plot_conf field exists for given exp
            if childrencheckval1 == 1
                childrencheck2 = fieldnames(md_GUI.mdata_n.([char(exp_names(ly))]).plot.user.(['det', num2str(detnr)]));
                for lly = 1:length(childrencheck2)
                    if strcmp(char(childrencheck2(ll)), 'user')
                        childrencheckval2 = 1;
                    end
                end
            end
        else
            childrencheckval2 = 1;
            childrencheck2 = fieldnames(md_GUI.mdata_n.([char(exp_names(ly))]).plot.user.(['det', num2str(detnr)]));
        end
        if childrencheckval2 == 1
            if length(childrencheck2) == 1
                % remove the 'user' field from plot confs completely since
                % otherwise, it is an empty struct that might interfere
                % when constructing new plot confs.
                % rmfield ?
                md_GUI.mdata_n.([char(exp_names(ly))]).plot = rmfield(md_GUI.mdata_n.([char(exp_names(ly))]).plot, 'user');
            else
                md_GUI.mdata_n.([char(exp_names(ly))]).plot.user.(['det', num2str(detnr)]) = rmfield(md_GUI.mdata_n.([char(exp_names(ly))]).plot.user.(['det', num2str(detnr)]), sel_plot_conf);
            end
        end
        
    end
    if md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_customized.Value == 1
        GUI.plot.data_selection.Radiobutton_Custom;
    end
    assignin('base', 'md_GUI', md_GUI)
end
end