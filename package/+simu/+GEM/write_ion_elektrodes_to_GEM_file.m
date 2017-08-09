function  write_ion_elektrodes_to_GEM_file(GEM_data_ion, fid)
%This function can be used in the case the spectrometer is confined to the
%boundary conditions of an already built device in the vicinity. In this
%case, the ion spectrometer.
%   GEM_data_ion is defined in GEM_parameters.m
    fprintf(fid, '; This part describes the electrodes that have already been built,\r\n');
    fprintf(fid, '; so not to be tampered with. presented in the following order\r\n');
    fprintf(fid, '; 1.grid of the extraction region that faces the electron spectrometer\r\n');
    fprintf(fid, '; 2.grid of the extraction region that faces the ion spectrometer\r\n');
    fprintf(fid, '; 3.grid that separates the Accelerator region from the drift region\r\n');
    % We write the elektrode data to the GEM-file:
    write_elektrode_to_GEM_file(GEM_data_ion, fid)
end

