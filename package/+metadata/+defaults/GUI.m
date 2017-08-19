function [md_GUI] = GUI ()

% md_GUI = struct();        deleted
% md_GUI.NumberOfLoadedFiles = 0;   relocated
% md_GUI.TreeValueCheck = 1;    relocated + renamed: NameOfTab (Not a number anymore but a string
% md_GUI.foldervariable = 0;    deleted
% md_GUI.filterlistval = 0;     renamed + relocated: list.RowNumber
% md_GUI.set_filter_names = cellstr('filter');
% md_GUI.NewNodeNumber = 1;     relocated + renamed: NewNodeLevel
% md_GUI.struct = 'No_Filter';  relocated + renamed: filtersel
% md_GUI.expsettings.All = [2 1 1];
% md_GUI.plotsettings = [1 1 1 1];
% assignin('base', 'md_GUI', md_GUI);
% assignin('base', 'tab_filter', tab_filter)

%% UI
md_GUI.UI.log_box_string = {['Log: ', datestr(datetime('now'))]};
md_GUI.UI.tabnumber = 1;
%% Load
md_GUI.load.NumberOfLoadedFiles = 0;
md_GUI.load.folder_name = pwd;
%% Calib
%% Filter
md_GUI.filter.tree.NewNodeLevel = 1;
md_GUI.filter.tree.NameOfTab = 'filter';
md_GUI.filter.list.RowNumber = 0;
md_GUI.filter.set_filter_names = cellstr('filter'); % Write it in the code, not here in definitions.
%% Plot
md_GUI.plot.filtersel = 'No_Filter';
md_GUI.plot.expsettings.All = [2 1 1];
md_GUI.plot.plotsettings = [1 1 1 1];
end