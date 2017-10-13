function isevent = is_event_pointer(pointer)
% This function determines whether a given pointer points to an event
% property or not.
if iscell(pointer)
	for i = 1:numel(pointer)
		isevent(i) = IO.is_event_pointer(pointer{i});
	end
else
	isevent = any(strfind(pointer, '.e.'));
end
