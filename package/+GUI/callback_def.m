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
set(UIPlot.new.PlotButton,...
    'Callback', @Plot_it_new)
set(UIPlot.def.PlotButton,...
    'Callback', @Plot_it_def)
set(UIPlot.def.PlotConfEditButton,...
    'Callback', @Edit_Plot_Conf_def)
set(UIPlot.new.new_signal,...
    'Callback', @New_Signal)
set(UIPlot.new.edit_signal,...
    'Callback', @Edit_Signal)
set(UIPlot.new.remove_signal,...
    'Callback', @Remove_Signal)
set(UIFilter.EditFilter,...
    'Callback', @EditFilterButton)
set(UIFilter.RenameFilter,...
    'Callback', @RenameFilterButton)
set(UIFilter.RemoveFilter,...
    'Callback', @RemoveFilterButton)
set(UIPlot.new.PlotConfButton,...
    'Callback', @Plotconf)

% set editboxes
set(UILoad.FiletypeEditBox, ...
    'Callback', @Filetypeselection)

% set checkboxes
set(UIPlot.new.y_signals_checkbox,...
    'Callback', @Y_Signals_Checkbox)

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
set(UIPlot.new.signals_list,...
    'Callback', @Signals_List)
set(UIPlot.new.btn_set_x_sign_pointer,...
    'Callback', @set_x_signal_button)
set(UIPlot.new.btn_set_y_sign_pointer,...
    'Callback', @set_y_signal_button)

% set popupboxes
set(UIPlot.Popup_Filter_Selection, ...
    'Callback', @Popup_FilterSelect)
set(UIPlot.new.PopupPlotSelected,...
    'Callback', @PlotTypeSel)

%%  Functions for editboxes
    function Filetypeselection(hObject, eventdata)
       GUI.load.IO.edits.Filetypeselection(hObject, eventdata, UILoad);
    end

%%  Functions for buttons
    function New_Signal(hObject, eventdata)
        %GUI.plot.md_edit.Plotconf();
    end
    function Edit_Signal(hObject, eventdata)
        %GUI.plot.md_edit.Plotconf();
    end
    function Remove_Signal(hObject, eventdata)
        %GUI.plot.md_edit.Plotconf();
    end
    function Plotconf(hObject, eventdata)
        GUI.plot.md_edit.Plotconf();
    end
    function LoadFolder(hObject, eventdata)
        GUI.load.IO.buttons.LoadFolder( hObject, eventdata, UIPlot.new, UILoad );
    end
    function SaveButton(hObject, eventdata)
        GUI.work.SaveWork( );
    end
    function LoadFile(hObject, eventdata)
        GUI.load.IO.buttons.LoadFile(UILoad, UIPlot, UIFilter);
    end
    function Plot_it_new(hObject, eventdata)
        GUI.plot.create.Plot();
    end
    function Plot_it_def(hObject, eventdata)
        GUI.plot.create.Plot_def();
	end
    function Edit_Plot_Conf_def(hObject, eventdata)
        GUI.plot.md_edit.open_Variables();
	end

    function Reset(hObject, eventdata)
        GUI.load.IO.buttons.Reset
    end
    function UnLoadFile(hObject, eventdata)
        GUI.load.IO.buttons.UnLoadFile(UILoad, UIPlot, UIFilter);
    end  
    function EditFilterButton(hObject, eventdata)
        GUI.filter.edit.Edit_Filter(UIFilter);
    end
    function RenameFilterButton(hObject, eventdata)
        GUI.filter.edit.Rename_Filter(UIFilter);
    end
    function RemoveFilterButton(hObject, eventdata)
        GUI.filter.edit.Remove_Filter(UIFilter);
    end

%%  Functions for popupboxes
    function Popup_FilterSelect(hObject, eventdata)
        GUI.plot.data_selection.Popup_Filter_Selection(hObject, eventdata, UILoad, UIPlot.new);
    end
    function PlotTypeSel(hObject, eventdata)
        GUI.plot.data_selection.Popup_Plot_Selection(hObject, eventdata, UILoad, UIPlot.new);
    end

%% Functions for checkboxes
    function Y_Signals_Checkbox(hObject, eventdata)
        if UIPlot.new.y_signals_checkbox.Value == 0
            UIPlot.new.btn_set_y_sign_pointer.Enable = 'off';
            UIPlot.new.y_signal_pointer.String = '-';
        else
            UIPlot.new.btn_set_y_sign_pointer.Enable = 'on';
        end
    end
    function set_x_signal_button(hObject, eventdata)
        UIPlot.new.x_signal_pointer.String = char(UIPlot.new.signals_list.String(UIPlot.new.signals_list.Value));
    end
    function set_y_signal_button(hObject, eventdata)
        UIPlot.new.y_signal_pointer.String = char(UIPlot.new.signals_list.String(UIPlot.new.signals_list.Value));
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
    function Signals_List(hObject, eventdata)
        %GUI.filter.edit.FieldnameList(hObject, eventdata, UIFilter);
    end
end