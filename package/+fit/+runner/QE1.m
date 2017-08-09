function [ BR_meas ] = QE1(BR_phys, QE_i, QE_e, C_nrs)
% peak fit of Branching ratio's of QE model
% Input parameters:
% BR_phys		[BR_phys1, BR_phys2, ....] The physical ('real') branching
%				ratio's
% QE			Quantum efficiency
% C_nrs			[C_nr1; C_nr2, ....]
% Output parameters:
% BR_meas		Measured Branching Ratio's
BR_meas = ones(size(BR_phys)); j = 0;

for C_nr = C_nrs'
	j = j+1;
	C_f = C_nrs >= C_nr;
	C = C_nrs(C_f);
	BR_meas(j) = sum(QE_e(C) .* BR_phys(C_f) .* general.stat.nof_comb(C, C_nr) .* ...
					QE_i.^(C_nr) .* (1 - QE_i).^(C - C_nr));
end