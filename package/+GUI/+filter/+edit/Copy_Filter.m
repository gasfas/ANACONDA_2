% Description: Duplicates a filter.
%   - inputs:
%           Tree node -> filter 'path'          (base_path)
%           Tree node -> filter 'fieldvalue'    (base_fieldvalue)
%           Tree node -> filter 'field'         (base_field
%           Loaded file metadata                (mdata_n)
%           Experiment name                     (exp_name)
%   - outputs:
%           Modified loaded file metadata.      (mdata_n)
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:
function [] = Copy_Filter(UIFilter)
%Load md_GUI from 'base' workpace:
%   - must always be put into workspace in terms of paths.
md_GUI = evalin('base', 'md_GUI');
%% Extracting the selected node
% Get the path of the selected node:
node_depth = 0; %At start 0 since penetration has not begun.
parents_nom_str = 'Parent.Name'; %Starting parental path.
parent.xyx = 0; %simply creating a struct named parent.
[ parent, SelectedNode ] = GUI.filter.visualize.UI_Tree_selected_node_extract( node_depth, parents_nom_str, parent );
% From the recursive extractor above, the path is returned as (parent.s(N-1)). ... .(parent.s2).
nom_parents = length(fieldnames(parent)) - 2; %First fieldname is xyx ('waste'), and last one is the selected node.
prev_path = parent.s1;
for pathway = 2:(nom_parents) % 2 since number 1 is already set to prev_path.
    prev_path = [(parent.(['s', num2str(pathway)])), '.', prev_path, ];
end
selected_node_path = [prev_path, '.', SelectedNode];
if selected_node_path == 0
    %Do nothing.
else
[exp_names] = strsplit(selected_node_path,'_|_');
exp_name = char(exp_names(1));
exp_real_name = char(exp_names(2));
exp_parts = strsplit(selected_node_path,'_|_.');
exp_part = char(exp_parts(2));
exp_parts_struct = strsplit(exp_part, '.');
exp_md = md_GUI.mdata_n.(exp_name);
%metadata_cond = fieldnames(exp_md.cond);
base_value = exp_md.cond;
base_path = 'cond';
for sdf = 2:length(exp_parts_struct)
    base_value = base_value.([char(exp_parts_struct(sdf))]);
end
%% Check if chosen property has children. If not, choose its parent.
ischosenfiltstruct = isstruct(base_value); % 1 means it is a struct, 0 that it is not a struct.
if ischosenfiltstruct == 1
    for sdf = 2:length(exp_parts_struct)
        % base_value is then good to go.
        base_path = [base_path, '.', char(exp_parts_struct(sdf))];
        if sdf == length(exp_parts_struct) - 1
            base_parent_path = base_path;
        end
    end
elseif ischosenfiltstruct == 0
    base_value = exp_md.cond; %must be restructured.
    for sdf = 2:(length(exp_parts_struct)-1)
        base_value = base_value.([char(exp_parts_struct(sdf))]); 
        base_path = [base_path, '.', char(exp_parts_struct(sdf))];
        if sdf == length(exp_parts_struct) - 2
            base_parent_path = base_path;
        end
    end
end
%Have from above: base_parent_path, base_path, base_value
import uiextras.jTree.* % Needed in order to be able to call and edit the UI.Tree.
UI = evalin('base','UI');

NewName = inputdlg('Select the new filter name.', 'New Filter name');
NewName = char(NewName);
OldName = UI.Tree.SelectedNodes.Name;
DiffNames = strcmp(NewName, OldName);
if DiffNames == 1   %They are the same - not allowed.
    msgbox('Same name as previously is forbidden.')
else                %They are not the same - allowed.
    UI.Tree.SelectedNodes.copy((UI.Tree.SelectedNodes.Parent));
    UI.Tree.SelectedNodes.Name = NewName;
    checkifitissecondtoplayer = exist('base_parent_path');% True if it is not secondtoplayer.
    if checkifitissecondtoplayer == 0
        base_parent_path = 'cond';
    end
    base_pathpath = [base_parent_path, '.', NewName];
    md_GUI.mdata_n.(exp_name) = general.setsubfield(md_GUI.mdata_n.(exp_name), base_pathpath, base_value);
end
end
assignin('base', 'md_GUI', md_GUI)
end