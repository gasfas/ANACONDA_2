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
            base_value = general.getsubfield(md_GUI.mdata_n.(exp_name).cond, exp_part); 
            UI = md_GUI.UI.UIFilter;
            fieldstoedit = [1 1 1 1 1];
            if ~isfield(base_value, 'data_pointer')
                base_value.data_pointer = 'datapointer';
            end
            if ~isfield(base_value, 'value')
                base_value.value = '0 1';
            end
            if ~isfield(base_value, 'type')
                base_value.type = 'continuous';
            end
            if ~isfield(base_value, 'translate_condition')
                create_tc_filt = questdlg('Create a translate condition field?', 'Translate condition field not found.', 'yes', 'no', 'no');
                switch create_tc_filt
                    case 'yes'
                        base_value.translate_condition = 'AND';
                    case 'no'
                        fieldstoedit(4) = 0;
                end
            end
            if ~isfield(base_value, 'invert_filter')
                create_inv_filt = questdlg('Create an invert filter field?', 'Invert Filter field not found.', 'yes', 'no', 'no');
                switch create_inv_filt
                    case 'yes'
                        base_value.invert_filter = logical(0);
                    case 'no'
                        fieldstoedit(5) = 0;
                end
            end
            base_value = GUI.filter.edit.Edit_Filter_Choice(fieldstoedit, base_value);
            md_GUI.mdata_n.(exp_name).cond = general.setsubfield(md_GUI.mdata_n.(exp_name).cond, exp_part, base_value);
        end
        fieldnamms = md_GUI.UI.UIFilter.Fieldname.String;
        for llz = 1:length(fieldnamms)
            if strcmp(fieldnamms, 'type')
                md_GUI.UI.UIFilter.Fieldvalue.String(llz) = base_value.type;
            end
            if strcmp(fieldnamms, 'data_pointer')
                md_GUI.UI.UIFilter.Fieldvalue.String(llz) = base_value.data_pointer;
            end
            if strcmp(fieldnamms, 'value')
                md_GUI.UI.UIFilter.Fieldvalue.String(llz) = base_value.value;
            end
            if strcmp(fieldnamms, 'translate_condition')
                md_GUI.UI.UIFilter.Fieldvalue.String(llz) = base_value.translate_condition;
            end
            if strcmp(fieldnamms, 'invert_filter')
                md_GUI.UI.UIFilter.Fieldvalue.String(llz) = base_value.invert_filter;
            end
        end
        if length(fieldnamms) < length(fieldnames(base_value)) % means new fields have been added.
            allfields = fieldnames(base_value);
            for llx = length(fieldnamms)+1:length(fieldnames(base_value))
                md_GUI.UI.UIFilter.Fieldname.String(llx) = allfields(llx);
                vaal = base_value.(char(allfields(llx)));
                if islogical(vaal)
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
        assignin('base', 'md_GUI', md_GUI)
    end
end