function h_f = Plot_m2q(exps, mds)
% Function to plot mass spectra which can be manipulated in a second separate
% control window

ifdo_remember_line      = 0;
ifdo_hold_axes_limits   = 0;
nof_remembered_lines    = 0;
sample_names            = fieldnames(exps);
sample_name             = sample_names{1};

UI_obj.plot.m2q.spectrumslider.Tooltip = 'Select different spectra in this slider to explore different energies';
UI_obj.plot.m2q.clear_graph_pushbtn.Tooltip = 'Clear all lines from the plot, creating empty axes';
UI_obj.plot.m2q.remember_linechbx.Tooltip = 'Hold the currently plotted spectrum in the window';
UI_obj.plot.m2q.holdchbx.Tooltip            = 'Do not change the X, Y axes limits when changing mass spectrum';

% Initiate the main plot window with the central axes:
UI_obj.plot.m2q.main = uifigure('Name', ['Control mass spectra, exp names: ' + join(string(sample_names), ', ')], ...
    'NumberTitle','off', 'position', [200 200 300 180], 'KeyPressFcn', @keypress_callback);
UI_obj.plot.m2q.plot_window = figure('Name', 'Plot mass spectra', ...
    'NumberTitle','off', 'position', [200 400 600 400]);
UI_obj.plot.m2q.axes = axes('Parent', UI_obj.plot.m2q.plot_window);
hleg = legend(UI_obj.plot.m2q.axes, 'show','location','NorthWest');
set(hleg,'FontSize',12);

[spectrum_numbers_first_sample, spectrum_names_first_sample] = get_spectrum_numbers( exps.(sample_name) );
hLine                   = update_plot(UI_obj.plot.m2q.axes, exps, sample_name, 1);
UI_obj.plot.m2q.slider_text = uilabel(UI_obj.plot.m2q.main, 'Text', 'Spectrum number', 'Position', [80, 60, 120, 25], ...
                            'Tooltip', UI_obj.plot.m2q.spectrumslider.Tooltip);
UI_obj.plot.m2q.spectr_slider = uislider(UI_obj.plot.m2q.main, 'Limits', [min(spectrum_numbers_first_sample), max(spectrum_numbers_first_sample)], ...
            'MajorTicks', spectrum_numbers_first_sample, 'Tooltip', UI_obj.plot.m2q.spectrumslider.Tooltip, ...
            'ValueChangedFcn', @change_spectrum);
UI_obj.plot.m2q.spectr_slider.Position(1:3) = [20, 54, 200];

% Create plot manipulation button and checkboxes:
UI_obj.plot.m2q.remember_linechbx   = uibutton(UI_obj.plot.m2q.main, 'Text', 'Store line', 'Position', [10, 90, 80, 25], ...
                        'ButtonPushedFcn', @remember_line, 'Tooltip', UI_obj.plot.m2q.remember_linechbx.Tooltip);
UI_obj.plot.m2q.clear_graph_pushbtn = uibutton(UI_obj.plot.m2q.main, 'Text', 'Clear', 'Position', [100, 90, 80, 25], ...
                        'ButtonPushedFcn', @clear_lines, 'Tooltip', UI_obj.plot.m2q.clear_graph_pushbtn.Tooltip);
UI_obj.plot.m2q.holdchbx            = uicheckbox(UI_obj.plot.m2q.main, 'Value', 0, ...
                        'Text', 'hold XY lim', 'Position', [200, 90, 150, 25], ...
                        'Tooltip', UI_obj.plot.m2q.holdchbx.Tooltip, 'ValueChangedFcn', @hold_limits);

% Create dropdown window to select different scans:
UI_obj.plot.m2q.holdchbx = uidropdown(UI_obj.plot.m2q.main, 'Items', sample_names, ...
    'ValueChangedFcn', @change_sample_dropdown_callback, 'Position', [10, 130, 120, 25]);
why

function change_sample_dropdown_callback(~,~)
    sample_name = UI_obj.plot.m2q.holdchbx.Value;
    change_scan(sample_name)
end     

function change_scan(sample_name)
    % The user wants to change scan. 
    spectrum_number = 1;
    % Update the plot window:
    update_plot(UI_obj.plot.m2q.axes, exps, sample_name, spectrum_number);
    % TODO: Find a spectrum that is closest in energy to the previous one,
    % or remember what user has used last.
    % re-build the slider:
    spectrum_numbers = get_spectrum_numbers( exps.(sample_name));
    UI_obj.plot.m2q.spectr_slider.Limits = [min(spectrum_numbers), max(spectrum_numbers)];
    UI_obj.plot.m2q.spectr_slider.MajorTicks =  spectrum_numbers;
    % For now, reset to first spectrum:
    UI_obj.plot.m2q.spectr_slider.Value = spectrum_number;
end

function remember_line(objHandle, ~)
    hLine2 = copyobj(UI_obj.plot.m2q.axes.Children(1), UI_obj.plot.m2q.axes);
    nof_remembered_lines = nof_remembered_lines + 1;
    hLine2(1).Color = plot.colormkr(nof_remembered_lines, 1);
    
%     ifdo_remember_line = objHandle.Value;
%     if ifdo_remember_line
%         hold(ax, 'on')
%     else
%         hold(ax, 'off')
%     end
end

function hold_limits(objHandle, ~)
    ifdo_hold_axes_limits  = objHandle.Value;
end

function clear_lines(objHandle, ~)
    delete(UI_obj.plot.m2q.axes.Children)
    nof_remembered_lines = 0;
end

function change_spectrum(~, ~) % The callback function of the slider
    % Jump slider to nearest MajorTick:
    [~, min_idx]     = min(abs(UI_obj.plot.m2q.spectr_slider.Value - UI_obj.plot.m2q.spectr_slider.MajorTicks));
    UI_obj.plot.m2q.spectr_slider.Value     = UI_obj.plot.m2q.spectr_slider.MajorTicks(min_idx);
    slider_value = get(UI_obj.plot.m2q.spectr_slider, 'Value');
    spectrum_number = round(slider_value);
    update_plot(UI_obj.plot.m2q.axes, exps, sample_name, spectrum_number);
    bl3.String = ['Spectrum number ', num2str(spectrum_number)];
end

function[hLine] = update_plot(ax, exps, sample_name, spectrum_number)
    sample_names    = fieldnames(exps);
    spectra_names   = fieldnames(exps.(sample_name).hist);
    M2Q_data        = exps.(sample_name).hist.(spectra_names{spectrum_number}).M2Q;
    if ifdo_hold_axes_limits  
        xlims = get(ax, 'XLim'); 
        ylims = get(ax, 'YLim');
    end
    if ifdo_remember_line
        % Remember the current line, re-color it and give it a name:
        nof_remembered_lines = nof_remembered_lines + 1;
        hLine.Color = plot.colormkr(nof_remembered_lines);
    else
        try delete(ax.Children(1)); end
    end
    hold(UI_obj.plot.m2q.axes, 'on')
    grid(UI_obj.plot.m2q.axes, 'on')
    LineName_leg        = ['Sample: ', sample_name, ', h\nu: ', num2str(exps.(sample_name).photon.energy(spectrum_number)), ' eV'];
    LineName_title        = ['Sample: ', sample_name, ',  ', num2str(exps.(sample_name).photon.energy(spectrum_number)), ' eV'];
    hLine           = plot(UI_obj.plot.m2q.axes, M2Q_data.bins, M2Q_data.I, 'DisplayName', LineName_leg);
    hLine.Color     = plot.colormkr(nof_remembered_lines, 1);
    if ifdo_hold_axes_limits
        xlim(UI_obj.plot.m2q.axes, xlims);
        ylim(UI_obj.plot.m2q.axes, ylims);
    end
    xlabel(UI_obj.plot.m2q.axes, 'mass to charge [au]')
    ylabel(UI_obj.plot.m2q.axes, 'Intensity [arb. u]')
    title([LineName_title])
end

function keypress_callback(app, event)
    value = UI_obj.plot.m2q.spectr_slider.Value; % get the slider value
	key = event.Key; % get the pressed key value
    if strcmp(key,'leftarrow') || strcmp(key,'rightarrow') 
        % The user wants the plot to move one mass spectrum up or down
        % Find the current value:
        Value_cur = UI_obj.plot.m2q.spectr_slider.Value;
        % Find the higher one in the spectra list, if it exists:
        cur_idx = find(Value_cur == UI_obj.plot.m2q.spectr_slider.MajorTicks);
        switch key
            case 'leftarrow' %one spectrum down
                Value_new = UI_obj.plot.m2q.spectr_slider.MajorTicks(max(cur_idx-1, 1));
            case 'rightarrow' % one spectrum up
                Value_new = UI_obj.plot.m2q.spectr_slider.MajorTicks(min(cur_idx+1, length(UI_obj.plot.m2q.spectr_slider.MajorTicks)));
        end
        UI_obj.plot.m2q.spectr_slider.Value = Value_new; % Set value in slider.
        change_spectrum();
    elseif strcmp(key, 'uparrow') || strcmp(key, 'downarrow')
        cur_sample_idx = find(strcmp(sample_name, sample_names));
        switch key
            case 'uparrow' % one scan up
                sample_name = sample_names{max(cur_sample_idx-1, 1)};
            case 'downarrow'
                sample_name = sample_names{min(cur_sample_idx+1, length(sample_names))};
        end
        % Change the spectrum (call the regular callback):
        change_scan(sample_name)
        % Also update the dropdown menu:
        UI_obj.plot.m2q.holdchbx.Value = sample_name;
    elseif strcmp(key,'t')
        msgbox('IT''S A TRAP!')
    end
end

end

function [spectrum_numbers, spectrum_names] = get_spectrum_numbers( exp_sample )
    spectrum_names = fieldnames(exp_sample.hist);
    spectrum_numbers = regexp(spectrum_names, '\d*','match');
    spectrum_numbers = cellfun(@str2num, cat(2, spectrum_numbers{:}));
end

function [photon_energy] = get_photon_energy(exps, sample_name, spectrum_number)
    sample_names    = fieldnames(exps);
    spectrum_names   = fieldnames(exps.(sample_name).hist);
    exps.(sample_name).hist.(spectrum_names{spectrum_number}).M2Q
end
