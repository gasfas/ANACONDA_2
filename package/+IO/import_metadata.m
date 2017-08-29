function [exp_md, simu_md, th_md] = import_metadata (filename)
 %  This macro imports the metadata from a filename.
 %  input:
% filename  The directory and filename to the metadatafile of interest.
%           If no file extension is given, a MAT file is searched. if not
%           MAT file is found, a .m script is attempted to be loaded.
 
 [dir, file, ext] = fileparts(filename);

 if ~strcmp(file(1:3), 'md_')
     file = ['md_' file];
 end

switch ext % If the extension is a known one, we try those:
	case '.mat'
		[exp_md, simu_md, th_md] = load_mat(filename);
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
	basedir = pwd;
	cd (dir)
	run(fullfile(dir, file));
	cd(basedir)
 end
 
function [exp_md, simu_md, th_md] = load_mat(filename)
% Load a '.mat' file:
	exp_md = []; simu_md = []; th_md = [];
	load(filename)
 end
	