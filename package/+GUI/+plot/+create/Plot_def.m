% Description: Set up parameters used for the plotting.
%   - inputs:
%           Selected experiment(s) name(s)     	(selected_exp_names)
%           Selected experiment(s) number(s)    (filenumber_selected)
%           Selected experiment(s) data         (data_n)
%           Selected experiment(s) metadata     (mdata_n)
%           Plot settings                       (plotsettings)
%           Experiment settings                 (expsettings)
%   - outputs:
%           Plot(s)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = Plot_def( ) 
md_GUI = evalin('base', 'md_GUI');
selectedexpnumbers = md_GUI.plot.filenumber_selected;
for lx = 1:length(selectedexpnumbers)
    sel_exp_names(lx) = cellstr(['exp', num2str(selectedexpnumbers(lx))]);
end
det_plottype_val = md_GUI.UI.UIPlot.def.Popup_plot_type.Value;
det_plottype = char(md_GUI.UI.UIPlot.def.Popup_plot_type.String(det_plottype_val));
typesplit = strsplit(det_plottype, '.');
if length(typesplit) == 2
    for lx = 1:length(selectedexpnumbers)
        exp_name = char(sel_exp_names(lx));
        detname = char(typesplit(1));
        plottype = char(typesplit(2));
        try
            % Plot them separately:
            macro.plot.create.plot(md_GUI.data_n.(exp_name), md_GUI.mdata_n.(exp_name).plot.(detname).(plottype))
        catch
            msgbox('Could not plot.', 'error')
        end
    end
end
end

