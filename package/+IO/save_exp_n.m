function save_exp_n(ds, d_fns)
% Function to ease the saving of mulitple ANACONDA_2 data files.
% Input:
%   ds		= Struct containing fhe measurement datafiles
%   d_fns	= the struct with full directories to where the *.mat file should be stored.


try 
	exp_names		= ds.info.foi;
	numexps			= ds.info.numexps;
catch
	exp_names		= fieldnames(ds);
	numexps			= length(exp_names);
end

for i = 1:numexps
    d		= ds.(exp_names{i});
	fullpath= d_fns.(exp_names{i});
	[path, name] = fileparts(fullpath);
	IO.save_exp(d, path, name)
end
end

