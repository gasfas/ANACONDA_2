function [KE] = KE(R, E0, a, b, R0)
%Calculate the electron Kinetic energy in the EPICEA spectrometer.
% This function converts radia to energy values, specifically for the EPICEA 
% spectrometer electrons:
% We use the formula from Liu, Nicolas, and Miron, Rev. Sci. Instrum. 84, 033105 (2013)
% a_50			= -0.16504; %Dispersion coefficientat 50 eV pass;
% b_50			= 110.7; %Dispersion coefficient at 50 eV pass;
% [a, b]			= deal (a_50*KER_md.E_pass./50, b_50*KER_md.E_pass./50);

KE = E0 + a*(R - R0) + b*(1./R - 1./R0);
end

