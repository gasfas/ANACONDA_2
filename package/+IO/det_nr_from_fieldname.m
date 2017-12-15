function [det_nr] = det_nr_from_fieldname(fieldname)
%This convenience function fetches the detector number from a fieldname in
%which it is defined (string).
if iscell(fieldname) % this means that the input is a list of fieldnames:
	for i = 1:length(fieldname)
		det_nr(i) = IO.det_nr_from_fieldname(fieldname{i});
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
