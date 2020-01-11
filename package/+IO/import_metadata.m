function [exp_md, simu_md, th_md] = import_metadata (filename)
%  This macro imports the metadata from a filename.
%  Input:
% filename  The directory and filename to the metadatafile of interest.
%           If no file extension is given, a MAT file is searched. if no
%           MAT file is found, a .m script is attempted to be loaded.
% Output:
% exp_md	struct, The experimental metadata
% simu_md	struct, The simulation metadata (if it exists)
% th_md	struct, The theory metadata (if it exists)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[dir, file, ext] = fileparts(filename);

 try 
	 is_md_prefix = strcmp(file(1:3), 'md_');
 catch
	 is_md_prefix = false;
 end
 if ~is_md_prefix
	file = ['md_' file];
 end

switch ext % If the extension is a known one, we try those:
	case '.mat'
		[exp_md, simu_md, th_md] = load_mat(fullfile(dir, [file ext]));
	case '.m'
		[exp_md, simu_md, th_md] = load_script(dir, file);
	otherwise % Otherwise we try two extensions (.mat and then .m): 
		try [exp_md, simu_md, th_md] = load_mat(fullfile(dir, [file '.mat']));
		catch [exp_md, simu_md, th_md] = load_script(dir, file);
		end
end
end

% Local functions	
function [exp_md, simu_md, th_md] = load_script(dir, file)
% load a '.m' script:
	exp_md = []; simu_md = []; th_md = [];
	homedir = pwd;
	cd(dir)
	run(fullfile(dir, file));
	cd(homedir)
% 	A = general.handle.function_handle(fullfile(dir, [file '.m']));
% 	A();
 end
 
function [exp_md, simu_md, th_md] = load_mat(filename)
% Load a '.mat' file:
	exp_md = []; simu_md = []; th_md = [];
	load(filename)
 end
	