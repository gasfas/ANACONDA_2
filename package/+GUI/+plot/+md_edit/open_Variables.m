function open_Variables ()
% This function opens up the variables reader to view the plotting
% configuration.
md_GUI = evalin('base', 'md_GUI');
plottype = char(md_GUI.UI.UIPlot.def.Popup_plot_type.String(md_GUI.UI.UIPlot.def.Popup_plot_type.Value));
typesplit = strsplit(plottype, '.');
try
    plottype = char(typesplit(2));
    % fetch all the current names:
    for ll = 1:length(md_GUI.UI.UIPlot.LoadedFilesPlotting.Value)
        exp_name(ll) = cellstr(['exp', num2str(md_GUI.UI.UIPlot.LoadedFilesPlotting.Value(ll))]);
        det_name(ll) = cellstr(['det' num2str(find(strcmp(char(typesplit(1)), md_GUI.mdata_n.(char(exp_name(ll))).spec.det_modes)))]);
        if md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_customized.Value == 1
            confname(ll) = cellstr(['md_GUI.mdata_n.' char(exp_name(ll)) '.plot.user.' char(det_name(ll)) '.' plottype]);
        elseif md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_built_in.Value == 1
            confname(ll) = cellstr(['md_GUI.mdata_n.' char(exp_name(ll)) '.plot.' char(det_name(ll)) '.' plottype]);
        end
        openvar(char(confname(ll)))
    end
catch
    GUI.log.add('Could not edit configuration since no configuration found to be selected.')
end
end