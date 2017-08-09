function [ detnr ] = fetch_det_nr( data_pointer )
%Find which detector the signal coming from, from its data pointer:
% Input:
% data_pointer	String with the name of the signal
% Output:
% isevent		boolean whether the signal is an event (true) or not
% (false)
% Find the positions of the dots:
dot_pos = findstr(data_pointer, '.');
detname = data_pointer(dot_pos(1)+1:dot_pos(2)-1);
detnr = IO.detname_2_detnr(detname);
end

