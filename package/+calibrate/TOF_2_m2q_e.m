function [ factor, t0 ] = TOF_2_m2q_e (TOF_point, m2q_point)
% Calculation of conversion factors from several landmark points in 
% TOF and m2q.
% Input:
% TOF_points:   2 or more TOF's that show a peak in the histogram [ns]
% m2q_points:   The m2q of those points [amu/q]
% Output:
% factor:       The factor predicted by the calibration. 
% t0:           The fime-correction value. [ns] so that TOF 

% 
% See also: CALIBRATE.FIND_TOF_PEAKS CONVERT.TOF_2_MASS2CHARGE
% make a polynomial fit with the given data:
%assume t0 = 0 for now (until we come up with something better


% give it comprehensible names:
factor          = TOF_point./sqrt(m2q_point);
t0              = 0;
end