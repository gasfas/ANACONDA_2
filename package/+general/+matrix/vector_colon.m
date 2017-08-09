function [ y, sep_vecs ] = vector_colon( x1, x2, spacing)
%This function creates an array of integer values spanned by two given vectors x1
%and x2, such that y = [x1(1):x2(1), x1(2):x2(2), x1(3):x2(3), etc]
% Inputs:
% x1    input vector of integer minima [n, 1];
% x2    input vector of integer maxima [n, 1];
% Outputs:
% y     the array of integer values spanned by x1 and x2, [m, 1]
D = diff([x1 x2],1,2);
if ~exist('spacing', 'var')
    spacing(D>=0) = 1;
    spacing(D<0) = -1;
else
    if length(spacing) ~= length(x1)
        % The spacing should have the same data format as x1, x2:
        spacing = spacing(1,1)*ones(size(x1))';
    end
end
sep_vecs     = arrayfun(@colon, x1', spacing, x2', 'Uniform', false);
y       = cell2mat(sep_vecs)';

end

