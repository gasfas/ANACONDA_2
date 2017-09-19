% Description: Creates multilayer nodes in the tree. 
%   - inputs: (none are from md_GUI)
%           Loaded file metadata conditions.        (mdata_n. _ .cond)
%           Nodes                                   (Node)
%   - outputs: 
%           Nodes.                                  (Tree.Node.Node...)
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:
function [ Node ] = NodeCreator(md_cond, Node, field_name, parentstruct)
if strcmp(parentstruct, 'cond')
    NodeStruct = field_name;
else
    NodeStruct = [parentstruct, '_', field_name];
    Node.(NodeStruct) = uiextras.jTree.TreeNode('Name', field_name, 'Parent', Node.(parentstruct));
end
md_cond_fields = fieldnames(md_cond);
for lx = 1:length(md_cond_fields)
    md_subcondstr = char(md_cond_fields(lx));
    md_subcond = md_cond.(md_subcondstr);
    if isstruct(md_subcond)
        Node = GUI.filter.visualize.NodeCreator(md_subcond, Node, md_subcondstr, NodeStruct);
    end
end
end