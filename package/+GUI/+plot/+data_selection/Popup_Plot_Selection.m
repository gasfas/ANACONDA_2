% Description: Select how the plot(s) are supposed to be:
% Together in new figure, separately in individual new figures or together
% in a pre-existing figure.
%   - inputs: none.
%   - outputs:
%           Plot settings       	(plotsettings)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = Popup_Plot_Selection(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
plot_type_value = get(hObject, 'Val');
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['How to plot: ', char(handles.filetype(plot_type_value))];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
% The plot function now only works for first two possibilities (together 
% in new figure or separately in individual new figures). If 3 is
% selected, make it number 1 instead.
if plot_type_value == 3
    plot_type_value = 1;
end
md_GUI.plot.plotsettings(4) = plot_type_value;
assignin('base', 'md_GUI', md_GUI);
end