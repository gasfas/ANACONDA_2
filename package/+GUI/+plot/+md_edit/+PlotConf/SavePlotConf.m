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

function [  ] = SavePlotConf()
md_GUI = evalin('base', 'md_GUI');
newPlotConfName = inputdlg('New plot configuration name:', 'Save to md');
signal_x = md_GUI.UI.UIPlot.new.x_signal_pointer.String;
signal_y = md_GUI.UI.UIPlot.new.y_signal_pointer.String;
selectedexpnumbers = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
if strcmp(signal_x, '-') % signal for x has not been chosen.
    msgbox('A signal for [ x ] has not been chosen.', 'error')
else
    for lx = 1:length(selectedexpnumbers)
        sel_exp_names(lx) = cellstr(['exp', num2str(selectedexpnumbers(lx))]);
        signals_list.(['exp', num2str(lx)]) = fieldnames(md_GUI.mdata_n.([char(sel_exp_names(lx))]).plot.signal);
        plottypes_def.(char(sel_exp_names(lx))) = {}; 
        % % %
        current_exp_name = char(sel_exp_names(lx));
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
            currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.(current_det_name));
            % remove possible 'ifdo' fields:
            currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
            for lz = 1:length(signals_list.(['exp', num2str(lx)]))
                if strcmp(char(signals_list.(['exp', num2str(lx)])(lz)), signal_x)
                    try
                        hr_detname_found_x2(1) = hr_detname_found_x;
                        hr_detname_found_x2(2) = hr_detname(ly);
                        hr_detname_found_x = hr_detname_found_x2;
                    catch
                        hr_detname_found_x = hr_detname;
                    end
                    % write dots between detectornames and fieldnames:
                    list_names_det_x = general.cell.pre_postscript_to_cellstring(signals_list.(['exp', num2str(lx)])(lz), [hr_detname_found_x '.' ], '');
                end
                if strcmp(signal_y, '-') % signal for x has not been chosen.
                    signal_y_exist = 0;
                else
                    signal_y_exist = 1;
                    if strcmp(char(signals_list.(['exp', num2str(lx)])(lz)), signal_y)
                        try 
                            hr_detname_found_y2(1) = hr_detname_found_y;
                            hr_detname_found_y2(2) = hr_detname(ly);
                            hr_detname_found_y = hr_detname_found_y2;
                        catch
                            hr_detname_found_y = hr_detname;
                        end
                        % write dots between detectornames and fieldnames:
                        list_names_det_y = general.cell.pre_postscript_to_cellstring(signals_list.(['exp', num2str(lx)])(lz), [hr_detname_found_y '.' ], '');
                    else
                        if numberofdetectors == 1
                            hr_detname_found_y = hr_detname;
                        end
                    end
                end
            end
        end
    end
    if length(list_names_det_x) == 1
        det_plottype_x = char(list_names_det_x);
    else % For now use 1st one - could be collision if plot type names are same for e.g. an electron detector and an ion detector of an experiment.
        det_plottype_x = char(list_names_det_x(1));
    end
    try
        if length(list_names_det_y) == 1
            det_plottype_y = char(list_names_det_y);
        else % For now use 1st one - could be collision if plot type names are same for e.g. an electron detector and an ion detector of an experiment.
            det_plottype_y = char(list_names_det_y(1));
        end
    catch
        signal_y_exist = 0;
    end
    typesplit_x = strsplit(det_plottype_x, '.');
    if length(typesplit_x) == 2
        for lx = 1:length(selectedexpnumbers)
            exp_name = char(sel_exp_names(lx));
            % Find which detector is used:
            detname = ['det' num2str(find(strcmp(char(typesplit_x(1)), md_GUI.mdata_n.(exp_name).spec.det_modes)))];
            plottype = char(typesplit_x(2));
            % See if a condition is defined:
            if ~strcmpi(md_GUI.UI.UIPlot.Popup_Filter_Selection.String(md_GUI.UI.UIPlot.Popup_Filter_Selection.Value), 'No_Filter')
                cond_name	= char(md_GUI.UI.UIPlot.Popup_Filter_Selection.String(md_GUI.UI.UIPlot.Popup_Filter_Selection.Value));
                cond_md     = general.struct.getsubfield( md_GUI.mdata_n.(exp_name).cond, cond_name);
                md_GUI.mdata_n.(exp_name).plot.(detname).(plottype) = replace_condition(md_GUI.mdata_n.(exp_name).plot.(detname).(plottype), cond_md, cond_name);
            end
        end
    end
    if signal_y_exist == 1
        typesplit_y = strsplit(det_plottype_y, '.');
        if length(typesplit_y) == 2
            for lx = 1:length(selectedexpnumbers)
                exp_name = char(sel_exp_names(lx));
                % Find which detector is used:
                detname_y = ['det' num2str(find(strcmp(char(typesplit_y(1)), md_GUI.mdata_n.(exp_name).spec.det_modes)))];
                plottype_y = char(typesplit_y(2));
                % See if a condition is defined - could be different for the x-axis and the y-axis - how to specify for each axis?
                if ~strcmpi(md_GUI.UI.UIPlot.Popup_Filter_Selection.String(md_GUI.UI.UIPlot.Popup_Filter_Selection.Value), 'No_Filter')
                    cond_name	= char(md_GUI.UI.UIPlot.Popup_Filter_Selection.String(md_GUI.UI.UIPlot.Popup_Filter_Selection.Value));
                    cond_md     = general.struct.getsubfield( md_GUI.mdata_n.(exp_name).cond, cond_name);
                    md_GUI.mdata_n.(exp_name).plot.(detname_y).(plottype_y) = replace_condition(md_GUI.mdata_n.(exp_name).plot.(detname_y).(plottype_y), cond_md, cond_name);
                end
                % Plot x signal vs y signal selected - construct new plot specie
                signals.(exp_name)                              = md_GUI.mdata_n.(exp_name).plot.signal;
                d1.([signal_x, '_', signal_y])                  = metadata.create.plot.signal_2_plot({signals.(exp_name).(signal_x), signals.(exp_name).(signal_y)});
                d1.([signal_x, '_', signal_y]).hist.binsize     = d1.([signal_x, '_', signal_y]).hist.binsize;
                if strcmp(signal_x, signal_y)
                    d1.([signal_x, '_', signal_y]).axes.axis	= 'equal';
                end
                d1.([signal_x, '_', signal_y]).GraphObj.Type    = 'imagesc';
                d1.([signal_x, '_', signal_y]).GraphObj.SizeData = 150;
                d1.([signal_x, '_', signal_y]).GraphObj.Marker  = 'o';
                d1.([signal_x, '_', signal_y]).GraphObj.MarkerEdgeColor = 'r';
                md_GUI.mdata_n.(exp_name).plot.(detname).(char(newPlotConfName)) = d1.([signal_x, '_', signal_y]);
                numberofplottypes = length(currentplottypes)+1;
                currentplottypes(numberofplottypes) = newPlotConfName;
                % write dots between detectornames and fieldnames:
                popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
                md_GUI.UI.UIPlot.def.Popup_plot_type.String = popup_list_names_det;
            end
        end
    end
end
assignin('base', 'md_GUI', md_GUI)
end