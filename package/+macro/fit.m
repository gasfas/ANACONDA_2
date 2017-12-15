function  [data_out, hFig, hAx, hGraphObj] = fit(data_in, metadata_in)
% This macro executes a bunch of fits on the corrected data.
% The fits executed:
% - TOF peaks to relative intensities
% SEE ALSO macro.correct, macro.convert, macro.filter
data_out = data_in;

% We fetch the detector names:
detnames = fieldnames(metadata_in.det);
for i = 1:length(detnames)
    detname = detnames{i};
	
	% m2q fitting:
	if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q'])		
		data_out.fit.(detname).m2q.param = macro.fit.m2q(data_in, metadata_in, detname);
	end
		
	% Find the appearance size of a signal series (e.g. cluster dication):
	if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.app_size'])		
		data_out.fit.(detname).app_size.param = macro.fit.app_size(data_in, metadata_in, detname);
	end
	
    % momentum angle correlation fitting (angle_p_corr or mutual angle)
	C_nrs = 2:3;
	for C_nr = C_nrs
		if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.angle_p_corr_C' num2str(C_nr)])
			data_out.fit.(detname).(['angle_p_corr_C' num2str(C_nr)]).param ...
						= macro.fit.angle_p_corr(data_in, metadata_in, C_nr, detname);
		end
	end
	
	% The Abel inversion fitting model
	if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.Abel_inversion'])
		data_out.fit.(detname).Abel_inversion.param ...
					= macro.fit.Abel_inversion (data_in, metadata_in, detname);
	end

end
