function [defaults, UI_obj] = Plot_m2q(exp_data, defaults, UI_obj)
% Function to plot mass spectra which can be manipulated in a second separate
% control window

ifdo_remember_line      = 0;
ifdo_hold_axes_limits   = 0;
nof_remembered_lines    = 0;
scan_names              = fieldnames(exp_data.scans);
scan_sample_name        = scan_names{1};

[spectrum_numbers_sample_cur] = get_spectrum_numbers( exp_data.scans.(scan_sample_name) );

defaults.plot_m2q.tooltips.spectrumslider = 'Select different spectra in this slider to explore different energies';
defaults.plot_m2q.tooltips.clear_graph_pushbtn = 'Clear all lines from the plot, creating empty axes';
defaults.plot_m2q.tooltips.remember_linechbx = 'Hold the currently plotted spectrum in the window';
defaults.plot_m2q.tooltips.holdchbx            = 'Do not change the X, Y axes limits when changing mass spectrum';

if ~isfield(settings.spectra)
    % There are no properties of the spectra defined yet:
    settings.spectra.dY % TODO refactoring first.
end

% Initiate the main plot window with the central axes:
UI_obj.plot.m2q.main = uifigure('Name', 'Control mass spectra, exp names: ' + join(string(scan_names), ', '), ...
    'NumberTitle','off', 'position', [100 100 300 180], 'KeyPressFcn', @keypress_callback);
UI_obj.plot.m2q.plot_window = figure('Name', 'Plot mass spectra', ...
    'NumberTitle','off', 'position', [100 200 600 400]);
UI_obj.plot.m2q.axes = axes('Parent', UI_obj.plot.m2q.plot_window);
hleg = legend(UI_obj.plot.m2q.axes, 'show','location','NorthWest');
set(hleg,'FontSize',12);

% Spectrum/scan tabs:
UI_obj.plot.m2q.uitabgroup.main    = uitabgroup(UI_obj.plot.m2q.main, "Position", [5, 45, 290, 130]);
UI_obj.plot.m2q.uitabgroup.spectra   = uitab(UI_obj.plot.m2q.uitabgroup.main, "Title",   "Spectra");
UI_obj.plot.m2q.uitabgroup.scans      = uitab(UI_obj.plot.m2q.uitabgroup.main, "Title",   "Scans");
% Scan tab:
set(UI_obj.plot.m2q.main, 'CloseRequestFcn', @close_both_M2Q_windows); % Make sure that both windows close when one is closed by user.
set(UI_obj.plot.m2q.plot_window, 'CloseRequestFcn', @close_both_M2Q_windows);

update_plot(UI_obj.plot.m2q.axes, exp_data, scan_sample_name, 1);
UI_obj.plot.m2q.slider_text = uilabel(UI_obj.plot.m2q.uitabgroup.scans, 'Text', 'Photon energy:', 'Position', [165, 75, 120, 25], ...
                            'Tooltip', defaults.plot_m2q.tooltips.spectrumslider);

[sliderMajorTicks, SliderMajorTickLabels] = get_uislider_ticks(spectrum_numbers_sample_cur);
    UI_obj.plot.m2q.spectr_slider = uislider(UI_obj.plot.m2q.uitabgroup.scans, 'Limits', [min(spectrum_numbers_sample_cur), max(spectrum_numbers_sample_cur)], ...
        'MajorTicks', sliderMajorTicks, 'MinorTicks', spectrum_numbers_sample_cur, 'MajorTickLabels', SliderMajorTickLabels, 'Tooltip', defaults.plot_m2q.tooltips.spectrumslider, ...
        'ValueChangedFcn', @change_spectrum);
UI_obj.plot.m2q.spectr_slider.Position(1:3) = [35, 55, 230];

% Create dropdown window to select different scans:
UI_obj.plot.m2q.holdchbx = uidropdown(UI_obj.plot.m2q.uitabgroup.scans, 'Items', scan_names, ...
    'ValueChangedFcn', @change_sample_dropdown_callback, 'Position', [25, 75, 120, 25]);

% Spectra tab:
% Show a table of all the loaded spectra and properties:
UI_obj.plot.m2q.spectra.uitable = uitable(UI_obj.plot.m2q.uitabgroup.spectra, ...
            "ColumnName", {'Name', 'dY', 'Scale', 'Color'}, "Position",[5 5 280 100], ...
            "Data", []);
nof_spectra = length(fieldnames(exp_data.spectra));
UI_obj.plot.m2q.spectra.uitable.Data{1:nof_spectra, 1} = fieldnames(exp_data.spectra);
UI_obj.plot.m2q.spectra.uitable.Data{1:nof_spectra, 2} = settings.spectra.dY;
UI_obj.plot.m2q.spectra.uitable.Data{1:nof_spectra, 1} = settings.spectra.Yscale;

% Create plot manipulation button and checkboxes:
UI_obj.plot.m2q.remember_linechbx   = uibutton(UI_obj.plot.m2q.main, 'Text', 'Store line', 'Position', [10, 10, 80, 25], ...
                        'ButtonPushedFcn', @remember_line, 'Tooltip', defaults.plot_m2q.tooltips.remember_linechbx);
UI_obj.plot.m2q.clear_graph_pushbtn = uibutton(UI_obj.plot.m2q.main, 'Text', 'Clear', 'Position', [100, 10, 80, 25], ...
                        'ButtonPushedFcn', @clear_lines, 'Tooltip', defaults.plot_m2q.tooltips.clear_graph_pushbtn);
UI_obj.plot.m2q.holdchbx            = uicheckbox(UI_obj.plot.m2q.main, 'Value', 0, ...
                        'Text', 'hold XY lim', 'Position', [200, 10, 150, 25], ...
                        'Tooltip', defaults.plot_m2q.tooltips.holdchbx, 'ValueChangedFcn', @hold_limits);



%% Local nested functions

% uislider
function [sliderMajorTicks, SliderMajorTickLabels] = get_uislider_ticks(spectrum_numbers_sample_cur)
    switch length(spectrum_numbers_sample_cur)
        case num2cell(1:5)
            sliderMajorTicks        = spectrum_numbers_sample_cur;
            SliderMajorTickLabels   = cellstr(num2str(exp_data.(scan_sample_name).photon.energy(:)));
        otherwise
            % More spectra (photon energies) than can be shown on the slider,
            % so divide it:
            sample_stepsize         = ceil(length(spectrum_numbers_sample_cur)/5);
            sample_nrs              = 1:sample_stepsize:length(spectrum_numbers_sample_cur);
            sliderMajorTicks        = spectrum_numbers_sample_cur(sample_nrs);
            slider_energies_double  = exp_data.scans.(scan_sample_name).photon.energy(sample_nrs);
            SliderMajorTickLabels   = cellstr(num2str(slider_energies_double(:)));
    end
end

function change_sample_dropdown_callback(~, ~)
    scan_sample_name = UI_obj.plot.m2q.holdchbx.Value;
    change_scan(scan_sample_name)
end     

%% Plot functions

function change_scan(sample_name)
    % The user wants to change scan. 
    spectrum_number = 1;
    % Update the plot window:
    update_plot(UI_obj.plot.m2q.axes, exp_data, sample_name, spectrum_number);
    % TODO: Find a spectrum that is closest in energy to the previous one,
    % or remember what user has used last.
    % re-build the slider:
    spectrum_numbers_sample_cur = get_spectrum_numbers( exp_data.(sample_name));
    [sliderMajorTicks, SliderMajorTickLabels] = get_uislider_ticks(spectrum_numbers_sample_cur);
    UI_obj.plot.m2q.spectr_slider.MajorTicks            = sliderMajorTicks;
    UI_obj.plot.m2q.spectr_slider.MajorTickLabels       = SliderMajorTickLabels;
    UI_obj.plot.m2q.spectr_slider.MinorTicks            = spectrum_numbers_sample_cur;
    UI_obj.plot.m2q.spectr_slider.Limits                = [1, max(spectrum_numbers_sample_cur)];
    % For now, reset to first spectrum:
    UI_obj.plot.m2q.spectr_slider.Value = spectrum_number;
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

function change_spectrum(~, ~) % The callback function of the slider
    % Jump slider to nearest MajorTick:
    [~, min_idx]     = min(abs(UI_obj.plot.m2q.spectr_slider.Value - UI_obj.plot.m2q.spectr_slider.MinorTicks));
    UI_obj.plot.m2q.spectr_slider.Value     = UI_obj.plot.m2q.spectr_slider.MinorTicks(min_idx);
    slider_value = get(UI_obj.plot.m2q.spectr_slider, 'Value');
    spectrum_number = round(slider_value);
    update_plot(UI_obj.plot.m2q.axes, exp_data, scan_sample_name, spectrum_number);
end

function[hLine] = update_plot(ax, exps, sample_name, spectrum_number)
    scan_names    = fieldnames(exps);
    spectra_names   = fieldnames(exps.scans.(sample_name).hist);
    M2Q_data        = exps.scans.(sample_name).hist.(spectra_names{spectrum_number}).M2Q;
    if ifdo_hold_axes_limits  
        xlims = get(ax, 'XLim'); 
        ylims = get(ax, 'YLim');
    end
    if ~ifdo_remember_line
        try delete(ax.Children(1)); catch ;  end
    end
    hold(UI_obj.plot.m2q.axes, 'on')
    grid(UI_obj.plot.m2q.axes, 'on')
    LineName_leg        = [sample_name, ', h\nu: ', num2str(exps.scans.(sample_name).photon.energy(spectrum_number)), ' eV'];
    LineName_title        = ['Sample: ', sample_name, ',  ', num2str(exps.scans.(sample_name).photon.energy(spectrum_number)), ' eV'];
    hLine           = plot(UI_obj.plot.m2q.axes, M2Q_data.bins, M2Q_data.I, 'DisplayName', LineName_leg);
    hLine.Color     = plot.colormkr(nof_remembered_lines, 1);
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
        change_spectrum();
    elseif strcmp(key, 'uparrow') || strcmp(key, 'downarrow')
        cur_sample_idx = find(strcmp(scan_sample_name, scan_names));
        switch key
            case 'uparrow' % one scan up
                scan_sample_name = scan_names{max(cur_sample_idx-1, 1)};
            case 'downarrow'
                scan_sample_name = scan_names{min(cur_sample_idx+1, length(scan_names))};
        end
        % Change the spectrum (call the regular callback):
        change_scan(scan_sample_name)
        % Also update the dropdown menu:
        UI_obj.plot.m2q.holdchbx.Value = scan_sample_name;
    elseif strcmp(key,'t')
        % Find where the image is placed:
        dir = which('GUI.fs_big.main');
        UI_obj.plot.m2q.trap = uiimage(UI_obj.plot.m2q.main, "ImageSource", fullfile(fileparts(dir), 'OIP.jpg'), 'Position', [0, 10, UI_obj.plot.m2q.main.Position(3:end)]);
        pause(0.5);
        delete(UI_obj.plot.m2q.trap);
    end
end

function close_both_M2Q_windows(~,~)
    delete(UI_obj.plot.m2q.main)
    delete(UI_obj.plot.m2q.plot_window)
end

end

%% Local (non-nested) functions

function [spectrum_numbers, spectrum_names] = get_spectrum_numbers( exp_sample )
    spectrum_names = fieldnames(exp_sample.hist);
    spectrum_numbers = regexp(spectrum_names, '\d*','match');
    spectrum_numbers = cellfun(@str2num, cat(2, spectrum_numbers{:}));
end
