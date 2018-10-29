function [ dTOF ] = TOF_afo_Z_Laksman (m2q, volt, dist, dZ)
% The TOF of the Laksman TOF spectrometer is predicted as the Z coordinate
% in the source position is changed.
% Inputs: 
% volt          struct with the fields giving the voltages:
%   Ve2s          [V] Voltage of grid separating electron side and source region
%   Vs2a			[V] Voltage of grid separating source and acceleration region;
%   Va2d			[V] Voltage of grid separating acceleration region and drift tube;
% dist          struct with the fields giving the relevant distances:
%   s             [m] electron grid to ion acceleration region grid  
%   s0 			[m] source to ion acceleration region grid  
%   d 			[m] length of accelation region
%   D 			[m] length of drift tube
% dZ            [mm] The displacement in Z-direction (0 = no displacement)
%               [n, 1]
% Outputs
% dTOF          [ns] The difference in TOF [n, 1]
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

TOF_0 = theory.predict_TOF_Laksman (0, m2q, 1, volt, dist);

dist.s0 = dist.s0 + dZ*1e-3;
TOF = theory.predict_TOF_Laksman(0, m2q, 1, volt, dist);

dTOF = TOF - TOF_0;

end

