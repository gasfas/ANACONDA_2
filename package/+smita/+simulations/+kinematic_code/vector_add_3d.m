function [vt] = vector_add_3d( v1, v2)
%  v struct with fields r , theta and phi
% return resultant struct : vx, vy, vz
if isstruct(v1)
%%for adding vectors its easier in cartesian so we convert
% all angles in radians
    [v1x, v1y, v1z] = sph2cart(v1.phi, v1.theta, v1.r);
else 
    v1x = v1(:,1);
    v1y = v1(:,2);
    v1z = v1(:,3);
end
if isstruct(v2)
    [v2x, v2y, v2z] = sph2cart(v2.phi, v2.theta, v2.r);
else 
    v2x = v2(:,1);
    v2y = v2(:,2);
    v2z = v2(:,3);
end

vtx = v1x + v2x;
vty = v1y + v2y;
vtz = v1z + v2z;
vt.vector = horzcat(vtx , vty, vtz);
[vt.phi,vt.theta,vt.r] =  cart2sph(vtx,vty,vtz);
end


% function [vx , vy, vz ] = vector_component_3d(r, theta, phi)
%     vx = abs(r) * sin(theta) * cos(phi);
%     vy = abs(r) * sin(theta) * sin(phi);
%     vz = abs(r) * cos(theta);
% end
% 
