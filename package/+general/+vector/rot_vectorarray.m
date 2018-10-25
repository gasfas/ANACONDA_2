function [ vector2 ] = rot_vectorarray(vector1, RotMat)
% rotates 3D vector1 to 3D vector2, using RotMat as rotation matrix
% Inputs:
% vector1	[n,3] vector array number 1: initial vector
% rotMat	[3,3,n] Rotationmatrix.
% Output:
% vector2	[n,3] vector array number 2: final vector
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% reshape the initial vector:
vector1_resh = permute(vector1, [2 3 1]);
vector2_resh = general.mtimes.mtimesx(RotMat, vector1_resh);
vector2 = squeeze(vector2_resh)';
end

