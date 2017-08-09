function [ BR_phys ] = QE1(C_nrs, BR_meas, QE_i, QE_e)
% Calculation of 'physical' Branching ratio's from measured BR, by QE model
% 1
% Input parameters:
% BR_meas		[BR_meas1, BR_meas2, ....] The measured branching
%				ratio's
% QE_i			scalar, ion Quantum efficiency
% QE_e			[1, max_nof_charges], Electron Quantum efficiency
% C_nrs			[C_nr1; C_nr2; ....]. No need to put them in sorted order.
% Output parameters:
% BR_phys		Physical (real) Branching Ratio's
BR_phys_s			= zeros(max(C_nrs), 1); j = 0;

[C_nrs_s, idxsort] = sort(C_nrs, 'descend');
BR_meas_s			= BR_meas(idxsort);

for C_nr = C_nrs_s'
	j = j+1;
	C_f				= (C_nrs_s > C_nr);
	C				= C_nrs_s(C_f);
	BR_meas_cur		= BR_meas_s(C_nrs_s == C_nr);
	BR_phys_s(C_nr)	= (1 ./ QE_e(C_nr) ./ QE_i^C_nr)  .* ...
		(BR_meas_cur - sum( BR_phys_s(C) .* QE_e(C)' .* general.stat.nof_comb(C, C_nr) ...
		.* QE_i^(C_nr) .* (1-QE_i).^(C-C_nr) ) );
end

BR_phys = BR_phys_s(C_nrs);