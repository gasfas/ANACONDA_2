% Description: Select how the plot(s) are supposed to be:
% Together in new figure, separately in individual new figures or together
% in a pre-existing figure.
%   - inputs: none.
%   - outputs:
%           GUI metadata.
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
%% Message to log_box
GUI.log.add(['How to plot: ', char(handles.filetype(plot_type_value))])
assignin('base', 'md_GUI', md_GUI);
end