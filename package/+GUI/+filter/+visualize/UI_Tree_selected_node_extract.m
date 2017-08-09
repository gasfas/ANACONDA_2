% Description: Extracts multilayer nodes in the tree. 
%   - inputs: 
%           Nodes.                          (UI.Tree.SelectedNodes)
%   - outputs: 
%           Selected node information.      (parent, SelectedNode)
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:
function [ parent, SelectedNode ] = UI_Tree_selected_node_extract( node_depth, parents_nom_str, parent)
node_depth = node_depth + 1;
node_depth_str = num2str(node_depth);
%% Name of selected node
md_GUI = evalin('base', 'md_GUI');
checkingexistanceofUI = isfield(md_GUI.UI, 'UI');
if checkingexistanceofUI == 1
UI = md_GUI.UI.UI; %Gives access to the tree layout.
SelectedNode = UI.Tree.SelectedNodes.Name;
%% Parent name - get top parent name.
% Compares if the top parent name is filter. If so, path is found.
parent.(['s', node_depth_str]) = general.getsubfield(UI.Tree.SelectedNodes, parents_nom_str);
%parent.(['s', node_depth_str]) = UI.Tree.SelectedNodes.Parent.Name;
s_check = strcmp(parent.(['s', node_depth_str]), 'Filter');
if s_check == 0
    parents_nom_cut = strsplit(parents_nom_str, '.Name');
    parents_nom_str = [char(parents_nom_cut(1)), '.Parent.Name'];
    s_check = strcmp(parent.(['s', node_depth_str]), 'Filter');
    if s_check == 0
        [ parent, SelectedNode ] = GUI.filter.visualize.UI_Tree_selected_node_extract( node_depth, parents_nom_str, parent );
    end
else
    nodeminusone = node_depth - 1;
    % Message to log_box - cell_to_be_inserted:
    cell_to_be_inserted = ['Depth: ', num2str(nodeminusone)];
    [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
    md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
    assignin('base', 'md_GUI', md_GUI)
    % End of new message to log_box function.
end
% path is returned of the selected object in the above algorithm as
% parent.subfields
else
    msgbox('The FilterTreeList is empty.')
    path = 0;
end
end