function save_exp(exp, dir, b_fn)
% Function to ease the saving of ANACONDA_2 data.
% Input:
%   exp     = The measurement data
%   dir     = the full directory to where the *.mat file should be stored.
%   b_fn    = The bare filename, without extensions or prefixes.

savename = fullfile(dir, [b_fn '.mat']);

tic; save(savename, '-struct', 'exp'); toc
% tic; IO.savefast([savename '_fast'], 'exp'); toc
% save(savename, 'exp');

% TODO: for now, only the data can be stored, not the metadata.
end

