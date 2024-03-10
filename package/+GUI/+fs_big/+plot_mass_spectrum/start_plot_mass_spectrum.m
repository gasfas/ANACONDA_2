function [GUI_settings, UI_obj] = start_plot_mass_spectrum(exp_data, GUI_settings, UI_obj)
% Function to plot mass spectra which can be manipulated in a second separate
% control window

ifdo_remember_line      = 0;
ifdo_hold_axes_limits   = 0;
nof_remembered_lines    = 0;

% Depending whether there are (no) scans or spectra loaded, open different
% tabs:

GUI_settings.plot_m2q.tooltips.spectrumslider       = 'Select different spectra in this slider to explore different energies';
GUI_settings.plot_m2q.tooltips.clear_graph_pushbtn  = 'Clear all lines from the plot, creating empty axes';
GUI_settings.plot_m2q.tooltips.remember_linechbx    = 'Hold the currently plotted spectrum in the window';
GUI_settings.plot_m2q.tooltips.holdchbx             = 'Fixate the X, Y axes limits when changing mass spectrum';
GUI_settings.plot_m2q.tooltips.smooth               = 'Smoothen the mass spectrum using a median filter of specified width';
GUI_settings.plot_m2q.tooltips.cur_line_color       = 'Choose the color of the current plot';
GUI_settings.plot_m2q.tooltips.save_and_close       = 'Save parameters and close mass spectrum windows';

% Initiate the main plot window with the central axes:
UI_obj.plot.m2q.main = uifigure('Name', 'Control panel mass spectra', ...
    'NumberTitle','off', 'position', [100 100 350 300], 'KeyPressFcn', @keypress_callback);
UI_obj.plot.m2q.plot_window = figure('Name', 'Plot mass spectra', ...
    'NumberTitle','off', 'position', [100 200 600 400]);
UI_obj.plot.m2q.axes = axes('Parent', UI_obj.plot.m2q.plot_window);
hleg = legend(UI_obj.plot.m2q.axes, 'show','location','NorthWest');
set(hleg,'FontSize',12);

% Create plot manipulation button and checkboxes outside tab:
UI_obj.plot.m2q.remember_linechbx   = uibutton(UI_obj.plot.m2q.main, 'Text', 'Store line', 'Position', [10, 40, 80, 25], ...
                        'ButtonPushedFcn', @remember_line, 'Tooltip', GUI_settings.plot_m2q.tooltips.remember_linechbx);
UI_obj.plot.m2q.clear_graph_pushbtn = uibutton(UI_obj.plot.m2q.main, 'Text', 'Clear', 'Position', [100, 40, 60, 25], ...
                        'ButtonPushedFcn', @clear_lines, 'Tooltip', GUI_settings.plot_m2q.tooltips.clear_graph_pushbtn);
UI_obj.plot.m2q.holdchbx            = uicheckbox(UI_obj.plot.m2q.main, 'Value', 0, ...
                        'Text', '⚓', 'Position', [170, 40, 80, 25], ...
                        'Tooltip', GUI_settings.plot_m2q.tooltips.holdchbx, 'ValueChangedFcn', @hold_limits);
UI_obj.plot.m2q.smooth_edit         = uieditfield(UI_obj.plot.m2q.main,"numeric", 'Value', 1, ...
                        'Tooltip', GUI_settings.plot_m2q.tooltips.smooth, 'Position', [210, 40, 35, 25], 'ValueChangedFcn', @change_spectrum_within_scan);
UI_obj.plot.m2q.smooth_label        = uilabel(UI_obj.plot.m2q.main, 'Text', 'smooth', ...
                        'Tooltip', GUI_settings.plot_m2q.tooltips.smooth, 'Position', [250, 40, 50, 25]);
UI_obj.plot.m2q.cur_line_color      = uibutton(UI_obj.plot.m2q.main, 'Position', [310, 40, 20, 25], 'Text', 'C', ...
                        'ButtonPushedFcn', @change_cur_line_color, 'Tooltip', GUI_settings.plot_m2q.tooltips.cur_line_color, 'BackgroundColor', plot.colormkr(nof_remembered_lines, 1));
UI_obj.plot.m2q.clear_graph_pushbtn = uibutton(UI_obj.plot.m2q.main, 'Text', '💾 + ✕', 'Position', [10, 10, 80, 25], ...
                        'ButtonPushedFcn', @close_both_M2Q_windows, 'Tooltip', GUI_settings.plot_m2q.tooltips.save_and_close);

% Spectrum/scan tabs:
UI_obj.plot.m2q.uitabgroup.main         = uitabgroup(UI_obj.plot.m2q.main, "Position", [5, 75, 340, 220]);
if numel(fieldnames(exp_data.spectra)) >= 1 % Show spectrum tab
    spectra_intnames                        = fieldnames(exp_data.spectra);
    spectra_sample_username                 = exp_data.spectra.(spectra_intnames{1}).Name;
    UI_obj.plot.m2q.uitabgroup.spectra      = uitab(UI_obj.plot.m2q.uitabgroup.main, "Title",   "Spectra");
    % Spectra tab:
    % Show a table of all the loaded spectra and properties:
    UI_obj.plot.m2q.spectra.uitable = uitable(UI_obj.plot.m2q.uitabgroup.spectra, ...
                "ColumnName", {'Name', 'dY', 'Scale', 'Color'}, "Position",[5 5 320 190], 'ColumnEditable', [false true true, false], ...
                "Data", [], 'ColumnWidth', {100, 40, 50, 80}, 'CellSelectionCallback', {@spectra_table_select, GUI_settings}, ...
                'CellEditCallback', {@spectra_table_edit, GUI_settings});
    % Write data in uitable:
    [UI_obj.plot.m2q.spectra.uitable.Data, UI_obj, exp_data] = GUI.fs_big.scan_viewer.compose_uitable_scan_spectrum_Data('spectra_m2q_spectrum', UI_obj, exp_data);

    if numel(fieldnames(exp_data.scans)) == 0 % If no scans loaded, the initial plot is a spectrum:
        UI_obj.plot.m2q.cur_line_color.BackgroundColor = exp_data.spectra.(spectra_intnames{1}).Color;
        update_plot(UI_obj.plot.m2q.axes, exp_data, 'spectra', spectra_sample_username, 1);
    end
end
if numel(fieldnames(exp_data.scans)) >= 1 % Show scan tab
    scan_usernames                  = GUI.fs_big.get_user_names(exp_data.scans);
    scan_sample_username            = scan_usernames{1};
    int_name_cur                    = GUI.fs_big.get_intname_from_username(exp_data.scans, scan_sample_username);
    [spectrum_numbers_sample_cur]   = get_spectrum_numbers( exp_data.scans.(int_name_cur));

    UI_obj.plot.m2q.uitabgroup.scans        = uitab(UI_obj.plot.m2q.uitabgroup.main, "Title",   "Scans");
    % Scan tab:
    % set(UI_obj.plot.m2q.main, 'CloseRequestFcn', @close_both_M2Q_windows); % Make sure that both windows close when one is closed by user.
    % set(UI_obj.plot.m2q.plot_window, 'CloseRequestFcn', @close_both_M2Q_windows);
    
    [sliderMajorTicks, SliderMajorTickLabels] = get_uislider_ticks(spectrum_numbers_sample_cur);
        UI_obj.plot.m2q.spectr_slider = uislider(UI_obj.plot.m2q.uitabgroup.scans, 'Limits', [min(spectrum_numbers_sample_cur), max(spectrum_numbers_sample_cur)], ...
            'MajorTicks', sliderMajorTicks, 'MinorTicks', spectrum_numbers_sample_cur, 'MajorTickLabels', SliderMajorTickLabels, 'Tooltip', GUI_settings.plot_m2q.tooltips.spectrumslider, ...
            'ValueChangedFcn', @change_spectrum_within_scan);
    UI_obj.plot.m2q.spectr_slider.Position(1:3) = [35, 125, 230];
    
    % Create dropdown window to select different scans:
    UI_obj.plot.m2q.dropdownscans = uidropdown(UI_obj.plot.m2q.uitabgroup.scans, 'Items', scan_usernames, ...
        'ValueChangedFcn', @change_sample_dropdown_callback, 'Position', [25, 145, 120, 25]);

    UI_obj.plot.m2q.cur_line_color.BackgroundColor = exp_data.scans.(int_name_cur).Color;
    update_plot(UI_obj.plot.m2q.axes, exp_data, 'scans', scan_sample_username, 1);
    UI_obj.plot.m2q.slider_text = uilabel(UI_obj.plot.m2q.uitabgroup.scans, 'Text', 'Photon energy:', 'Position', [165, 145, 120, 25], ...
                                'Tooltip', GUI_settings.plot_m2q.tooltips.spectrumslider);
end

% Write the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)

%% Local nested functions
    function spectra_table_edit(hObj, event, GUI_settings)
        % Function to enable the user to change dY and scale of spectra.
        % Get the variables from base workspace:
        [~, ~, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

        spectra_intnames        = fieldnames(exp_data.spectra);
        current_spectrum_name   = spectra_intnames{event.Indices(1)};
        sample_username         = exp_data.spectra.(current_spectrum_name).Name;
        spectrum_number         = 1;
        switch unique(event.Indices(2))
            case 2 % Change in dY:
                exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.dY    = event.NewData;
                % Update the plot:
                update_plot(UI_obj.plot.m2q.axes, exp_data, 'spectra', sample_username, spectrum_number);
            case 3 % change in Scale
                exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.Scale = event.NewData;
                % Update the plot:
                update_plot(UI_obj.plot.m2q.axes, exp_data, 'spectra', sample_username, spectrum_number);
        end
        % Write the variables to base workspace:
        GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
    end

    function spectra_table_select(hObj, event, GUI_settings)
    % Get the variables from base workspace:
    [~, ~, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    spectra_intnames    = fieldnames(exp_data.spectra);
    sample_username     = exp_data.spectra.(spectra_intnames{event.Indices(1)}).Name;
    sample_intname      = GUI.fs_big.get_intname_from_username(exp_data.spectra, sample_username);
    % Update the color to the one specified by the spectrum:
    UI_obj.plot.m2q.cur_line.Color = exp_data.spectra.(sample_intname).Color;
    % Update the button color:
    UI_obj.plot.m2q.cur_line_color.BackgroundColor = exp_data.spectra.(sample_intname).Color;
    % User selected a row in the spectrum table, so show that in the plot:
    update_plot(UI_obj.plot.m2q.axes, exp_data, 'spectra', sample_username, 1);
end

% uislider
function [sliderMajorTicks, SliderMajorTickLabels] = get_uislider_ticks(spectrum_numbers_sample_cur)
    scan_intname            = GUI.fs_big.get_intname_from_username(exp_data.scans, scan_sample_username);
    switch length(spectrum_numbers_sample_cur)
        case num2cell(1:5)
            sliderMajorTicks        = spectrum_numbers_sample_cur;
            SliderMajorTickLabels   = cellstr(num2str(exp_data.scans.(scan_intname).Data.photon.energy(:)));
        otherwise
            % More spectra (photon energies) than can be shown on the slider,
            % so divide it:
            sample_stepsize         = ceil(length(spectrum_numbers_sample_cur)/5);
            sample_nrs              = 1:sample_stepsize:length(spectrum_numbers_sample_cur);
            sliderMajorTicks        = spectrum_numbers_sample_cur(sample_nrs);
            slider_energies_double  = exp_data.scans.(scan_intname).Data.photon.energy(sample_nrs);
            SliderMajorTickLabels   = cellstr(num2str(slider_energies_double(:)));
    end
    % Write the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
end

function change_sample_dropdown_callback(hObj, event)
    scan_sample_username = UI_obj.plot.m2q.dropdownscans.Value;
    change_scan(scan_sample_username)
end     

%% Plot functions

function change_scan(sample_username)
    sample_intname = GUI.fs_big.get_intname_from_username(exp_data.scans, sample_username);
    % The user wants to change scan. 
    spectrum_number = 1;
    % Update the plot window:
    update_plot(UI_obj.plot.m2q.axes, exp_data, 'scans', sample_username, spectrum_number);
    % TODO: Find a spectrum that is closest in energy to the previous one,
    % or remember what user has used last.
    % re-build the slider:
    spectrum_numbers_sample_cur = get_spectrum_numbers( exp_data.scans.(sample_intname));
    [sliderMajorTicks, SliderMajorTickLabels] = get_uislider_ticks(spectrum_numbers_sample_cur);
    UI_obj.plot.m2q.spectr_slider.MajorTicks            = sliderMajorTicks;
    UI_obj.plot.m2q.spectr_slider.MajorTickLabels       = SliderMajorTickLabels;
    UI_obj.plot.m2q.spectr_slider.MinorTicks            = spectrum_numbers_sample_cur;
    UI_obj.plot.m2q.spectr_slider.Limits                = [1, max(spectrum_numbers_sample_cur)];
    % For now, reset to first spectrum:
    UI_obj.plot.m2q.spectr_slider.Value = spectrum_number;
    % Update the color to the one specified by the scan:
    UI_obj.plot.m2q.cur_line.Color = exp_data.scans.(sample_intname).Color;
    % Update the button color:
    UI_obj.plot.m2q.cur_line_color.BackgroundColor = exp_data.scans.(sample_intname).Color;
end

function remember_line(~, ~)
    hLine2 = copyobj(UI_obj.plot.m2q.axes.Children(1), UI_obj.plot.m2q.axes);
    nof_remembered_lines = nof_remembered_lines + 1;
    hLine2(1).Color = plot.colormkr(nof_remembered_lines, 1);
end

    function hold_limits(objHandle, ~)
    ifdo_hold_axes_limits  = objHandle.Value;
end

function clear_lines(~, ~)
    delete(UI_obj.plot.m2q.axes.Children)
    nof_remembered_lines = 0;
end

function change_spectrum_within_scan(~, ~) % The callback function of the slider
    % Jump slider to nearest MajorTick:
    [~, min_idx]     = min(abs(UI_obj.plot.m2q.spectr_slider.Value - UI_obj.plot.m2q.spectr_slider.MinorTicks));
    UI_obj.plot.m2q.spectr_slider.Value     = UI_obj.plot.m2q.spectr_slider.MinorTicks(min_idx);
    slider_value = get(UI_obj.plot.m2q.spectr_slider, 'Value');
    spectrum_number = round(slider_value);
    update_plot(UI_obj.plot.m2q.axes, exp_data, 'scans', scan_sample_username, spectrum_number);
end

function[hLine] = update_plot(ax, exps, datatype, sample_name, spectrum_number)
    % datatype is either 'scans' or 'spectra'
    if ifdo_hold_axes_limits  
        xlims = get(ax, 'XLim'); 
        ylims = get(ax, 'YLim');
    end
    if ~ifdo_remember_line
        try delete(ax.Children(1)); catch ;  end
    end
    hold(UI_obj.plot.m2q.axes, 'on')
    grid(UI_obj.plot.m2q.axes, 'on')
    sample_intname  = GUI.fs_big.get_intname_from_username(exp_data.(datatype), sample_name);
    spectra_names   = fieldnames(exps.(datatype).(sample_intname).Data.hist);
    Yscale          = exps.(datatype).(sample_intname).Data.hist.(spectra_names{spectrum_number}).Scale;
    dY              = exps.(datatype).(sample_intname).Data.hist.(spectra_names{spectrum_number}).dY;
    M2Q_data        = exps.(datatype).(sample_intname).Data.hist.(spectra_names{spectrum_number}).M2Q;
    sample_intname  = GUI.fs_big.get_intname_from_username(exp_data.(datatype), sample_name);
    sample_name_legendready = general.char.replace_symbol_in_char(sample_name, '_', ' ');
    if isnumeric(exps.(datatype).(sample_intname).Data.photon.energy(spectrum_number))
        LineName_leg    = [sample_name_legendready, ', h\nu: ', num2str(exps.(datatype).(sample_intname).Data.photon.energy(spectrum_number)), ' eV'];
    else
        LineName_leg    = sample_name_legendready;
    end
    LineName_title  = ['Sample: ', sample_name_legendready, ',  ', num2str(exps.(datatype).(sample_intname).Data.photon.energy(spectrum_number)), ' eV'];
    if UI_obj.plot.m2q.smooth_edit.Value >= 1 % User wants to smooth the intensity data:
        M2Q_data.I = smoothdata(M2Q_data.I, "movmedian", UI_obj.plot.m2q.smooth_edit.Value, 'omitnan');
    end
    UI_obj.plot.m2q.cur_line           = plot(UI_obj.plot.m2q.axes, M2Q_data.bins, Yscale*M2Q_data.I+dY, 'DisplayName', LineName_leg);
    % try 
    %     hLine.Color     = exp_data.(datatype).(sample_intname).Color;
    % catch 
        UI_obj.plot.m2q.cur_line.Color                  = UI_obj.plot.m2q.cur_line_color.BackgroundColor;
    % end
    if ifdo_hold_axes_limits
        xlim(UI_obj.plot.m2q.axes, xlims);
        ylim(UI_obj.plot.m2q.axes, ylims);
    end
    xlabel(UI_obj.plot.m2q.axes, 'mass to charge [au]')
    ylabel(UI_obj.plot.m2q.axes, 'Intensity [arb. u]')
    title(LineName_title)
end

%% Callbacks
function keypress_callback(~, event)
    % value = UI_obj.plot.m2q.spectr_slider.Value; % get the slider value
	key = event.Key; % get the pressed key value
    if strcmp(key,'leftarrow') || strcmp(key,'rightarrow') 
        % The user wants the plot to move one mass spectrum up or down
        % Find the current value:
        Value_cur = round(UI_obj.plot.m2q.spectr_slider.Value);
        % Find the higher one in the spectra list, if it exists:
        cur_idx = find(Value_cur == UI_obj.plot.m2q.spectr_slider.MinorTicks);
        switch key
            case 'leftarrow' %one spectrum down
                Value_new = UI_obj.plot.m2q.spectr_slider.MinorTicks(max(cur_idx-1, 1));
            case 'rightarrow' % one spectrum up
                Value_new = UI_obj.plot.m2q.spectr_slider.MinorTicks(min(cur_idx+1, length(UI_obj.plot.m2q.spectr_slider.MinorTicks)));
        end
        UI_obj.plot.m2q.spectr_slider.Value = Value_new; % Set value in slider.
        change_spectrum_within_scan();
    elseif strcmp(key, 'uparrow') || strcmp(key, 'downarrow')
        cur_sample_idx = find(strcmp(scan_sample_username, scan_usernames));
        switch key
            case 'uparrow' % one scan up
                scan_sample_username = scan_usernames{max(cur_sample_idx-1, 1)};
            case 'downarrow'
                scan_sample_username = scan_usernames{min(cur_sample_idx+1, length(scan_usernames))};
        end
        % Change the spectrum (call the regular callback):
        change_scan(scan_sample_username)
        % Also update the dropdown menu:
        UI_obj.plot.m2q.dropdownscans.Value = scan_sample_username;
    elseif strcmp(key,'t')
        % Find where the image is placed:
        dir = which('GUI.fs_big.main');
        UI_obj.plot.m2q.trap = uiimage(UI_obj.plot.m2q.main, "ImageSource", fullfile(fileparts(dir), 'OIP.jpg'), 'Position', [0, 10, UI_obj.plot.m2q.main.Position(3:end)]);
        pause(0.5);
        delete(UI_obj.plot.m2q.trap);
    end
end

function close_both_M2Q_windows(~,~)
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
    % Close both windows:
    delete(UI_obj.plot.m2q.main)
    delete(UI_obj.plot.m2q.plot_window)
    % Update the tables at main window:
    GUI.fs_big.scan_viewer.uitable_scan_modify(UI_obj, exp_data);
    GUI.fs_big.scan_viewer.uitable_spectra_modify(UI_obj, exp_data);
    % Put main window at front:
    figure(UI_obj.main.uifigure)
end

function change_cur_line_color(hObj, event)
    % User wants to pick a new line plot color:
    UI_obj.plot.m2q.cur_line.Color = uisetcolor(UI_obj.plot.m2q.cur_line.Color);
    % Update the button color:
    UI_obj.plot.m2q.cur_line_color.BackgroundColor = UI_obj.plot.m2q.cur_line.Color;
    % Put the m2q plot window on top:
    figure(UI_obj.plot.m2q.plot_window)
    figure(UI_obj.plot.m2q.main)
end


end

%% Local (non-nested) functions

function [spectrum_numbers, spectrum_names] = get_spectrum_numbers( exp_sample )
    spectrum_names = fieldnames(exp_sample.Data.hist);
    spectrum_numbers = regexp(spectrum_names, '\d*','match');
    spectrum_numbers = cellfun(@str2num, cat(2, spectrum_numbers{:}));
end
