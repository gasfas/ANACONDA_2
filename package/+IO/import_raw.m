function [exp] = import_raw (filename)
%  This macro imports the data from a filename.
%  input:
% filename  The directory and filename to the datafile of interest.
%           If a DLT file is given, a MAT file is searched in the same
%           folder. If a MAT file is not found, the DLT file is converted 
%           and saved as .MAT file.
% Output:
% exp		The experimental data, in ANACONDA_2 format.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~strcmpi(filename(end-3:end), '.mat') && ~strcmpi(filename(end-3:end), '.dlt') ...
     && ~strcmpi(filename(end-4:end), '.hdf5')
	filename = [filename '.mat'];
end

[dir, file, ext] = fileparts(filename);

if  exist(fullfile(dir, [file '.mat']), 'file')
	% load mat files:
	exp = IO.load_exp(dir, file);
    
elseif  exist(fullfile(dir, [file '.dlt']), 'file') % Labview DLT file
    dltfilename         = fullfile(dir, [file '.dlt']);
	[exp]               = IO.DLT_2_ANA2(dltfilename);
	IO.save_exp(exp, dir, file);
elseif exist(fullfile(dir, [file '.hdf5']), 'file') % Maxlab HDF5 file
    [exp]               = IO.MAXIV_HDF5.HDF5_2_ANA2(dir, file);
    IO.save_exp(exp, dir, file);
% elseif TODO: automize EPICEA import as well.
else
    error(['no file found in either dlt or mat format of file ' filename])
end


end
