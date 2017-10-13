function [ isevent ] = is_event_signal( data_pointer )
%Find whether a signal is a hit or event property from its data pointer:
% Input:
% data_pointer	String with the name of the signal
% Output:
% isevent		boolean whether the signal is an event (true) or not
% (false)
if iscell(data_pointer)
	for i = 1:numel(data_pointer)
		isevent(i) = metadata.data_pointer.is_event_signal(data_pointer{i});
	end
else
	if strcmp(data_pointer(1:2), 'e.') || contains(data_pointer, '.e.')
		isevent = true;
	elseif strcmp(data_pointer(1:2), 'h.') || contains(data_pointer, '.h.')
		isevent = false;
	else
		error(['no valid data pointer given: ' data_pointer ' is not recognized'])
	end
end

end