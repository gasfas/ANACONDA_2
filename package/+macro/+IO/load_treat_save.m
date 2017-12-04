function [] = load_treat_save(filenames, procedure_spec, savename)
% macro to correct, convert and fit (if requested) the data, and save it to
% a new (or existing) datafile. 

% import the files:
[exps] = IO.import_raw_n(filenames);
% import the metadata:
[mds] = IO.import_metadata_n(filenames);

% treat the data:
try macro.all_n(exps, mds, procedure_spec)
catch macro.all_n(exps, mds); end

% save the data:
IO.save_exp_n(exps, filenames);