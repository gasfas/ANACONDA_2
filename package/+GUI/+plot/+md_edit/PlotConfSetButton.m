% Description: Sets the selected user defined/customized plot configurations for the selected experiment(s)
%   - inputs:
%           Selected signal name
%           Experiment metadata
%   - outputs:
%           New experiment metadata
% Date of creation: 2017-08-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [] = PlotConfSetButton(fieldselected, fieldselectedvalue)
md_GUI = evalin('base', 'md_GUI');
selectedexps = md_GUI.plot.selected_exp_names;
if ischar(selectedexps)
    exp_name = selectedexps;
    detectornum = md_GUI.plot.expsettings.All(2);
    detectorname = fieldnames(md_GUI.mdata_n.([exp_name]).plot(detectornum));
    detectorname = char(detectorname(detectornum));
    graphnum_X = md_GUI.plot.plotsettings(2);
    graphtypes = fieldnames(md_GUI.mdata_n.([exp_name]).plot.([detectorname]));
    graphtype_X = char(graphtypes(graphnum_X));
    %graphtype_Y = md_GUI.graphtype_Y; % % % % Add when 2D plotting is available.
    message = ['New value(s) for field "', char(fieldselected), '" of graphtype "', char(graphtype_X),  ' for ', exp_name, ' have/has been set.'];
    disp(message)
    disp('Old value(s):')  
    disp(md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]).([char(fieldselected)]));
    md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]).([char(fieldselected)]) = fieldselectedvalue;
    disp('New value(s):')
    disp(md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]).([char(fieldselected)]));
else
    for lllx = 1:length(selectedexps)
        exp_name = char(selectedexps(lllx));
        detectornum = md_GUI.plot.expsettings.All(2);
        detectorname = fieldnames(md_GUI.mdata_n.([exp_name]).plot(detectornum));
        detectorname = char(detectorname(detectornum));
        graphnum_X = md_GUI.plot.plotsettings(2);
        graphtypes = fieldnames(md_GUI.mdata_n.([exp_name]).plot.([detectorname]));
        graphtype_X = char(graphtypes(graphnum_X));
        %graphtype_Y = md_GUI.graphtype_Y; % % % % Add when 2D plotting is available.
        message = ['New value(s) for field "', char(fieldselected), '" of graphtype "', char(graphtype_X),  ' for ', exp_name, ' have/has been set.'];
        disp(message)
        disp(' ')
        disp('Old value(s):')  
        disp(md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]).([char(fieldselected)]));
        md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]).([char(fieldselected)]) = fieldselectedvalue;
        disp('New value(s):')
        disp(md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]).([char(fieldselected)]));
    end
end
assignin('base', 'md_GUI', md_GUI);
end