function open_Variables ()
% This function opens up the variables reader to view the plotting
% configuration.
md_GUI = evalin('base', 'md_GUI');
% fetch all the current names:
exp_name = ['exp', num2str(md_GUI.plot.filenumber_selected)];
plottype = char(md_GUI.UI.UIPlot.def.Popup_plot_type.String(md_GUI.UI.UIPlot.def.Popup_plot_type.Value));
typesplit = strsplit(plottype, '.');
det_name = ['det' num2str(find(strcmp(char(typesplit(1)), md_GUI.mdata_n.(exp_name).spec.det_modes)))];
plottype = char(typesplit(2));
confname = ['md_GUI.mdata_n.' exp_name '.plot.' det_name '.' plottype];

openvar(confname)
end