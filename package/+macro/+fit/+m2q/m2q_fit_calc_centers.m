function [ fit_md ] = m2q_fit_calc_centers( fit_md )
% Convenience function to calculate the fitting centers as infered from the
% input 'fit_md'. 

q                   = fit_md.q; % the total number of monomer units
m_mass              = fit_md.m.mass; % the mass of unit m
n_mass              = fit_md.n.mass; % the mass of unit n
H_mass              = fit_md.H.mass; % proton mass
nof_prot            = fit_md.H.nof;  % number of protons
% mu_m                = round(q * fit_md.p_m);% integer expectation value;
% mu_m_mass           = (mu_m*m_mass + (q-mu_m)*n_mass)+nof_prot*H_mass;

fit_md.pure_masses         = [q*m_mass+nof_prot*H_mass, q*n_mass+nof_prot*H_mass];
fit_md.centers      = general.matrix.vector_colon(fit_md.pure_masses(1), fit_md.pure_masses(2));%defining the centres of the peaks
% x_m                 = (fit_md.centers - H_mass*nof_prot - q*m_mass) ./ (n_mass - m_mass);


end

