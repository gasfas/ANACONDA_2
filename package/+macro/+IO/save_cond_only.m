function save_cond_only(filename_read, cond, filename_write)
% This Function accepts a reference to a datafile, opens it, identifies the
% the events satisfying the given conditions, filters them out, and saves it to a new file.
% The writing of the metadata file is done in a similar way.
% Input
% filename_read     (char) The filename to the original file to be read
% filename_write    (optional) The filename to which the program writes the
%                   new experiment. Note: if no name is specified,
%                   filename_write is determined by adding a
%                   postscript '_Ci' to filename_read.

%% Load data:

[exp]           = IO.import_raw(filename_read); 
[metadata]      = IO.import_metadata(filename_read);

%% save the original, untreated data:

exp_ori = exp;

%% fetch the event filter, as defined by the condition:

exp        = macro.correct(exp, metadata);
exp        = macro.convert(exp, metadata);
exp        = macro.filter(exp, metadata);

f_e			= macro.filter.conditions_2_filter(exp, cond);
nof_hits	= IO.count_nof_hits(exp.h);

%% Create the new experiment struct:

[ exp_f ] = filter.exp(exp_ori, f_e, nof_hits);

%% write to the new file:
if exist('filename_write', 'var')
    [pathstr,writename] = fileparts(filename_write);
else
    [pathstr,writename] = fileparts(filename_read);
    writename = [writename '_cond'];
end

IO.save_exp(exp_f, pathstr, writename)

end