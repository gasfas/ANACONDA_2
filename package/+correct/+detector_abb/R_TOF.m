function [ TOF_c ] = R_TOF (TOF_noKE, V_created, V_detector, V_DriftTube, R, R_det, p)
% This function executes the second step of the detector abberation. It
% handles the TOF deviation due to the detector front potential being
% different than the Drift tube voltage. This function corrects the 
% radius-dependent deviation. See manual for the detailed
% explanation.
% Input:
% TOF_noKE          The zero Kinetic energy corrected TOF [ns] [n, 1]
% V_created         The electrostatic potential of the point of creation [V]
% V_detector        The detector front potential [V]
% V_DriftTube       The drift tube potential. [V]
% R                 The measured splat radius [mm] [n, 1]
% R_det             The Radius of the detector [mm]
% p                 the polynomial fit parameters [n,1]
% 
% Output:
% TOF_c				The corrected TOF [ns]


% Calculate the nondimensional voltage difference:
V_nd        = (V_detector - V_DriftTube) ./ (V_created - V_DriftTube);
% Calculate the nondimensional radius:
R_nd        = R./R_det;
% Calculate the nondimensional TOF difference (from the fit):
TOF_nd      = polyval(p, R_nd) .* V_nd;

% Now calculate the corrected TOF:
TOF_c    = TOF_noKE ./ (TOF_nd + 1);

end

