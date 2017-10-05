% Description: Starts up the GUI. Creates the GUI layout with all the
% controls and functions, and their callback definitions.
%   - inputs:
%           GUI layout
%           GUI callbacks
%   - outputs:
%           Load tab        (UILoad)
%           Filter tab      (UIFilter)
%           Plot tab        (UIPlot)
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = main( )
screensize = GUI.objects.GetScreenRes;
md_GUI = metadata.defaults.GUI;
md_GUI.UI.screensize = screensize;
assignin('base', 'md_GUI', md_GUI);
[handle, UILoad, UIPlot, UIFilter, UImultitab] = GUI.create_layout(screensize);
[ UIPlot, UILoad, UIFilter, UImultitab ] = GUI.callback_def(UIPlot, UILoad, UIFilter, UImultitab);
md_GUI = evalin('base', 'md_GUI');
md_GUI.UI.UImultitab = UImultitab;
md_GUI.UI.UIFilter = UIFilter;
md_GUI.UI.UILoad = UILoad;
md_GUI.UI.UIPlot = UIPlot;
assignin('base', 'md_GUI', md_GUI);
GUI.log.add('Session started')
end