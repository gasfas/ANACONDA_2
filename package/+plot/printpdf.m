function [] = printpdf(fighandle, filename)
% Simple printout of MATLAB figures to a document in PDF format
% Inputs:
% fighandle		the handle of the figure
% filename		The name (including path) to which the eps file should be
%				written to
% ifdo_savefig	logical (true/false) whether the figure should also be
%				saved as a MATLAB .fig file, in the same directory as the 
%				PDF file (optional, default = true).
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

pos = get(fighandle,'Position');
set(fighandle,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)]);
saveas(fighandle,filename,'pdf');
end