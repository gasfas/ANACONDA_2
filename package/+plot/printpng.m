function [] = printpng(fighandle, filename, ifdo_savefig)
% Simple printout of MATLAB figures to a document in PNG format
% Inputs:
% fighandle		the handle of the figure
% filename		The name (including path) to which the eps file should be
%				written to
% ifdo_savefig	logical (true/false) whether the figure should also be
%				saved as a MATLAB .fig file, in the same directory as the 
%				PNG file (optional, default = true).
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if ~exist('ifdo_savefig', 'var')
	ifdo_savefig = true;
end

% remove the extension in case it is given:
[path, name] = fileparts(filename);
filename = fullfile(path, name);

set(fighandle, 'PaperPositionMode', 'auto'); 
% saveas(fighandle,filename,'epsc -painters');
print('-painters', '-dpng', [filename '.png'])

if ifdo_savefig
	savefig(fighandle, filename)
end 