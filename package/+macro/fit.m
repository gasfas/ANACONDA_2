function  [fit_param, hFig, hAx, hGraphObj] = fit(data_in, metadata_in)
% This macro executes a bunch of fits on the corrected data.
% The fits executed:
% - TOF peaks to relative intensities
% SEE ALSO macro.correct, macro.convert, macro.filter

% We fetch the detector names:
detnames = fieldnames(metadata_in.det);
for i = 1:length(detnames)
    detname = detnames{i};
	
	% m2q fitting:
	if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q'])		
		fit_param = macro.fit.m2q(data_in, metadata_in, detname);
	end
	
    % TODO: mutual angle fitting (angle_p_corr)
	
    % The Abel inversion fitting model
    if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.Abel_inversion'])
        [fit_param] = macro.fit.Abel_inversion (data_in, metadata_in, detname);               
	end
end
end
