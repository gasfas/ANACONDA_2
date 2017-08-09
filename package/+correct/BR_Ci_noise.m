function [BR_corr] = BR_Ci_noise(C_nrs, BR, lambda)
% This function cleans the measured branching ratio's from hits that are 
% expected to arrise from noise. We assume a poisson distribution for the
% for the occurence of noise hits, with mean value lambda.
% Inputs:
% C_nrs			[n, 1] coincidence numbers under study
% BR_Ci			[n, 1] The uncorrected branching ratio's
% lambda		scalar, mean expectation value of the number of hits.
BR_s_fs			= zeros(max(C_nrs), 1);
C_nrs_fs		= 1:max(C_nrs);
BR_corr_s		= zeros(max(C_nrs),1); 

% sort the data in ascending order:
[C_nrs_s, idxsort] = sort(C_nrs, 'ascend');

BR_s_fs(C_nrs)	= BR;

j = 0;
for C_nr = C_nrs_fs(1:end)
	j = j+1;
	larger_C_nrs = C_nrs_fs(C_nrs_fs>C_nr);
	larger_BRs	= BR_s_fs(C_nrs_fs>C_nr);
	BR_corr_s(j)= (1 - sum(poisspdf(1:C_nr, lambda))) * BR_s_fs(j) + ...
				sum(poisspdf(larger_C_nrs-C_nr, lambda).*larger_BRs');
end

BR_corr = BR_corr_s(C_nrs);

end

