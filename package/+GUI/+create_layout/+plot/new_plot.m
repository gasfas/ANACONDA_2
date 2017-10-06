% Description: Layout for the plot tab.
%   - inputs: 
%           Envents coming from the GUI.
%   - outputs: 
%           User interface (UI) control values for the plot tab control functions.
% Date of creation: 2017-07-11
% Author: Benjamin Bolling
% Modification date:
% Modifier:

function [ h_figure, UI ] = new_plot( h_figure, pos, h_tabs, tab_plot)
%% Functions
% Information about the listbox below

UI.BackgroundBox_1 =uicontrol('Parent', tab_plot, ...
'Style', 'pushbutton', ...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 14, ...
'BackgroundColor', [0.935 0.935 0.935], ...
'Position',[0.005 0.55 0.99 0.4],...
'Enable', 'off', ...
'String', '', ...
'TooltipString', '');

UI.BackgroundBox_2 =uicontrol('Parent', tab_plot, ...
'Style', 'pushbutton', ...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 14, ...
'BackgroundColor', [0.935 0.935 0.935], ...
'Position',[0.005 0.15 0.99 0.4],...
'Enable', 'off', ...
'String', '', ...
'TooltipString', '');

% Information about popup menu for experiment name
UI.InformationText_Experiment_name = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'Position',[0.02 0.88 0.7 0.06],...
'FontSize', 14, ...
'HorizontalAlignment', 'left', ...
'String','Choose experiment to set up');

% Popup for choice of experiment name; exp1, exp2, ...
UI.Popup_experiment_name = uicontrol('Parent', tab_plot, ...
'Enable', 'off', ...
'Style','popupmenu',...
'String', {''},...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.02 0.8 0.58 0.06]);

% Information about popup menu for hits or events
UI.InformationText_Hits_or_Events = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'Position',[0.02 0.72 0.5 0.06],...
'FontSize', 12, ...
'HorizontalAlignment', 'right', ...
'String','Hits- or events-based results:');

% Popup for choice of hits or event
UI.Popup_Hits_or_Events = uicontrol('Parent', tab_plot, ...
'Style','popupmenu',...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.54 0.72 0.44 0.06],...
'String', {''});

% Information about popup menu for detector selection
UI.InformationText_detector_choice = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.02 0.64 0.5 0.06],...
'HorizontalAlignment', 'right', ...
'String','Select detector:');

% Popup for choice of different detectors - detector 1, 2, 3.
UI.Popup_detector_choice = uicontrol('Parent', tab_plot, ...
'Style','popupmenu',...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.54 0.64 0.44 0.06],...
'String',{''});

% Information about popup menu for hits or events
UI.InformationText_Filter_Selection = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.02 0.56 0.44 0.06],...
'HorizontalAlignment', 'right', ...
'String','Select filter system to use:');

% Popup for filter selection
UI.Popup_Filter_Selection = uicontrol('Parent', tab_plot, ...
'Style','popupmenu',...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.48 0.56 0.5 0.06],...
'String', {'filter'});

% Information about popup menu for experiment name
UI.InformationText_PlotSettings = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'Position',[0.02 0.48 0.5 0.06],...
'FontSize', 14, ...
'HorizontalAlignment', 'left', ...
'String','Choose plot settings');

% Information about popup menu for graph dimensions
UI.InformationText_Plot_Dimensions = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.08 0.4 0.44 0.06],...
'HorizontalAlignment', 'right', ...
'String','Select dimensions:');

% Popup for choice of different dimensions (show only signals for 1D for 1D, only 2D for 2D,...
%   For 1D - plots above each other possible (1 combined graph). 2D & 3D - create 4 diff. windows
UI.Popup_plot_dimensions = uicontrol('Parent', tab_plot, ...
'Style','popupmenu',...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.54 0.4 0.44 0.06],...
'String',{'1D', '2D'});

% Information about popup menu for what graph to plot
UI.InformationText_graph_type_X = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.08 0.32 0.44 0.06],...
'HorizontalAlignment', 'right', ...
'String','Abscissa:');

% Popup graph plotting type (Abscissa)
UI.Popup_graph_type_X = uicontrol('Parent', tab_plot, ...
'Style','popupmenu',...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.54 0.32 0.44 0.06],...
'String',{''});

% Information about popup menu for what graph to plot - will be set as Y.
UI.InformationText_graph_type_Y = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.08 0.24 0.44 0.06],...
'HorizontalAlignment', 'right', ...
'String','Ordinate:');

% Popup graph plotting type 2 (Ordinate)
UI.Popup_graph_type_Y = uicontrol('Parent', tab_plot, ...
'Style','popupmenu',...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.54 0.24 0.44 0.06],...
'String',{''});

% Information about popup menu for how to plot it
UI.InformationText_PlotSelected = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.08 0.16 0.44 0.06],...
'HorizontalAlignment', 'right', ...
'String','Destination:');

% Selecting how to plot it
UI.PopupPlotSelected = uicontrol('Parent', tab_plot, ...
'Style','popupmenu',...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.54 0.16 0.44 0.06],...
'String',{'Plot all in new figure together', 'Plot all separately', 'Plot selection into pre-existing figure'});

% Plot the new selected stuff from the popups
UI.PlotButton = uicontrol('Parent', tab_plot, ...
'Style', 'pushbutton', ...
'Units', 'normalized',...
'FontSize', 14, ...
'Position',[0.52 0.03 0.46 0.1],...
'Enable', 'off', ...
'String', 'Plot', ...
'TooltipString', 'Press to plot');

% Plot the new selected stuff from the popups
UI.PlotConfButton = uicontrol('Parent', tab_plot, ...
'Style', 'pushbutton', ...
'Units', 'normalized',...
'FontSize', 14, ...
'Position',[0.02 0.03 0.46 0.1],...
'Enable', 'off', ...
'String', 'Plot Configurations', ...
'TooltipString', 'Press to configure plot settings for all selected experiments for the selected plot type');
end