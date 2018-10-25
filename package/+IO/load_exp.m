function exp = load_exp(dir, b_fn)
% Function to ease the loading of ANACONDA_2 data.
% Input:
%   dir     = the full directory from where the *.mat file should be loaded.
%   b_fn    = The bare filename, without extensions or prefixes.
% Output:
%   exp     = The measurement data
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

loadname    = fullfile(dir, [b_fn '.mat']);
% data        = load(loadname, 'exp');
% exp         = data.exp;
exp         = load(loadname);

% TODO: for now, only the data can be stored, not the metadata.
end