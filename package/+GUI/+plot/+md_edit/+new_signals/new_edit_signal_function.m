% Description: Creates a dialog to gather input needed for the new signal.
%   - inputs:
%           Screensize
%   - outputs:
%           Signal parameters   (values_out)
% Date of creation: 2017-08-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:
function [ values_out, yesorno ] = new_edit_signal_function(new_or_edit, edit_value) 
md_GUI = evalin('base', 'md_GUI');
yesorno = 0;
screensize = md_GUI.UI.screensize;
d = dialog('Position',[screensize(3)/4 screensize(4)/5 screensize(3)/3 screensize(4)/2],'Name',[new_or_edit, ' signal'], 'Resize', 'on');
txt_name = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.85 0.28 0.1],...
       'String','Name: ');
txt_range = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.75 0.28 0.1],...
       'String','Range: ');
txt_binsize = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.65 0.28 0.1],...
       'String','Binsize: ');
txt_data_pointer = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.55 0.28 0.1],...
       'String','Data pointer: ');
txt_axis_label = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.45 0.28 0.1],...
       'String','Axis label: ');
txt_data_pointer_selector = uicontrol('Parent',d,...
       'Style','text',...
       'units', 'normalized',...
       'fontsize', 12,...
       'HorizontalAlignment', 'right',...
       'Position',[0.02 0.35 0.28 0.1],...
       'String','Data pointer selector: ');
val_name = uicontrol('Parent',d,...
       'Style','edit',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.87 0.55 0.08],...
       'Callback',@name_callback);
val_range = uicontrol('Parent',d,...
       'Style','edit',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.77 0.55 0.08],...
       'Callback',@range_callback);
val_binsize = uicontrol('Parent',d,...
       'Style','edit',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.67 0.55 0.08],...
       'Callback',@binsize_callback);
val_data_pointer = uicontrol('Parent',d,...
       'Style','edit',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.57 0.55 0.08],...
       'Callback',@data_pointer_callback);
val_axis_label = uicontrol('Parent',d,...
       'Style','edit',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.35 0.47 0.55 0.08],...
       'Callback',@axis_label_callback);
setdatapointerbutton = uicontrol('Parent',d,...
       'Style','pushbutton',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.75 0.38 0.2 0.08],...
       'String','Set datapointer',...
       'Callback',@setdatapointerbutton_callback);
listbox1_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.04 0.05 0.23 0.32],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox1_datapointer_callback);
listbox2_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.27 0.05 0.23 0.32],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox2_datapointer_callback);
listbox3_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.5 0.05 0.23 0.32],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox3_datapointer_callback);
listbox4_datapointer = uicontrol('Parent',d,...
       'Style','listbox',...
       'Enable', 'off',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.73 0.05 0.23 0.32],...
       'String','Use',...
       'Value', 1,...
       'Callback',@listbox4_datapointer_callback);
OK_btn = uicontrol('Parent',d,...
       'Style','pushbutton',...
       'units', 'normalized',...
       'fontsize', 12,...
       'Position',[0.85 0.03 0.1 0.06],...
       'String','Ok',...
       'Callback',@ok_callback);
switch new_or_edit
    case 'new'
        OK_btn.Enable = 'off';
    case 'edit'
        val_name.String = edit_value.name;
        val_range.String = edit_value.range;
        val_binsize.String = edit_value.binsize;
        val_data_pointer.String = edit_value.data_pointer;
        val_axis_label.String = edit_value.axis_label;
        values_out = edit_value;
end

% edit_value: name, range, binsize, data_pointer, axis_label
function name_callback(val_name,event)
    values_out.name = val_name.String;
    OK_btn.Enable = 'off';
    if ~isempty(val_name.String)
        if ~isempty(val_range.String)
            if ~isempty(val_binsize.String)
                if ~isempty(val_data_pointer.String)
                    if ~isempty(val_axis_label.String)
                        OK_btn.Enable = 'on';
                    end
                end
            end
        end
    end
end
function range_callback(val_range,event)
    values_out.range = val_range.String;
    OK_btn.Enable = 'off';
    if ~isempty(val_name.String)
        if ~isempty(val_range.String)
            if ~isempty(val_binsize.String)
                if ~isempty(val_data_pointer.String)
                    if ~isempty(val_axis_label.String)
                        OK_btn.Enable = 'on';
                    end
                end
            end
        end
    end
end
function binsize_callback(val_binsize,event)
    values_out.binsize = val_binsize.String;
    OK_btn.Enable = 'off';
    if ~isempty(val_name.String)
        if ~isempty(val_range.String)
            if ~isempty(val_binsize.String)
                if ~isempty(val_data_pointer.String)
                    if ~isempty(val_axis_label.String)
                        OK_btn.Enable = 'on';
                    end
                end
            end
        end
    end
end
function data_pointer_callback(val_data_pointer,event)
    values_out.data_pointer = val_data_pointer.String;
    OK_btn.Enable = 'off';
    if ~isempty(val_name.String)
        if ~isempty(val_range.String)
            if ~isempty(val_binsize.String)
                if ~isempty(val_data_pointer.String)
                    if ~isempty(val_axis_label.String)
                        OK_btn.Enable = 'on';
                    end
                end
            end
        end
    end
end
function axis_label_callback(val_axis_label,event)
    values_out.axis_label = val_axis_label.String;
    OK_btn.Enable = 'off';
    if ~isempty(val_name.String)
        if ~isempty(val_range.String)
            if ~isempty(val_binsize.String)
                if ~isempty(val_data_pointer.String)
                    if ~isempty(val_axis_label.String)
                        OK_btn.Enable = 'on';
                    end
                end
            end
        end
    end
end
exp_name = char(['exp', num2str(md_GUI.UI.UIPlot.LoadedFilesPlotting.Value(1))]);
datapointers = md_GUI.data_n.(exp_name);
full_datapointer_string = '';
list1 = fieldnames(datapointers);
list2 = {'-'};
list3 = {'-'};
list4 = {'-'};
setdatapointerbutton.Enable = 'Off';
listbox1_datapointer.Enable = 'On';
listbox2_datapointer.Enable = 'Off';
listbox3_datapointer.Enable = 'Off';
listbox4_datapointer.Enable = 'Off';
listbox1_datapointer.String = list1;
listbox2_datapointer.String = list2;
listbox3_datapointer.String = list3;
listbox4_datapointer.String = list4;
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
    val_data_pointer.String = full_datapointer_string;
    values_out.data_pointer = val_data_pointer.String;
    OK_btn.Enable = 'off';
    if ~isempty(val_name.String)
        if ~isempty(val_range.String)
            if ~isempty(val_binsize.String)
                if ~isempty(val_data_pointer.String)
                    if ~isempty(val_axis_label.String)
                        OK_btn.Enable = 'on';
                    end
                end
            end
        end
    end
end
% Wait for d to close before running to completion
uiwait(d);
    function ok_callback(setdatapointerbutton, event)
		% Pressing this button tells us that the user thinks the signal is
		% ready to be used. Then delete the window.
        yesorno = 1;
        delete(gcf)
    end
end