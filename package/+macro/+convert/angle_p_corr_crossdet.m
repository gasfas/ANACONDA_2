function  [data_out] = angle_p_corr_crossdet(data_in, metadata_in)
% This macro calculates the angle between same-event momenta, but recorded 
% at different detectors. Conversion to the shortest great circle path between
% fragment momenta, which means that it must lie between 0 and pi radians.
% Input:
% data_in       The experimental data, already converted
% metadata_in   The corresponding metadata
% C_nr          The number of hits in one event. Options: 2, 3, 4, etc
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
data_out = data_in;

% Check the metadata: 
try
	p_corr_md	= metadata_in.conv.angle_p_corr.crossdet;
catch
	disp ('no crossdet convert metadata found. Defaults assumed')
	nof_coor	= min(size(data_in.h.det1.dp, 2), size(data_in.h.det2.dp, 2));
	p_corr_md.data_pointers = {'h.det1.dp(:, ' num2str(nof_coor) ')', ...
								'h.det2.dp(:, ' num2str(nof_coor) ')'};
	p_corr_md.hitnrs		= [1 1];
end

detnrs		= IO.det_nr_from_fieldname(p_corr_md.data_pointer);
detnames	= IO.data_pointer.pointer_2_detnames(p_corr_md.data_pointer);

% fetch momentum data:
for i = 1:length(p_corr_md.data_pointer)
    detnr		= detnrs(i);
	detname		= detnames{i};

	% Check which hit number the user wants to see:
	
	
	% Select the data of this detector:
	dp.(['det' num2str(detnr)]) = IO.read_data_pointer(p_corr_md.data_pointer{i}, data_in);
	
end
% Calculate the correlation between the momentum vectors:
[ angle_rad ] = convert.vector_angle(dp.(['det' num2str(detnrs(1))]), dp.(['det' num2str(detnrs(2))]));

disp(['Log: cross-detector momentum correlation calculated, measured at detector ' num2str(detnrs(1)) ' and ' num2str(detnrs(2))])
end
