% Description: Definitions of all the callbacks (nested functions).
%   - inputs:
%           UI controls.
%   - outputs:
%           Callback functions for the UI controls.
% Date of creation: 2017-07-11.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ UIPlot, UILoad, UIFilter, UImultitab ] = callback_def(UIPlot, UILoad, UIFilter, UImultitab)
%set buttons
set(UILoad.LoadFolderButton, ...
    'Callback', @LoadFolder)
set(UILoad.ConfButton, ...
    'Callback', @Conf)
set(UImultitab.ResetButton, ...
    'Callback', @Reset)
set(UImultitab.SaveButton, ...
    'Callback', @SaveButton)
set(UILoad.LoadFileButton, ...
    'Callback', @LoadFile)
set(UILoad.UnLoadFileButton, ...
    'Callback', @UnLoadFile)
%set(UILoad.UseFilesButton, ...
%    'Callback', @UseFiles)
set(UIPlot.PlotButton,...
    'Callback', @Plot_it)
set(UIFilter.EditFilter,...
    'Callback', @EditFilterButton)
set(UIFilter.RenameFilter,...
    'Callback', @RenameFilterButton)
set(UIFilter.RemoveFilter,...
    'Callback', @RemoveFilterButton)
set(UIPlot.PlotConfButton,...
    'Callback', @Plotconf)

% set editboxes
set(UILoad.FiletypeEditBox, ...
    'Callback', @Filetypeselection)

% set listboxes
set(UIPlot.LoadedFilesPlotting, ...
    'Callback',@LoadedFilesCall) %To the plotting tab
set(UILoad.ListOfFilesInFolder, ...
	'Callback', @FilesList) 
set(UILoad.LoadedFiles, ...
    'Callback',@LoadedFilesCall) %To the loading tab
set(UIFilter.Fieldname, ...
    'Callback',@FilterFieldNameCall)
set(UIFilter.Fieldvalue, ...
    'Callback',@FilterFieldValueCall) %To the filter tab

% set popupboxes
set(UIPlot.Popup_experiment_name, ...
    'Callback', @Popup_experiment)
set(UIPlot.Popup_Hits_or_Events, ...
    'Callback', @Popup_HitsEvents)
set(UIPlot.Popup_Filter_Selection, ...
    'Callback', @Popup_FilterSelect)
set(UIPlot.Popup_detector_choice, ...
    'Callback', @Popup_detector)
set(UIPlot.Popup_plot_dimensions,...
    'Callback', @Dimensions)
set(UIPlot.Popup_graph_type_X,...
    'Callback', @Popup_graph_X)
set(UIPlot.Popup_graph_type_Y,...
    'Callback', @Popup_graph_Y)
set(UIPlot.PopupPlotSelected,...
    'Callback', @PlotTypeSel)

%%  Functions for editboxes
    function Filetypeselection(hObject, eventdata)
       GUI.load.IO.edits.Filetypeselection(hObject, eventdata, UILoad);
    end

%%  Functions for buttons
    function Plotconf(hObject, eventdata)
        GUI.plot.md_edit.Plotconf();
    end
    function LoadFolder(hObject, eventdata)
        GUI.load.IO.buttons.LoadFolder( hObject, eventdata, UIPlot, UILoad );
    end
    function SaveButton(hObject, eventdata) %Does nothing now, button for future purposes.
        GUI.load.IO.buttons.FileType();
    end
    function Conf(hObject, eventdata)
        GUI.load.IO.buttons.Conf();
    end
    function LoadFile(hObject, eventdata)
        %set(UILoad.LoadFileButton, 'Enable', 'off')
        GUI.load.IO.buttons.LoadFile(UILoad, UIPlot, UIFilter);
        %set(UILoad.LoadFileButton, 'Enable', 'on')
    end
    function Plot_it(hObject, eventdata)
        GUI.plot.create.Plot();
    end
    function Reset(hObject, eventdata) %Resets all data
        GUI.load.IO.buttons.Reset
    end
    function UnLoadFile(hObject, eventdata)
        GUI.load.IO.buttons.UnLoadFile(UILoad, UIPlot, UIFilter);
    end  
    function EditFilterButton(hObject, eventdata)
        GUI.filter.edit.Edit_Filter(UIFilter);
    end
%     function CopyFilterButton(hObject, eventdata)
%         GUI.filter.edit.Copy_Filter(UIFilter);
%     end
    function RenameFilterButton(hObject, eventdata)
        GUI.filter.edit.Rename_Filter(UIFilter);
    end
    function RemoveFilterButton(hObject, eventdata)
        GUI.filter.edit.Remove_Filter(UIFilter);
    end

%%  Functions for popupboxes
    function Popup_experiment(hObject, eventdata)
        GUI.plot.data_selection.Popup_experiment_name(hObject, eventdata, UILoad, UIPlot);
    end
    function Popup_HitsEvents(hObject, eventdata)
        GUI.plot.data_selection.Popup_Hits_or_Events(hObject, eventdata, UILoad, UIPlot);
    end
    function Popup_FilterSelect(hObject, eventdata)
        GUI.plot.data_selection.Popup_Filter_Selection(hObject, eventdata, UILoad, UIPlot);
    end
    function Popup_detector(hObject, eventdata)
        GUI.plot.data_selection.Popup_detector_choice(hObject, eventdata, UILoad, UIPlot);
    end
    function Dimensions(hObject, eventdata)
        GUI.plot.data_selection.Popup_plot_dimensions(hObject, eventdata, UILoad, UIPlot);
    end
    function Popup_graph_X(hObject, eventdata)
        GUI.plot.data_selection.Popup_graph_type_X(hObject, eventdata, UILoad, UIPlot);
    end
    function Popup_graph_Y(hObject, eventdata)
        GUI.plot.data_selection.Popup_graph_type_Y(hObject, eventdata, UILoad, UIPlot);
    end
    function PlotTypeSel(hObject, eventdata)
        GUI.plot.data_selection.Popup_Plot_Selection(hObject, eventdata, UILoad, UIPlot);
    end
%%  Functions for listboxes
    function FilesList(hObject, eventdata)
       GUI.load.IO.lists.FilesList(hObject, eventdata, UILoad);
    end
    function LoadedFilesCall(hObject, eventdata)
       GUI.load.IO.lists.LoadedFiles(hObject, eventdata, UILoad, UIPlot);
    end
    function FilterFieldValueCall(hObject, eventdata)
        GUI.filter.edit.FieldValueList(hObject, eventdata, UIFilter);
    end
    function FilterFieldNameCall(hObject, eventdata)
        GUI.filter.edit.FieldnameList(hObject, eventdata, UIFilter);
    end
end