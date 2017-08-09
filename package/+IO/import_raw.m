function [exp] = import_raw (filename)
%  This macro imports the data from a filename.
%  input:
% filename  The directory and filename to the datafile of interest.
%           If a DLT file is given, a MAT file is searched in the same
%           folder. If a MAT file is not found, the DLT file is converted 
%           and saved as .MAT file.

[dir, file] = fileparts(filename);

if      exist(fullfile(dir, [file '.mat']), 'file')
	% load mat files:
	exp = IO.load_exp(dir, file);
    
elseif  exist(fullfile(dir, [file '.dlt']), 'file')
    dltfilename         = fullfile(dir, [file '.dlt']);
	[exp]               = IO.DLT_2_ANA2(dltfilename);
	IO.save_exp(exp, dir, file);
    
else
    error(['no file found in either dlt or mat format of file ' filename])
end

end
