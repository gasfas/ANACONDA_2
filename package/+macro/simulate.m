function [ simu_data ] = simulate( simu_md )
% This macro function performs a SIMION simulation.
% Input:
% simu_md   The simulation metadata struct, defining the geometry and simulation
%           parameters 
% Output:
% simu      The output simulated data (events and hits)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Fetch all the directories of the rundir files:
simu_md.WB              = simu.rundir.all_WBnames(simu_md.WB);

%% Preparing files (if GEM file has changed)
% Write a GEM file:
simu_md                 = simu.GEM.write_GEM_file(simu_md, simu_md.WB.GEM);
% % convert the GEM file to a PA file:
% simu.rundir.SIMION_cmd(simu_md, 'gem2pa')
% % now we can refine the new GEM file into a set of PA files:
% simu.rundir.SIMION_cmd(simu_md, 'refine')
% pause('save the IOB file with SIMION')
%% Preparing files
% Write a user program LUA file:
simu_md                 = simu.FLY.write_lua_file(simu_md);
% Write a FLY2 file:
simu_md                 = simu.FLY.write_FLY2(simu_md);

%% simulate and fetch data:
[simu_data, simu_md]    = simu.FLY.run_simulation(simu_md);
% simu_data = [];
end

