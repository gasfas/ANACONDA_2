function [md_GUI] = GUI ()
%% UI
md_GUI.UI.log_box_string = {['Log: ', datestr(datetime('now'))]};
md_GUI.UI.tabnumber = 1;
%% Load
md_GUI.load.folder_name = pwd;
%% Calib
%% Filter
md_GUI.filter.tree.NewNodeLevel = 1;
md_GUI.filter.tree.NameOfTab = 'filter';
set(groot,'units','pixels')
%md_GUI.filter.list.RowNumber = 0;
%% Built-in filters defined:
md_GUI.filter.set_filter_names = cellstr('filter');
md_GUI.filter.built_in_filter.cond.Combined_Filter.EventsFilter.type = 'continuous';
md_GUI.filter.built_in_filter.cond.Combined_Filter.EventsFilter.value = [0 40];
md_GUI.filter.built_in_filter.cond.Combined_Filter.EventsFilter.data_pointer = 'e.det1.m2q_l_sum';
md_GUI.filter.built_in_filter.cond.Combined_Filter.HitsFilter.type = 'discrete';
md_GUI.filter.built_in_filter.cond.Combined_Filter.HitsFilter.value = [0 5 10 15 20 25 30 35 40];
md_GUI.filter.built_in_filter.cond.Combined_Filter.HitsFilter.data_pointer = 'h.det1.m2q_l';
%% Plot
md_GUI.plot.filtersel = 'No_Filter';
end