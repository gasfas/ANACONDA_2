function exp = import_example(datadir, filename)
% This function shows a simple example on how to import data from the
% DLT data format.

% If the user does not provide a file it wants to open, we load the example
% file included in the ANACONDA package:
isdummy = false;
if ~exist('datadir', 'var')
	disp('no data given, dummy data file imported instead')
	% Find where the package is located:
	Fulldir		= mfilename('fullpath');
	[datadir]		= fileparts(Fulldir);
	% example data is located in subfolder:
	datadir = fullfile(datadir, '+EXAMPLE_DLT');
	filename = 'dummy.dlt';
	isdummy = true;
end

%% Convert to ANA2 format from ASCII textfile:
exp = IO.DLT_2_ANA2(fullfile(datadir, filename));

end