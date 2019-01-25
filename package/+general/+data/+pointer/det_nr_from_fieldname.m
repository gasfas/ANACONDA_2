function [det_nr] = det_nr_from_fieldname(fieldname)
%This convenience function fetches the detector number from a fieldname in
%which it is defined (string).
% Inputs:
% fieldname		The name of the (data pointer) field name
% Outputs:
% det_nr		scalar, the detector number of the specified field.
% Example:
% detnr = det_nr_from_fieldname('e.det1.raw(:,3)')
% dentr = 
%			1
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if iscell(fieldname) % this means that the input is a list of fieldnames:
	for i = 1:length(fieldname)
		det_nr(i) = general.data.pointer.det_nr_from_fieldname(fieldname{i});
	end
else
	% Find where the detector is mentioned in the string:
	det_prefix = 'det';
	st_idx      = strfind(fieldname,'det') + length(det_prefix);
	if any(strfind(fieldname, '.'))
		end_idx     = strfind(fieldname(st_idx(1):end), '.') - 2 + st_idx(1);
	else
		end_idx = length(fieldname);
	end
	det_nr      = str2double(fieldname(st_idx(1):end_idx(1)));
end

end
