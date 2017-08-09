function save_fit_param(exp, dir, b_fn)
% Function to ease the saving of ANACONDA_2 fit parameters.
% Input:
%   fit_param   The fitting parameters
%   dir         The full directory to where the *.mat file should be stored.
%   b_fn        The bare filename, without extensions or prefixes.

savename = fullfile(dir, [b_fn '_fit_param.mat']);

tic; save(savename, '-struct', 'exp'); toc
% tic; IO.savefast([savename '_fast'], 'exp'); toc
% save(savename, 'exp');

% TODO: for now, only the data can be stored, not the metadata.
end

