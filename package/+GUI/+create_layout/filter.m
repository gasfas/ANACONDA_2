% Description: Layout for the filter tab.
%   - inputs: 
%           Main graphical objects, incl. main figure of the GUI.
%   - outputs: 
%           User interface (UI) graphical objects for the filter tab.
% Date of creation: 2017-01-04
% Author: Benjamin Bolling
% Modification date:
% Modifier:

function [ h_figure, UI ] = filter( h_figure, pos, h_tabs, tab_filter)

% Button which increases the fontsize of the UITree
UI.IncreaseFont_Tree = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.05 0.24 0.1 0.05], ...
'Enable', 'on', ...
'String', 'A+', ...
'FontSize', 12, ...
'TooltipString', 'Press to increase fontsize of the UI Tree. Rapid pressing increases it exponentially.');

% Button which decreases the fontsize of the UITree
UI.DecreaseFont_Tree = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.15 0.24 0.1 0.05], ...
'Enable', 'on', ...
'String', 'A-', ...
'FontSize', 10, ...
'TooltipString', 'Press to decrease fontsize of the UI Tree. Rapid pressing decreases it exponentially.');

% Button which opens a dialog window with various editable filter
% parameters
UI.EditFilter = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.27 0.24 0.2 0.05], ...
'Enable', 'on', ...
'String', 'Edit condition', ...
'TooltipString', 'Press to add a condition');

% Button which enables editing the name of the selected filter
UI.RenameFilter = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.49 0.24 0.2 0.05 ], ...
'Enable', 'on', ...
'String', 'Rename condition', ...
'TooltipString', 'Press to rename the selected condition');

% Button which removes the selected filter
UI.RemoveFilter = uicontrol('Parent', tab_filter, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.71 0.24 0.2 0.05], ...
'Enable', 'on', ...
'String', 'Remove condition', ...
'TooltipString', 'Press to remove the selected filter');

% A listbox which shows the names of the different filter parameters
UI.Fieldname = uicontrol('Parent', tab_filter, ...
'Style', 'list', ...
'Units', 'normalized', ...
'Position', [0.05 0.02 0.55 0.2], ...
'FontSize', 14, ...
'Enable', 'on', ...
'String', 'Fieldnames', ...
'TooltipString', 'Fieldnames of selected condition');

% A listbox which shows the values of the different filter parameters
UI.Fieldvalue = uicontrol('Parent', tab_filter, ...
'Style', 'list', ...
'Units', 'normalized', ...
'Position', [0.55 0.02 0.4 0.2], ...
'FontSize', 14, ...
'Enable', 'on', ...
'String', 'Fieldvalue', ...
'TooltipString', 'Fieldvalues of the different fieldname values for the selected condition');

% Construction of the UI Tree:
UI.Tree = general.UI.uiextras.jTree.Tree('Parent', tab_filter);
UI.Tree.Root.Name = 'Filter';
UI.Tree.Position = [0.05 0.31 0.9 0.67];
UI.Tree.Enable = 0;
UI.Tree.NodeDroppedCallback = @(x,y,z) GUI.filter.edit.DnD(x,y);
UI.Tree.MouseClickedCallback = @(x,y,z) GUI.filter.edit.SetEditFilterBoxValue(x,y);
end
