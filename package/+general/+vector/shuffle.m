function [data_shuffled, shuffle_idx] = shuffle(data_in, md)
% This function takes a data vector, and repositions the data according to
% the user-prefered method.
% Input
% data_in		[n,1], the vector with data that will be shuffled in
%				position.
% md			(optional), struct with metadata on which method to use.
%				Optional fields:
%			-	md.method	= 'rotation'; This method shifts all the
%				elements 'md.shift' up, and the first 'md.shift' are placed
%				at the end of the vector.
%			-	md.method	= 'rand'; This method shuffles all elements
%				randomly.
%				Default: 'rotation', with a shift of one.
% data_out		[n,1] randomly shuffled array
% shuffle_idx	The index number, to see where the elements originally were.

if ~exist('md', 'var')
	md.method	= 'rotation';
	md.shift	= 1;
end

switch md.method
	case 'rotation'
		data_shuffled = [data_in((md.shift+1):end,:); data_in(1:md.shift,:)];
		shuffle_idx = [(md.shift+1):size(data_in, 1) 1:md.shift];
	case 'rand'
		[M,N] = size(data_in);
		
		ColIndex = repmat((1:N),[M 1]);

		% Get randomized row indices by sorting a second random array
		[~,randomizedRowIndex] = sort(rand(M,1),1);

		% Need to use linear indexing to create shuffled data:
		shuffle_idx = sub2ind([M,N],repmat(randomizedRowIndex, [1, N]), ColIndex);
		data_shuffled = data_in(shuffle_idx);
end
end