function [settings] = write_GEM_file(settings, GEMfilename)
% This script writes the .gem files for the user-requested values, GEM_data.
% to the input argument 'filename':
% write_GEM_file(filename, GEM_data);
% Electrode is abbreviated to 'el' in some names.
% Potential is abbreviated to 'pot' in some names.
% some values are assumed to be constant, such as the pa_define arguments
% and locate arguments. this should be easily extendable in the future, if
% needed, but for the moment seems to be unnecessary. These 'default'
% values are listed in the m-file GEM_parameters.m:

% we first create a new GEM-file:
     fid = fopen(GEMfilename, 'w');
     % and then we write it in a way SIMION understands it:
     fprintf(fid, '; GEM file, automatically created from the MATLAB function write_GEM_file. \r\n');
     fprintf(fid, '; written on: [Year month day hour min sec] \r\n');
     fprintf(fid, ['; ' num2str(clock) '\r\n']);
     fprintf(fid, ['pa_define(%.0f, %.0f, %.0f, ' settings.GEM.pa_define_Sym ', ' settings.GEM.pa_define_Mirror ', ' settings.GEM.pa_define_Type ') \r\n'], settings.GEM.pa_define_nx, settings.GEM.pa_define_ny, settings.GEM.pa_define_nz);
     fprintf(fid, 'locate (%.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f) \r\n', settings.GEM.locate_x, settings.GEM.locate_y, settings.GEM.locate_z, settings.GEM.locate_scale, settings.GEM.locate_az, settings.GEM.locate_el, settings.GEM.locate_rt);
     fprintf(fid, '{ \r\n');
     
    %here we write out the text needed for every elektrode:
    simu.GEM.write_elektrode_to_GEM_file(settings.GEM.data, fid);
    if settings.GEM.data.fixed_geom == 1
        % now we come to the part where we describe the extraction region
        % elektrodes and the ion grid, needed to simulate all electrons
        % correctly (also those that have high initial kinetic energy towards 
        % the ion spectrometer and cross the ion-accelerator region).
        write_ion_elektrodes_to_GEM_file(settings.GEM.fixed_geom, fid);
    end
  

    fprintf(fid, '} \r\n');

     fclose(fid);

end