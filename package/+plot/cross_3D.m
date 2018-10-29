function [h] = cross_3D(center, size, color )
%This function draws a 3D cross in a figure axes. 
% Inputs:
% center	[3, 1] X,y,z coordinated of the crosspoint (origin) of the three
%			orthogonal lines (optional, default = [0 0 0])
% size		[3,1] size of the cross lines from origin (optional,
%			default = 1).
% color		char, denoting the preferred color of the cross (optional,
%			default = 'k')
% Outputs:
% h			The Graphical object handle of the cross lines
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('center', 'var')
    center = [0 0 0];
end
if ~ exist('size', 'var')
    size = [1];
end
if ~exist('color','var')
    color = 'k';
end

if numel(size) ~= 1
	size = repmat(size(1), 3, 1);
end

X = center(1)*ones(2,3);
Y = center(2)*ones(2,3);
Z = center(3)*ones(2,3);

X(:,1) = [center(1)+size(1); center(1)-size(1)];
Y(:,2) = [center(2)+size(2); center(2)-size(2)];
Z(:,3) = [center(3)+size(3); center(3)-size(3)];
    
h = line(X, Y, Z, 'Color', color);

end

