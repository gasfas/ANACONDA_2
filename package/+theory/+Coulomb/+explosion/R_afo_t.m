function [R_t] = R_afo_t(R_start, v_start, t_arr, mu, eps, z1, z2)
% This function calculates the theoretical evolution of the separation
% distance between two point masses due to Coulomb repulsion.
% Inputs:
% R_start	scalar, The separation distance at t_0 = t(1) [m];
% v_start	scalar, The separation distance velocity at t_0 = t(1) [m/s];
% t			[n,1], The times at which the separation distance is requested. The
% smaller the timestep, the more accurate the calculation.
% mu		scalar, The equivalent mass of the two point-masses involved.
% eps		scalar, The dielectric constant
% z1		scalar, The charge number of particle one 
% z2		scalar, The charge number of particle two

k_e = 1/(4*pi*general.constants('eps0')*eps);
C = k_e*(general.constants('q').^2)*z1*z2./mu;

lf = @(t, r) [r(2); C./(r(1).^2)];

[t, R1_R2_t] = ode45(lf, t_arr, [R_start, v_start]);

R_t = R1_R2_t(:,1);
% plot(t, R_t)
% hold on
% d2R_dt2 = diff(R1_R2_t(:,2))./diff(t_arr');
% plot(t(2:end), sqrt(C./d2R_dt2), 'r')
end