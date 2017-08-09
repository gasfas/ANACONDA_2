function [ output_args ] = verify_C2_C3_p( ds, mds )
% This function compares the ratio between the reconstructed (or 'physical')
% triple and double coincidence with the one fitted from angular
% correlation plots.
detname = 'det1'; detnr = IO.detname_2_detnr(detname);
fit_angles = [pi, 2*pi/3];

%% Ratio from mutual angle Fit
% Fetch the real double, and aborted triple coincidence from a fit:
I_C2_m_hits = macro.calibrate.BR.disect_C2_m(ds, mds, fit_angles);

%% Ratio from Branching ratio model
% Calculate the branching ratio from the BR_fragment model:
numexps = ds.info.numexps;
% Write the fit angles into the fit metadata:
for i = 1:numexps
	exp_name            = ds.info.foi{i};
	C_nrs		= mds.(exp_name).plot.(detname).BR_fragment_pair.C_nrs;
	mds.(exp_name).plot.(detname).BR_fragment_pair.ifshow = false;
	% We only need down to double coincidence:
	C_nrs		= C_nrs(C_nrs>1);
	
	% Calculate the measured and physical branching ratio:
	[~, ~, ~, ~, ~, BR_Ci_phys(:,i)] = macro.plot.BR_fragment_pair([], ds.(exp_name), mds.(exp_name), C_nrs);
	% calculate the average mass of C3 fragments:
	avg_C3_frag = mean(ds.(exp_name).e.(detname).m2q_l_sum(ds.(exp_name).e.(detname).filt.C3), 'omitnan')./3;
	% calculate the corresponding calibration efficiency:
	QE_i_avg_C3	= interp1(mds.(exp_name).plot.(detname).BR_fragment_pair.label_list, mds.(exp_name).plot.(detname).BR_fragment_pair.QE_i, avg_C3_frag);
	QE_e		= mds.(exp_name).plot.(detname).BR_fragment_pair.QE_e;
	I_120_2_180(i) = 3 * (1-QE_i_avg_C3) * (QE_e(3)./QE_e(3)) * (BR_Ci_phys(2,i)./BR_Ci_phys(1,i));
end

%% Comparison
figure; ax = gca;
% plot the branching ratio from the corrected branching ratio's:
plot(ax, I_120_2_180, 'r'); hold on
% plot the measured branching ratio from the fitting:
plot(ax, I_C2_m_hits(:,2)./I_C2_m_hits(:,1), 'k')
ylabel('${I(120)}/{I(180)}$'); 
xlabel('experiment number');
legend({'Corrected BR', 'Mutual angles'}, 'Interpreter', 'Latex'); legend boxoff
end

