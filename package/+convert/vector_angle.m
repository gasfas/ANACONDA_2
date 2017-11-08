function [ angle_rad ] = vector_angle( vec1, vec2 )
%This function calculates the angle between two vectors, in two or
%three-dimensional space.
% Input:
% vec1      The first vector [n, 3] or [n, 2]
% vec2      The second vector [n, 3] or [n, 2]
% Output:
% angle_rad The shortest great circle path between them [rad].


if size(vec1, 2) == 2
    % The input vector is two-dimensional. We add another line of zeros to
    % the vector, so that cross product can be calculated:
    vec1 = [vec1 zeros(size(vec1,1),1)];
    vec2 = [vec2 zeros(size(vec1,1),1)];
end
if size(vec1, 1) == 1 && size(vec2, 1) > 1
 % There is only one vector given for vec1, but the other contains
 % multiple. This means we multiply the vector to the same size:
vec1 = repmat(vec1, size(vec2, 1), 1);
end
if size(vec2, 1) == 1 && size(vec1, 1) > 1
 % There is only one vector given for vec2, but the other contains
 % multiple. This means we multiply the vector to the same size:
vec2 = repmat(vec2, size(vec1, 1), 1);
end
if any(size(vec1) == 0) || any(size(vec2) == 0)
	angle_rad = NaN*ones(size(vec1, 1), 1);
else
	angle_rad = atan2(sqrt(sum(abs(cross(vec1,vec2,2)).^2,2)),dot(vec1,vec2,2));
end

