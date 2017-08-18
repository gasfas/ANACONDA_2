% Description: Layout for the filter tab.
%   - inputs: 
%           Envents coming from the GUI.
%   - outputs: 
%           User interface (UI) control values for the filter tab control
%           functions, including the UI Tree (at bottom).
% Date of creation: 2017-07-11
% Author: Benjamin Bolling
% Modification date:
% Modifier:

function [ h_figure, UI ] = filter( h_figure, pos, h_tabs, tab_filter)
%% Functions
UI.AddFilter = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.27 0.42 0.2 0.05], ...
'Enable', 'on', ...
'String', 'Add filter', ...
'TooltipString', 'Press to add a filter');

% UI.CopyFilter = uicontrol('Parent', tab_filter, ...
% 'Style', 'pushbutton', ...
% 'Units', 'normalized', ...
% 'Position', [0.05 0.42 0.2 0.05], ...
% 'Enable', 'on', ...
% 'String', 'Copy filter', ...
% 'TooltipString', 'Press to add a filter');

UI.RenameFilter = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.49 0.42 0.2 0.05 ], ...
'Enable', 'on', ...
'String', 'Rename filter', ...
'TooltipString', 'Press to set value to selected filter');

UI.RemoveFilter = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.71 0.42 0.2 0.05], ...
'Enable', 'on', ...
'String', 'Remove filter', ...
'TooltipString', 'Press to Remove the selected filter');

UI.Fieldname = uicontrol('Parent', tab_filter, ...
'Style', 'list', ...
'Units', 'normalized', ...
'Position', [0.05 0.05 0.55 0.35], ...
'FontSize', 14, ...
'Enable', 'on', ...
'String', 'Fieldnames', ...
'TooltipString', 'Fieldnames of selected filter');

UI.Fieldvalue = uicontrol('Parent', tab_filter, ...
'Style', 'list', ...
'Units', 'normalized', ...
'Position', [0.55 0.05 0.4 0.35], ...
'FontSize', 14, ...
'Enable', 'on', ...
'String', 'Fieldvalue', ...
'TooltipString', 'Fieldvalues of the different fieldname values for the selected filter.');

% Creating the UI Tree, exported and imported using [ UI ].
UI.Tree = uiextras.jTree.Tree('Parent', tab_filter);
UI.Tree.Root.Name = 'Filter';
%UI.Tree.Units = 'normalized';
UI.Tree.Position = [0.05 0.48 0.9 0.5];
UI.Tree.Enable = 0;
UI.Tree.FontSize = 12;
UI.Tree.NodeDroppedCallback = @(x,y,z) GUI.filter.edit.DnD(x,y);
UI.Tree.MouseClickedCallback = @(x,y,z) GUI.filter.edit.SetEditFilterBoxValue(x,y);
end