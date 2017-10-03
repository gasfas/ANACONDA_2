function [E ] = R_2_KE_EPICEA(a, b, E0, R0, R)
% This function converts radia to energy values, specifically for the EPICEA 
% spectrometer electrons

E = E0 + a*(R - R0) + b*(1./R - 1./R0);

end
