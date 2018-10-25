function [ edges, mids ] = bins(range, binsize)
% This function defines the uniformly spaced bin edges and middles from a 
% specified range and binsize
% Inputs:
% range		[ndims, 2] matrix of minimum and maximum of the bin span
% binsize	[ndims, 1] array of binsizes in each dimension
% Outputs:
% edges		struct with the bins for each dimension
% mids		array with the middles of the bins (only for single-dimension
%			data)
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

dim = max(length(binsize), size(range, 1));
if length(binsize) < size(range, 1) % assume the same binsize as the last if not enough binsizes are given;
	binsize = [binsize repmat(binsize(end), 1, size(range, 1) - length(binsize))];
end
if  dim == 1
	edges = transpose(range(:,1)-binsize./2:binsize:max(range(:,2)+binsize/2, range(:,1)+binsize));
else % If range and binsize for a multi-dimensional histogram are given, we split bins into different categories:
	for i = 1:dim
		edges.(['dim' num2str(i)]) = hist.bins(range(i,:), binsize(i));
	end
end
if nargout > 1
	if  dim == 1
		mids = transpose(range(:,1):binsize:max(range(:,2), range(:,1)+binsize));
	end
end

