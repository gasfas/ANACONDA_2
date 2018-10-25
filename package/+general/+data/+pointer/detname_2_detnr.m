function [ detnr ] = detname_2_detnr( detname )
%A simple translation from internal detector name to detector number
% If detname is a cell of detector names, an array of detectornumbers is returned.
% Inputs: 
% detname	char (or cell of chars) with the detector name
% Outputs:
% detnr		scalar (or array) of detector numbers of the given detector
% name.
% Example:
% detnr = detname_2_detnr('det2')
% detnr =
%			2
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if iscell(detname)
	detnr = zeros(length(detname),1);
	for i = 1:length(detname)
		detnr(i) = general.data.pointer.detname_2_detnr(detname{i});
	end
else
	if detname(1:3) == 'det'
		detnr = str2num(detname(4:end));
	else
		error('name not recognized')
	end
end

