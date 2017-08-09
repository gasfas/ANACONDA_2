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

function [ ] = Plot( ) 
clear d_fn;
md_GUI = evalin('base', 'md_GUI');
plotsettings = md_GUI.plot.plotsettings;
expsettings = md_GUI.plot.expsettings;
exp_names = md_GUI.plot.selected_exp_names;
experiment_selected_number = md_GUI.plot.filenumber_selected;
dimensions = plotsettings(1);
if ischar(exp_names)
    exp_names = cellstr(exp_names);
end

% Data array values explained:
% expsettings(1) : hits/events
% expsettings(2) : detector number
% expsettings(3) : filter selection
% plotsettings(1) dimensions
% plotsettings(2) graph abscissa (X)
% plotsettings(3) graph ordinate (Y)
% plotsettings(4) = 1: Plot all in new figure.
% plotsettings(4) = 2: Plot all separately.
% plotsettings(4) = 3: Plot selection into pre-existing figure.

for lxlx = 1:length(experiment_selected_number)
    detectors.([char(exp_names(lxlx))]) = fieldnames(md_GUI.mdata_n.([char(exp_names(lxlx))]).plot);
    plottypes.([char(exp_names(lxlx))]) = fieldnames(md_GUI.mdata_n.([char(exp_names(lxlx))]).plot.([char(detectors.([char(exp_names(lxlx))])(1))]));
    graphtype_X_selected.([char(exp_names(lxlx))]) = plottypes.([char(exp_names(lxlx))])(plotsettings(2));
    graphtype_Y_selected.([char(exp_names(lxlx))]) = plotsettings(3);
    if graphtype_Y_selected.([char(exp_names(lxlx))]) == 1
        disp('Y-axis: Pre-defined.')
    else
        disp('Y-axis: Modified.')
        % Fix it here. 2D graph (2D map).
    end
end

%% Getting data and metadata and experiment selections
graphtype_X = graphtype_X_selected.([char(exp_names(1))]);
numberofloadedfilesselected = length(experiment_selected_number);
data_n = md_GUI.data_n;
mdata_n = md_GUI.mdata_n;

%% Let's apply the filters on the data.
for llx = 1:length(exp_names)
    % Get the name of the filter - if it has been chosen. Otherwise - set
    % no filter as the name of the struct.
    if isfield(md_GUI, 'filterpath');
        if isfield(md_GUI.plot.filterpath, char(exp_names(llx)));
            filtername.(char(exp_names(llx))) = md_GUI.plot.filterpath.(char(exp_names(llx)));
        else
            filtername.(char(exp_names(llx))) = 'nofilter';
        end
    else
        filtername.(char(exp_names(llx))) = 'nofilter';
    end
    if strcmp('nofilter', char(filtername.(char(exp_names(llx)))))
        % Use no filter.
        disp('No filter.')
    else % Apply the filter.
        fieldname.([char(exp_names(llx))]) = filtername.(char(exp_names(llx)));
        filtername.([char(exp_names(llx))]) = general.getsubfield(mdata_n.([char(exp_names(llx))]).cond, fieldname.([char(exp_names(llx))]));
        mdata_n.([char(exp_names(llx))]).plot.([char(detectors.([char(exp_names(llx))]))]).(char(graphtype_X)).cond = filtername.(char(exp_names(llx)));
    end
end

%% Plotting
if plotsettings(4) == 1 % Plot all in new figure.
    if numberofloadedfilesselected == 1 %One file to plot - only one exp
        detectorname = char(detectors.([char(exp_names(1))]));
        disp('one exp to plot')
        if isfield(md_GUI.plot, 'plofconf')
            if isfield(md_GUI.plot.plotconf, char(graphtype_X))
                mdata_n.([char(exp_names)]).plot.([detectorname]).([char(graphtype_X)]) = md_GUI.plot.plotconf.(char(graphtype_X));
            end
        end
        macro.plot_2(data_n.([char(exp_names)]), mdata_n.([char(exp_names)]), graphtype_X, exp_names, dimensions, md_GUI);
    elseif numberofloadedfilesselected > 1  %Multiple files to plot - multiple exp
        for l = 1:numberofloadedfilesselected
            detectorname = char(detectors.([char(exp_names(l))]));
            %expnumber(l) = int2str(experiment_selected_number(l))
            disp('multi exp to plot')
            %exp_name(l) = md_GUI.exp_names(experiment_selected_number(l));
            exp_name(l) = md_GUI.load.exp_names(l);
        end
        if isfield(md_GUI.plot, 'plofconf')
            if isfield(md_GUI.plot.plotconf, char(graphtype_X))
                mdata_n.([char(exp_names(l))]).plot.([detectorname]).([char(graphtype_X)]) = md_GUI.plot.plotconf.(char(graphtype_X));
            end
        end
        macro.plot_2_n(data_n, mdata_n, exp_name, graphtype_X, dimensions, md_GUI);
    end
elseif plotsettings(4) == 2 % Plot all separately.
    if numberofloadedfilesselected == 1 %One file to plot - only one exp
        if ischar(exp_names)
            exp_name = exp_names;
        else
        exp_name = char(exp_names);
        end
        detectorname = char(detectors.([char(exp_name)]));
        if isfield(md_GUI.plot, 'plofconf')
            if isfield(md_GUI.plot.plotconf, char(graphtype_X))
                mdata_n.([char(exp_name)]).plot.([detectorname]).([char(graphtype_X)]) = md_GUI.plot.plotconf.(char(graphtype_X));
            end
        end
        macro.plot_2(data_n.([char(exp_name)]), mdata_n.([char(exp_name)]), graphtype_X, exp_name, dimensions, md_GUI);
    elseif numberofloadedfilesselected > 1  %Multiple files to plot - multiple exp
        for l = 1:numberofloadedfilesselected
            detectorname = char(detectors.([char(exp_names(l))]));
            number = l;
            exp_name = exp_names{l};
            if isfield(md_GUI.plot, 'plofconf')
                if isfield(md_GUI.plot.plotconf, char(graphtype_X))
                    mdata_n.([char(exp_names(l))]).plot.([detectorname]).([char(graphtype_X)]) = md_GUI.plot.plotconf.(char(graphtype_X));
                end
            end
            macro.plot_2(data_n.([char(exp_name)]), mdata_n.([char(exp_name)]), graphtype_X, exp_name, dimensions, md_GUI);
        end
    end
elseif plotsettings(4) == 3 % Plot selection into pre-existing figure.
    %% Not activated yet. % % % % % % % % % % % % % % % % % % % 
    figureselected = inputdlg('Write figure number you wish to plot over.', 'Figure selection');
    figureselected = str2num(figureselected);
    %ax = macro.plot_4(p_pyridine_p_d.(exp_name), p_pyridine_p_md.(exp_name), graphtype_X_selected_number, figureselected, experiment_name);
    %% Fix macro.plot_3 and macro.plot_3_n. Look at macro_plot_4. Problem with expnumber if experiment_selected_number(l) >= 10...
    if numberofloadedfilesselected == 1 %One file to plot - only one exp
        experiment_selected_number = int2str(experiment_selected_number);
        disp('one exp to plot')
        exp_name = exp_names{str2num(experiment_selected_number)};
        detectorname = char(detectors.([char(exp_names(1))]));
        if isfield(md_GUI.plot, 'plofconf')
            if isfield(md_GUI.plot.plotconf, char(graphtype_X))
                mdata_n.([char(exp_name)]).plot.([detectorname]).([char(graphtype_X)]) = md_GUI.plot.plotconf.(char(graphtype_X));
            end
        end
        ax = macro.plot_3(data_n.(exp_name), mdata_n.(exp_name), graphtype_X, figureselected, experiment_name, dimensions, md_GUI);
    elseif numberofloadedfilesselected > 1  %Multiple files to plot - multiple exp
        detectorname = char(detectors.([char(exp_names(l))]));
        for l = 1:numberofloadedfilesselected
            expnumber(l) = int2str(experiment_selected_number(l))
            disp('multi exp to plot')
        end
        if isfield(md_GUI.plot, 'plofconf')
            if isfield(md_GUI.plot.plotconf, char(graphtype_X))
                mdata_n.([char(exp_names(l))]).plot.([detectorname]).([char(graphtype_X)]) = md_GUI.plot.plotconf.(char(graphtype_X));
            end
        end
        ax = macro.plot_3_n(data_n, mdata_n, exp_names, graphtype_X, figureselected, experiment_name, dimensions, md_GUI);
    end
end
end