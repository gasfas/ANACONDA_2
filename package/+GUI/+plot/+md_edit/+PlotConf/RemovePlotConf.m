% Description: Set up parameters used for the plotting.
%   - inputs:
%           Selected exp. number                (experiment_selected_number)
%           Selected experiment(s) metadata     (mdata_n)
%           Experiment settings                 (expsettings)
%           Plot settings                       (plotsettings)

%           Old field values in struct <-- Fix it.

%   - outputs: (into PlotConfSetButton)
%           Field selected              (fieldselected)
%           Field selected value      	(fieldselectedvalue)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [  ] = RemovePlotConf()
md_GUI = evalin('base', 'md_GUI');
PlotConfs = md_GUI.UI.UIPlot.def.Popup_plot_type.String;
[selected_confs, yesorno] = listdlg('PromptString','Select a plot configuration to remove',...
                'SelectionMode','multiple','ListString',PlotConfs);
if yesorno == 1
    expnum = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
    for ly = 1:length(expnum)
        expname(ly) = cellstr(['exp', num2str(expnum(ly))]);
        detmodes = md_GUI.mdata_n.(char(expname(ly))).spec.det_modes;
        for lx = 1:length(selected_confs)
            selectedconf = strsplit(char(PlotConfs(selected_confs(lx))), '.');
            selectedconfplot = char(selectedconf(2));
            selectedconfdetname = char(selectedconf(1));
            for lz = 1:length(detmodes)
                if strcmp(selectedconfdetname, char(detmodes(lz)))
                    detnum = lz;
                end
            end
            detname = fieldnames(md_GUI.mdata_n.(char(expname(ly))).plot);
            detname = char(detname(detnum));
            try
                md_GUI.mdata_n.(char(expname(ly))).plot.(detname) = rmfield(md_GUI.mdata_n.(char(expname(ly))).plot.(detname), selectedconfplot);
            end
        end
    end
    for lx = 1:length(expname)
        detector_choices = fieldnames(md_GUI.mdata_n.(char(expname(lx))).det);
        if ischar(detector_choices)
            numberofdetectors = 1;
            detector_choices = cellstr(detector_choices);
        else
            numberofdetectors = length(detector_choices);
        end
        for ly = 1:numberofdetectors
            current_det_name = char(detector_choices(ly));
            detnr			 = IO.detname_2_detnr(current_det_name);
            % Find a human-readable detector name:
            hr_detname		= md_GUI.mdata_n.(char(expname(lx))).spec.det_modes{detnr};
            currentplottypes = fieldnames(md_GUI.mdata_n.(char(expname(lx))).plot.(current_det_name));
            % remove possible 'ifdo' fields:
            currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
            if ly == 1
                popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
            else
                popup_list_names_det_2 = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
                popup_list_names_det(length(popup_list_names_det)+1:length(popup_list_names_det)+length(popup_list_names_det_2),1) = popup_list_names_det_2;
            end
        end
    end
    md_GUI.UI.UIPlot.def.Popup_plot_type.String = popup_list_names_det;
end
assignin('base', 'md_GUI', md_GUI)
end