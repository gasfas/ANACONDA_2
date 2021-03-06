function [ TOF_c ] = no_KE_TOF(TOF_measured, V_created, V_lens, V_DriftTube, p)
% This function executes the first step of the detector abberation. It
% handles the TOF deviation due to the detector front potential being
% different than the Drift tube voltage. See manual for the detailed
% explanation.
% Input:
% TOF_measured      The measured, uncorrected TOF [ns]
% V_created         The electrostatic potential of the point of creation [V]
% V_lens            The lens potential [V]
% V_DriftTube       The drift tube potential. [V]
% p                 the polynomial fit parameters [n,1]
% Output:
% TOF_c				The corrected TOF [ns]
%
% SEE ALSO: correct.lens_abb.dR
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se


% Calculate the nondimensional voltage difference:
V_nd        = (V_lens - V_DriftTube) ./ (V_created - V_DriftTube);
% Calculate the nondimensional TOF difference (from the fit):
TOF_nd      = polyval(p, V_nd);
% Now calculate the corrected TOF:
TOF_c    = TOF_measured ./ (TOF_nd + 1);

end

