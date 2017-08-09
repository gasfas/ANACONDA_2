function [ RotMat ] = vrrotmat_array(vector1, vector2)
% Create a SuperRotationMatrix to rotate from 3D vector1 to 3D vector2 (both
% arrays)
% Inputs:
% vector1	[n,3] vector array number 1: start direction
% vector2	[n,3] vector array number 2: end direction
% Output:
% RotMat	[3,3,n] Rotationmatrix.

if (size(vector1, 1) ~= size(vector2, 1))
	if size(vector1,1) == 1
		vector1 = repmat(vector1, size(vector2, 1), 1);
	elseif size(vector2,1) == 1
		vector2 = repmat(vector2, size(vector1, 1), 1);
	end
end

%Find axis and angle using cross product and dot product:
cross12 = cross(vector1, vector2);
% axis along to rotate:
x		= cross12./(general.vector.norm_vectorarray(cross12));
% angle:
theta	= acos(dot(vector1, vector2, 2)./ ...
			general.vector.norm_vectorarray(vector1).*general.vector.norm_vectorarray(vector2));
% deal with corner cases: (TODO)
% x(abs(pi-theta)<eps) = min(vector1(abs(pi-theta)<eps),2);
% Rotation matrix R and help matrix A have [3,3,n] sizes:
A		= zeros(3, 3, size(vector1,1));
A(1,2,:)= -x(:,3); A(2,1,:)=  x(:,3);
A(1,3,:)=  x(:,2); A(3,1,:)= -x(:,2);
A(2,3,:)= -x(:,1); A(3,2,:)=  x(:,1);
% write rotation matrix:
% R	= exp(A.*permute(theta, [2 3 1]));
RotMat	= repmat(eye(3), 1,1,size(vector1,1)) + ...
	permute(sin(theta), [2 3 1]).*A + ...
	permute((1 - cos(theta)), [2 3 1]).*general.matrix.mmat(A, A, [1 2]);
% Deal with corner cases:
RotMat(:,:,theta<eps) = repmat(eye(3), 1,1,sum(theta<eps));
RotMat(:,:,all(cross12==0, 2)) = repmat(eye(3), 1, 1, sum(all(cross12==0, 2)));
end

