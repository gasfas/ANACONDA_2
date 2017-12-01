% Description: Layout for the plot tab.
%   - inputs: 
%           Envents coming from the GUI.
%   - outputs: 
%           User interface (UI) control values for the plot tab control functions.
% Date of creation: 2017-07-11
% Author: Benjamin Bolling
% Modification date:
% Modifier:

function [ h_figure, UI ] = new_signal( h_figure, pos, h_tabs, tab_plot)
%% Functions
% Information about the listbox below

UI.BackgroundBox =uicontrol('Parent', tab_plot, ...
'Style', 'pushbutton', ...
'Enable', 'off', ...
'Units', 'normalized',...
'FontSize', 14, ...
'BackgroundColor', [0.935 0.935 0.935], ...
'Position',[0.005 0.01 0.99 0.98],...
'Enable', 'off', ...
'String', '', ...
'TooltipString', '');

% Information text about Signal settings
UI.SignalSettings_Text = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'Position',[0.02 0.91 0.96 0.06],...
'FontSize', 14, ...
'HorizontalAlignment', 'left', ...
'String','Signal settings');

% List of signal pointers
UI.signals_list = uicontrol('Parent', tab_plot, ...
'Style','list',...
'Units', 'normalized',...
'Position',[0.02 0.1 0.47 0.8],...
'FontSize', 14, ...
'HorizontalAlignment', 'center', ...
'Enable', 'off',...
'String','-');

% New signal
UI.new_signal = uicontrol('Parent', tab_plot, ...
'Style','pushbutton',...
'Units', 'normalized',...
'Position',[0.51 0.82 0.47 0.1],...
'FontSize', 14, ...
'HorizontalAlignment', 'center', ...
'Enable', 'off',...
'String','Save to md...');

% Edit existing signal (customized or defined by user)
UI.edit_signal = uicontrol('Parent', tab_plot, ...
'Style','pushbutton',...
'Units', 'normalized',...
'Position',[0.51 0.7 0.47 0.1],...
'FontSize', 14, ...
'HorizontalAlignment', 'center', ...
'Enable', 'off',...
'String','Edit...');

% Remove existing signal (customized or defined by user)
UI.remove_signal = uicontrol('Parent', tab_plot, ...
'Style','pushbutton',...
'Units', 'normalized',...
'Position',[0.51 0.58 0.47 0.1],...
'FontSize', 14, ...
'HorizontalAlignment', 'center', ...
'Enable', 'off',...
'String','Remove...');

end