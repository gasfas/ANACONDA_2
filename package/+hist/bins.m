function [ edges, mids ] = bins(range, binsize)
%Simple function to span a range from the range and binsize
dim = length(binsize);
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

