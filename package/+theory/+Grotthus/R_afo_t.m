function [R_t] = R_afo_t(R_start, t_arr, u, eps, z)
% This function calculates the theoretical evolution of the separation
% distance between two charges due to (Grotthus) proton hopping.
% Inputs:
% R_start	scalar, The separation distance at t_0 = t(1) [m];
% v_start	scalar, The separation distance velocity at t_0 = t(1) [m/s];
% t			[n,1], The times at which the separation distance is requested. The
% smaller the timestep, the more accurate the calculation.
% mu		scalar, The equivalent mass of the two point-masses involved.
% eps		scalar, The dielectric constant
% z			scalar, The charge number of both particles 
% Outputs:
% R			[n,1] The time-dependent charge-to-charge distance at times t [m].
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

k_e = 1/(4*pi*general.constants('eps0')*eps);
C = u*k_e*general.constants('q')*z;

lf = @(t, r) C./(r.^2);

[t, R_t] = ode45(lf, t_arr, [R_start]);

% plot(t, R_t)
% hold on
% d2R_dt2 = diff(R1_R2_t(:,2))./diff(t_arr');
% plot(t(2:end), sqrt(C./d2R_dt2), 'r')
end