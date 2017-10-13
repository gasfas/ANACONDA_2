function signal_md = data_pointer_2_md(exp, data_pointer)
% This convenience function creates metadata from data pointers.
% Inputs: 
% exp				The experimental data to read the pointer from
% data_pointer		string character, pointing to the signal. For example: 'e.det1.TOF'.
% Outputs:
% signal_md			The signal_md with the signals added.

%% Defining the signal metadata

% First, we check the data pointer:
% Try to read the data from the pointer: 
data = IO.read_data_pointer(data_pointer, exp);

% Then, we define the signal metadata:
% Histogram data:
signal_md.hist.range	= [min(data, [], 1)' max(data, [], 1)'];%  range of the variable.
signal_md.hist.binsize	= diff(signal_md.hist.range, 1, 2)./100;% binsize of the variable. 
% Axes metadata:
signal_md.axes.XLim		= [0 1e5];% [ns] XLim of the axis that shows the variable
signal_md.axes.XLabel	= data_pointer_fieldname(data_pointer); %The label of the variable

end
function fieldname = data_pointer_fieldname(data_pointer)
	fields = strsplit(data_pointer, '.');
	fieldname = fields{end};
end