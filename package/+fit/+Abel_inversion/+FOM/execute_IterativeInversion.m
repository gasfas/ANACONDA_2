function execute_IterativeInversion()
% This function calls the IterativeInversion that is situated in the same
% location as this function, along with the needed configuration/data
% files.

% Find the location of the function:
loc = fileparts(mfilename('fullpath'));
oridir = pwd;
cd(loc)

switch ispc
case true
		dos ([loc '\iterative_inversion.exe'])
case false
		system([loc '/iterative_inversion_unix'])
end
cd(oridir)

end