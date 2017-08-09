function [ md_out ] = md_remove_coordinates(remove_coor, md_in)
%This function swaps coordinates from the source name to the destination
%name.

md_out = md_in;

fn = fieldnames(md_in);
f = strncmpi(fn,remove_coor,1);
idx = find(f);
for i = 1:sum(f)
	source_name			= fn{idx(i)};
	remove_name			= [remove_coor source_name(2:end)];
	md_out				= rmfield(md_out, remove_name);
end

% take care of binsize:
if isfield(md_out, 'binsize')
	remove_coor_idx	= find(strcmp ({'x', 'y', 'z'}, remove_coor));
	md_out.binsize(remove_coor_idx) = [];
end
end
