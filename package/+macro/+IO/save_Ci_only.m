function save_Ci_only(filename_read, C_nr, detnames, filename_write)
%This Function accepts a reference to a datafile, opens it, identifies the
%Ci (i = 1 (single), 2 (double), 3 (triple)) coincidence events, 
% filters them out, and saves it to a new file.
%The writing of the metadata file is done in a similar way.
% Input
% filename_read     (char) The filename to the original file to be read
% filename_write    (optional) The filename to which the program writes the
%                   new experiment. Note: if no name is specified,
%                   filename_write is determined by adding a
%                   postscript '_Ci' to filename_read.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se


%% Load data:

[exp]           = IO.import_raw(filename_read); 
[md]			= IO.import_metadata(filename_read);

%% save the original, untreated data:

exp_ori = exp;

%% fetch the Ci event filter:

exp			= macro.filter(exp, md);
e_f			= true(size(exp.e.raw,1),1);
f_Ci		= false(size(exp.e.raw,1),1);

if ~iscell(detnames); detnames = {detnames}; end

for i = 1:length(detnames)
	detname		= detnames{i};	
	for j = 1:length(C_nr)
		 f_Ci = f_Ci | exp.e.(detname).filt.(['C' num2str(C_nr(j))]);
	end
	e_f		= e_f & f_Ci;
end

%% Create the new experiment struct:
nof_hits  = general.data.count_nof_hits(exp_ori.h);
[ exp_f ] = filter.exp(exp_ori, e_f, nof_hits);

%% write to the new file:
if exist('filename_write', 'var')
    [pathstr,writename] = fileparts(filename_write);
else
    [pathstr,writename] = fileparts(filename_read);
	for j = 1:length(C_nr)
		writename = [writename '_C' num2str(C_nr(j),1)];
	end
end

IO.save_exp(exp_f, pathstr, writename)

end