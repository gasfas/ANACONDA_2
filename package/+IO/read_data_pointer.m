function data = read_data_pointer(pointer, exp)
% read data from pointer:
	try data		= eval(['exp.' pointer]);
		% If the given string is not a valid field name, it might
		% be a script, with a signal in it:
	catch data		=  eval(pointer);
	end
end
