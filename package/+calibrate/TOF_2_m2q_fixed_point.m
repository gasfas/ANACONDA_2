function  [factor_new,  t0_new] = TOF_2_m2q_fixed_point(factor, t0, m_fixed, ratio)
%This function converts the TOF input signal to mass2charge units
%   It takes calibration values as input, and moves the calibration 
% around a fixed (specified) mass.
% Input values:
% factor:           The conversion factor
% t0				The time correction value [ns]. 
% m_fixed			The mass that should still correspond to the same
%					mass-2-charge
% ratio				The ratio that the mass to charge should change around
% m_fixed. Formally: change in factor.
% See also: CALIBRATE.TOF_2_m2q CALIBRATE.FIND_TOF_PEAKS
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% First calculate the new factor:
factor_new	= factor.*ratio;
% Then the new t0 associated with that, not moving the spectrum at a
% specified mass point (m_fixed).
t0_new		= t0 - sqrt(m_fixed)*(ratio-1)*factor;

end

