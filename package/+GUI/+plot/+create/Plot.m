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
md_GUI = evalin('base', 'md_GUI');

exp_in = md_GUI.data_n;
metadata_in = md_GUI.mdata_n;
expsettings_in = md_GUI.plot.expsettings; % e/h/.. , det#, filter
expnames = md_GUI.plot.selected_exp_names;

for expnum = 1:length(expnames)
    %macro.plot(exp.(char(expnames(expnum))), metadata.(char(expnames(expnum))))
    exp = exp_in.(char(expnames(expnum)));
    metadata = metadata_in.(char(expnames(expnum)));
    expsettings = expsettings_in.(char(expnames(expnum)));
    
    % Imported from the function macro.plot:
    detnames            = fieldnames(metadata.det);
    detname = detnames(expsettings(2));
    
    % We check all the detectors:
    for i = 1:length(detnames)
        detname		= detnames{i};
        detnr		= IO.det_nr_from_fieldname(detname);
        % We check all the plotnames of this detector:
        plotnames = general.struct.probe_field(metadata.plot.(detname), 'ifdo');
        if isstruct(plotnames)
            for plotname = fieldnames(plotnames)'
                % If the user wants to plot that plottype:
                if metadata.plot.(detname).ifdo.(plotname{:})
                    % Create the plot figure and its contents:
                     [h_figure.(detname).(plotname{:}), h_axes.(detname).(plotname{:}), h_GraphObj.(detname).(plotname{:}), exp] = ...
						 macro.plot.create.plot(exp, metadata.plot.(detname).(plotname{:}));
                end
            end
        else % no plots requested:
            [h_figure.(detname), h_axes.(detname), h_GraphObj.(detname)] = deal([], [], []);
        end
    end
    
    
    
end



end