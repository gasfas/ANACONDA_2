% Description: Creates a new treenode for the common filters.
%   - inputs: none.
%   - outputs:
%           Tree node for the common filters.
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ UI ] = FilterTreeList_built_in_filter() 
import uiextras.jTree.*
%% Create tree nodes
% Parent's name is always Filter, which is set as root.
% Creates list of filter names under Filter.
md_GUI = evalin('base', 'md_GUI');
built_in_filter = md_GUI.filter.built_in_filter;
UI = md_GUI.UI.UIFilter; % Gives access to the tree layout.
UI.Tree.Enable = 1;
expnom = 0;
built_in_filter_fieldnames = fieldnames(built_in_filter.cond);
Node.(['Experiment', int2str(expnom)]) = TreeNode('Name','built_in_filter','Parent',UI.Tree);
[ Node ] = GUI.filter.visualize.NodeCreator(built_in_filter_fieldnames, built_in_filter, Node, expnom);
%% Select nodes
% Strongly recommend having single selection - multi selection not yet supported since filter structure altering has to be exported...
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
%assignin('base', 'Node', Node)
end