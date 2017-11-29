function [ detnr ] = detname_2_detnr( detname )
%A simple translation from internal detector name to detector number
% If detname is a cell of detector names, an array of detectornumbers is returned.
if iscell(detname)
	detnr = zeros(length(detname),1);
	for i = 1:length(detname)
		detnr(i) = IO.detname_2_detnr(detname{i});
	end
else
	if detname(1:3) == 'det'
		detnr = str2num(detname(4:end));
	else
		error('name not recognized')
	end
end

