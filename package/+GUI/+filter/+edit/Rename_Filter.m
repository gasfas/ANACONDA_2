% Description: Renames the selected filter.
%   - inputs:
%           Tree node -> filter 'path'          (base_path)
%           Tree node -> filter 'fieldvalue'    (base_fieldvalue)
%           Tree node -> filter 'field'         (base_field
%           Loaded file metadata                (mdata_n)
%           Experiment name                     (exp_name)
%   - outputs:
%           Modified loaded file metadata.      (mdata_n)
% Date of creation: 2017-07-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:
function [] = Rename_Filter(UIFilter)
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
    selected_node_path_cells = strsplit(selected_node_path, '.');
    if nom_parents == 0
        % Name is NOT editable! This is an experimental parameter.
        msgbox('This field cannot be renamed! This is a filter parent for an experiment.', 'Warning')
    elseif strcmp(char(selected_node_path_cells(1)), 'built_in_filter') || strcmp(char(selected_node_path_cells(2)), 'built_in_filter')
        msgbox('Cannot rename a built-in filter.', 'Warning')
    else
        if selected_node_path == 0
            %Do nothing.
        else
            [exp_names] = strsplit(selected_node_path,'.');
            exp_name = char(exp_names(1));
            exp_parts = strsplit(selected_node_path,[exp_name, '.']);
            exp_part = char(exp_parts(2));
            exp_parts_struct = strsplit(exp_part, '.');
            exp_parent_path = char(exp_parts_struct(1));
            for llx = 2:length(exp_parts_struct)-1
                exp_parent_path = [exp_parent_path, '.', char(exp_parts_struct(llx))];
            end
            base_value = general.struct.getsubfield(md_GUI.mdata_n.(exp_name).cond, exp_part);
            
            
            UI = md_GUI.UI.UIFilter;
            OldName = UI.Tree.SelectedNodes.Name;
            NewName = inputdlg('Select the new filter name.', 'New Filter name', 1, {char(OldName)});
            NewName = char(NewName);
            if strcmp(NewName, OldName)
                % Do nothing since old name is same as new name.
                %% Message to log_box - cell_to_be_inserted:
                cell_to_be_inserted = ['New name is the same as the old name.'];
                [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                % End of new message to log_box function.
            else
                parentpath = strsplit(exp_part, '.');
                pathdepth = length(parentpath);
                newpath = strsplit(exp_part, char(parentpath(pathdepth)));
                newpath = char(newpath(1));
                newpath = [newpath, NewName];
                md_GUI.mdata_n.(exp_name).cond = general.struct.setsubfield(md_GUI.mdata_n.(exp_name).cond, newpath, base_value);
                FieldToRmvCell = strsplit(exp_part, '.');
                if length(FieldToRmvCell) == 1
                    md_GUI.mdata_n.(exp_name).cond = rmfield(md_GUI.mdata_n.(exp_name).cond, exp_part);
                else
                    md_GUI.mdata_n.(exp_name).cond = general.rmsubfield(md_GUI.mdata_n.(exp_name).cond, exp_part);
                end
                %% Message to log_box - cell_to_be_inserted:
                cell_to_be_inserted = ['Filter was renamed from [ ', OldName, ' ] to [ ', NewName, ' ].'];
                [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                % End of new message to log_box function.
                UI.Tree.SelectedNodes.Name = NewName;
            end
        end
        assignin('base', 'md_GUI', md_GUI)
    end
end