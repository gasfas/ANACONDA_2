% Description: Sets the FieldnameList and FieldValueList to have the names
% resp. the values of the selected filter.
%   - inputs: 
%           Experiment name                     (exp_name)
%           Selected experiment metadata        (mdata_n)
%           Selected node position (parent, children)
%   - outputs: 
%           Field names                         (FieldnameList)
%           Field values                        (FieldValueList)
%           FieldnameList & FieldValueList associated values.
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [] = SetEditFilterBoxValue(Tree, ~)
treePath = Tree.SelectedNodes;
md_GUI = evalin('base', 'md_GUI');
UIFilter = md_GUI.UI.UIFilter;
if isempty(treePath)
    % Nothing selected.
    set(UIFilter.Fieldvalue, 'String', {' - - Value - - ', ' - - Value - - '})
    set(UIFilter.Fieldname, 'String', {' - - Name - - ', ' - - Name - - '})
else
md_GUI = evalin('base', 'md_GUI');
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
    base_fieldtype = cellstr('Nothing');
else
exp_parts = strsplit(selected_node_path,'.');
exp_name = exp_parts(1);
md_GUI.filter.filterexpname = char(exp_name);
if strcmp(char(exp_parts(1)), 'Filter')
    % Do nothing - experiment was selected.
    base_fieldtype = cellstr('Experiment');
    filtertreatable = 0;
else
    exp_md = md_GUI.mdata_n.(char(exp_name));
    base_field = exp_md.cond;
    base_path = 'cond';
    for sdf = 2:length(exp_parts)
        base_field = base_field.([char(exp_parts(sdf))]);
        base_fieldnames = fieldnames(base_field);
        base_path = [base_path, '.', char(exp_parts(sdf))];
    end
    for fieldnumbervalue = 1:length(base_fieldnames)
        base_fieldvaluex = base_field.([char(base_fieldnames(fieldnumbervalue))]);
        if ischar(base_fieldvaluex)
            md_GUI.filter.numeric = 0;
            filtertreatable = 1;
            base_fieldvalue(fieldnumbervalue) = cellstr(base_fieldvaluex);
            base_fieldtype(fieldnumbervalue) = cellstr('char');
            md_GUI.filter.onerow(fieldnumbervalue) = 1;
        elseif isnumeric(base_fieldvaluex)
            md_GUI.filter.numeric = 1;
            if length(base_fieldvaluex) == 1
                filtertreatable = 1;
            else
                [xxrows, xxcolumns] = size(base_fieldvaluex);
                if xxrows == 1
                    % Then good. Nothing else needed.
                    md_GUI.filter.onerow(fieldnumbervalue) = 1;
                    filtertreatable = 1;
                else
                    %Check if there is also more than one column. If yes, not
                    %possible to use vallues.
                    if xxcolumns == 1
                        % Then good - let's convert rows to columns.
                        % Important to remember this for the filter.
                        md_GUI.filter.onerow(fieldnumbervalue) = 0;
                        filtertreatable = 1;
                        base_fieldvaluex = base_fieldvaluex.';
                    else
                        % This means that the matrix cannot be treated.
                        filtertreatable = 0;
                        md_GUI.filter.onerow(fieldnumbervalue) = 0;
                        disp('Matrix too large.')
                        disp('Matrix dimensions required:')
                        disp(' [n, 1] or [1, n]')
                    end
                end
            end
            if filtertreatable == 1
                base_fieldvalue(fieldnumbervalue) = cellstr(num2str(base_fieldvaluex));
                base_fieldtype(fieldnumbervalue) = cellstr('numeric');
            else
                base_fieldtype(fieldnumbervalue) = cellstr('Numeric_untreatable');
            end
        elseif islogical(base_fieldvaluex)
            md_GUI.filter.onerow(fieldnumbervalue) = 1;
            md_GUI.filter.numeric = 1;
            filtertreatable = 1;
            base_fieldvalue(fieldnumbervalue) = cellstr(num2str(base_fieldvaluex));
            base_fieldtype(fieldnumbervalue) = cellstr('logical');
        elseif isstruct(base_fieldvaluex)
            md_GUI.filter.onerow(fieldnumbervalue) = 0;
            filtertreatable = 1;
            base_fieldvalue(fieldnumbervalue) = cellstr('Structure.');
            base_fieldtype(fieldnumbervalue) = cellstr('struct');
        end
    end
    md_GUI.filter.TreeNodeSel = treePath;
    md_GUI.filter.base_field = base_field;
    md_GUI.filter.base_fieldvalue = base_fieldvalue;
    md_GUI.filter.base_path = base_path;
    md_GUI.filter.base_fieldtype = base_fieldtype;
end
md_GUI.filter.filterlistval = 0;
assignin('base', 'md_GUI', md_GUI);
if filtertreatable == 1
    set(UIFilter.Fieldvalue, 'String', base_fieldvalue)
    set(UIFilter.Fieldname, 'String', base_fieldnames)
    set(UIFilter.Fieldvalue, 'Value', 1)
    set(UIFilter.Fieldname, 'Value', 1)
    
    % Check if base_fieldvaluex is struct. If yes, check if one child is
    % the 'operators'.
    if isstruct(base_field)
        operatorexist = 0;
        childrennames = fieldnames(base_field);
        for llz = 1:length(childrennames)
            if strcmp(char(childrennames(llz)), 'operators')
                operatorexist = 1;
            end
        end
    end
    
    if operatorexist == 0
        if strcmp(char(base_fieldvalue(1)), 'Structure.')
            set(UIFilter.Fieldvalue, 'Enable', 'off')
            set(UIFilter.Fieldname, 'Enable', 'off')
        else
            set(UIFilter.Fieldvalue, 'Enable', 'on')
            set(UIFilter.Fieldname, 'Enable', 'on')
        end
    elseif operatorexist == 1
        operatorvalue = base_field.operators;
        set(UIFilter.Fieldvalue, 'String', operatorvalue)
        set(UIFilter.Fieldname, 'String', 'operators')
        set(UIFilter.Fieldvalue, 'Enable', 'on')
        set(UIFilter.Fieldname, 'Enable', 'on')
    end
    %set(UIFilter.EditFilter, 'Enable', 'on')
elseif filtertreatable == 0
    set(UIFilter.Fieldvalue, 'Enable', 'off')
    set(UIFilter.Fieldname, 'Enable', 'off')
	set(UIFilter.Fieldvalue, 'String', {' - - Value - - ', ' - - Value - - '})
    set(UIFilter.Fieldname, 'String', {' - - Name - - ', ' - - Name - - '})
    set(UIFilter.Fieldvalue, 'Value', 1)
    set(UIFilter.Fieldname, 'Value', 1)
end
end
end
end