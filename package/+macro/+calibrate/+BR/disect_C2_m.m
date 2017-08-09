function [ I_hits_C2 ] = disect_C2_m(ds, mds, fit_angles)
% This function calculates the relative intensities of the true double
% coincidence and the aborted triple coincidence that ends up in second
% coincidencence.
% Inputs:
% d				struct, the datafile of the experiment under study
% md			struct, the rest of the fit metadata.
% fit_angles	[2,1] The angles at which the true C2 and aborted triple
%				coincidence can be found.
% Output:
% I_hits		The intensities of true C2 and aborted C3 in hits.

detname = 'det1';
numexps = ds.info.numexps;

% Write the fit angles into the fit metadata:
for i = 1:numexps
	exp_name            = ds.info.foi{i};
	mds.(exp_name).fit.(detname).angle_p_corr_C2.gauss.mu.value = fit_angles;
end

[I_hits_C2] = macro.fit.angle_p_corr.p1_2_p2_all(ds, mds, 2);

end

