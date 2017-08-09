function [ values ] = constants( name )
% Supplies the general physical constants.
% Input:
% name      1D cell, the names of the physical constants requested.
% Output:
% values    array with the values of the requested constants.
if ~iscell(name)
    names{1} = name;
else
    names   = name;
end

for i = 1:length(names)
    switch names{i}
        case {'q','eVtoJ'}
            values(i) = 1.6021766208e-19; % [C] elementary charge or conversion from joule to eV
        case {'JtoeV'}
            values(i) = 1./(1.6021766208e-19); % [C^-1] elementary charge or conversion from joule to eV
        case {'k_e'}
            values(i) = 8.99*1e9; % [N*m^2 C^-2] Coulomb's constant
        case 'h'
            values(i) = 6.626176e-34; % [Js] Planck's constant
        case 'hbar'
            values(i) = (6.626176e-34)/(2*pi); % [Js] Planck's constant /2pi
        case 'c'
            values(i) = 2.99792458e8; %[m/s] speed of light
        case 'amu'
            values(i) = 1.66054e-27; % atomic mass unit [Da]
        case 'me'
            values(i) = 9.109534e-31;% [kg] electron rest mass
        case 'mp'
            values(i) = 1.6726485e-27; % [kg] proton/neutron rest mass
        case 'momentum_au'
            values(i) = 1.992851882e-24;% [kg*m/s] atomic momentum unit
        case 'eps0'
            values(i) = 8.854187817e-12;% [F/m] Vacuum permittivity
        case 'mu_B'
            values(i) = 9.274e-24;% [A m2 or J/T] Bohr magnetron
        case 'a_0'
            values(i) = 5.29e-11;% [m] Bohr radius
        case 'alpha'
            values(i) = 1/137.036;% [-] fine structure constant
        case 'kb'
            values(i) = 1.3807e-23;% [J/K] Boltzmann constant
        case 'R'
            values(i) = 8.3144598e3;% [a.m.u./K (m/s)^2] Gas constant
        case 'Na'
            values(i) = 6.022140857e23;% [mol^-1] Gas constant
        case {'eVtocm-1'}
            values(i) = 8065.44; % converstion from eV to cm-1 (inverse centimeter)
		case {'kcalmol_to_eV'}
			values(i) = 0.0433634;
    end
end
end

