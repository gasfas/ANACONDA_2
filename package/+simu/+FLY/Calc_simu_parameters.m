function [ simu ] = Calc_simu_parameters( simu )
% This function calculates the simulation parameters from the settings
% given in the input struct 'settings'.

% in case we loop over the elevation angle:
if simu.loop_el == 1;
    simu.el =               linspace(simu.el_start, simu.el_end, simu.el_nof_loops);
end
% in case we loop over the kinetic energy:
if simu.loop_ke == 1;
    simu.ke =               linspace(simu.ke_start, simu.ke_end, simu.ke_nof_loops);
end
end

