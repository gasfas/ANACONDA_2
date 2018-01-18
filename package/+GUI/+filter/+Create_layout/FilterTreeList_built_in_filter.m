% Description: Creates a new treenode for the common filters.
%   - inputs:
%           Metadata of built-in filters.
%   - outputs:
%           Tree node for the common filters.
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ UI ] = FilterTreeList_built_in_filter() 
%% Create tree nodes
md_GUI = evalin('base', 'md_GUI');
built_in_filter = md_GUI.filter.built_in_filter;
UI = md_GUI.UI.UIFilter;
UI.Tree.Enable = 1;
Node.('built_in_filter') = uiextras.jTree.TreeNode('Name','built_in_filter','Parent',UI.Tree);
[ Node ] = GUI.filter.visualize.NodeCreator(built_in_filter.cond, Node, 'built_in_filter', 'cond');
%% Select nodes
UI.Tree.SelectionType = 'single'; % 'discontinuous' & 'continuous' & 'single'. For some reason suggested 'dis'-/'contiguous' ? ? ?
%% Drag and drop
UI.Tree.DndEnabled = true;
%% Node editing
UI.Tree.Editable = false;
%% Root visibility - Visible = 1, Invisible = 0.
UI.Tree.RootVisible = 0;
%% Text font
UI.Tree.FontSize = 7;
%% Assign new md_GUI into base workspace.
md_GUI.filter.Node = Node;
assignin('base', 'md_GUI', md_GUI)
end