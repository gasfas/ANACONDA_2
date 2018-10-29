function [par_h, perp_h] = grid(varargin)
% Create a 2D grid in any non-square shape, with uniform spacing at the
% sides.
% Inputs:
% start1_pos	[2, 1], x,y coordinates of the first starting position of the
%				lines
% start2_pos	[2, 1], x,y coordinates of the second starting position of the
%				lines
% end1_pos		[2, 1], x,y coordinates of the first end position of the
%				lines
% end2_pos		[2, 1], x,y coordinates of the second end position of the
%				lines
% nof_par_lines	scalar, number of parallel lines
% nof_perp_lines scaler, number of perpendicular lines
% Outputs:
% par_h			handles of parallel lines
% perp_h		handles of perpendicular lines
% Example:
% [par_h, perp_h] = grid(start1_pos, start2_pos, end1_pos, end2_pos, nof_par_lines, nof_perp_lines, 'Color', 'k')
% plot.grid([1, 5], [2, 3], [1, 3], [-3, 6], 60, 20, 'Color', 'k')
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

start1_pos	= varargin{1};
start2_pos	= varargin{2};
end1_pos	= varargin{3};
end2_pos	= varargin{4};
nof_par_lines= varargin{5};
nof_perp_lines= varargin{6};

% Parallel lines:
start_x = linspace(start1_pos(1),start2_pos(1), nof_par_lines);
start_y	= linspace(start1_pos(2),start2_pos(2), nof_par_lines);

end_x	= linspace(end1_pos(1),end2_pos(1), nof_par_lines);
end_y	= linspace(end1_pos(2),end2_pos(2), nof_par_lines);

% Draw the line:
par_h = line([start_x; end_x], [start_y; end_y]);

if nargin > 6
	Properties	= varargin(7:2:nargin);
	Values		= varargin(8:2:nargin);
	for i = 1:length(start_x)
		for j = 1:length(Properties)
			par_h(i).(Properties{j}) = Values{j};
		end
	end
end

end

	