% Description: Constructs the dialog with all editable conditions and
% previously defined conditions pre-set as the values.
%   - inputs:
%           fields to edit (now checks if translate conditions or invert filter are turned on or off)
%           base_value (previously defined values of selected filter)
%           Loaded file metadata.
%   - outputs:
%           Modified loaded file metadata.
% Date of creation: 2017-08-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:
function [ base_value ] = Edit_Filter_Choice(fieldstoedit, base_value, datapointers)
md_GUI = evalin('base', 'md_GUI');
%function choice = choosedialog
screensize = md_GUI.UI.screensize;
d = dialog('Position',[screensize(3)/4 screensize(4)/5 screensize(3)/3 screensize(4)/2],'Name','Edit filter');
txt_type = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.85 0.28 0.1],...
       'String','Filter values type: ');
txt_value = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.75 0.28 0.1],...
       'String','Value: ');
txt_translate = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.65 0.28 0.1],...
       'String','Translate condition: ');
txt_invert = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.55 0.28 0.1],...
       'String','Invert filter: ');
previous_data_pointer = base_value.data_pointer;
datapointer_str = ['Current data pointer:   ', char(previous_data_pointer)];
txt_datapointer = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'left',...
       'Position',[0.35 0.47 0.6 0.1],...
       'String',datapointer_str);
type_options = {'continuous'; 'discrete'};
for lk = 1:length(type_options)
    if strcmp(type_options(lk), base_value.type)
        type_value = lk;
    end
end
popup_type = uicontrol('Parent',d,...
       'Style','popup',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.85 0.55 0.1],...
       'String',type_options,...
       'Value', type_value,...
       'Callback',@type_callback);
value_onerowcheck = size(base_value.value);
if value_onerowcheck(1) == 1 %horizontal
elseif value_onerowcheck(2) == 1 %vertical
    base_value.value = base_value.value';
else %neither -> problem
    disp('error with value; it is a (n>1) x (m>1) matrix.')
end
edit_value = uicontrol('Parent',d,...
       'Style','edit',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.81 0.55 0.06],...
       'String',{num2str(base_value.value)},...
       'Callback',@value_callback);
translate_options = {'AND';'OR';'XOR';'HIT1';'HIT2'};
translave_value = 1;
if fieldstoedit(4) == 1 % translate
    for ll = 1:length(translate_options)
        if ~isfield(base_value, 'translate_condition')
            translave_value = 1;
        else
            if strcmp(translate_options(ll), base_value.translate_condition)
                translave_value = ll;
            end
        end
    end
    translate_enable = 'on';
else
    translate_enable = 'off';
end
popup_translate = uicontrol('Parent',d,...
       'Style','popup',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.65 0.55 0.1],...
       'String',translate_options,...
       'Value',translave_value,...
       'Enable', translate_enable,...
       'Callback',@translate_callback);
checkbox_translate = uicontrol('Parent',d,...
       'Style','checkbox',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.9 0.68 0.2 0.1],...
       'String','Use',...
       'Value', fieldstoedit(4),...
       'Callback',@checkbox_translate_callback);

invert_options = [0, 1];
invert_value = 1;
if fieldstoedit(5) == 1 % inverse
    for lm = 1:length(invert_options)
        if ~isfield(base_value, 'invert_filter')
            base_value.invert_filter = logical(0);
            fieldstoedit(5) = 0;
        end
        if invert_options(lm) == base_value.invert_filter
            invert_value = lm;
        end
    end
    invert_enable = 'on';
else
    invert_enable = 'off';
end
popup_invert = uicontrol('Parent',d,...
       'Style','popup',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.55 0.55 0.1],...
       'String',{'Off', 'On'},...
       'Value',invert_value,...
       'Enable', invert_enable,...
       'Callback',@invert_callback);
checkbox_invert = uicontrol('Parent',d,...
       'Style','checkbox',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.9 0.58 0.2 0.1],...
       'String','Use',...
       'Value', fieldstoedit(5),...
       'Callback',@checkbox_invert_callback);
checkbox_datapointer = uicontrol('Parent',d,...
       'Style','checkbox',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.05 0.51 0.28 0.1],...
       'String','Edit datapointer?',...
       'Value', 0,...
       'Callback',@checkbox_datapointer_callback);
listbox1_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.04 0.15 0.23 0.38],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox1_datapointer_callback);
listbox2_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.27 0.15 0.23 0.38],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox2_datapointer_callback);
listbox3_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.5 0.15 0.23 0.38],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox3_datapointer_callback);
listbox4_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.73 0.15 0.23 0.38],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox4_datapointer_callback);
setdatapointerbutton = uicontrol('Parent',d,...
       'Style','pushbutton',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.75 0.09 0.2 0.06],...
       'String','Set datapointer',...
       'Callback',@setdatapointerbutton_callback);
OK_btn = uicontrol('Parent',d,...
       'Style','pushbutton',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.85 0.03 0.1 0.06],...
       'String','Ok',...
       'Callback',@ok_callback);
    function type_callback(popup_type,event)
        idx = popup_type.Value;
        popup_items = popup_type.String;
        base_value.type = char(popup_items(idx,:));
    end
    function value_callback(edit_value,event)
        base_value.value = edit_value.String;
        base_value.value = str2double(strsplit(char(base_value.value)));
        if value_onerowcheck(2) == 1 %vertical before, so make it vertical again.
           base_value.value = base_value.value';
        end
    end
    function translate_callback(popup_translate,event)
        idx = popup_translate.Value;
        popup_items = popup_translate.String;
        base_value.translate_condition = char(popup_items(idx,:));
    end
    function invert_callback(popup_invert,event)
        idx = popup_invert.Value;
        popup_items = popup_invert.String;
        inv_filt = char(popup_items(idx,:));
        switch inv_filt
            case 'On'
                base_value.invert_filter = 1;
            case 'Off'
                base_value.invert_filter = 0;
        end
    end
    function checkbox_translate_callback(popup_checkbox_translate,event)
        if popup_checkbox_translate.Value == 0 % off - remove field.
            popup_translate.Value = 1;
            popup_translate.Enable = 'off';
            fieldstoedit(4) = 0;
            if isfield(base_value, 'translate_condition') % remove field
                base_value = rmfield(base_value, 'translate_condition');
            end
        elseif popup_checkbox_translate.Value == 1 % on - add field.
            popup_translate.Enable = 'on';
            fieldstoedit(4) = 1;
            base_value.translate_condition = char(popup_translate.String(popup_translate.Value));
        end
    end
    function checkbox_invert_callback(popup_checkbox_invert,event)
        if popup_checkbox_invert.Value == 0 % off - remove field.
            popup_invert.Value = 1;
            popup_invert.Enable = 'off';
            fieldstoedit(5) = 0;
            if isfield(base_value, 'invert_filter') % remove field
                base_value = rmfield(base_value, 'invert_filter');
            end
        elseif popup_checkbox_invert.Value == 1 % on - add field.
            popup_invert.Enable = 'on';
            fieldstoedit(5) = 1;
            invertfilterval = char(popup_invert.String(popup_invert.Value));
            switch invertfilterval
                case 'Off'
                    base_value.invert_filter = 0;
                case 'On'
                    base_value.invert_filter = 1;
            end
        end
    end
    list1 = fieldnames(datapointers);
    list2 = {'-'};
    list3 = {'-'};
    list4 = {'-'};
    full_datapointer_string = '';
    function checkbox_datapointer_callback(checkbox_datapointer, event)
        list1 = fieldnames(datapointers);
        list2 = {'-'};
        list3 = {'-'};
        list4 = {'-'};
        setdatapointerbutton.Enable = 'Off';
        if checkbox_datapointer.Value == 1
            listbox1_datapointer.Enable = 'On';
            listbox2_datapointer.Enable = 'Off';
            listbox3_datapointer.Enable = 'Off';
            listbox4_datapointer.Enable = 'Off';
            listbox1_datapointer.String = list1;
            listbox2_datapointer.String = list2;
            listbox3_datapointer.String = list3;
            listbox4_datapointer.String = list4;
        elseif checkbox_datapointer.Value == 0
            listbox1_datapointer.Enable = 'Off';
            listbox2_datapointer.Enable = 'Off';
            listbox3_datapointer.Enable = 'Off';
            listbox4_datapointer.Enable = 'Off';
            listbox1_datapointer.String = list1;
            listbox2_datapointer.String = list2;
            listbox3_datapointer.String = list3;
            listbox4_datapointer.String = list4;
        end
    end
    prevlistdatapointer = 'null';
    function listbox1_datapointer_callback(listbox1_datapointer, event)
        if ~strcmp(prevlistdatapointer, 'null'); % Means list is not at zero-level - make it zero-level.
            setdatapointerbutton.Enable = 'Off';
            list1 = fieldnames(datapointers);
            prevlistdatapointer = 'null';
            listbox2_datapointer.String = {'-'};
            listbox2_datapointer.Enable = 'Off';
            listbox1_datapointer.Value = 1;
            listbox1_datapointer.String = list1;
        else % Means list is at zero-level
            list1sel = listbox1_datapointer.String(listbox1_datapointer.Value);
            full_datapointer_string = [char(list1sel)];
            checkchildren = isstruct(datapointers.(char(list1sel)));
            if checkchildren == 1
                list2 = general.struct.getsubfield(datapointers, full_datapointer_string);
                listbox2_datapointer.String = fieldnames(list2);
                listbox2_datapointer.Enable = 'On';
                setdatapointerbutton.Enable = 'Off';
            else
                listbox2_datapointer.String = {'-'};
                listbox2_datapointer.Enable = 'Off';
                setdatapointerbutton.Enable = 'On';
            end
        end
        listbox2_datapointer.Value = 1;
        listbox3_datapointer.String = {'-'};
        listbox4_datapointer.String = {'-'};
        listbox3_datapointer.Value = 1;
        listbox4_datapointer.Value = 1;
        listbox3_datapointer.Enable = 'Off';
        listbox4_datapointer.Enable = 'Off';
        listbox3_datapointer.String = {'-'};
        listbox4_datapointer.String = {'-'};
        listbox3_datapointer.Value = 1;
        listbox4_datapointer.Value = 1;
        listbox3_datapointer.Enable = 'Off';
        listbox4_datapointer.Enable = 'Off';
    end
    function listbox2_datapointer_callback(listbox2_datapointer, event)
        list2sel = listbox2_datapointer.String(listbox2_datapointer.Value);
        list1sel = listbox1_datapointer.String(listbox1_datapointer.Value);
        if strcmp(prevlistdatapointer, 'null');
            full_datapointer_string = [char(list1sel), '.', char(list2sel)];
            checkchildren = isstruct(datapointers.(char(list1sel)).(char(list2sel)));
        else
            full_datapointer_string = [prevlistdatapointer, char(list1sel), '.', char(list2sel)];
            prevlistdatapointers = strsplit(prevlistdatapointer, '.');
            for lz = 1:length(prevlistdatapointers)-1
                prevlistdatapoint(lz) = prevlistdatapointers(lz);
            end
            prevlistdatapointers = strjoin(prevlistdatapoint, '.');
            preldatapointer = general.struct.getsubfield(datapointers, prevlistdatapointers);
            checkchildren = isstruct(preldatapointer.(char(list1sel)).(char(list2sel)));
        end
        if checkchildren == 1
            list3 = general.struct.getsubfield(datapointers, full_datapointer_string);
            setdatapointerbutton.Enable = 'Off';
            listbox3_datapointer.String = fieldnames(list3);
            listbox4_datapointer.String = {'-'};
            listbox3_datapointer.Value = 1;
            listbox4_datapointer.Value = 1;
            listbox3_datapointer.Enable = 'On';
            listbox4_datapointer.Enable = 'Off';
        else
            setdatapointerbutton.Enable = 'On';
            listbox3_datapointer.String = {'-'};
            listbox4_datapointer.String = {'-'};
            listbox3_datapointer.Value = 1;
            listbox4_datapointer.Value = 1;
            listbox3_datapointer.Enable = 'Off';
            listbox4_datapointer.Enable = 'Off';
        end
    end
    function listbox3_datapointer_callback(listbox3_datapointer, event)
        list3sel = listbox3_datapointer.String(listbox3_datapointer.Value);
        list2sel = listbox2_datapointer.String(listbox2_datapointer.Value);
        list1sel = listbox1_datapointer.String(listbox1_datapointer.Value);
        if strcmp(prevlistdatapointer, 'null');
            full_datapointer_string = [char(list1sel), '.', char(list2sel), '.', char(list3sel)];
            checkchildren = isstruct(datapointers.(char(list1sel)).(char(list2sel)).(char(list3sel)));
        else
            full_datapointer_string = [prevlistdatapointer, char(list1sel), '.', char(list2sel), '.', char(list3sel)];
            prevlistdatapointers = strsplit(prevlistdatapointer, '.');
            for lz = 1:length(prevlistdatapointers)-1
                prevlistdatapoint(lz) = prevlistdatapointers(lz);
            end
            prevlistdatapointers = strjoin(prevlistdatapoint, '.');
            preldatapointer = general.struct.getsubfield(datapointers, prevlistdatapointers);
            checkchildren = isstruct(preldatapointer.(char(list1sel)).(char(list2sel)).(char(list3sel)));
        end
        if checkchildren == 1
            list4 = general.struct.getsubfield(datapointers, full_datapointer_string);
            setdatapointerbutton.Enable = 'Off';
            listbox4_datapointer.String = fieldnames(list4);
            listbox4_datapointer.Value = 1;
            listbox4_datapointer.Enable = 'On';
        else
            setdatapointerbutton.Enable = 'On';
            listbox4_datapointer.String = {'-'};
            listbox4_datapointer.Value = 1;
            listbox4_datapointer.Enable = 'Off';
        end
    end
    function listbox4_datapointer_callback(listbox4_datapointer, event)
        list4sel = listbox4_datapointer.String(listbox4_datapointer.Value);
        list3sel = listbox3_datapointer.String(listbox3_datapointer.Value);
        list2sel = listbox2_datapointer.String(listbox2_datapointer.Value);
        list1sel = listbox1_datapointer.String(listbox1_datapointer.Value);
        full_datapointer_string = [char(list1sel), '.', char(list2sel), '.', (char(list3sel)), '.', (char(list4sel))];
        
        
        if strcmp(prevlistdatapointer, 'null');
            full_datapointer_string = [char(list1sel), '.', char(list2sel), '.', char(list3sel), '.', char(list4sel)];
            checkchildren = isstruct(datapointers.(char(list1sel)).(char(list2sel)).(char(list3sel)).(char(list4sel)));
        else
            full_datapointer_string = [prevlistdatapointer, char(list1sel), '.', char(list2sel), '.', char(list3sel), '.', char(list4sel)];
            prevlistdatapointers = strsplit(prevlistdatapointer, '.');
            for lz = 1:length(prevlistdatapointers)-1
                prevlistdatapoint(lz) = prevlistdatapointers(lz);
            end
            prevlistdatapointers = strjoin(prevlistdatapoint, '.');
            preldatapointer = general.struct.getsubfield(datapointers, prevlistdatapointers);
            checkchildren = isstruct(preldatapointer.(char(list1sel)).(char(list2sel)).(char(list3sel)).(char(list4sel)));
        end
        if checkchildren == 1
            if strcmp(prevlistdatapointer, 'null'); % Means list is at zero-level
                prevlistdatapointer = [char(list1sel), '.'];
            else % Means list is already at a non-zero level
                prevlistdatapointer = [prevlistdatapointer, char(list1sel), '.'];
            end
            setdatapointerbutton.Enable = 'Off';
            listbox1_datapointer.Value = listbox2_datapointer.Value;
            listbox2_datapointer.Value = listbox3_datapointer.Value;
            listbox3_datapointer.Value = listbox4_datapointer.Value;
            listbox1_datapointer.String = listbox2_datapointer.String;
            listbox2_datapointer.String = listbox3_datapointer.String;
            listbox3_datapointer.String = listbox4_datapointer.String;
            list4 = general.struct.getsubfield(datapointers, full_datapointer_string);
            listbox4_datapointer.String = fieldnames(list4);
            listbox4_datapointer.Value = 1;
        else
            setdatapointerbutton.Enable = 'On';
        end
    end
    function setdatapointerbutton_callback(setdatapointerbutton, event)
        %% Message to log_box:
        GUI.log.add(['New data pointer set to: ', full_datapointer_string])
        base_value.data_pointer = full_datapointer_string;
	end
% Wait for d to close before running to completion
uiwait(d);

    function ok_callback(setdatapointerbutton, event)
		% Pressing this button tells us that the user thinks the condition
		% is ready for use. We check the parameters to be sure:
		if ~IO.data_pointer.is_event_signal(base_value.data_pointer) & ~isfield(base_value, 'translate_condition')
			% This means it is a hit condition, without translate
			% condition. This will cause an error, and we add a default AND
			% as a translate condition:
			base_value.translate_condition = 'AND';
			% Message to log_box:
			GUI.log.add('Translate condition missing, set to default AND');
		end
        delete(gcf)
	end

end