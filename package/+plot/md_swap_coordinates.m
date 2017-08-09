function [ md_out ] = md_swap_coordinates(source_coor, dest_coor, md_in)
%This function swaps coordinates from the source name to the destination
%name.

md_out = md_in;


fn = fieldnames(md_in);
f = strncmpi(fn,source_coor,1);
idx = find(f);
for i = 1:sum(f)
	source_name			= fn{idx(i)};
	dest_name			= [dest_coor source_name(2:end)];
	md_out.(dest_name)	= md_in.(source_name);
	% remove the old fields, if they exist:
	try md_out			= rmfield(md_out, source_name); catch; end
end

% take care of binsize:
if isfield(md_out, 'binsize')
	source_coor_idx = find(strcmp ({'x', 'y', 'z'}, source_coor));
	dest_coor_idx	= find(strcmp ({'x', 'y', 'z'}, dest_coor));
	md_out.binsize(dest_coor_idx) = md_in.binsize(source_coor_idx);
	% remove the old binsize value:
	md_out.binsize(source_coor_idx) = [];
end
end
