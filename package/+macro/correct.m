function [data_out] = correct(data_in, metadata_in)
% This macro applies the corrections to the
% raw signals. The result is given as an output.
% TODO: loop over corrections (all detectors), instead of all conversions
% for one detector.
% SEE ALSO macro.corrected_to_converted

% Copy the data:
data_out = data_in;

% We fetch the detector names:
detnames = fieldnames(metadata_in.det);

for i = 1:length(detnames)
    detname     = detnames{i};
    
    % Check the log, which corrections have already been performed:
    corr_log    = general.struct.probe_field(data_out, ['h.' detname '.corr_log']);
%     % if no corrections have been performed, add the empty field:
    if islogical(corr_log) && ~corr_log; data_out.h.(detname).corr_log = []; end
    
    % find all X,Y,TOF signals:
    idx_X       = find(strcmp(metadata_in.det.(detname).signals, 'X [mm]'));
    idx_Y       = find(strcmp(metadata_in.det.(detname).signals, 'Y [mm]'));
    idx_TOF		= find(strcmp(metadata_in.det.(detname).signals, 'TOF [ns]'));
    idx_E		= find(strcmp(metadata_in.det.(detname).signals, 'E [eV]'));

    % Now we go through all possible corrections:
    
    % Detector image translation:
    if ~isempty(idx_X) && ~isempty(idx_Y) && general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.dXdY') 
        data_out = macro.correct.dXdY(data_out, metadata_in, detname);
	else
		if idx_X % If the signal X is requested without correction:
			data_out.h.(detname).X = data_out.h.(detname).raw(:,idx_X);
		end
		if idx_Y % If the signal Y is requested without correction:
			data_out.h.(detname).Y = data_out.h.(detname).raw(:,idx_Y);
		end
    end
    
    % Detector image rotation:
    if ~isempty(idx_X) && ~isempty(idx_Y) && general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.dTheta') 
        data_out = macro.correct.dTheta(data_out, metadata_in, detname);
	end
	
end

%% Cross-detector correction:

	% Ionization correction:
if general.struct.probe_field(metadata_in.corr, 'crossdet.ifdo.ionization_position') 
	data_out = macro.correct.ionization_position(data_out, metadata_in);
end


%%
for i = 1:length(detnames)
    detname     = detnames{i};
    
    % Check the log, which corrections have already been performed:
%     corr_log    = general.struct.probe_field(data_out, ['h.' detname '.corr_log']);
%     % if no corrections have been performed, add the empty field:
%     if islogical(corr_log) && ~corr_log; data_out.h.(detname).corr_log = []; end
	
	% find all X,Y,TOF signals:
    idx_X       = find(strcmp(metadata_in.det.(detname).signals, 'X [mm]'));
    idx_Y       = find(strcmp(metadata_in.det.(detname).signals, 'Y [mm]'));
    idx_TOF		= find(strcmp(metadata_in.det.(detname).signals, 'TOF [ns]'));
    idx_E		= find(strcmp(metadata_in.det.(detname).signals, 'E [eV]'));
	
    % Detector image non-roundness correction:
    if ~isempty(idx_X) && ~isempty(idx_Y) && general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.dTheta') 
        data_out = macro.correct.R_circle(data_out, metadata_in, detname);
	end 
	
    % TOF dead time correction
    if ~isempty(idx_TOF) && general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.dTOF') 
        data_out = macro.correct.dTOF(data_out, metadata_in, detname);
	elseif idx_TOF % If the signal TOF is requested without correction:
			data_out.h.(detname).TOF = data_out.h.(detname).raw(:,idx_TOF);
    end
    
    % Energy correction
    if ~isempty(idx_E) && general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.dE') 
        data_out = macro.correct.dE(data_out, metadata_in, detname);
	end    
	
    % Detector-induced electrostatic abberation:
    if general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.detectorabb') 
        data_out = macro.correct.detectorabb(data_out, metadata_in, detname);
    end
    
    % Lens-induced abberation:
    if general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.lensabb') 
        data_out = macro.correct.lensabb(data_out, metadata_in, detname);
	end
	
	% Remove (events that contain) outliers in the data:
	if general.struct.probe_field(metadata_in.corr.(detname), 'ifdo.remove_outliers') 
		data_out = macro.correct.remove_outliers(data_out, metadata_in, detname);
	end
end
