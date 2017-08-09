function [theta] = p_sum_norm_to_theta(p1, p2, psum)
%The norm of the sum of two momenta norms is calculated from the individual
% momentum norms and their mutual angle.
% Input 
% p1	norm of the first vector
% p2	norm of the second vector
% psum  norm of the sum vector
% output
% theta[rad] angle between the two vectors

theta = acos( ((psum.^2 - p1.^2 - p2.^2)./(2*p1.*p2)) );
end

