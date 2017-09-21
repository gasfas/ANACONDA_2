% Description: Edits all fields of the selected filter.
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
function [] = Edit_Filter(UIFilter)
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
    if length(fieldnames(parent)) > 1
    %if ~parent == 0
        nom_parents = length(fieldnames(parent)) - 2; %First fieldname is xyx ('waste'), and last one is the selected node.
        children = md_GUI.UI.UIFilter.Tree.SelectedNodes.Children;

        if ~isempty(children)
            msgbox('This field cannot be edited using this function since it is not a filter but a filter folder.')
        else
            prev_path = parent.s1;
            for pathway = 2:(nom_parents) % 2 since number 1 is already set to prev_path.
                prev_path = [(parent.(['s', num2str(pathway)])), '.', prev_path, ];
            end
            selected_node_path = [prev_path, '.', SelectedNode];
            selected_node_path_cells = strsplit(selected_node_path, '.')
            if selected_node_path == 0
                %Do nothing.
            elseif strcmp(char(selected_node_path_cells(1)), 'built_in_filter') || strcmp(char(selected_node_path_cells(2)), 'built_in_filter')
                msgbox('Cannot edit common filters.')
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
                fieldstoedit = [1 1 1 1 1];
                if ~isfield(base_value, 'data_pointer')
                    fieldstoedit(1) = 0;
                end
                if ~isfield(base_value, 'value')
                    fieldstoedit(2) = 0;
                end
                if ~isfield(base_value, 'type')
                    fieldstoedit(3) = 0;
                end
                if ~isfield(base_value, 'translate_condition')
                    fieldstoedit(4) = 0;
                end
                if ~isfield(base_value, 'invert_filter')
                    fieldstoedit(5) = 0;
                end
                oldbasevalue = base_value;
                datapointers = md_GUI.data_n.(char(exp_name));
                base_value = GUI.filter.edit.Edit_Filter_Choice(fieldstoedit, base_value, datapointers);
                md_GUI.mdata_n.(exp_name).cond = general.struct.setsubfield(md_GUI.mdata_n.(exp_name).cond, exp_part, base_value);
                allfields = fieldnames(base_value);
                md_GUI.UI.UIFilter.Fieldvalue.String = cell(size(allfields));
                md_GUI.UI.UIFilter.Fieldname.String = cell(size(allfields));
                for llz = 1:length(allfields)
                    if strcmp(allfields(llz), 'type')
                        md_GUI.UI.UIFilter.Fieldvalue.String(llz) = {base_value.type};
                        md_GUI.UI.UIFilter.Fieldname.String(llz) = cellstr('type');
                    end
                    if strcmp(allfields(llz), 'data_pointer')
                        md_GUI.UI.UIFilter.Fieldvalue.String(llz) = {base_value.data_pointer};
                        md_GUI.UI.UIFilter.Fieldname.String(llz) = cellstr('data_pointer');
                    end
                    if strcmp(allfields(llz), 'value')
                        md_GUI.UI.UIFilter.Fieldvalue.String(llz) = {strjoin(strsplit(char(num2str(base_value.value))), '  ')};
                        md_GUI.UI.UIFilter.Fieldname.String(llz) = cellstr('value');
                    end
                    if strcmp(allfields(llz), 'translate_condition')
                        md_GUI.UI.UIFilter.Fieldvalue.String(llz) = {base_value.translate_condition};
                        md_GUI.UI.UIFilter.Fieldname.String(llz) = cellstr('translate_condition');
                    end
                    if strcmp(allfields(llz), 'invert_filter')
                        md_GUI.UI.UIFilter.Fieldvalue.String(llz) = {num2str(base_value.invert_filter)};
                        md_GUI.UI.UIFilter.Fieldname.String(llz) = cellstr('invert_filter');
                    end
                end
                if length(allfields) > length(fieldnames(oldbasevalue)) % means new fields have been added.
                    for llx = length(oldbasevalue)+1:length(allfields)
                        md_GUI.UI.UIFilter.Fieldname.String(llx) = allfields(llx);
                        vaal = base_value.(char(allfields(llx)));
                        if islogical(vaal) || isnumeric(vaal)
                            vaal = num2str(vaal);
                        end
                        md_GUI.UI.UIFilter.Fieldvalue.String(llx) = cellstr(vaal);
                    end
                end
                %% Message to log_box - cell_to_be_inserted:
                cell_to_be_inserted = ['The filter ', exp_part, ' for ',parent.s2, ' has been edited.'];
                [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                % End of new message to log_box function.
                        %% Message to log_box - cell_to_be_inserted:
                cell_to_be_inserted = ['New filter conditions saved.'];
                [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                % End of new message to log_box function.
            end
        end
        assignin('base', 'md_GUI', md_GUI)
    end
end