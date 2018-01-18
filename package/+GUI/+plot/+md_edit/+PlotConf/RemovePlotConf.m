% Description: Set up parameters used for the plotting.
%   - inputs:
%           Selected exp. number                (experiment_selected_number)
%           Selected experiment(s) metadata     (mdata_n)
%           Experiment settings                 (expsettings)
%           Plot settings                       (plotsettings)
%   - outputs:
%           Field selected              (fieldselected)
%           Field selected value      	(fieldselectedvalue)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [  ] = RemovePlotConf()
md_GUI = evalin('base', 'md_GUI');
filenumber = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
exp_names = cellstr('');
for lx = 1:length(filenumber)
    exp_names(lx) = cellstr(['exp', int2str(filenumber(lx))]);
end        
plottypes_def = {}; 
popup_list_names = {};
for lx = 1:length(exp_names)
    current_exp_name = char(exp_names(lx));
    % Get number of detectors.
    detector_choices = fieldnames(md_GUI.mdata_n.(current_exp_name).det);
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
        hr_detname		= md_GUI.mdata_n.(current_exp_name).spec.det_modes{detnr};
        currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.user.(current_det_name));
        % remove possible 'ifdo' fields:
        currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
        numberofplottypes = length(currentplottypes);

        % write dots between detectornames and fieldnames:
        popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
        plottypes_def(1,end+1:end+numberofplottypes) = currentplottypes;
        popup_list_names(1,end+1:end+numberofplottypes) = popup_list_names_det;
    end
    if length(exp_names) > 1
        list_struct.([char(exp_names(lx))]) = popup_list_names_det;
    end
end
if length(exp_names) > 1 % check so that all exps have plot confs:
    value = 0;
    for llz = 1:length(exp_names)
        if length(list_struct.([char(exp_names(llz))])) > 0
            value = value + 1;
        end
    end
    list_names_window = cellstr('');
    if value > length(exp_names)-1 % Do the fields comparison.
        list_names_window = GUI.general_functions.CommonFields(list_struct);
    else % At least one exp has zero fields - do nothing.
        GUI.log.add(['At least one experiment has no pre-defined plots for selected plot setting.'])
    end
else
    list_names_window = popup_list_names_det;
end

PlotConfs = popup_list_names_det;
[selected_confs, yesorno] = listdlg('PromptString','Select a plot configuration to remove',...
                'SelectionMode','multiple','ListString',list_names_window);
if yesorno == 1
    for ly = 1:length(exp_names)
        detmodes = md_GUI.mdata_n.(char(exp_names(ly))).spec.det_modes;
        for lx = 1:length(selected_confs)
            selectedconf = strsplit(char(PlotConfs(selected_confs(lx))), '.');
            selectedconfplot = char(selectedconf(2));
            selectedconfdetname = char(selectedconf(1));
            for lz = 1:length(detmodes)
                if strcmp(selectedconfdetname, char(detmodes(lz)))
                    detnum = lz;
                end
            end
            detname = fieldnames(md_GUI.mdata_n.(char(exp_names(ly))).plot);
            detname = char(detname(detnum));
            try
                md_GUI.mdata_n.(char(exp_names(ly))).plot.user.(detname) = rmfield(md_GUI.mdata_n.(char(exp_names(ly))).plot.user.(detname), selectedconfplot);
                GUI.log.add(['User plot configuration ', selectedconfplot, ' removed from ', char(exp_names(ly)), '.']);
            catch
                GUI.log.add(['User plot configuration ', selectedconfplot, ' was not removed from ', char(exp_names(ly)), '.']);
            end
            
            
            
        end
    end
    for lx = 1:length(exp_names)
        detector_choices = fieldnames(md_GUI.mdata_n.(char(exp_names(lx))).det);
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
            hr_detname		= md_GUI.mdata_n.(char(exp_names(lx))).spec.det_modes{detnr};
            currentplottypes = fieldnames(md_GUI.mdata_n.(char(exp_names(lx))).plot.user.(current_det_name));
            % remove possible 'ifdo' fields:
            currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
            if ly == 1
                popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
            else
                popup_list_names_det_2 = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
                popup_list_names_det(length(popup_list_names_det)+1:length(popup_list_names_det)+length(popup_list_names_det_2),1) = popup_list_names_det_2;
            end
        end
        if length(exp_names) > 1
            list_struct.([char(exp_names(lx))]) = popup_list_names_det;
        end
    end
    if length(exp_names) > 1 % check so that all exps have plot confs:
        value = 0;
        for llz = 1:length(exp_names)
            if length(list_struct.([char(exp_names(llz))])) > 0
                value = value + 1;
            end
        end
        popup_list_names = cellstr('');
        if value > length(exp_names)-1 % Do the fields comparison.
            popup_list_names = GUI.general_functions.CommonFields(list_struct);
        else % At least one exp has zero fields - do nothing.
            GUI.log.add(['At least one experiment has no pre-defined plots for selected plot setting.'])
        end
    end
    if md_GUI.UI.UIPlot.def.pre_def_plot_radiobutton_customized.Value == 1
        if isempty(popup_list_names_det)
            md_GUI.UI.UIPlot.def.Popup_plot_type.String = '-';
            md_GUI.UI.UIPlot.def.Popup_plot_type.Enable = 'off';
        else
            md_GUI.UI.UIPlot.def.Popup_plot_type.String = popup_list_names_det;
        end
    end
end
assignin('base', 'md_GUI', md_GUI)
end