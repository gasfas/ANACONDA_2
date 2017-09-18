function save_exp(exp, dir, b_fn)
% Function to ease the saving of ANACONDA_2 data.
% Input:
%   exp     = The measurement data
%   dir     = the full directory to where the *.mat file should be stored.
%   b_fn    = The bare filename, without extensions or prefixes.

savename = fullfile(dir, [b_fn '.mat']);

save(savename, '-struct', 'exp','-v7.3');

end

