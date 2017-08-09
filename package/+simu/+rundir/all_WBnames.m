function [ WBsettings ] = all_WBnames(WBsettings)
% creates all the Workbench names from the WBname
WBsettings.basedir = fileparts(mfilename('fullpath'));
WBsettings.WBname = fullfile(WBsettings.basedir, WBsettings.rel_WBname);

extensions =    {'GEM', 'iob', 'PA#', 'PA0', 'fly2', 'rec', 'LUA', 'dat'};
names =         {'GEM', 'IOB', 'PAdash', 'PA0', 'FLY2', 'REC', 'LUA', 'FLYoutput'};
for i = 1:length(extensions);
    extension =             extensions{i};
    name =                  names{i};
    WBsettings.(name) =    [WBsettings.WBname '.' extension];
end

end
