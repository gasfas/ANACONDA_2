function [ R_corr ] = dR (V_created, V_detector, V_DriftTube, R, R_det, p)
% This function executes the third step of the detector abberation. It
% corrects the radial deviation due to the detector front potential being
% different than the Drift tube voltage. This function corrects the 
% radius-dependent deviation. See manual for the detailed
% explanation.
% Input:
% V_created         The electrostatic potential of the point of creation [V]
% V_detector        The detector front potential [V]
% V_DriftTube       The drift tube potential. [V]
% R                 The measured splat radius [mm] [n, 1]
% R_det             The Radius of the detector [mm]
% p                 the polynomial fit parameters [n,1]
% 
% Output:
% R_corr            The corrected TOF [mm]
%
% SEE ALSO: correct.detector_abb.no_KE_TOF, correct.detector_abb.R_TOF
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% Calculate the nondimensional voltage difference:
V_nd        = (V_detector - V_DriftTube) ./ (V_created - V_DriftTube);
% Calculate the nondimensional radius:
R_nd        = R./R_det;
% Calculate the nondimensional R difference (from the fit):
dR_nd       = polyval(p, R_nd) .* V_nd;

% Now calculate the corrected Radius:
R_corr      = R - R_det*dR_nd;

end

