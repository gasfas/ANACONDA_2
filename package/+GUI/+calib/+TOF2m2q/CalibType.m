





function [] = CalibType()

md_GUI = evalin('base', 'md_GUI');
try md_GUI.mdata_n;
UICalib = md_GUI.UI.UICalib;

set(UiCalib.TOF2m2q.Push_CalibControl, 'Enable', 'on')



exp_names = cellstr('');
NbrOfFiles = md_GUI.data_n.info.numexps;
for lx = 1:length(NbrOfFiles)
    exp_names(lx) = cellstr(['exp', int2str(NbrOfFiles(lx))]);
end        
 
%% The next step is to determine the string of the button of the 
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
        
        % assign data used 
        if mean(hr_detname == UICalib.TOF2m2q.Radio_CalibType_Ions.String)
            
            
            

        currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.(current_det_name));
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
        popup_list_names = cellstr('');
        if value > length(exp_names)-1 % Do the fields comparison.
            popup_list_names = GUI.general_functions.CommonFields(list_struct);
        else % At least one exp has zero fields - do nothing.
            GUI.log.add(['At least one experiment has no pre-defined plots for selected plot setting.'])
        end
    end
set(md_GUI.UI.UIPlot.def.Popup_plot_type, 'String', popup_list_names)
set(md_GUI.UI.UIPlot.def.PlotConfEditButton, 'Enable', 'off')
set(md_GUI.UI.UIPlot.def.PlotConfRmvButton, 'Enable', 'off')
assignin('base', 'md_GUI', md_GUI)
catch
    GUI.log.add(['No experiment metadata found.'])
end



set(md_GUI.UI.UICalib.TOF2m2q.type, 
end