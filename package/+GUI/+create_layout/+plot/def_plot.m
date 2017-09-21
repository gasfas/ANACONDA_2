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

% Information about popup menu for plot selection
UI.InformationText_plot_selection = uicontrol('Parent', tab_plot, ...
'Style','text',...
'Units', 'normalized',...
'Position',[0.02 0.85 0.96 0.05],...
'FontSize', 14, ...
'HorizontalAlignment', 'left', ...
'String','Choose how to plot selected experiment(s):');

% Popup box with plot type def in:
% md_GUI.mdata_n.exp1.plot.det1.KER_sum
% Gets def when loading exp and by sel exp in plot loadedfiles listbox.
UI.Popup_plot_type = uicontrol('Parent', tab_plot, ...
'Enable', 'off', ...
'Style','popupmenu',...
'String', {''},...
'Units', 'normalized',...
'FontSize', 12, ...
'Position',[0.02 0.78 0.96 0.05]);

% Plot the way selected from popup above
UI.PlotButton = uicontrol('Parent', tab_plot, ...
'Style', 'pushbutton', ...
'Units', 'normalized',...
'FontSize', 14, ...
'Position',[0.02 0.65 0.96 0.1],...
'Enable', 'off', ...
'String', 'Plot', ...
'TooltipString', 'Press to plot');
% Plot function used:
%macro.plot.create.plot(md_GUI.data_n.exp1, md_GUI.mdata_n.exp1.plot.det1.KER_sum)

end