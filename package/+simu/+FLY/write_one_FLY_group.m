function [settings] = write_one_FLY_group(settings, nop, mass, charge, ke, el, color, group_nr, fid)
% this function writes one FLY group with a specified kinetic energy (ke)
% and elevation angle (el) to the file with identifier fid.

average =                   settings.FLY.average;
stdevs =                    settings.FLY.stdevs;

 fprintf(fid, '\t standard_beam { \r\n'); 
 fprintf(fid, '\t\t ke = %f , -- kinetic energy [eV] \r\n',                ke);
 fprintf(fid, '\t\t mass = %f , -- particle mass [amu] \r\n',              mass);
 fprintf(fid, '\t\t charge = %f , -- elementary charge \r\n',              charge);
 fprintf(fid, '\t\t el = %f , -- elevation (polar) angle [deg]\r\n',       el);
 fprintf(fid, '\t\t az = %f , -- azimuthal angle [deg]\r\n',               settings.FLY.az);
 fprintf(fid, '\t\t cwf = %f , -- ?? [deg]\r\n',                           settings.FLY.cwf);
 fprintf(fid, '\t\t tob = %f , -- time of birth [usec]    \r\n',           settings.FLY.tob);
 fprintf(fid, '\t\t color = %f , -- color code    \r\n',                   color);
 i = 1;
 if strcmp(settings.FLY.DistributionType, 'Gaussian')
     fprintf(fid, '\t\t n = %f , -- number of particles \r\n',                 nop);
     for coordinate = ['x' 'y' 'z'];
         fprintf(fid, ['\t\t ' coordinate ' = gaussian_distribution {mean = %f , stdev = %f }, -- particle position distribution in ' coordinate ' direction \r\n'], average(i),  stdevs(i));
        i = i + 1;
     end
 elseif strcmp(settings.FLY.DistributionType, 'Cuboid')
     nof_cuboid_coordinates = 0; % the number of directions in which user wants a finite size.
     for coordinate = ['x' 'y' 'z'];
         if stdevs(i) ~= 0
            fprintf(fid, ['\t\t ' coordinate ' = sequence {%f, %f}, -- particle position distribution in ' coordinate ' direction \r\n'], average(i)-stdevs(i), average(i)+stdevs(i));
            nof_cuboid_coordinates = nof_cuboid_coordinates + 1;
         elseif stdevs(i) == 0
             fprintf(fid, ['\t\t ' coordinate ' = %f, -- particle position in ' coordinate ' direction \r\n'], average(i));
         end
         i = i + 1;
     end
%      this changes the number of particles:
     nop = 2^(nof_cuboid_coordinates);
 end
 
fprintf(fid, '\t }, \r\n');

% we write some fly_info, for later:
settings.FLY.fly.group_nr(group_nr) =                                              group_nr;
settings.FLY.fly.Ion_N_start(group_nr) =                                           nop*(group_nr-1)+1;
settings.FLY.fly.Ion_N_end(group_nr) =                                             settings.FLY.fly.Ion_N_start(group_nr) + nop-1;
settings.FLY.fly.ke(group_nr) =                                                    ke;
settings.FLY.fly.el(group_nr) =                                                    el;
settings.FLY.fly.nof_particles_per_group(group_nr) =                               nop;

end

