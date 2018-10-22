function [ factor, t0 ] = TOF_2_m2q (TOF_points, m2q_points)
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
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% make a polynomial fit with the given data:
p               = polyfit(sqrt(m2q_points), TOF_points, 1);
% give it comprehensible names:
factor          = p(1);
t0              = p(2);
end

