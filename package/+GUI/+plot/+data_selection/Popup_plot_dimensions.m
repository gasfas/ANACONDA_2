% Description: Selects how many dimensions the graph is to have.
%   - inputs: None.
%   - outputs:
%           Plot settings         	(plotsettings)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% Note: % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Does nothing now but separates the choices. Will be used in the soon future. %
 % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%% Plot dimensions function:
function [ ] = Popup_plot_dimensions(hObject, eventdata, UILoad, UIPlot)
md_GUI = evalin('base', 'md_GUI');
%Gives: Experiment selected, Experiment selected number
guidata(hObject);
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
dimension_selected_number = get(hObject, 'Val');
%% Message to log_box - cell_to_be_inserted:
cell_to_be_inserted = ['Dimensions selected: ', num2str(dimension_selected_number), 'D'];
[ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
if dimension_selected_number == 1
    % In future, sort the graph types. 1D.
end
if dimension_selected_number == 2
    % In future, sort the graph types. 2D.
end
if dimension_selected_number == 3
    % In future, sort the graph types. 3D.
end
if dimension_selected_number == 4
    % In future, sort the graph types. This can be called 'Special'.
end
md_GUI.plot.plotsettings(1) = dimension_selected_number;
assignin('base', 'md_GUI', md_GUI);
end