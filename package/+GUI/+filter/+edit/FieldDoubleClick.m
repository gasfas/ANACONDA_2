% Description: Modifies the fieldvalue of a filter.
%   - inputs:
%           Selected node (filter)
%           Selected filter's file metadata
%   - outputs:
%           Modified loaded file metadata
% Date of creation: 2017-07-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [] = FieldDoubleClick(UIFilter)
    md_GUI = evalin('base', 'md_GUI');
    base_field = md_GUI.filter.base_field;
    base_fields = fieldnames(base_field);
    base_fieldvalue = md_GUI.filter.base_fieldvalue;
    base_path = md_GUI.filter.base_path;
    condition_number = UIFilter.Fieldvalue.Value;
    if strcmp(md_GUI.UI.UIFilter.Fieldname.String, 'operator')
        if isfield(base_field, 'operator')
            base_fieldvalue = base_field.operator;
        elseif isfield(base_field, 'operators')
            base_fieldvalue = base_field.operators;
        else
            base_fieldvalue = 'AND';
        end
    end
    previous_ans = char(base_fieldvalue(condition_number));
    fieldselected = char(base_fields(condition_number));
    base_finalpath = [base_path, '.', fieldselected];
    prompt = {sprintf(['Choose a new value for "', fieldselected, '":'])};
    exp_name = md_GUI.filter.filterexpname;
    base_fieldtype = md_GUI.filter.base_fieldtype;
    base_selectedfieldtype = base_fieldtype(condition_number);
    onerowcheck = md_GUI.filter.onerow(condition_number);
    if isfield(base_field, 'operators')
        base_selectedfieldtype = 'char';
    end
    switch char(base_selectedfieldtype)
        case 'char'
            %% Message to log_box
            GUI.log.add(['Fieldtype selected to edit: Character.'])
            new_ans = inputdlg(prompt,['Change: ', fieldselected], 1, {previous_ans});
            new_ans_char = char(new_ans);
            filteroutputvalue = new_ans_char;
            treatable = 1;
        case 'numeric'
            %% Message to log_box
            GUI.log.add(['Fieldtype selected to edit: Numeric.'])
            new_ans = inputdlg(prompt,['Change: ', fieldselected], 1, {previous_ans});
            new_ans_char = char(new_ans);
            if onerowcheck == 1
                new_ans_numcell = strsplit(new_ans_char);
                filteroutputvalue = str2double(new_ans_numcell);
                [rows, columns] = size(filteroutputvalue);
                for colnom = 1:columns
                    if isnan(filteroutputvalue(colnom))
                        msgbox({'error in numeric array:' 'NaN' 'Position:' num2str(colnom) 'Only use numbers with spacing between.'}, 'Error')
                        treatable = 0;
                    else
                        treatable = 1;
                    end
                end
            elseif onerowcheck == 0
                new_ans_numcell = strsplit(new_ans_char);
                new_ans_numcelltranspose = new_ans_numcell.';
                filteroutputvalue = str2double(new_ans_numcelltranspose);
                [rows, columns] = size(filteroutputvalue);
                for rownom = 1:rows
                    if isnan(filteroutputvalue(rownom))
                        msgbox({'error in numeric array:' 'NaN' 'Position:' num2str(rownom) 'Only use numbers with spacing between.'}, 'Error')
                        treatable = 0;
                    else
                        treatable = 1;
                    end
                end
            end
        case 'logical'
            %% Message to log_box
            GUI.log.add(['Fieldtype selected to edit: Logical.'])
            new_ans = inputdlg(prompt,['Change: ', fieldselected], 1, {previous_ans});
            new_ans_char = char(new_ans);
            new_ans_double = str2double(new_ans_char);
            if isnan(new_ans_double)
                msgbox('error: Not a number. It also has to be a logical (0 or 1).', 'Error')
                treatable = 0;
            else
                if new_ans_double == 1 || new_ans_double == 0
                    treatable = 1;
                    filteroutputvalue = logical(new_ans_double);
                else
                    treatable = 0;
                    msgbox('error: Not a Logical. Logical has to be 0 or 1.', 'Error')
                end
            end
        case 'struct'
            %% Operator can be constructed or changed.
            valsel = 0;
            [ base_fieldvalue, valsel ] = GUI.filter.edit.Edit_Operator(base_fieldvalue, valsel);
            if valsel == 1 % Means constructed or changed - add operator to filter structure.
                treatable = 2;
                %% Message to log_box
                GUI.log.add(['New operator set: [ ', base_fieldvalue, ' ] for ', exp_name, '.', base_path, '.operator'])
            else
                treatable = 0;
            end
        otherwise %hmm what could this be... ?
            %% Message to log_box
            GUI.log.add(['Fieldtype selected to edit: Unknown!'])
            treatable = 0;
            msgbox('Check the datatype. It is not a char, numeric, logical nor struct.', 'Unknown error.')
    end
    if treatable == 1
        md_GUI.mdata_n.(exp_name) = general.struct.setsubfield(md_GUI.mdata_n.(exp_name), base_finalpath, filteroutputvalue);
        if ischar(previous_ans)
            previous_val = previous_ans;
        elseif isnumeric(previous_ans)
            previous_val = num2str(previous_ans);
        elseif iscell(previous_ans)
            previous_val = char(previous_ans);
        elseif islogical(previous_ans)
            previous_val = num2str(previous_ans);
        else
            % Error.
        end
        base_fieldvalue(condition_number) = cellstr(new_ans_char);
        md_GUI.filter.base_fieldvalue(condition_number) = base_fieldvalue(condition_number);
        set(UIFilter.Fieldvalue, 'String', cellstr(base_fieldvalue))
        %% Message to log_box
        GUI.log.add(['Previous value(s) for ', fieldselected, ': ', previous_val])
        %% Message to log_box
        GUI.log.add(['New value(s) for ', fieldselected, ': ', new_ans_char])
        %% Message to log_box
        GUI.log.add(['Saved.'])
        assignin('base', 'md_GUI', md_GUI)
    elseif treatable == 2 % Operator changing
        base_finalpath = [base_path, '.operator'];
        md_GUI.mdata_n.(exp_name) = general.struct.setsubfield(md_GUI.mdata_n.(exp_name), base_finalpath, base_fieldvalue);
        md_GUI.UI.UIFilter.Fieldvalue.String = base_fieldvalue;
        assignin('base', 'md_GUI', md_GUI)
    end
end