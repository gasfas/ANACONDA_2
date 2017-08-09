function [ nof_misses, nof_traps ] = Calc_nof_misses_traps( SIMU_data )
%This function calculates the number of missed ion trajectories (the ones
%that didn't end up at the detector) or trapped ions (ions with such a large
%TOF(>Ridiculously large TOF) that the simulation was stopped by the program)
%   Detailed explanation goes here
nof_misses = 0; nof_traps = 0;
for i = 1:size(SIMU_data, 1)
    for j = 1:size(SIMU_data, 2)
        nof_misses = nof_misses + SIMU_data(i,j).nofmisses;
        nof_traps = nof_traps + SIMU_data(i,j).noftraps;
    end
end

end

