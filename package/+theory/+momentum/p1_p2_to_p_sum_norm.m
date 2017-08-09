function [psum] = p1_p2_to_p_sum_norm(p1, p2, theta )
%The norm of the sum of two momenta norms is calculated from the individual
% momentum norms and their mutual angle.
% Input 
% p1	norm of the first vector
% p2	norm of the second vector
% theta[rad] angle between the two vectors
% output
% psum	norm of the resulting summed vector.

psum = sqrt(p1.^2 + p2.^2 + 2*cos(theta).*p1.*p2);

end

