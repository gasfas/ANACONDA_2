% Description: Constructs the GUI tabs and creates the GUI layout with all
% the user interface (UI) controls.
%   - inputs: none.
%   - outputs:
%           Load tab                                (UILoad)
%           Filter tab                              (UIFilter)
%           Plot tab                                (UIPlot)
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ h_figure, UIctrl_load, UIctrl_plot, UIctrl_filter, UIctrl_multitab ] = create_layout(screensize)
set(0, 'Units', 'characters');
if screensize(4) < 500
    screensize(4) = 500;
elseif screensize(4) > 900
    screensize(4) = 900;
end
% % % Delete this when GUI layout is window size dependent!!!
screensize(4) = 900;    % % % % % % % % % % % % % % % % % !!!
% % % Delete this when GUI layout is window size dependent!!!
screen = [0 0 400 screensize(4)];

%% Create the start-up metadata structure

% Build the figure
pos = struct('xpos', screen(1), 'ypos', screen(2), 'width', screen(3), 'height', screen(4));
UI.h_figure = figure('Units', 'pixels', ...
'Position', [pos.xpos pos.ypos pos.width pos.height], ...
'Resize', 'on', ...
'MenuBar', 'none', ...
'NumberTitle', 'off', ...
'Name', 'Graphical User Interface', ...
'HandleVisibility', 'callback');

%% Build the tabs
% Tab group:
UI.h_tabs = uitabgroup(UI.h_figure,'Position',[.01 .17 0.98 0.82]);
% Load tab:
tab_load = uitab(UI.h_tabs,'Title','Load');
% Calibration tab:
tab_calib = uitab(UI.h_tabs,'Title','Calib');
% Filter tab:
tab_filter = uitab(UI.h_tabs,'Title','Filter');
% Plot tab:
tab_plot = uitab(UI.h_tabs,'Title','Plot');

%% Build the multitab functions

% Notifier boxes:
md_GUI = evalin('base', 'md_GUI');
UIctrl_multitab.log_box = uicontrol('Parent', UI.h_figure, ...
'Style','listbox',...
'Units', 'normalized',...
'Position',[0.02 0.07 0.96 0.10],...
'fontsize', 12,...
'String', [md_GUI.UI.log_box_string]);

% Reset all data button
UIctrl_multitab.ResetButton = uicontrol('Parent', UI.h_figure, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.51 0.02 0.47 0.05], ...
'Enable', 'on', ...
'String', 'Reset all data', ...
'TooltipString', 'Reset to starting conditions');

% Set to only show the written filetype in the editbox
UIctrl_multitab.SaveButton = uicontrol('Parent', UI.h_figure, ...
'Style', 'pushbutton', ...
'Units', 'normalized', ...
'Position', [0.02 0.02 0.47 0.05], ...
'Enable', 'on', ...
'String', 'Save', ...
'TooltipString', 'Does nothing now. Callback function is empty. In future - will save GUI workspace to a file.');

%% Loading
[h_figure, UIctrl_load] = GUI.create_layout.load(UI.h_figure, pos, UI.h_tabs, tab_load);

%% Calibrating
%[h_figure, UIctrl_calib] = GUI.create_layout.calib(UI.h_figure, pos, UI.h_tabs, tab_calib);

%% Filtering
[h_figure, UIctrl_filter] = GUI.create_layout.filter(UI.h_figure, pos, UI.h_tabs, tab_filter);
assignin('base', 'tab_filter', tab_filter)
%% Plotting
[h_figure, UIctrl_plot] = GUI.create_layout.plot(UI.h_figure, pos, UI.h_tabs, tab_plot);

%% Create the handles
guidata(UI.h_figure, UI);

end