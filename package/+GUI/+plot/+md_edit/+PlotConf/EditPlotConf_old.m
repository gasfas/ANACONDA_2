% Description: Set up parameters used for the plotting.
%   - inputs:
%           Selected exp. number                (experiment_selected_number)
%           Selected experiment(s) metadata     (mdata_n)
%           Experiment settings                 (expsettings)
%           Plot settings                       (plotsettings)
%   - outputs: (into PlotConfSetButton)
%           Field selected              (fieldselected)
%           Field selected value      	(fieldselectedvalue)
% Date of creation: 2017-11-27.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [  ] = EditPlotConf()
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
                'SelectionMode','single','ListString',list_names_window);
if yesorno == 1
    for ly = 1:length(exp_names)
        detmodes = md_GUI.mdata_n.(char(exp_names(ly))).spec.det_modes;
        for lx = 1:length(selected_confs)
            selectedconf = strsplit(char(list_names_window(selected_confs(lx))), '.');
            selectedconfplot = char(selectedconf(2));
            selectedconfdetname = char(selectedconf(1));
            for lz = 1:length(detmodes)
                if strcmp(selectedconfdetname, char(detmodes(lz)))
                    detnum = lz;
                end
            end
            detname = fieldnames(md_GUI.mdata_n.(char(exp_names(ly))).plot);
            detname = char(detname(detnum));
            confname(ly) = cellstr(['md_GUI.mdata_n.' char(exp_names(ly)) '.plot.user.' detname '.' selectedconfplot]);
            % Open up the variables reader to view and/or edit the plotting configuration.
            if length(confname) > 1
                openvar(char(confname(ly)))
            else
                openvar(char(confname))
            end
            
            GUI.log.add(['User plot configuration ', selectedconfplot, ' for ', char(exp_names(ly)), ' opened in .']);
        end
    end
end
assignin('base', 'md_GUI', md_GUI)
end