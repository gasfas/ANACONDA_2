function [exps, mds] = load_treat_save(filenames, procedure_spec, savenames)
% macro to correct, convert and fit (if requested) the data, and save it to
% a new (or existing) datafile. 
% Inputs:
% filenames		Struct containing the filenames of the experimental files 
%				the macro should read.
% procedure_spec The procedure the user wants to execute
% savenames		The names to save the experimental datafile to
%
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% import the files:
[exps] = IO.import_raw_n(filenames);
% import the metadata:
[mds] = IO.import_metadata_n(filenames);

% treat the data:

try 
	exps = macro.all_n(exps, mds, procedure_spec);
catch
	exps = macro.all_n(exps, mds);
end

% save the data:
try 
	IO.save_exp_n(exps, savenames);
catch
	IO.save_exp_n(exps, filenames);
end