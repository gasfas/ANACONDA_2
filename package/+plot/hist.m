function [h_GraphObj] = hist(h_axes, hist, GraphObj_md)
% This function turns a given histogram into a graphical object of choice.
% It redirects to dedicated histogram functions in plot.hist.....
% Inputs:
% h_axes	The axes handle to plot the histogram into
% hist		The input histogram struct with fields hist.Count, and
%			hist.midpoints
% GraphObj_md	The Graphical Object metadata
% Outputs:
% h_GraphObj	The handle of the Graphical Object.
%
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Convert the histogram to a Graphical object:
% the dimension of the histogram:
if ~isstruct(hist.midpoints)
	dim = 1;
else
	dim = general.matrix.nof_dims(hist.Count);
end

a = str2func(['plot.hist.' h_axes.Type '.H_' num2str(dim) 'D.' GraphObj_md.Type]);

[h_GraphObj] = a(h_axes, hist.midpoints, hist.Count, GraphObj_md);

end
