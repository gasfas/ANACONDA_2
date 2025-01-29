function wavelength_um = wavenumber_to_wavelength_um (wavenumber_invcm)
% Function that calculates the wavelength in micrometer from a given
% wavenumber in inverse centimeter.
wavelength_um = 1/wavenumber_invcm*1e4;
end
