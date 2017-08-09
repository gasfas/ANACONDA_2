function fit_param = load_fit_param(dir, b_fn)
% Function to ease the loading of ANACONDA_2 fit parameters.
% Input:
%   dir     = the full directory from where the *.mat file should be loaded.
%   b_fn    = The bare filename, without extensions or prefixes.
% Output:
%   exp     = The measurement data

loadname    = fullfile(dir, [b_fn '_fit_param.mat']);
% data        = load(loadname, 'exp');
% exp         = data.exp;
fit_param         = load(loadname);

% TODO: for now, only the data can be stored, not the metadata.
end