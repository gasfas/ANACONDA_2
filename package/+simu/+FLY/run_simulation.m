function [SIMU_data, settings] = run_simulation(settings)
% [SIMU_data] = run_simulation(settings)
% executes a simulation according to the user-supplied settings.

% The values simu_el, simu_ke are in principal treated as arrays,
% and all combinations will be flied. (to read and change these values
% permanently, see simu_parameters.m)
% List of sequential actions in this function:
%   write a new fly file
%   fly the particles
%   read the output datafile, return the data in a struct named SIMU_data

% We also want to have info about the GEM-file we are simulating with:
if ~isfield(settings.GEM,'data')
    settings = read_GEM_file(settings, settings.WB.GEM);
end

% before we simulate, we should check if there is a FLY file available
% under the expected name:
if ~exist(settings.WB.FLY2, 'file')
    warning('the FLY file did not exist, but is automatically created')
    write_FLY2(settings);
end

delete(settings.WB.FLYoutput);

% now that the correct parameters are set, we can fly the sh*t out of it:
simu.rundir.SIMION_cmd(settings, 'fly');

% read the output data:
SIMU_data = simu.FLY.read_fly_output_ANA2(settings);

delete(fullfile(settings.WB.basedir, '*.tmp'));

end
