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
selectedconf = cellstr('In_Workspace');
for ly = 1:length(exp_names)
    current_exp_name = char(exp_names(lx));
    % Get number of detectors.
    detector_choices = fieldnames(md_GUI.mdata_n.(current_exp_name).det);
    if ischar(detector_choices)
        numberofdetectors = 1;
        detector_choices = cellstr(detector_choices);
    else
        numberofdetectors = length(detector_choices);
    end
    for lz = 1:numberofdetectors
        current_det_name = char(detector_choices(ly));
        detnr			 = IO.detname_2_detnr(current_det_name);
    end
    detmodes = md_GUI.mdata_n.(char(exp_names(ly))).spec.det_modes;
    detname = fieldnames(md_GUI.mdata_n.(char(exp_names(ly))).plot);
    if strcmp(selectedconf, 'In_Workspace')
        detname = char(detname(detnr));
        confname(ly) = cellstr(['md_GUI.mdata_n.' char(exp_names(ly)) '.plot.user.' detname '.In_Workspace']);
    else
        selectedconf = strsplit(char(selected_confs(ly)), '.');
        selectedconfplot = char(selectedconf(2));
        selectedconfdetname = char(selectedconf(1));
        for lz = 1:length(detmodes)
            if strcmp(selectedconfdetname, char(detmodes(lz)))
                detnum = lz;
            end
        end
        detname = char(detname(detnum));
        confname(ly) = cellstr(['md_GUI.mdata_n.' char(exp_names(ly)) '.plot.user.' detname '.' selectedconfplot]);
    end
    % Open up the variables reader to view and/or edit the plotting configuration.
    if length(confname) > 1
        openvar(char(confname(ly)))
    else
        openvar(char(confname))
    end
    GUI.log.add(['User plot configuration ', selectedconfplot, ' for ', char(exp_names(ly)), ' opened in .']);
end
assignin('base', 'md_GUI', md_GUI)
end