function  [fit_param] = fit(data_in, metadata_in)
% This macro executes a bunch of fits on the corrected data.
% The fits executed:
% - TOF peaks to relative intensities
% SEE ALSO macro.correct, macro.convert, macro.filter

% We fetch the detector names:
detnames = fieldnames(metadata_in.det);
for i = 1:length(detnames)
    detname = detnames{i};
	
	if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_1']) || ...
			general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_2']) || ...
			general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_3']) || ...
			general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_4'])
		% We load the background measurements (all m2q fitting prcedures need them)
        % Load the background data:
		bgr =   IO.import_raw(metadata_in.fit.det1.m2q.bgr_subtr.filename);
		bgr_md =IO.import_metadata(metadata_in.fit.det1.m2q.bgr_subtr.filename);
		bgr = macro.correct(bgr, bgr_md);
		bgr = macro.convert(bgr, bgr_md);
	end

    % The first m2q fitting model (binomial model)
    if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_1'])
        [fit_param] = macro.fit.m2q_1(data_in, metadata_in, detname, bgr, bgr_md);
    end
    
    % The second m2q fitting model (nucleation model)
    if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_2'])
        [fit_param] = macro.fit.m2q_2(data_in, metadata_in, detname, bgr, bgr_md);       
    end
    
    % The third m2q fitting model (evaporation model)
    if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_3'])
        [fit_param] = macro.fit.m2q_3(data_in, metadata_in, detname, bgr, bgr_md);       
    end
    
    % The fourth m2q fitting model (nucleation and evaporation model combined)
    if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.m2q_4'])
        [fit_param] = macro.fit.m2q_4(data_in, metadata_in, detname, bgr, bgr_md);               
    end 
    
    % The Abel inversion fitting model
    if general.struct.probe_field(metadata_in, ['fit.' detname '.ifdo.Abel_inversion'])
        [fit_param] = macro.fit.Abel_inversion (data_in, metadata_in, detname);               
	end
end
end
