% Description: Removes the selected filter.
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
function [] = Remove_Filter(UIFilter)
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
        [exp_names] = strsplit(selected_node_path,'.');
        exp_name = char(exp_names(1));
        exp_name_filter = strsplit(exp_name,  '.');
        if length(exp_name_filter) == 1
            % Good - then exp_name is expN where N is the experiment number.
        else % This means that the experiment itself is selected and that the cell name is Filter.expN. "Filter." must then be extracted.
            exp_name = char(exp_name_filter(1));
        end
        exp_parts = strsplit(selected_node_path,([exp_name, '.']));
        exp_parts_struct = strsplit(char(exp_parts(2)), '.');
        exp_md = md_GUI.mdata_n.(exp_name);
        %metadata_cond = fieldnames(exp_md.cond);
        base_value = exp_md.cond;
        base_path = 'cond';
        for sdf = 1:length(exp_parts_struct)
            base_value = base_value.([char(exp_parts_struct(sdf))]);
        end
        %% Check if chosen property has children. If not, choose its parent.
        ischosenfiltstruct = isstruct(base_value); % 1 means it is a struct, 0 that it is not a struct.
        if ischosenfiltstruct == 1
            for sdf = 1:length(exp_parts_struct)
                % base_value is then good to go.
                base_path = [base_path, '.', char(exp_parts_struct(sdf))];
            end
        elseif ischosenfiltstruct == 0
            base_value = exp_md.cond; %must be restructured.
            for sdf = 1:(length(exp_parts_struct)-1)
                base_value = base_value.([char(exp_parts_struct(sdf))]); 
                base_path = [base_path, '.', char(exp_parts_struct(sdf))];
            end
        end
        filtname = md_GUI.UI.UIFilter.Tree.SelectedNodes.Name;
        choice = questdlg(['Are you sure you want to delete ', filtname, '?'],'Remove filter');
        switch choice
            case 'Yes'
            parentname = md_GUI.UI.UIFilter.Tree.SelectedNodes.Parent.Name;
            checkifnotexperiment = strcmp(parentname, 'Filter');
            if checkifnotexperiment == 0 % Means parent is not Filter and hence it is not an experiment itself
                % Remove it:
                FieldToRmv = strsplit(base_path, 'cond.');
                FieldToRmv = char(FieldToRmv(2));
                FieldToRmvCell = strsplit(FieldToRmv, '.');
                if length(FieldToRmvCell) == 1
                    md_GUI.mdata_n.(exp_name).cond = rmfield(md_GUI.mdata_n.exp1.cond, FieldToRmv);
                else
                    md_GUI.mdata_n.(exp_name).cond = general.rmsubfield(md_GUI.mdata_n.(exp_name).cond, FieldToRmv);
                end
                %% Message to log_box - cell_to_be_inserted:
                FilterName = UIFilter.Tree.SelectedNodes.Name;
                FilterName = char(FilterName);
                FilterParentName = UIFilter.Tree.SelectedNodes.Parent.Name;
                FilterParentName = char(FilterParentName);
                cell_to_be_inserted = ['Filter [ ', FilterName, ' ] removed from [ ', FilterParentName, ' ].'];
                [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                % End of new message to log_box function.
                %%
                SelNode = UIFilter.Tree.SelectedNodes.Parent;
                UIFilter.Tree.SelectedNodes.delete
                UIFilter.Tree.SelectedNodes = SelNode;
                for lzz = length(FieldToRmvCell)-1:-1:1
                    % Check if parent filter combinations are empty or not:
                    for lzx = 1:lzz
                        if lzx == 1
                            fieldcheck = char(FieldToRmvCell(lzx));
                        else
                            fieldcheck = [fieldcheck, '.', char(FieldToRmvCell(lzx))];
                        end
                    end
                    parentcheck = general.getsubfield(md_GUI.mdata_n.(exp_name).cond, fieldcheck);
                    if isempty(fieldnames(parentcheck))
                        fieldcheckCell = strsplit(fieldcheck, '.');
                        if length(fieldcheckCell) == 1
                            md_GUI.mdata_n.(exp_name).cond = rmfield(md_GUI.mdata_n.exp1.cond, fieldcheck);
                        else
                            md_GUI.mdata_n.(exp_name).cond = general.rmsubfield(md_GUI.mdata_n.(exp_name).cond, fieldcheck);
                        end
                        %% Message to log_box - cell_to_be_inserted:
                        FilterName = UIFilter.Tree.SelectedNodes.Name;
                        FilterName = char(FilterName);
                        FilterParentName = UIFilter.Tree.SelectedNodes.Parent.Name;
                        FilterParentName = char(FilterParentName);
                        cell_to_be_inserted = ['Filter combination [ ', FilterName, ' ] removed from [ ', FilterParentName, ' ].'];
                        [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                        md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                        % End of new message to log_box function.
                        %%
                        SelNode = UIFilter.Tree.SelectedNodes.Parent;
                        UIFilter.Tree.SelectedNodes.delete
                        UIFilter.Tree.SelectedNodes = SelNode;
                    elseif length(fieldnames(parentcheck)) == 1
                        operatorcheck = fieldnames(parentcheck);
                        operatorcheck = char(operatorcheck(1));
                        if strcmp(operatorcheck, 'operators')
                            fieldcheckCell = strsplit(fieldcheck, '.');
                            if length(fieldcheckCell) == 1
                                md_GUI.mdata_n.(exp_name).cond = rmfield(md_GUI.mdata_n.exp1.cond, fieldcheck);
                            else
                                md_GUI.mdata_n.(exp_name).cond = general.rmsubfield(md_GUI.mdata_n.(exp_name).cond, fieldcheck);
                            end
                            %% Message to log_box - cell_to_be_inserted:
                            FilterName = UIFilter.Tree.SelectedNodes.Name;
                            FilterName = char(FilterName);
                            FilterParentName = UIFilter.Tree.SelectedNodes.Parent.Name;
                            FilterParentName = char(FilterParentName);
                            cell_to_be_inserted = ['Filter combination [ ', FilterName, ' ] removed from [ ', FilterParentName, ' ].'];
                            [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
                            md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
                            % End of new message to log_box function.
                            %%
                            SelNode = UIFilter.Tree.SelectedNodes.Parent;
                            UIFilter.Tree.SelectedNodes.delete
                            UIFilter.Tree.SelectedNodes = SelNode;
                        end
                    end
                end
                assignin('base', 'md_GUI', md_GUI)
            elseif checkifnotexperiment == 1
                msgbox('This is an experiment filter container and can not be deleted.')
            end
        end
    end
end