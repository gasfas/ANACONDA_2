function  [ TOF ] = m2q_2_TOF(m2q, factor, t0)
%This function converts the mass2charge input signal to TOF signal
%   It converts the input signal m2q' and exports it to 'TOF' 
% Input values:
% m2q:              mass over charge signal.
% factor:           The conversion factor
% timecorr:         The time correction factor. 
% Output:
% TOF:              The data containing the Times-Of-Flight [ns]
% See also: CALIBRATE.TOF_2_m2q CALIBRATE.FIND_TOF_PEAKS
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

TOF = t0 + factor*sqrt(m2q);

end

