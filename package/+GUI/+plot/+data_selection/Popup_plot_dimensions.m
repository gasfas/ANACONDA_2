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
guidata(hObject)
disp('Object marked in exp popup')
handles = guidata(hObject);
handles.filetype = get(hObject, 'String');
dimension_selected_number = get(hObject, 'Val');
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