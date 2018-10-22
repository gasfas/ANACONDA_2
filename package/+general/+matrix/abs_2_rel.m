function [ X_r, sf ] = abs_2_rel( X_a, dim )
%This function transforms a matrix with unscaled, absolute intensities to
%a similar-sized matrix with relative numbers instead.
% The total is determined by adding up all elements, unless a dimension is
% indicated, along which the sum will be added to define the total row- or
% column-wise.
% Negative numbers are ignored in the determination of the total number
% Inputs:
% X_a	The matrix with the absolute intensities
% dim	(optional), the dimension along which one should determine the
%		total.
% Outputs:
% X_r	The relative intensities.
% sf	The scaling factors used.


if any(any(X_a < 0))
	X_a(X_a < 0) = 0;
	warning('existing negative bar values excluded in total'); 
end

try		
	sf			= sum(X_a, dim);
	nof_rep		= ones(1, ndims(X_a));
	nof_rep(dim)= size(X_a, dim);
	sf			= repmat(sf, nof_rep);
catch
	sf = sum(X_a(:));
end

X_r = X_a./sf;
	
end

