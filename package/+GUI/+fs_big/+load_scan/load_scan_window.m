function [GUI_settings, UI_obj] = load_scan_window(GUI_settings, username, UI_obj, is_modify_scan)
% Create the load scan window
    
    UI_obj.load_scan.f_open_scan = uifigure('Name', 'Add scan',...
        'NumberTitle','off','position',[200 250 600 400], ...
        'KeyPressFcn', {@ GUI.fs_big.load_scan.callback.load_scan_Keypress_callback, GUI_settings});
    % Radio button to choose type of spectrometer:
    % Let the user decide which kind of experiment is done:
    UI_obj.setup_bg     = uibuttongroup(UI_obj.load_scan.f_open_scan,'Title', 'Choose spectrometer', 'Position',[30 280 140 120], 'Tooltip', GUI_settings.load_scan.tooltips.choose_spectrometer);
    rb_Spektrolatius    = uiradiobutton(UI_obj.setup_bg,'Text', 'Spektrolatius', 'Position',[10 82 91 15]);
    rb_Desirs_LTQ       = uiradiobutton(UI_obj.setup_bg,'Text', 'Desirs_LTQ', 'Position',[10 60 91 15]);
    rb_Desirs_LTQ       = uiradiobutton(UI_obj.setup_bg,'Text', 'Amazon (FELIX)', 'Position',[10 38 125 15]);
    rb_Bessy            = uiradiobutton(UI_obj.setup_bg,'Text', 'Bessy', 'Position',[10 16 91 15]);
    % Set default radiobutton position:
    switch GUI_settings.load_scan.setup_type
        case 'Spektrolatius'
            rb_Spektrolatius.Value = true;
        case 'Desirs_LTQ'
            rb_Desirs_LTQ.Value = true;
        case 'Bessy'
            rb_Bessy.Value = true;
    end
    GUI_settings.load_scan.setup_type = '';

    UI_obj.load_scan.sample_name = uilabel(UI_obj.load_scan.f_open_scan, 'Text', 'Sample name', 'Position', [200, 375, 100, 30]);
    UI_obj.load_scan.sample_name = uieditfield(UI_obj.load_scan.f_open_scan, 'Value', username, 'Tooltip', GUI_settings.load_scan.tooltips.sample_name, 'Position', [200, 350, 100, 30]);
    
    % re-bin factor:
    UI_obj.load_scan.re_bin_text = uilabel(UI_obj.load_scan.f_open_scan, 'Text', 're-bin factor', 'Position', [200, 325, 70, 30]);
    UI_obj.load_scan.re_bin_factor = uieditfield(UI_obj.load_scan.f_open_scan,"numeric", 'Value', GUI_settings.load_scan.re_bin_factor, 'Tooltip', GUI_settings.load_scan.tooltips.re_bin_factor, 'Position', [200, 300, 50, 30]);
    
    % scan or individual spectra:
    % Radio button to choose type of spectrometer:
    % Let the user decide which kind of data is loaded:
    UI_obj.load_scan.isscan                               = uibuttongroup(UI_obj.load_scan.f_open_scan,'Title', 'Data type', 'Tooltip', GUI_settings.load_scan.tooltips.Data_type_radio, 'Position',[320 300 140 80]);
    UI_obj.load_scan.isscanfields.rb_individual_spectra   = uiradiobutton(UI_obj.load_scan.isscan,'Text', 'spectra', 'Position',[10 38 91 15]);
    UI_obj.load_scan.isscanfields.rb_scan                 = uiradiobutton(UI_obj.load_scan.isscan,'Text', 'scans', 'Position',[10 16 91 15]);
    UI_obj.load_scan.isscan.SelectedObject.Value          = ~GUI_settings.load_scan.is_scan;

    % Text of the filepath:
    UI_obj.load_scan.LoadFilePath         = uitextarea(UI_obj.load_scan.f_open_scan, 'Value', GUI_settings.load_scan.filelist, 'Position', [10, 50, 500, 220]);
    UI_obj.load_scan.LoadFile_Browse_btn  = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Browse", "Position", [10, 10, 80, 20], ...
        "ButtonPushedFcn", {@GUI.fs_big.load_scan.callback.get_filepath, GUI_settings, UI_obj}, ...
        'Tooltip', GUI_settings.load_scan.tooltips.Browse);
    UI_obj.load_scan.LoadFile_Cancel_btn  = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Cancel", "Position", [410, 10, 80, 20], ...
        "ButtonPushedFcn", {@GUI.fs_big.load_scan.callback.load_scan_cancel_callback, GUI_settings}, ...
        'Tooltip', GUI_settings.load_scan.tooltips.Cancel);
    UI_obj.load_scan.LoadFile_Ok_btn      = uibutton(UI_obj.load_scan.f_open_scan, "Text", "Ok", "Position", [500, 10, 80, 20], ...
        "ButtonPushedFcn", {@GUI.fs_big.load_scan.callback.load_scan_OK_callback, GUI_settings, is_modify_scan}, ...
        'Tooltip', GUI_settings.load_scan.tooltips.OK);

    % Write the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
end