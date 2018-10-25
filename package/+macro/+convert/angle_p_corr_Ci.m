function  [data_out] = angle_p_corr_Ci(data_in, metadata_in, C_nr, det_name)
% This macro calculates the angle between same-event momenta, in 'C_nr' coincidence.
% C_nr = 2 : double, C_nr = 3 : triple, etc.
% Input:
% data_in       The experimental data, already converted
% metadata_in   The corresponding metadata
% C_nr          The number of hits in one event. Options: 2, 3, 4, etc
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i}; 
	detnr = general.data.pointer.det_nr_from_fieldname(detname);

    % Conversion to the shortest great circle path between
    % fragment momenta of a double coincidence event.

    % The mutual angle requires a 'C_nr' coincidence, and thus is an
    % EVENT property, not a hit property.
    %     Conversion to the shortest great circle path between them, which
    %     means that it must lie between 0 and pi radians
    
    %Select the 'C_nr' coincidence events:
    nof_hits = size(data_out.h.(detname).m2q_l,1);
    f_C_nr = filter.events.multiplicity (data_out.e.raw(:,detnr), C_nr, C_nr, nof_hits);
    
    % get the hit numbers of the first, second, up to C_nr hits:
    hit_nrs = repmat(data_out.e.raw(f_C_nr, detnr), 1, C_nr) + repmat(0:C_nr-1, sum(f_C_nr,1), 1);
    % [nof_C_nr_hits, C_nr] = size(hit_nrs)
    
    X = data_out.h.(detname).m2q_l(hit_nrs);
    % MATLAB changes behaviour when one size is one:
    if size(X,2) == 1; X = transpose(X); end
    
    % Making sure that they all have a label (and thus momenta defined):
    C_f_labeled  = all(~isnan(X), 2);
    
    % select, from the C_nr coincidences, the ones where the label is defined:
    all_events_labeled          = f_C_nr;
    all_events_labeled(f_C_nr)  = C_f_labeled;
    
    hit_nrs_l                   = hit_nrs(C_f_labeled,:);
    
    % Initiate a three-dimensional matrix for different hit numbers 
    % in the event (third dimension), for all momentum components (second dimension):
    dp_C_l(1:size(hit_nrs_l,1), 1:C_nr, 1)    = reshape(data_out.h.(detname).dp(hit_nrs_l, 1), size(hit_nrs_l, 1), C_nr); % for x
    dp_C_l(1:size(hit_nrs_l,1), 1:C_nr, 2)    = reshape(data_out.h.(detname).dp(hit_nrs_l, 2), size(hit_nrs_l, 1), C_nr); % for y
    dp_C_l(1:size(hit_nrs_l,1), 1:C_nr, 3)    = reshape(data_out.h.(detname).dp(hit_nrs_l, 3), size(hit_nrs_l, 1), C_nr); % for z
    dp_C_l = permute(dp_C_l, [1 3 2]);

	% Check the number of angles one can calculate: (1 for two momenta, 3 for three, etc).:
    try
		combinations = metadata_in.plot.det1.(['angle_p_corr_C' num2str(C_nr)]).combinations;
	catch
		combinations = combnk(1:C_nr,2);
	end
    nof_comb = size(combinations,1);
    comb_n = 0; all_DClabel_angle_rad = zeros(size(dp_C_l, 1), nof_comb);
	
    for p_comb = combinations'
        comb_n = comb_n + 1;
        % Calculating the angles between the two momenta:
        all_DClabel_angle_rad(:, comb_n) = convert.vector_angle(dp_C_l(:,:,p_comb(1)), dp_C_l(:,:,p_comb(2)));
	end

    % Fill it in into an event array:
    data_out.e.(detname).(['angle_p_corr_C' num2str(C_nr)]) = NaN*ones(size(data_out.e.raw,1), nof_comb);
    data_out.e.(detname).(['angle_p_corr_C' num2str(C_nr)])(all_events_labeled,:) = all_DClabel_angle_rad;
% 	% Write the sum of all mutual angles:
%     data_out.e.(detname).(['angle_p_corr_C' num2str(C_nr) '_sum']) = NaN*ones(size(data_out.e.raw,1), 1);
%     data_out.e.(detname).(['angle_p_corr_C' num2str(C_nr) '_sum'])(all_events_labeled,:) = sum(all_DClabel_angle_rad, 2);	if C_nr > 2
	if C_nr > 1
	% Write the average of all mutual angles:
    data_out.e.(detname).(['angle_p_corr_C' num2str(C_nr) '_mean']) = NaN*ones(size(data_out.e.raw,1), 1);
    data_out.e.(detname).(['angle_p_corr_C' num2str(C_nr) '_mean'])(all_events_labeled,:) = mean(all_DClabel_angle_rad, 2);
	end

	% If the user requests, we calculate the angle of the third momentum
	% relative to the plane spanned by the first two momenta:
	if general.struct.probe_field(metadata_in.conv, [detname, '.angle_p_corr_C3.ifdo.angle_p3_to_p1p2']) & C_nr == 3
		% Calculate the normal of p1-p2 plane:
		dp1		= dp_C_l(:,:,1);
		dp2		= dp_C_l(:,:,2);
		dp3		= dp_C_l(:,:,3);
		n12		= cross(dp1, dp2);
		% Calculate the angle of this normal to the third momentum
		data_out.e.(detname).angle_p3_to_p1p2 = NaN*ones(size(data_out.e.raw,1), 1);
		data_out.e.(detname).angle_p3_to_p1p2(all_events_labeled) = pi/2 - convert.vector_angle(n12, dp3);
	end
    disp(['Log: angle p1 correlation calculated for C' num2str(C_nr)])
end
end
