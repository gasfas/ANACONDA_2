% Description: Starts up the GUI. Creates the GUI layout with all the
% controls and functions, and their callback definitions.
%   - outputs:
%           GUI layout
%           GUI callbacks
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = main( )
screensize = GUI.objects.GetScreenRes;
md_GUI = metadata.defaults.GUI;
md_GUI.UI.screensize = screensize;
assignin('base', 'md_GUI', md_GUI);
% Create GUI layout:
[handle, UILoad, UIPlot, UIFilter, UICalib, UImultitab] = GUI.create_layout(screensize);
% Create callbacks for all GUI layout objects
[ UIPlot, UILoad, UIFilter, UImultitab ] = GUI.callback_def(UIPlot, UILoad, UIFilter, UICalib, UImultitab);
md_GUI = evalin('base', 'md_GUI');
md_GUI.UI.UImultitab = UImultitab;
md_GUI.UI.UIFilter = UIFilter;
md_GUI.UI.UILoad = UILoad;
md_GUI.UI.UIPlot = UIPlot;
md_GUI.UI.UICalib = UICalib;
assignin('base', 'md_GUI', md_GUI);
GUI.log.add('Session started')
end