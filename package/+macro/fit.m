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
		fit_param.m2q = macro.fit.m2q(data_in, metadata_in, detname);
	end
	
    % momentum angle correlation fitting (angle_p_corr or mutual angle)
	C_nrs = 2:3;
	for C_nr = C_nrs
	if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.angle_p_corr_C' num2str(C_nr)])
		fit_param.(['angle_p_corr_C' num2str(C_nr)]) = macro.fit.angle_p_corr(data_in, metadata_in, C_nr, detname);
	end
	
    % The Abel inversion fitting model
    if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.Abel_inversion'])
        fit_param.Abel_inversion = macro.fit.Abel_inversion (data_in, metadata_in, detname);               
	end
end
end
