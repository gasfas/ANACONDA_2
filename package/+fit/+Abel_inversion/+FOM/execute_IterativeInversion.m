function execute_IterativeInversion()
% This function calls the IterativeInversion that is situated in the same
% location as this function, along with the needed configuration/data
% files.
%
% Routine developed by FOM research institute, Amsterdam.
% Shell written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Find the location of the function:
loc = fileparts(mfilename('fullpath'));
oridir = pwd;
cd(loc)

% The command depends on the operating system:
switch ispc
case true % Windows command
		dos ([loc '\iterative_inversion.exe'])
case false % Other:
		system([loc '/iterative_inversion_unix'])
end
cd(oridir)

end