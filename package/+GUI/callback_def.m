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
        GUI.plot.md_edit.PlotConf.SavePlotConf;
    end
    function edit_plot_conf(hObject, eventdata)
        %GUI.plot.md_edit.Plotconf();
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

%%  Functions for popupboxes
    function Popup_FilterSelect(hObject, eventdata)
        GUI.plot.data_selection.Popup_Filter_Selection(hObject, eventdata, UILoad, UIPlot.new);
    end
    function PlotTypeSel(hObject, eventdata)
        GUI.plot.data_selection.Popup_Plot_Selection(hObject, eventdata, UILoad, UIPlot.new);
    end

%%  Functions for radiobuttons
    function pre_def_plot_radiobutton_customized(hObject, eventdata)
        md_GUI = evalin('base', 'md_GUI');
        try
            filenumber = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
            exp_names = cellstr('');
            for lx = 1:length(filenumber)
                exp_names(lx) = cellstr(['exp', int2str(filenumber(lx))]);
            end        
            plottypes_def = {}; 
            popup_list_names = {};
            for lx = 1:length(exp_names)
                current_exp_name = char(exp_names(lx));
                % Get number of detectors.
                detector_choices = fieldnames(md_GUI.mdata_n.(current_exp_name).det);
                if ischar(detector_choices)
                    numberofdetectors = 1;
                    detector_choices = cellstr(detector_choices);
                else
                    numberofdetectors = length(detector_choices);
                end
                for ly = 1:numberofdetectors
                    current_det_name = char(detector_choices(ly));
                    detnr			 = IO.detname_2_detnr(current_det_name);
                    % Find a human-readable detector name:
                    hr_detname		= md_GUI.mdata_n.(current_exp_name).spec.det_modes{detnr};
                    currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.user.(current_det_name));
                    % remove possible 'ifdo' fields:
                    currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
                    numberofplottypes = length(currentplottypes);

                    % write dots between detectornames and fieldnames:
                    popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
                    plottypes_def(1,end+1:end+numberofplottypes) = currentplottypes;
                    popup_list_names(1,end+1:end+numberofplottypes) = popup_list_names_det;
                end
                if length(exp_names) > 1
                    list_struct.([char(exp_names(lx))]) = popup_list_names_det;
                end
            end
            if length(exp_names) > 1 % check so that all exps have plot confs:
                value = 0;
                for llz = 1:length(exp_names)
                    if length(list_struct.([char(exp_names(llz))])) > 0
                        value = value + 1;
                    end
                end
                popup_list_names = cellstr('');
                if value > length(exp_names)-1 % Do the fields comparison.
                    popup_list_names = GUI.general_functions.CommonFields(list_struct);
                else % At least one exp has zero fields - do nothing.
                    GUI.log.add(['At least one experiment has no pre-defined plots for selected plot setting.'])
                end
            end
            set(md_GUI.UI.UIPlot.def.Popup_plot_type, 'String', popup_list_names)
            set(md_GUI.UI.UIPlot.def.Popup_plot_type, 'Enable', 'on')
            
        catch
            set(UIPlot.def.Popup_plot_type, 'String', {' - '})
            set(md_GUI.UI.UIPlot.def.Popup_plot_type, 'Enable', 'off')
        end
        if isempty(popup_list_names)
            set(UIPlot.def.Popup_plot_type, 'String', {' - '})
            set(md_GUI.UI.UIPlot.def.Popup_plot_type, 'Enable', 'off')
        end
        set(UIPlot.def.Popup_plot_type, 'Value', 1)
        assignin('base', 'md_GUI', md_GUI)
    end
    function pre_def_plot_radiobutton_built_in(hObject, eventdata)
        md_GUI = evalin('base', 'md_GUI');
        set(md_GUI.UI.UIPlot.def.Popup_plot_type, 'Enable', 'on')
        filenumber = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
        exp_names = cellstr('');
        for lx = 1:length(filenumber)
            exp_names(lx) = cellstr(['exp', int2str(filenumber(lx))]);
        end        
        plottypes_def = {}; 
        popup_list_names = {};
        for lx = 1:length(exp_names)
            current_exp_name = char(exp_names(lx));
            % Get number of detectors.
            detector_choices = fieldnames(md_GUI.mdata_n.(current_exp_name).det);
            if ischar(detector_choices)
                numberofdetectors = 1;
                detector_choices = cellstr(detector_choices);
            else
                numberofdetectors = length(detector_choices);
            end
            for ly = 1:numberofdetectors
                current_det_name = char(detector_choices(ly));
                detnr			 = IO.detname_2_detnr(current_det_name);
                % Find a human-readable detector name:
                hr_detname		= md_GUI.mdata_n.(current_exp_name).spec.det_modes{detnr};
                currentplottypes = fieldnames(md_GUI.mdata_n.(current_exp_name).plot.(current_det_name));
                % remove possible 'ifdo' fields:
                currentplottypes(find(ismember(currentplottypes,'ifdo'))) = [];
                numberofplottypes = length(currentplottypes);

                % write dots between detectornames and fieldnames:
                popup_list_names_det = general.cell.pre_postscript_to_cellstring(currentplottypes, [hr_detname '.' ], '');
                plottypes_def(1,end+1:end+numberofplottypes) = currentplottypes;
                popup_list_names(1,end+1:end+numberofplottypes) = popup_list_names_det;
            end
                if length(exp_names) > 1
                    list_struct.([char(exp_names(lx))]) = popup_list_names_det;
                end
            end
            if length(exp_names) > 1 % check so that all exps have plot confs:
                value = 0;
                for llz = 1:length(exp_names)
                    if length(list_struct.([char(exp_names(llz))])) > 0
                        value = value + 1;
                    end
                end
                popup_list_names = cellstr('');
                if value > length(exp_names)-1 % Do the fields comparison.
                    popup_list_names = GUI.general_functions.CommonFields(list_struct);
                else % At least one exp has zero fields - do nothing.
                    GUI.log.add(['At least one experiment has no pre-defined plots for selected plot setting.'])
                end
            end
        set(md_GUI.UI.UIPlot.def.Popup_plot_type, 'String', popup_list_names)
        assignin('base', 'md_GUI', md_GUI)
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
        % No callback defined yet.
    end
end