function [] = printpng(fighandle, filename, ifdo_savefig)
% Simple printout to PNG format
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