function [ htext ] = write_values( ax, x_values, y_values, format )
% This function writes the values above a bar plot (or other type).
% Inputs: 
% ax		axes in which to write the text
% x_values	[n, 1] array with x locations
% y_values	[n, 1] array with y_values 
% format	cell, containing the form in which the user wants to see the
%			text. Options: 'absolute' 'percentage'
% Output
% htext		Handle to the text.

textmat = [];
for i = 1:length(format)
	f = format{i};
	switch f
		case 'absolute'
			addtext = num2str(y_values, 2);
		case 'percentage'
			percent_values = general.matrix.abs_2_rel(y_values)*100;
			addtext = [repmat('(',  size(y_values)) num2str(percent_values, 2) repmat('\%)', size(y_values))];
	end
	textmat = [textmat addtext];
end

htext = text(ax, x_values, y_values, textmat, 'HorizontalAlignment','center', 'VerticalAlignment','bottom');
% set(htext,'Rotation',90);
end

