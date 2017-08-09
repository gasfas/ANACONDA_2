function [ R_corr ] = dR (V_created, V_lens, V_DriftTube, R, p)
% This function executes the third step of the lens abberation. It
% corrects the radial deviation due to the detector front potential being
% different than the Drift tube voltage. This function corrects the 
% radius-dependent deviation. See manual for the detailed
% explanation.
% Input:
% V_created         The electrostatic potential of the point of creation [V]
% V_lens            The lens potential [V]
% V_DriftTube       The drift tube potential. [V]
% R                 The measured splat radius [mm] [n, 1]
% p                 the polynomial fit parameters [n,1]
% 
% Output:
% R_corr            The corrected TOF [mm]


% Calculate the nondimensional voltage difference:
V_nd        = (V_lens - V_DriftTube) ./ (V_created - V_DriftTube);
% Calculate the nondimensional R ratio (from the fit):
R_ratio     = polyval(p, V_nd);

% Now calculate the corrected Radius:
R_corr      = R_ratio.*R;

end

