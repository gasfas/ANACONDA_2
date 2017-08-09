% Description: Adds a new filter to the selected filter path.
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
function [ ] = Add_Filter(UIFilter)
%Load md_GUI from 'base' workpace:
%   - must always be put into workspace in terms of paths.
md_GUI = evalin('base', 'md_GUI');
% The name of the new filter
NewName = inputdlg('Type the new filter name.', 'New Filter');
NewName = char(NewName);
if isempty(NewName)
    errornum = 1;
    msgbox('Not a valid name.', 'Error')
else
    errornum = 0;
end
% If more than 1 experiment - ask user which experiment to insert the filter into.
if errornum == 0
    if md_GUI.load.NumberOfLoadedFiles == 1
        if ischar(md_GUI.load.exp_names)
            exp_name = md_GUI.load.exp_names;
        else
            exp_name = char(md_GUI.load.exp_names);
        end
    else
        exp_nom = inputdlg('Select experiment number to insert the new filter into.', 'Select experiment');
        exp_nom = str2num(char(exp_nom));
        % check if it was just a number or something else.
        if isempty(exp_nom)
            % NaN. Error. 
            errornum = 1;
            msgbox('Not a number.', 'Error')
        else    % check if number is not too large.
            if exp_nom > md_GUI.load.NumberOfLoadedFiles
                % Too large number inserted. Error.
                msgbox('Number too large.', 'Error')
                errornum = 1;
            else
                exp_name = char(md_GUI.load.exp_names(exp_nom));
                errornum = 0;
            end
        end
    end
end
% Ask the user if it is a hits or events condition.
if errornum == 0
    filter_type = questdlg('Hit or event filter?', 'New filter type', 'Hit', 'Event', 'Event');
    % Ask the user for the number of fields - give a checkbox list in a window. Some are mandatory for all: Data pointer, value, type.
    % For events: Checkbox for translate_condition, invert_filter.
    % For hits: translate_conditions is also mandatory. Checkbox for invert_filter.
    switch filter_type
        case 'Event'
            mand_string = {'data_pointer', 'type', 'value'};
            checkboxstring = {'invert_filter', 'translate_condition'};
            fieldvals = 3;
        case 'Hit'
            mand_string = {'data_pointer', 'type', 'value', 'translate_condition'};
            checkboxstring = {'invert_filter'};
            fieldvals = 4;
        otherwise %means user cancelled process.
        errornum = 1;
    end
end
if errornum == 0
    checkbox.figure = figure('Name','FilterFields','units','normalized',...
        'position',[0.1, 0.2, 0.2, 0.4], 'toolbar','none','menu','none');
    for chch = 1:length(checkboxstring)
        ypos = 0.88 - (chch-1) * 0.08;
        checkbox.box(chch) = uicontrol('parent', checkbox.figure,...
            'style','checkbox','units','normalized',...
            'HorizontalAlignment', 'left', 'position',[0.05 ypos 0.9 0.1],...
            'string',char(checkboxstring(chch)), 'FontUnits', 'normalized', 'FontSize', 0.4);
    end
    ypos = ypos - 0.16;
    checkbox.button = uicontrol('parent', checkbox.figure,...
        'style','pushbutton','units','normalized',...
        'position',[0.2 ypos 0.6 0.1],'string','Ok', 'FontUnits',...
        'normalized', 'FontSize', 0.4,'callback',@checkboxbutton);
waitfor(checkbox.figure)
end
function extrafields = checkboxbutton(varargin)
    vals = get(checkbox.box, 'Value');
    for valulists = 1:length(vals)
        if iscell(vals)
            extrafields(valulists) = vals{valulists};
        else
            extrafields =  vals;
        end
    end
    assignin('base', 'extrafields', extrafields)
    close FilterFields
end
if errornum == 0
extrafields = evalin('base', 'extrafields');
chcb = length(checkboxstring);
chcc = 0;
extrafieldname = { };
for chca = 1:chcb
    if extrafields(chca) == 1
        chcc = chcc+1;
        extrafieldname(chcc) = checkboxstring(chca);
    end
end
for fieldvalues1 = 1:length(mand_string)
    all_strings{fieldvalues1} = mand_string{fieldvalues1};
end
if isempty(extrafieldname)
    % Nothing to do, mandatory fields are the only fields.
else
    for fieldvalues2 = 1:length(extrafieldname)
        all_strings{fieldvalues2 + length(mand_string)} = extrafieldname{fieldvalues2};
    end
end
newcondvals = inputdlg(all_strings, 'New condition values');
for chca = 1:length(all_strings)
    addfilterstruct.(char(all_strings{chca})) = newcondvals(chca);
end
end
% Check if value and (if exists) invert_filter are numerical. If not,
% errornum = 1.

if errornum == 0
md_GUI.mdata_n.(exp_name).cond.(NewName) = addfilterstruct;
assignin('base', 'md_GUI', md_GUI)
% Reconstruct the tree:

end
end