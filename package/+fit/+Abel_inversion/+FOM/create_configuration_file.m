function create_configuration_file(conf_struct)
% This function writes a configuration file for the FOM iterative Abel inversion code, from a given struct.
% The configuration file will be written in the same directory as the
% location of this function.
% inputs:
% fit_md 	The structure containing the configuration information in the fields: 
		% Symmetry: Symmetry used in computation. Default = 0
		% itermode  	% itermode = 1: do itmax iterations. 
				% itermode = 2: stop the iterations when the absolute sum difference between successive iterations stops decreasing
		%		% itermode = 3: stop the iterations when the relative sum difference between successive iterations stops decreasing (the maximum no. of iterations is itmax)
		% itmax: 	the highest number of iterations that the program can make. Default = 50;
		% radfac:		Correction factor radial iteration. Default = 1
		% angfac:		Correction factor angular iteration. Default = 1
		% filenumber	number of the input datafile. Default = 1;
		% SampleName: 	Name. Default = 'AbelInversion';
		% ImageSize: 	The x, and y-size. Default = [1000, 1000];
%
% Routine developed by FOM research institute, Amsterdam.
% Shell written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Define the defaults, fill in the missing values:
		
def.Symmetry	= 0;
def.itermode	= 1;
def.itmax		= 10;
def.radfac		= 1; 
def.angfac		= 1; 
def.filenumber	= 1;
def.SampleName	= 'Neon';
def.ImageSize	= [1000 1000];

% fill up conf_struct with whichever field is missing:
conf_struct = general.struct.catstruct(def, conf_struct);

%% write the file to the inversion directory:
 % we first create a new file
fid = fopen(fullfile(fileparts(mfilename('fullpath')), 'names.dat'), 'w');
% and we write the configuration data:
% First line:
fprintf(fid, ['    ' num2str(int16(conf_struct.Symmetry))]);
fprintf(fid, ['    ' num2str(int16(conf_struct.itermode))]);
fprintf(fid, ['   ' num2str(int16(conf_struct.itmax))]);
fprintf(fid, ['  ' num2str(conf_struct.radfac,'%0.6f')]);
fprintf(fid, ['  ' num2str(conf_struct.angfac,'%0.6f')]);
fprintf(fid, ['\n']);
% Second line:
fprintf(fid, ['    ' num2str(int16(conf_struct.filenumber))]);
fprintf(fid, [' ' conf_struct.SampleName]);
fprintf(fid, ['\n']);
% Third line:
fprintf(fid, [' ' num2str(int16(conf_struct.ImageSize(1))) ' ' num2str(int16(conf_struct.ImageSize(2)))]);

 % close the file:
 fclose(fid);