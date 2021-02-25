function [] = IgorWave_2_MAT(base_path, varargin)
% Function to convert binary IGOR waves to the MAT format.
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
%				'--max-ions'(shorthand '-mi'),  maximum number of ions you want to save data for for each event, default=4
%				'--max-electrons (shorthand -me)', maximum number of electrons you want to save data for for each event, default=2
%				Note that if the name expects a value, this value should
%				also be given as a string! Example:
%				IO.EPICEA.IgorWave_2_ANA2('/home/Igordata', '--max-n', '1000')

args = general.cell.unpack_cell_recurse(varargin);

%% Convert to .mat
d = [reshape(args, 1, numel(args)); repmat({'  '},1,numel(args))];
optional_argumentstr = [d{:}];
% pyv = pyversion;

% Run the IGOR binary wave to .MAT conversion
% system(['python' pyv ' ' mfilename('fullpath'), '.py --name ' base_path ' ' optional_argumentstr]);
system(['py' ' ' mfilename('fullpath'), '.py --name ' base_path ' ' optional_argumentstr]);

end