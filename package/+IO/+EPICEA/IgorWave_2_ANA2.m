function [ exp ] = IgorWave_2_ANA2(base_path, filename, varargin)
% Function to import binary IGOR waves into the ANACONDA2 format.
% This function uses python code as provided by tbarillot, imperial
% college, London
% Inputs:
% base_path		string, containing the path to the data-containing folder. 
%				The program expects this directory to contain a configuration 
%				file saved as cfg.txt, along with a further directory called 
%				'rawdata' in which the Igor binary wave files themselves are stored.
% varargin		name - value pairs (optional). Example:
%				IO.EPICEA.IgorWave_2_ANA2('/home/Igordata', '--save-path', '/home/ANA2data')
%				Possible options are:
%				'--save-path'	, the path in which to save the processed data.
%				'--max-n'		, the maximum number of events to be read in, default=all
%				'--n-files'		, the maximum number of Igor binary wave files to be read in (useful for debugging etc.), default=all
%				'--max-ions'(shorthand '-mi'),  maximum number of ions you want to save data for each event, default=4
%				'--max-electrons (shorthand -me)', maximum number of electrons you want to save data for for each event, default=2
%				Note that if the name expects a value, this value should
%				also be given as a string! Example:
%				IO.EPICEA.IgorWave_2_ANA2('/home/Igordata', '--max-n', '1000')
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Find the directory where it is saved, if it already exists:
idx =  general.cell.find_string_in_cell(varargin, '--save-path');
if ~isempty(idx) % In this case, a separate save path is defined
	MAT_path = varargin{idx+1};
else % Otherwise, the file must be saved in the same directory as the IGOR binary:
	MAT_path = base_path;
end

STR = [];
if exist(fullfile(MAT_path, [filename '.mat']), 'file')
	prompt = 'IGOR binary to MAT conversion already performed. Overwrite file?';
	ifdo_conv = input(prompt,'s');
else
	ifdo_conv = 'Y';
end

switch ifdo_conv
	case {'Y', 'y'} % Convert to .mat:
		disp('Conversion starts, this might take a while...')
	IO.EPICEA.IgorWave_2_MAT(base_path, varargin);
	delete(fullfile(MAT_path, 'data.npz'));
	movefile(fullfile(MAT_path, 'data.mat'), fullfile(MAT_path, [filename '.mat']))
end

%% Convert to ANACONDA 2 format
exp = IO.EPICEA.Imperial_2_ANA2(MAT_path, filename);

end