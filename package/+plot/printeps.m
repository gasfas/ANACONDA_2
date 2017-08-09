function [] = printeps(fighandle, filename, ifdo_savefig)
% Simple printout to EPS format
if ~exist('ifdo_savefig', 'var')
	ifdo_savefig = true;
end

% remove the extension in case it is given:
[path, name] = fileparts(filename);
filename = fullfile(path, name);

set(fighandle, 'PaperPositionMode', 'auto'); 
% saveas(fighandle,filename,'epsc -painters');
print('-painters', '-depsc2', [filename '.eps'])

if ifdo_savefig
	savefig(fighandle, filename)
end 