function  [data_out] = ionization_position(data_in, metadata_in)
% This macro corrects the detector electrostatic abberation.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
data_out = data_in;

% Fetch the chosen data:
detnr_source	= metadata_in.corr.crossdet.ionization_position.source.detnr;
detnr_subj		= metadata_in.corr.crossdet.ionization_position.subject.detnr;
det_source		= ['det' num2str(detnr_source)];
det_subj		= ['det' num2str(detnr_subj)];

X_fraction	= metadata_in.corr.crossdet.ionization_position.X_fraction;
Y_fraction	= metadata_in.corr.crossdet.ionization_position.Y_fraction;

% fetch the electron positions:
X_source_h			= data_out.h.(det_source).X;
Y_source_h			= data_out.h.(det_source).Y;
X_subj_h			= data_out.h.(det_subj).X;
Y_subj_h			= data_out.h.(det_subj).Y;

% Convert to event position:
X_source_e			= convert.event_sum(X_source_h, data_out.e.raw(:,detnr_source));
Y_source_e			= convert.event_sum(Y_source_h, data_out.e.raw(:,detnr_source));

% Calculate the shift on each event:
X_corr_e		= X_fraction * X_source_e;
Y_corr_e		= Y_fraction * Y_source_e;

% Now translate that shift to the hits:
X_subj_corr_h		= convert.event_2_hit_values(X_corr_e, data_out.e.raw(:,detnr_subj), length(X_subj_h));
Y_subj_corr_h		= convert.event_2_hit_values(Y_corr_e, data_out.e.raw(:,detnr_subj), length(Y_subj_h));

if strcmpi(general.struct.probe_field(metadata_in.corr.crossdet.ionization_position, 'Type'), 'linear_radial')
	% linear radial: Correction that increases radially to R = detector radius,
	% where the full X, Y fraction is applied.
	% Calculate the relative radius:
	[~, R]		= cart2pol(X_subj_h, Y_subj_h);
	R_rel			= 1;% R//metadata_in.det.(det_subj).max_radius;
	data_out.h.(det_subj).X = X_subj_h - X_subj_corr_h .* R_rel;
	data_out.h.(det_subj).Y = Y_subj_h - Y_subj_corr_h .* R_rel;
else
	% subtract this (constant) from the original signal:
	data_out.h.(det_subj).X = X_subj_h - X_subj_corr_h;
	data_out.h.(det_subj).Y = Y_subj_h - Y_subj_corr_h;
end

disp('Log: Cross-detector ionization position correction performed')

end
