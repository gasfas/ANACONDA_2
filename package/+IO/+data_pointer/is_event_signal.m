function [ isevent ] = is_event_signal( data_pointer )
%Find whether a signal is a hit or event property from its data pointer:
% Input:
% data_pointer	String with the name of the signal
% Output:
% isevent		boolean whether the signal is an event (true) or not
% (false)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if iscell(data_pointer) % if more data pointers are given, run this function on each pointer:
	for i = 1:numel(data_pointer)
		isevent(i) = IO.data_pointer.is_event_signal(data_pointer{i});
	end
else % Only one data pointer to be read:
	% See if some landmark strings can be found in the pointer:
	if strcmp(data_pointer(1:2), 'e.') || contains(data_pointer, '.e.') || contains(data_pointer, 'select_only_hit_')
		isevent = true;
	elseif strcmp(data_pointer(1:2), 'h.') || contains(data_pointer, '.h.')
		isevent = false;
	else
		error(['no valid data pointer given: ' data_pointer ' is not recognized'])
	end
end

end