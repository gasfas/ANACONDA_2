function [ detnames, detnrs, idxs ] = pointer_2_detnames( pointer )
%A simple translation that reads the data pointer string and returns the
%detector names that are mentioned in there. A variable name with 'det' in
%the name is not misinterpreted as a detector.
% Inputs:
% -pointer	String with the pointer to the signal
% Outputs:
% detnames	Cell of strings with the different detector name(s)

% split the pointer into separate cells for each fieldname:
pointer_cell = strsplit(pointer, {'.', ' '});
% Find the detector names: 
IndexC = strfind(pointer_cell, 'det');
detnames = pointer_cell(find(not(cellfun('isempty', IndexC))));
% if the detnames do not have a number at the end, we do not regard it a
% real detector name, but maybe rather a variable name:
detnrs_cell = erase(detnames, 'det');
bool_isdetname = isstrprop(detnrs_cell, 'digit');

for i = 1:length(detnrs_cell)
	if any(~bool_isdetname{i})
		% If we found a 'false' detector name:
		detnames(i) = [];
	end
end
if nargout > 1
	detnrs = IO.detname_2_detnr(detnames);
end

if nargout>2
% Find where we can find the definition of detectors:
	for i = 1:length(detnames)
		idxs(strcmp(detnames,detnames{i})) = strfind(pointer, detnames{i});
	end
end