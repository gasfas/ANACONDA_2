% Description: Creates a new treenode for the file being loaded.
%   - inputs:
%           Metadata of file(s) being loaded
%           Exp number
%   - outputs:
%           Tree node(s) for loaded file's (files') filter.
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ UI ] = FilterTreeList( expnumber ) 
md_GUI = evalin('base', 'md_GUI');
UI = md_GUI.UI.UIFilter;
UI.Tree.Enable = 1;
if ~expnumber == 0
    expnom = expnumber;
    expnumber = int2str(expnumber);
end
exp_md = md_GUI.mdata_n.(['exp', expnumber]);
metadata_cond_1 = fieldnames(exp_md.cond);
exp_name_in_tree = ['exp', int2str(expnom)]; %
Node = md_GUI.filter.Node;
Node.(['exp', int2str(expnom)]) = uiextras.jTree.TreeNode('Name',exp_name_in_tree,'Parent', UI.Tree);
[ Node ] = GUI.filter.visualize.NodeCreator(exp_md.cond, Node, exp_name_in_tree, 'cond');
%% Select nodes
UI.Tree.SelectionType = 'single'; % 'discontinuous' & 'continuous' & 'single'.
% Drag and drop:
UI.Tree.DndEnabled = true;
% Node editing:
UI.Tree.Editable = false;
% Root visibility - Visible = 1, Invisible = 0. Want it invisible.
UI.Tree.RootVisible = 0;
%% Assign new md_GUI into base workspace.
md_GUI.filter.Node = Node;
assignin('base', 'md_GUI', md_GUI)
%assignin('base', 'Node', Node)
end