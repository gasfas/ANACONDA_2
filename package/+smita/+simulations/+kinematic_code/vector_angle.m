function [psi] = vector_angle( v1, v2)
%  v struct with fields r , theta and phi
% return struct resultant vector : r,theta,phi
% all angles in radians
    [v1x, v1y, v1z] = sph2cart(v1.phi, v1.theta, v1.r);
    [v2x, v2y, v2z] = sph2cart(v2.phi, v2.theta, v2.r);
    dot_product = dot([v1x, v1y, v1z], [v2x, v2y, v2z],2);
    norm1 =sqrt(v1x.^2 + v1y.^2 + v1z.^2);
    norm2 =sqrt(v2x.^2 + v2y.^2 + v2z.^2);
%     psi = nan(length(v1x),1);
%     if dot_product ./ (norm1 .* norm2)<=1
    psi = acos(dot_product ./ (norm1 .* norm2));
    psi = real(psi);
%     end
end


% function [vx , vy, vz ] = vector_component_3d(r, theta, phi)
%     vx = abs(r) * sin(theta) * cos(phi);
%     vy = abs(r) * sin(theta) * sin(phi);
%     vz = abs(r) * cos(theta);
% end