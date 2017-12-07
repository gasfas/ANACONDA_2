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
%%  set buttons
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
set(UIPlot.new.PlotButton,...
    'Callback', @Plot_it_new)
set(UIPlot.def.PlotButton,...
    'Callback', @Plot_it_def)
set(UIPlot.def.PlotConfEditButton,...
    'Callback', @Edit_Plot_Conf_def)
set(UIPlot.new.save_plot_conf,...
    'Callback', @save_plot_conf)
set(UIPlot.new.edit_plot_conf,...
    'Callback', @edit_plot_conf)
set(UIPlot.new.remove_plot_conf,...
    'Callback', @remove_plot_conf)
set(UIPlot.new_signal.new_signal,...
    'Callback', @new_signal_conf)
set(UIPlot.new_signal.edit_signal,...
    'Callback', @edit_signal_conf)
set(UIPlot.new_signal.remove_signal,...
    'Callback', @remove_signal_conf)
set(UIFilter.EditFilter,...
    'Callback', @EditFilterButton)
set(UIFilter.RenameFilter,...
    'Callback', @RenameFilterButton)
set(UIFilter.RemoveFilter,...
    'Callback', @RemoveFilterButton)
set(UIFilter.IncreaseFont_Tree,...
    'Callback', @IncreaseTreeFontsizeButton)
set(UIFilter.DecreaseFont_Tree,...
    'Callback', @DecreaseTreeFontsizeButton)
set(UIPlot.new.PlotConfButton,...
    'Callback', @Plotconf)

%%  set editboxes
set(UILoad.FiletypeEditBox, ...
    'Callback', @Filetypeselection)

%%  set checkboxes
set(UIPlot.new.y_signals_checkbox,...
    'Callback', @Y_Signals_Checkbox)

%%  set listboxes
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
set(UIPlot.def.pre_def_plot_radiobutton_built_in,...
    'Callback', @pre_def_plot_radiobutton_built_in)
set(UIPlot.def.pre_def_plot_radiobutton_customized,...
    'Callback', @pre_def_plot_radiobutton_customized)

%%  set popupboxes
set(UIPlot.Popup_Filter_Selection, ...
    'Callback', @Popup_FilterSelect)

%%  Functions for editboxes
    function Filetypeselection(hObject, eventdata)
       GUI.load.IO.edits.Filetypeselection(hObject, eventdata, UILoad);
    end

%%  Functions for buttons
    function new_signal_conf(hObject, eventdata)
        md_GUI = evalin('base', 'md_GUI');
        
        assignin('base', 'md_GUI', md_GUI)
    end
    function edit_signal_conf(hObject, eventdata)
        md_GUI = evalin('base', 'md_GUI');
        
        assignin('base', 'md_GUI', md_GUI)
    end
    function remove_signal_conf(hObject, eventdata)
        md_GUI = evalin('base', 'md_GUI');
        
        assignin('base', 'md_GUI', md_GUI)
    end
    function save_plot_conf(hObject, eventdata)
        newPlotConfName = inputdlg('New plot configuration name:', 'Save to md');
        GUI.plot.md_edit.PlotConf.SavePlotConf(newPlotConfName);
    end
    function edit_plot_conf(hObject, eventdata)
        GUI.plot.md_edit.PlotConf.EditPlotConf('open_editor');
    end
    function remove_plot_conf(hObject, eventdata)
        GUI.plot.md_edit.PlotConf.RemovePlotConf;
    end
    function Plotconf(hObject, eventdata)
        GUI.plot.md_edit.PlotConf.SavePlotConf();
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
    function IncreaseTreeFontsizeButton(hObject, eventdata)
        md_GUI = evalin('base', 'md_GUI');
        md_GUI.UI.UIFilter.Tree.FontSize = md_GUI.UI.UIFilter.Tree.FontSize * 1.5;
        assignin('base', 'md_GUI', md_GUI)
    end
    function DecreaseTreeFontsizeButton(hObject, eventdata)
        md_GUI = evalin('base', 'md_GUI');
        md_GUI.UI.UIFilter.Tree.FontSize = md_GUI.UI.UIFilter.Tree.FontSize / 1.5;
        assignin('base', 'md_GUI', md_GUI)
    end
    function set_x_signal_button(hObject, eventdata)
        UIPlot.new.x_signal_pointer.String = char(UIPlot.new.signals_list.String(UIPlot.new.signals_list.Value));
        GUI.plot.md_edit.PlotConf.EditPlotConf('edit_only');
    end
    function set_y_signal_button(hObject, eventdata)
        UIPlot.new.y_signal_pointer.String = char(UIPlot.new.signals_list.String(UIPlot.new.signals_list.Value));
        GUI.plot.md_edit.PlotConf.EditPlotConf('edit_only');
    end
%%  Functions for popupboxes
    function Popup_FilterSelect(hObject, eventdata)
        GUI.plot.data_selection.Popup_Filter_Selection(hObject, eventdata, UILoad, UIPlot.new);
    end
    function PlotTypeSel(hObject, eventdata)
        GUI.plot.data_selection.Popup_Plot_Selection(hObject, eventdata, UILoad, UIPlot.new);
    end

%%  Functions for radiobuttons
    function pre_def_plot_radiobutton_customized(hObject, eventdata)
        GUI.plot.data_selection.Radiobutton_Custom;
    end
    function pre_def_plot_radiobutton_built_in(hObject, eventdata)
        GUI.plot.data_selection.Radiobutton_PreDef;
    end
%% Functions for checkboxes
    function Y_Signals_Checkbox(hObject, eventdata)
        if UIPlot.new.y_signals_checkbox.Value == 0
            UIPlot.new.btn_set_y_sign_pointer.Enable = 'off';
            UIPlot.new.y_signal_pointer.String = '-';
        else
            UIPlot.new.btn_set_y_sign_pointer.Enable = 'on';
        end
        GUI.plot.md_edit.PlotConf.EditPlotConf('edit_only');
    end
%%  Functions for listboxesedi
    function FilesList(hObject, eventdata)
       GUI.load.IO.lists.FilesList(hObject, eventdata, UILoad);
    end
    function LoadedFilesCall(hObject, eventdata)
        GUI.load.IO.lists.LoadedFiles(hObject, eventdata, UILoad, UIPlot);
        if UIPlot.def.pre_def_plot_radiobutton_customized.Value == 1
            GUI.plot.data_selection.Radiobutton_Custom;
        end
    end
    function FilterFieldValueCall(hObject, eventdata)
        GUI.filter.edit.FieldValueList(hObject, eventdata, UIFilter);
    end
    function FilterFieldNameCall(hObject, eventdata)
        GUI.filter.edit.FieldnameList(hObject, eventdata, UIFilter);
    end
    function Signals_List(hObject, eventdata)
        % No callback defined yet.
    end
end