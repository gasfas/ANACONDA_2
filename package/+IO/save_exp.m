function save_exp(exp, dir, b_fn)
% Function to ease the saving of ANACONDA_2 data.
% Input:
%   exp     = The measurement data
%   dir     = the full directory to where the *.mat file should be stored.
%   b_fn    = The bare filename, without extensions or prefixes.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[~, ~, ext] =  fileparts(b_fn);

if strcmpi(ext, '.mat')
	savename = fullfile(dir, b_fn);
else
	savename = fullfile(dir, [b_fn '.mat']);
end

save(savename, '-struct', 'exp','-v7.3');

end

