function [photon_energy] = fetch_photon_energy_csv_namelist(filelist)
% Convenience function to get a list of the photon energies:
switch class(filelist)
    case 'char'
        % We assume the name of only one file is given:
        energy_number_end   = strfind(filelist, 'eV')-1;
        energy_number_start = strfind(filelist(1:energy_number_end), '_');
        photon_energy       = str2num(filelist(energy_number_start(end)+1:energy_number_end));
    case 'cell'
        photon_energy = zeros(length(filelist),1);
        for i = 1:length(filelist)
            photon_energy(i) = IO.SPECTROLATIUS_S2S.fetch_photon_energy_csv_namelist(filelist{i});
        end
end