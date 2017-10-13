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
set(groot,'units','pixels')
scrsize = get( groot, 'Screensize' );
%md_GUI.filter.tree.FontSize = max(8, scrsize(3) * 0.7 - 182); % Fontsize of the tree shown.
md_GUI.filter.tree.FontSize = 40;
md_GUI.filter.list.RowNumber = 0;
md_GUI.filter.set_filter_names = cellstr('filter'); % Write it in the code, not here in definitions.
md_GUI.filter.built_in_filter.cond.Combined_Filter.EventsFilter.type = 'continuous';
md_GUI.filter.built_in_filter.cond.Combined_Filter.EventsFilter.value = [0 40];
md_GUI.filter.built_in_filter.cond.Combined_Filter.EventsFilter.data_pointer = 'e.det1.m2q_l_sum';
md_GUI.filter.built_in_filter.cond.Combined_Filter.HitsFilter.type = 'discrete';
md_GUI.filter.built_in_filter.cond.Combined_Filter.HitsFilter.value = [0 5 10 15 20 25 30 35 40];
md_GUI.filter.built_in_filter.cond.Combined_Filter.HitsFilter.data_pointer = 'h.det1.m2q_l';
%% Plot
md_GUI.plot.filtersel = 'No_Filter';
end