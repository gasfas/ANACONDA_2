function [ TOF_c ] = no_KE_TOF(TOF_m, V_created, V_detector, V_DriftTube, p)
% This function executes the first step of the detector abberation. It
% handles the TOF deviation due to the detector front potential being
% different than the Drift tube voltage. See manual for the detailed
% explanation.
% Input:
% TOF_m				The measured, uncorrected TOF [ns]
% V_created         The electrostatic potential of the point of creation [V]
% V_detector        The detector front potential [V]
% V_DriftTube       The drift tube potential. [V]
% p                 the polynomial fit parameters [n,1]
% Output:
% TOF_c				The corrected TOF [ns]


% Calculate the nondimensional voltage difference:
V_nd        = (V_detector - V_DriftTube) ./ (V_created - V_DriftTube);
% Calculate the nondimensional TOF difference (from the fit):
TOF_nd      = polyval(p, log(1-V_nd));
% Now calculate the corrected TOF:
TOF_c    = TOF_m ./ (TOF_nd + 1);

end

