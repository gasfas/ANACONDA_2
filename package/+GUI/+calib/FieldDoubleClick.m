
function [] = FieldDoubleClick(UICalib)
    md_GUI = evalin('base', 'md_GUI');
   
    
    tabselected = UICalib.h_calib_tabs.SelectedTab.Title;
    det_mode    = UICalib.Popup_DetModes.Value -1;
    det_mode    = ['det', num2str(det_mode)];
            
    
    %define the fields to be modified    
    base_fields = UICalib.(tabselected).Fieldname.String;
    base_fieldvalue = UICalib.(tabselected).Fieldvalue.String;
    
   
    
    condition_number = UICalib.(tabselected).Fieldvalue.Value;
    
%     if strcmp(md_GUI.UI.UIFilter.Fieldname.String, 'operator')
%         if isfield(base_field, 'operator')
%             base_fieldvalue = base_field.operator;
%         elseif isfield(base_field, 'operators')
%             base_fieldvalue = base_field.operators;
%         else
%             base_fieldvalue = 'AND';
%         end
%     end
        
    previous_ans = char(base_fieldvalue(condition_number));
    fieldselected = char(base_fields(condition_number));
 
   base_path = md_GUI.calib.(tabselected).base{condition_number};
   
    base_finalpath = base_path;
    
    prompt = {sprintf(['Choose a new value for "', fieldselected, '":'])};
    
    exp_name = ['exp', num2str(UICalib.LoadedFilesCalibrating.Value)];
    
    for i= 1:length(base_fields)
        if ischar(base_fieldvalue{i})
            fieldselectedType{i} = 'char';
        elseif isnumeric(base_fieldvalue{i})
            fieldselectedType{i} = 'numeric';
        end
    end
    
    
    base_selectedfieldtype = fieldselectedType{condition_number};
    %onerowcheck = md_GUI.filter.onerow(condition_number);
   
    switch char(base_selectedfieldtype)
        case 'char'
            %% Message to log_box
            GUI.log.add(['Fieldtype selected to edit: Character.'])
            new_ans = inputdlg(prompt,['Change: ', fieldselected], 1, {previous_ans});
            new_ans_char = char(new_ans);
            outputvalue = new_ans_char;
            treatable = 1;
        case 'numeric'
            %% Message to log_box
            GUI.log.add(['Fieldtype selected to edit: Numeric.'])
            new_ans = inputdlg(prompt,['Change: ', fieldselected], 1, {previous_ans});
            new_ans_char = char(new_ans);
            treatable = 1;
%             if onerowcheck == 1
%                 new_ans_numcell = strsplit(new_ans_char);
%                 outputvalue = str2double(new_ans_numcell);
%                 [rows, columns] = size(outputvalue);
%                 for colnom = 1:columns
%                     if isnan(outputvalue(colnom))
%                         msgbox({'error in numeric array:' 'NaN' 'Position:' num2str(colnom) 'Only use numbers with spacing between.'}, 'Error')
%                         treatable = 0;
%                     else
%                         treatable = 1;
%                     end
%                 end
%             elseif onerowcheck == 0
%                 new_ans_numcell = strsplit(new_ans_char);
%                 new_ans_numcelltranspose = new_ans_numcell.';
%                 outputvalue = str2double(new_ans_numcelltranspose);
%                 [rows, columns] = size(outputvalue);
%                 for rownom = 1:rows
%                     if isnan(outputvalue(rownom))
%                         msgbox({'error in numeric array:' 'NaN' 'Position:' num2str(rownom) 'Only use numbers with spacing between.'}, 'Error')
%                         treatable = 0;
%                     else
%                         treatable = 1;
%                     end
%                 end
%             end
  
    end
    if treatable == 1
        md_GUI.mdata_n.(exp_name) = general.struct.setsubfield(md_GUI.mdata_n.(exp_name), base_finalpath, str2num(outputvalue));
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
        md_GUI.calib.base_fieldvalue(condition_number) = base_fieldvalue(condition_number);
%         md_GUI.mdata_n.(exp_name).(base_finalpath)
        set(UICalib.(tabselected).Fieldvalue, 'String', cellstr(base_fieldvalue))
        %% Message to log_box
        GUI.log.add(['Previous value(s) for ', fieldselected, ': ', previous_val])
        %% Message to log_box
        GUI.log.add(['New value(s) for ', fieldselected, ': ', new_ans_char])
        %% Message to log_box
        GUI.log.add(['Saved.'])
        assignin('base', 'md_GUI', md_GUI)
    end
end