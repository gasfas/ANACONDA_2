function  [ m2q ] = TOF_2_m2q(TOF, factor, t0)
%This function converts the TOF input signal to mass2charge units
%   It converts the input signal 'TOF' and exports it to 'm2q'
% Input values:
% TOF:              The data containing the Times-Of-Flight
% factor:           The conversion factor
% timecorr:         The time correction factor. 
%
% See also: CALIBRATE.TOF_2_m2q CALIBRATE.FIND_TOF_PEAKS
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

m2q = ((TOF - t0)./factor).^2;

% TODO: make the deviation better suitable for a large range of TOFs, 
% based on the deviation caused by plus/minus U_0.

end

