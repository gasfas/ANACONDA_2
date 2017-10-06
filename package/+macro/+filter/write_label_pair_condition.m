function c = write_label_pair_condition(varargin)
% function c = write_label_pair_condition(data_pointer, value, translate_condition)
% This function makes the writing of a condition shorter, in case there are
% multiple signals and corresponding properties.
% Input:
%	data_pointer	cell (or single string) which point to a signal. Example:
%	'h.det1.m2q_l'
%	value			cell of arrays (or single array) that gives the
%					value(s) the label(s) can have. Example: [14] (nitrogren)
%	translate_condition (optional) if a hit signal is given, how is the hit
%					filter translated to an event filter?

% give it understandable names:
data_pointer	= make_cell(varargin{1});
value			= make_cell(varargin{2});
if length(varargin) > 2 
	translate_condition = varargin{3};
end

signal_names = cell(length(data_pointer), 1);
for i = 1:length(data_pointer)
	% Make names for the signals:
	signal_names{i} = select_signal_name(data_pointer{i});
	signal_names{i} = [signal_names{i} '_' num2str(value{i})];
	% Check if the name is already taken:
	if i > 1
		signal_name_ori = signal_names{i}; j = 2;
		while any(strcmp(signal_names{i}, signal_names(1:i-1)))
			signal_names{i} = [signal_name_ori '_v' num2str(j)];
			j = j + 1;
		end
	end
	
	% Assign the values to the condition:
	c.(signal_names{i}).data_pointer	= data_pointer{i};
	c.(signal_names{i}).value			= value{i};
	if exist('translate_condition', 'var')
		c.(signal_names{i}).translate_condition = translate_condition{i};
	end
	c.(signal_names{i}).type			= 'discrete';
end
end

function signal_name = select_signal_name(data_pointer)
	% select the name after the last dot:
	dot_pos = strfind(data_pointer, '.');
	signal_name = data_pointer(dot_pos(end)+1:end);
end

function varargout = make_cell(varargin)
% turn object to cells, if they are not:
varargout = cell(size(varargin));
for i = 1:length(varargin)
	if ~iscell(varargin{i})
		varargout{i} = {varargin{i}};
	else 
		varargout{i} = varargin{i};
	end
end
end