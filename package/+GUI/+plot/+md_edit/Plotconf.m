% Description: Set up parameters used for the plotting.
%   - inputs:
%           Selected exp. number                (experiment_selected_number)
%           Selected experiment(s) metadata     (mdata_n)
%           Experiment settings                 (expsettings)
%           Plot settings                       (plotsettings)

%           Old field values in struct <-- Fix it.

%   - outputs: (into PlotConfSetButton)
%           Field selected              (fieldselected)
%           Field selected value      	(fieldselectedvalue)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [  ] = Plotconf()
md_GUI = evalin('base', 'md_GUI');
selected_exp_names = md_GUI.plot.selected_exp_names;
if ischar(selected_exp_names)
    exp_name = selected_exp_names;
else
    exp_name = char(selected_exp_names(1)); % since the first selected exp file will be visible in the popup window.
end

detectornum = md_GUI.plot.expsettings.All(2);
detectorname = fieldnames(md_GUI.mdata_n.([exp_name]).plot);
detectorname = char(detectorname(detectornum));
if strcmp(detectorname, 'signal')
    detectorname = fieldnames(md_GUI.mdata_n.([exp_name]).plot);
    detectorname = char(detectorname(detectornum+1));
end
graphnum_X = md_GUI.plot.plotsettings(2);
graphtypes = fieldnames(md_GUI.mdata_n.([exp_name]).plot.([detectorname]));
graphtype_X = char(graphtypes(graphnum_X));
%graphtype_Y = graphtype_X; % % % % Add when 2D plotting is available.


plotconf_fieldnames = md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]);
% Exclude the 'signal' subfield:

% Get name of all properties of the selected plottype. In the future: Also have plot configurations for graphtype_Y.
nameof_x_fields = fieldnames(plotconf_fieldnames);
fieldselected = nameof_x_fields(1); % 1 since the first field will be displayed in the popup window.
md_GUI.plot.plotconf.fieldselected = fieldselected;
fieldselectedvalue = plotconf_fieldnames.([char(fieldselected)]);
if ischar(selected_exp_names)
    if isfield(md_GUI.plot.plotconf, selected_exp_names)
        if isfield(md_GUI.plot.plotconf.(selected_exp_names), 'OrdValue')
            %do nothing.
        else %this has not yet been defined for this experiment.
            md_GUI.plot.plotconf.(selected_exp_names).OrdValue = plotconf_fieldnames;
        end
    else %this has not yet been defined..
        md_GUI.plot.plotconf.(selected_exp_names).OrdValue = plotconf_fieldnames;
    end
else
    for llxl = 1:length(selected_exp_names)
        if isfield(md_GUI.plot.plotconf, char(selected_exp_names(llxl)))
            if isfield(md_GUI.plot.plotconf.([char(selected_exp_names(llxl))]), 'OrdValue')
                %do nothing.
            else %this has not yet been defined for this experiment.
                md_GUI.plot.plotconf.([char(selected_exp_names(llxl))]).OrdValue = plotconf_fieldnames;
            end
        else %this has not yet been defined.
            md_GUI.plot.plotconf.([char(selected_exp_names(llxl))]).OrdValue = plotconf_fieldnames;
        end
    end
end
assignin('base', 'md_GUI', md_GUI)
%Window size and positions:
screensize = md_GUI.UI.screensize;
screen = [400 (screensize(4) / 2) 200 200];
pos = struct('xpos', screen(1), 'ypos', screen(2), 'width', screen(3), 'height', screen(4));
% Construction of figure......................
PlotConfFig = figure('Name', 'PlotConfFig', 'NumberTitle','off', 'MenuBar', 'none', 'Position', [ pos.xpos pos.ypos pos.width pos.height ]);
%% 
% Above was only starting conditions for figure. Below are the dynamical functions and the creation of the uicontrols of the plotconf figure.
%%
% Field selection:
PlotConfFigPopup = uicontrol('Parent', PlotConfFig, ...
'Style','popupmenu', ...
'Enable', 'on', ...
'String', nameof_x_fields, ...
'Units', 'pixels', ...
'Position',[20 160 160 20], ...
'Callback', @PlotConfSel);
function PlotConfSel(hObject, eventdata)
    GUI.plot.md_edit.PlotConfFigPopup(hObject, eventdata);
    md_GUI = evalin('base', 'md_GUI');
    fieldselected = md_GUI.plot.plotconf.fieldselected;
    fieldselectedvalue = md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]).([char(fieldselected)]);
    fieldselectedvalue = plotconf_fieldnames.([char(fieldselected)]);
	if ischar(fieldselectedvalue)
        fieldselectedvalue_str = fieldselectedvalue;
        structure_true = 0;
        set(PlotConfFigSetButton, 'Enable', 'on')
    elseif isnumeric(fieldselectedvalue)
        fieldselectedvalue_str = cell(length(fieldselectedvalue), 1);
        for llx = 1:length(fieldselectedvalue)
            fieldselectedvalue_str(llx, 1) = cellstr(num2str(fieldselectedvalue(llx)));
        end
        fieldselectedvalue_str = strjoin(fieldselectedvalue_str);
        structure_true = 0;
        set(PlotConfFigSetButton, 'Enable', 'on')
    elseif isstruct(fieldselectedvalue)
        %Create recursive function? Probably not needed but might be good to have.
        disp('It is a structure. Not yet possible to edit.')
%         structend = fieldnames(plotconf_fieldnames.([char(fieldselected)]))
%         fieldselectedvalue_2 = plotconf_fieldnames.([char(fieldselected)]).([char(structend)]);
         structure_true = 1;
         set(PlotConfFigSetButton, 'Enable', 'off')
    end
    if structure_true == 0
        set(PlotConfFigPopupEditBox, 'String', fieldselectedvalue_str)
        assignin('base', 'md_GUI', md_GUI);
        assignin('base', 'oldfieldselectedvalue', fieldselectedvalue);
        assignin('base', 'fieldselectedvalue', fieldselectedvalue); 
    end
end
%%
% Field edit:
if ischar(fieldselectedvalue)
    fieldselectedvalue_str = fieldselectedvalue;
elseif isnumeric(fieldselectedvalue)
    fieldselectedvalue_str = num2str(fieldselectedvalue);
elseif isstruct(fieldselectedvalue)
    % Need a new popup box.
    
end
% Edit box construction:
PlotConfFigPopupEditBox = uicontrol('Parent', PlotConfFig, ...
'style','edit',...
'units','pix',...
'position',[20 80 160 40],...
'string', fieldselectedvalue_str,...                 
'fontweight','bold',...
'horizontalalign','center',...
'fontsize',11,...
'Callback', @PlotConfEdit);
% Set values button construction:
PlotConfFigSetButton = uicontrol('Parent', PlotConfFig, ...
'Style', 'pushbutton', ...
'Units', 'pix', ...
'Position', [100 40 80 20], ...
'Enable', 'on', ...
'String', 'Set', ...
'TooltipString', 'Press to set values', ...
'Callback', @PlotConfSet);
% Reset plot values button construction:
PlotConfFigResetButton = uicontrol('Parent', PlotConfFig, ...
'Style', 'pushbutton', ...
'Units', 'pix', ...
'Position', [20 10 80 20], ...
'Enable', 'on', ...
'String', 'Reset all', ...
'TooltipString', 'Press to reset all values', ...
'Callback', @PlotConfReset);
PlotConfFigResetSingleButton = uicontrol('Parent', PlotConfFig, ...
'Style', 'pushbutton', ...
'Units', 'pix', ...
'Position', [100 10 80 20], ...
'Enable', 'on', ...
'String', 'Reset', ...
'TooltipString', 'Press to reset only the selected field', ...
'Callback', @PlotConfResetSingle);
% Close 'PlotConf-window' button construction:
PlotConfFigExitButton = uicontrol('Parent', PlotConfFig, ...
'Style', 'pushbutton', ...
'Units', 'pix', ...
'Position', [20 40 80 20], ...
'Enable', 'on', ...
'String', 'Close', ...
'TooltipString', 'Press to close this window', ...
'Callback', @PlotConfExit);
% Kick the new values out so the set button can grab and set these values.
function PlotConfEdit(hObject, eventdata)
    [newfieldcell] = GUI.plot.md_edit.PlotConfFieldEdit(hObject);
    if isnumeric(fieldselectedvalue)
        newfieldcell = strsplit(newfieldcell);
        newfieldcell = str2double(newfieldcell);
    elseif ischar(fieldselectedvalue)
        newfieldcell = char(newfieldcell);
    end
    oldfieldselectedvalue.([graphtype_X]) = fieldselectedvalue.([graphtype_X]);
    fieldselectedvalue.([graphtype_X]) = newfieldcell;
    assignin('base', 'oldfieldselectedvalue', oldfieldselectedvalue)
    assignin('base', 'fieldselectedvalue', fieldselectedvalue)
end
function PlotConfSet(hObject, eventdata)
    oldfieldselectedvalue = evalin('base', 'exist(''oldfieldselectedvalue'')');
    fieldselectedvalue = evalin('base', 'fieldselectedvalue');
    if isnumeric(oldfieldselectedvalue)
        if isnumeric(fieldselectedvalue)
            GUI.plot.md_edit.PlotConfSetButton(fieldselected, fieldselectedvalue);
        else
            msgbox('Not same type of array as previously - previously was numeric.')
        end
    else
        GUI.plot.md_edit.PlotConfSetButton(fieldselected, fieldselectedvalue);
    end
end
function PlotConfReset(hObject, eventdata)
% if ischar(selected_exp_names)
%     if isfield(md_GUI, selected_exp_names)
%         if isfield(md_GUI.(selected_exp_names), 'OrdValue')
%             plotconf_fieldnames = md_GUI.(selected_exp_names).OrdValue;
%         else %this has not yet been defined for this experiment, i.e. values have not been changed.
%             disp('These are the ordinary values.')
%         end
%     else %this has not yet been defined..
%         disp('These are the ordinary values.')
%     end
% else
%     for llxl = 1:length(selected_exp_names)
%         if isfield(md_GUI, char(selected_exp_names(llxl)))
%             if isfield(md_GUI.([char(selected_exp_names(llxl))]), 'OrdValue')
%                 plotconf_fieldnames.([char(selected_exp_names(llxl))]) = md_GUI.([char(selected_exp_names(llxl))]).OrdValue;
%             else %this has not yet been defined for this experiment.
%                 disp('These are the ordinary values.')
%             end
%         else %this has not yet been defined.
%             disp('These are the ordinary values.')
%         end
%     end
% end
% if ischar(selected_exp_names)
%     exp_name = selected_exp_names;
%     md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]) = plotconf_fieldnames;
%     close PlotConfFig
% else
%     for lxls = 1:length(selected_exp_names)
%         exp_name = char(selected_exp_names(lxls)); % since the first selected exp file will be visible in the popup window.
%         md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]) = plotconf_fieldnames.([char(selected_exp_names(llxl))]);
%     end
%     close PlotConfFig
% end
% assignin('base', 'md_GUI', md_GUI) 
end

function PlotConfResetSingle(hObject, eventdata)
% if ischar(selected_exp_names)
%     if isfield(md_GUI, selected_exp_names)
%         if isfield(md_GUI.(selected_exp_names), 'OrdValue')
%             plotconf_fieldnames = md_GUI.(selected_exp_names).OrdValue;
%         else %this has not yet been defined for this experiment, i.e. values have not been changed.
%             disp('These are the ordinary values.')
%         end
%     else %this has not yet been defined..
%         disp('These are the ordinary values.')
%     end
% else
%     for llxl = 1:length(selected_exp_names)
%         if isfield(md_GUI, char(selected_exp_names(llxl)))
%             if isfield(md_GUI.([char(selected_exp_names(llxl))]), 'OrdValue')
%                 plotconf_fieldnames.([char(selected_exp_names(llxl))]) = md_GUI.([char(selected_exp_names(llxl))]).OrdValue;
%             else %this has not yet been defined for this experiment.
%                 disp('These are the ordinary values.')
%             end
%         else %this has not yet been defined.
%             disp('These are the ordinary values.')
%         end
%     end
% end
% if ischar(selected_exp_names)
%     exp_name = selected_exp_names;
%     md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]) = plotconf_fieldnames;
%     close PlotConfFig
% else
%     for lxls = 1:length(selected_exp_names)
%         exp_name = char(selected_exp_names(lxls)); % since the first selected exp file will be visible in the popup window.
%         md_GUI.mdata_n.([exp_name]).plot.([detectorname]).([char(graphtype_X)]) = plotconf_fieldnames.([char(selected_exp_names(llxl))]);
%     end
% 	close PlotConfFig
% end
% assignin('base', 'md_GUI', md_GUI) 
end
function PlotConfExit(hObject, eventdata)
    close PlotConfFig
end
end