function exp = import_example(datadir, filename)
% This function shows a simple example on how to import data from the
% EPICEA spectrometer (PLEIADES, Soleil).
% Inputs:	
% datadir	The path where a EPICEA ASCII file can be found (optional)
% filename	The name of the EPICEA ASCII file (optional)
% Outputs:
% exp		The data struct.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% If the user does not provide a file it wants to open, we load the example
% file included in the ANACONDA package:
isdummy = false;
if ~exist('datadir', 'var')
	disp('no data given, dummy data file imported instead')
	% Find where the package is located:
	Fulldir		= mfilename('fullpath');
	[datadir]		= fileparts(Fulldir);
	% example data is located in subfolder:
	datadir = fullfile(datadir, '+EXAMPLE_ASCII');
	filename = 'dummy';
	isdummy = true;
end

%% Convert to ANA2 format from ASCII textfile:
exp = IO.EPICEA.convert_2_ANA2(datadir, filename);

end