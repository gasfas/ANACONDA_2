function signal_md = data_pointer_2_md(exp, data_pointer)
% This convenience function creates metadata from data pointers.
% Inputs: 
% exp				The experimental data to read the pointer from
% data_pointer		string character, pointing to the signal. For example: 'e.det1.TOF'.
% Outputs:
% signal_md			The signal_md with the signals added.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Defining the signal metadata

% First, we check the data pointer:
% Try to read the data from the pointer: 
data = general.data.pointer.read(data_pointer, exp);

% Then, we define the signal metadata:
% Histogram data:
signal_md.hist.pointer	= data_pointer;
% We determine the histogram range, such that a large percentage (at least 70%) of the
% data will be within that range. To do so, we calculate the standard deviation and mean:
[data_std, data_mean]	= deal(std(data, 'omitnan'), mean(data, 'omitnan'));
signal_md.hist.Range	= [(data_mean - 1.2*data_std)' (data_mean + 1.2*data_std)'];%  range of the variable.
signal_md.hist.binsize	= diff(signal_md.hist.Range, 1, 2)./500;% binsize of the variable. 
% Axes metadata:
signal_md.axes.XLim		= signal_md.hist.Range;% [ns] XLim of the axis that shows the variable
signal_md.axes.XLabel	= data_pointer_fieldname(data_pointer); %The label of the variable

end
function fieldname = data_pointer_fieldname(data_pointer)
	fields = strsplit(data_pointer, '.');
	fieldname = fields{end};
end