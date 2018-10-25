function [h_figure, h_axes, h_GraphObj, exp] = plot(exp, metadata)
% This macro produces plots, based on the corrected and converted signals.
% The metadata.plot.(detname).ifdo list is checked for the plot types the
% user wants to see, and they are shown.
% Input:
% exp           The experimental data, already converted
% metadata      The corresponding metadata 
% SEE ALSO macro.correct, macro.convert
% macro.fit
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% we fetch the detector names:
detnames            = fieldnames(metadata.det);
% we add the cross detector name:
detnames			= {detnames{:}, 'crossdet'};

% We check all the detectors:
for i = 1:length(detnames)
	detname		= detnames{i};
	detnr		= general.data.pointer.det_nr_from_fieldname(detname);
	% We check all the plotnames of this detector:
	plotnames = general.struct.probe_field(metadata, ['plot.' detname '.ifdo']);
	if isstruct(plotnames)
		for plotname = fieldnames(plotnames)'
			% If the user wants to plot that plottype:
			if metadata.plot.(detname).ifdo.(plotname{:})
				% Create the plot figure and its contents:
				 [h_figure.(detname).(plotname{:}), h_axes.(detname).(plotname{:}), h_GraphObj.(detname).(plotname{:}), exp] = macro.plot.create.plot(exp, metadata.plot.(detname).(plotname{:}));
			end
		end
	else % no plots requested:
		[h_figure.(detname), h_axes.(detname), h_GraphObj.(detname)] = deal([], [], []);
	end
end

% We plot the cross_det plots:
			
% TODO