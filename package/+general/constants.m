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
            values(i) = 1./(general.constants('q')); % [C^-1] elementary charge or conversion from joule to eV
        case {'ke', 'k_e'}
            values(i) = 8.99*1e9; % [N*m^2 C^-2] Coulomb's constant
        case 'h'
            values(i) = 6.62607004081e-34; % [Js] Planck's constant
        case {'hbar', 'h_bar'}
            values(i) = (6.626176e-34)/(2*pi); % [Js] Planck's constant /2pi
        case 'c'
            values(i) = 2.99792458e8; %[m/s] speed of light
        case {'amu', 'a.m.u.'}
            values(i) = 1.66054e-27; % atomic mass unit [Da]
        case {'me', 'm_e'}
            values(i) = 9.109534e-31;% [kg] electron rest mass
        case {'me_amu', 'm_e_amu'}
            values(i) = general.constants('me')/general.constants('amu');% [a.m.u] electron rest mass in atomic mass unit
        case {'mp', 'm_p'}
            values(i) = 1.6726485e-27; % [kg] proton/neutron rest mass
        case 'momentum_au'
            values(i) = 1.992851882e-24;% [kg*m/s] atomic momentum uit
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
            values(i) = 1./(general.constants('h')*general.constants('c').*general.constants('JtoeV')*100); % converstion from eV to cm-1 (inverse centimeter)
		case {'kcalmol_to_eV'}
			values(i) = 0.0433634;
		otherwise % We assume that a formula of different constants is given:
			% TODO
		const = {'q', ...	% [C] elementary charge or conversion from joule to eV
			'eVtoJ', ...	% [C] elementary charge or conversion from joule to eV
			'JtoeV', ...	% [C^-1] elementary charge or conversion from joule to eV
			'k_e', ...		% [N*m^2 C^-2] Coulomb's constant
			'h', ...		% [Js] Planck's constant
			'hbar', ...		% [Js] Planck's constant /2pi
			'c', ...		% [m/s] speed of light
			'amu', ...		% [Da] atomic mass unit 
			'me', ...		% [kg] electron rest mass
			'mp', ...		% [kg] proton/neutron rest mass
			'momentum_au', ...% [kg*m/s] atomic momentum unit
			'eps0', ...		% [F/m] Vacuum permittivity
			'mu_B', ...% [A m2 or J/T] Bohr magnetron
			'a_0', ...% [m] Bohr radius
			'alpha', ...% [-] fine structure constant
			'kb', ...% [J/K] Boltzmann constant
			'R', ...% [a.m.u./K (m/s)^2] Gas constant
			'Na', ...% [mol^-1] Gas constant
			'eVtocm-1'}; ...% converstion from eV to cm-1 (inverse centimeter)
	end
end
end

