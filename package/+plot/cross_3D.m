function [h] = cross_3D(center, size, color )
%Convenience function to plot a cross in a 3D plot

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

X(:,1) = [center(1)+size(1); center(1)-size(3)];
Y(:,2) = [center(2)+size(2); center(2)-size(3)];
Z(:,3) = [center(3)+size(3); center(3)-size(3)];
    
h = line(X, Y, Z, 'Color', color);

end

