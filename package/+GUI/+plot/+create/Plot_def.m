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
        % Find which detector is used:
		detname = ['det' num2str(find(strcmp(char(typesplit(1)), md_GUI.mdata_n.(exp_name).spec.det_modes)))];
        plottype = char(typesplit(2));
        % See if a condition is defined:
		if ~strcmpi(md_GUI.plot.filterpath.All, 'No_Filter')
			cond_name	= md_GUI.plot.filterpath.All;
			cond_md		= md_GUI.mdata_n.(exp_name).cond.(cond_name);
			md_GUI.mdata_n.(exp_name).plot.(detname).(plottype) = add_condition(md_GUI.mdata_n.(exp_name).plot.(detname).(plottype), cond_md, cond_name);
		end
		
		try
			% Plot them separately:
            macro.plot.create.plot(md_GUI.data_n.(exp_name), md_GUI.mdata_n.(exp_name).plot.(detname).(plottype));
        catch
            msgbox('GUI.plot.create.Plot_def: Could not plot.', 'error')
			macro.plot.create.plot(md_GUI.data_n.(exp_name), md_GUI.mdata_n.(exp_name).plot.(detname).(plottype));
        end
    end
end
end

function plot_md = add_condition(plot_md, cond_md, name)
% This function adds a condition to plot metadata, whether there has been a
% condition defined previously or not.
if general.struct.issubfield(plot_md, ['cond.' name])
	% Add this condition to the existing field, with an adapted name:
	plot_md.cond.([name '_2']) = cond_md;
else
	% Add this condition to the existing field, with the original name:
	plot_md.cond.(name) = cond_md;
end
end
