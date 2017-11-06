function  [data_out] = angle_p_2_eps(data_in, metadata_in, det_name)
% This macro calculates the angle between the polarization and the momentum.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
data_out = data_in;

if exist('det_name', 'var')
    switch iscell(det_name)
		case true
			detnames = det_name;
		case false
			detnames = {det_name};
	end
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i}; 
    
    % Conversion to the shortest great circle path between
    % polarization and fragment momentum. Note that this means that 
    % it must lie between 0 and pi radians

    % Fetch the momenta:
    dp      = data_out.h.(detname).dp;
    % Fetch the polarization direction:
    eps     = metadata_in.det.det1.pol_direction;
    % Making sure that the hits have their momenta defined:
    f_def   = all(~isnan(dp),2);        
    dp_def  = dp(f_def,:);
    % Calculating the angle between them:
    angle_dp_to_eps = convert.vector_angle(dp_def, eps);
    % Fill it in into a new array:
    data_out.h.det1.p_2_pol_angle = NaN*ones(size(dp,1),1);
    data_out.h.det1.p_2_pol_angle(f_def) = angle_dp_to_eps;
    disp(['Log: momentum to polarization angle conversion performed on ' detname])
end
end
