function merged_exp = save_Ci_only(varargin)
% GUI function that saves certain coincidence of a measurement only.
% If no filename is specified, the function will open a file browser for
% the user to select the files manually.
% Inputs:
% exp_names		(optional) struct of which fields contain the name(s) of the (dlt or mat) files
% to be merged, or the actual struct containing the data. If the actual
% data is given, the second expected input is the metadata.
% Outputs:
% merged_exp	(optional) the merged experiments
% Example:
% GUI.load.IO.merge_and_save_exp(exps, {'', ''}) will merge file 1 and 2.
% exps could be a struct with: exps.exp1 = '/home/user/file1.dlt' and 
% exps.exp2 = '/home/user/file2.mat';
% Or it could be: exps.exp1 is the experimental data of measurement 1(contains e and h
% field) and exps.exp2 is the experimental data of measurement 2.

%% Data fetching
% Check whether an experimental name is specified:
if nargin > 0 % yes, it is specified:
	% Fetch the internal names
	exp_names = varargin{1};
	exp_int_names = fieldnames(exp_names);
	if isfield(exp_names.(exp_int_names{1}), 'e') % The actual data is given:
		try exp_names		= rmfield(exp_names, 'info'); end
		[exps_data]			= exp_names; 
		[exps_metadata]		= varargin{2};
		default_savename	= create_merged_default_name(exp_names, 'name');
	else % The names to the data is given
		if length(varargin) > 1
			save_name = varargin{2};
		end
	end
else % no file specified, so we load the file explorer:
	exp_names_cell	= general.UI.uipickfiles('Prompt', 'Select Files to merge', 'FilterSpec', pwd);
	% Change from (cell) format to struct format:
	exp_names		= change_fieldname_format(exp_names_cell);
end

if ~exist('exps_data', 'var')
	% Load the files to memory:
		[exps_data]			= IO.import_raw_n(exp_names); 
		default_savename	= create_merged_default_name(exp_names, 'value');
end

%% Merge the files:
[ merged_exp ] = IO.merge_exp(exps_data);

%% Save the files:
[FileName,PathName] = uiputfile(pwd,'Specify path and name to save the merged file to', default_savename);
IO.save_exp(merged_exp, PathName, FileName)

end
%% Subfunctions
function exp_names_struct = change_fieldname_format(exp_names_cell)
	for i = 1:length(exp_names_cell)
		exp_names_struct.(['exp' num2str(i)]) = exp_names_cell{i};
	end
end

function default_name = create_merged_default_name(exp_names, nametype)
	default_name = '';	
	fieldnames_exps = fieldnames(exp_names);
	for i = 1:length(fieldnames_exps)
		% Select only the bare filename:
		switch nametype
			case 'value'
				[~, b_fn] = fileparts(exp_names.(fieldnames_exps{i}));
			case 'name'
				b_fn = fieldnames_exps{i};
		end
				
		if i ==1
			default_name = [default_name b_fn];
		else 
			default_name = [default_name '_' b_fn];
		end
	end
	default_name = [default_name];
end
