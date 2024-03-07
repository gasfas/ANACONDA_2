function photon_flux = calc_photon_flux(photodiode_readout, photon_energy, photodiode_type)
% Function to calculate the photon flux (photons/sec) from the photodiode
% readout and the photon energy.

switch photodiode_type
    case 'OptodiodeSXUV100'
    % Convert the current reading to photons/sec:
    % Assuming here we are using the following photodiode:
    % Opto diode Photodiode 100 mm2 SXUV100
    % https://optodiode.com/pdf/SXUV100.pdf

    % Calculate the responsivity from look-up table:
    responsivity    = OptodiodeSXUV100_responsivity(photon_energy);
    % Calculate the photons/sec from responsivity and measured current:
    photon_power    = responsivity * photodiode_readout; %[Watt]
    photon_flux    = photon_power/(photon_energy*general.constants('eVtoJ')); %photons/sec
end 
end

function responsivity = OptodiodeSXUV100_responsivity(photon_energy)
    % Convert photon energy to photon wavelength (nm):
    photon_wavelength       = convert.eV_to_nm(photon_energy);
    % The responsivity and wavelength from the specheets:
    responsivity_q           = [0.27 0.25 0.23 0.20 0.18 0.16, 0.14, 0.13, 0.125, 0.125]; %current_to_photon_power (Amp/Watt)
    photon_wavelength_q      = 1:length(responsivity_q);
    responsivity             = interp1(photon_wavelength_q, responsivity_q, photon_wavelength);
end