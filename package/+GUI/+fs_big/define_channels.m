function [defaults, settings, UI_obj] = define_channels(defaults, settings, UI_obj, exp_data)
% TODO: make valid for multiple samples at once.

% If no fragments are defined yet, we initiate an empty array:
if ~isfield(settings.metadata, 'channels')
    settings.metadata.channels.Name       = {};
    settings.metadata.channels.minMtoQ    = [];
    settings.metadata.channels.maxMtoQ    = [];
end


%% Mass spectrum/fragment selection/scan plot

% TODO: Plot all selected samples. For now, we just take the first one:
sample_names    = fieldnames(exp_data);
sample_name     = sample_names{1};

% Set up the m2q plot window:
UI_obj.def_channel.data_plot  = figure('Name', 'Channel scan, M/Q', ...
    'NumberTitle','off', 'position', [20 20 800 600]);

% Plot the first mass spectrum:
UI_obj.def_channel.m2q.axes     = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10);
setpixelposition(UI_obj.def_channel.m2q.axes, [75, 350, 700, 200])
% Calculate the spectrum matrix, to speed up plot updates:
[exp_data.(sample_name).matrix.M2Q.I, exp_data.(sample_name).matrix.M2Q.bins] = IO.SPECTROLATIUS_S2S.exp_struct_to_matrix(exp_data.(sample_name));
% Calculate the average m2q spectrum:
avg_M2Q.I       = mean(exp_data.(sample_name).matrix.M2Q.I, 2);
avg_M2Q.bins    = exp_data.(sample_name).matrix.M2Q.bins;
UI_obj.def_channel.hLine        = update_plot(sample_name, avg_M2Q);
hold(UI_obj.def_channel.m2q.axes, 'on')

% Plot the rectangle with the rangeslider values:
UI_obj.def_channel.m2q.rectangle = rectangle(UI_obj.def_channel.m2q.axes, 'FaceColor','none', ...
    'Position', [UI_obj.def_channel.m2q.axes.XLim(1), UI_obj.def_channel.m2q.axes.YLim(1), UI_obj.def_channel.m2q.axes.XLim(2), UI_obj.def_channel.m2q.axes.YLim(2)]);

% Set up the callbacks of the axes:
set(zoom(UI_obj.def_channel.m2q.axes),'ActionPostCallback',@(x,y) update_slider_limits(UI_obj.def_channel.m2q.axes));
set(pan(UI_obj.def_channel.data_plot),'ActionPostCallback',@(x,y) update_slider_limits(UI_obj.def_channel.m2q.axes));

% Set the (improvised) Java range slider:
UI_obj.def_channel.m2q.jRangeSlider = GUI.fs_big.rangeslider(UI_obj.def_channel.data_plot, 0, 100, 0, 100, 'channel limits', [75, 570, 700, 15], 0.1, 0.1, @update_channel_limits);

%Plot the live scan axes in the same figure:
UI_obj.def_channel.scan.axes            = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10);
setpixelposition(UI_obj.def_channel.scan.axes, [75, 100, 700, 200])
mass_limits                             = [min(avg_M2Q.bins), max(avg_M2Q.bins)];
UI_obj.def_channel.m2q.hLine            = update_scan_plot(exp_data, sample_name, mass_limits);

% Let the user decide which sample to show:

%% Control window
% Set up the control window:
UI_obj.def_channel.main         = uifigure('Name', ['Define channels for scan ' sample_name],'NumberTitle','off','position',[100 100 400 500]);

% User defines the channels of a certain scan
defaults.def_channel.tooltips.Add_single_channel      = 'Manually add a channel by clicking the channel limits in the axes of the mass spectrum';
defaults.def_channel.tooltips.Import_scan             = 'Import fragments from another scan in the workspace';
defaults.def_channel.tooltips.Remove_channel          = 'Remove the selected channels';
defaults.def_channel.tooltips.Add_prospector_channels = 'Load channels from Prospector html file.';
defaults.def_channel.tooltips.Import_quickview        = 'Import the fragments from quickviewer';
defaults.def_channel.tooltips.OK                      = 'Save channels and close window';

% Initiate the experiment struct:
update_filelist_uitable()

% Initialize the interaction buttons (load, delete, view spectra):
UI_obj.def_channel.Add_single_channel       = uibutton(UI_obj.def_channel.main , "Text", "Add channel", "Position",     [10, 450, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually);
UI_obj.def_channel.Reset     = uibutton(UI_obj.def_channel.main , "Text", "Reset", "Position", ...
        [65, 450, 45, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_reset, 'Visible', 'Off');
UI_obj.def_channel.Done     = uibutton(UI_obj.def_channel.main , "Text", "Done", "Position", ...
        [10, 450, 50, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_done, 'Visible', 'Off');    
UI_obj.def_channel.Add_prospector_channels  = uibutton(UI_obj.def_channel.main , "Text", "Add Prospector", "Position",  [10, 420, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Add_prospector_channels, "ButtonPushedFcn", @load_scan_GUI);
UI_obj.def_channel.Import_quickviewer       = uibutton(UI_obj.def_channel.main , "Text", "Import Quickview", "Position", [10, 390, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Import_quickview, "ButtonPushedFcn", @load_scan_GUI);
UI_obj.def_channel.Import_scan              = uibutton(UI_obj.def_channel.main , "Text", "Import from scan", "Position",[10, 360, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Import_scan, "ButtonPushedFcn", @load_scan_GUI);
UI_obj.def_channel.Remove_channel           = uibutton(UI_obj.def_channel.main , "Text", "Remove channel", "Position",  [10, 330, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Remove_channel, "ButtonPushedFcn", @remove_fragment_GUI);
UI_obj.def_channel.OK                       = uibutton(UI_obj.def_channel.main , "Text", "OK", "Position",  [10, 10, 100, 20], 'Tooltip', defaults.def_channel.tooltips.OK, "ButtonPushedFcn", @OK_close);

% Make table that selects which sample to show:

UI_obj.def_channel.scan_uitable = uitable(UI_obj.def_channel.main, 'Units','normalized','Position',...
          [0.1 0.1 0.9 0.9], 'Data', [sample_names, true(size(sample_names))],... 
          'ColumnName', {'Scan name', 'Show'},...
          'ColumnFormat', {'char', 'logical'},...
          'ColumnEditable', [false true],...
          'RowName',[] ,'BackgroundColor',[.7 .9 .8],'ForegroundColor',[0 0 0]);
setpixelposition(UI_obj.def_channel.scan_uitable, [120 25 230 180]) 

%% Local functions:

function add_channel_manually(~,~)
    % User wants to manually pick a fragment from the plot window.
    UI_obj.def_channel.Add_single_channel.Visible   = 'off';
    UI_obj.def_channel.Reset.Visible                = 'on';
    UI_obj.def_channel.Done.Visible                 = 'on';
end

function add_channel_manually_done(~,~)
    % Place the current rectangle limits into the list of channels:
    minMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(1);
    maxMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(3) +  UI_obj.def_channel.m2q.rectangle.Position(1);
    Name_cur = num2str(mean([minMtoQ_cur, maxMtoQ_cur]));
    settings.metadata.channels.minMtoQ(end+1,1)   = minMtoQ_cur;
    settings.metadata.channels.maxMtoQ(end+1,1)   = maxMtoQ_cur;
    settings.metadata.channels.Name{end+1,1}      = Name_cur;
    UI_obj.def_channel.Add_single_channel.Visible = 'on';
    UI_obj.def_channel.Done.Visible = 'off';
    UI_obj.def_channel.Reset.Visible = 'off';
    update_filelist_uitable()
end

function add_channel_manually_reset(~,~)
    % Set the range back to full:
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    UI_obj.def_channel.m2q.rectangle.Position(1) = XLim(1);
    UI_obj.def_channel.m2q.rectangle.Position(3) = diff(XLim);
    UI_obj.def_channel.m2q.jRangeSlider.HighValue   = UI_obj.def_channel.m2q.jRangeSlider.Maximum;
    UI_obj.def_channel.m2q.jRangeSlider.LowValue    = UI_obj.def_channel.m2q.jRangeSlider.Minimum;
    resetplotview(UI_obj.def_channel.m2q.axes)
end

function OK_close(~,~)
    UI_obj.def_channel.main.Visible                 = 'off';
    UI_obj.def_channel.data_plot.Visible          = 'off';
    % TODO: how to parse the fragments to main.
end

function update_filelist_uitable()
    try 
        rmfield(UI_obj.def_channel.uitable) % Remove old table, if present.
    end
    % Update the names:
    settings.filelist.scan_name             = fieldnames(exp_data);
    settings.filelist.number_of_spectra     = zeros(size(settings.filelist.scan_name));
    settings.filelist.photon_energy_min     = zeros(size(settings.filelist.scan_name));
    settings.filelist.photon_energy_max     = zeros(size(settings.filelist.scan_name));
    for name_nr = 1:length(settings.filelist.scan_name)
        name_cur = settings.filelist.scan_name{name_nr};
        % Fetch the number of spectra for each sample:
        try settings.filelist.number_of_spectra(name_nr)           = length(fieldnames(exp_data.(name_cur).hist));
        catch
            settings.filelist.number_of_spectra(name_nr) = 0;
        end
         % And the minimum and maximum photon energies:
         settings.filelist.photon_energy_min(name_nr)     = min(exp_data.(name_cur).photon.energy);
         settings.filelist.photon_energy_max(name_nr)     = max(exp_data.(name_cur).photon.energy);
    end
    UI_obj.def_channel.fragment_list          = table(settings.metadata.channels.Name, settings.metadata.channels.minMtoQ, settings.metadata.channels.maxMtoQ);
    UI_obj.def_channel.fragment_list.Properties.VariableNames = {'Name', 'min M/Q', 'max M/Q'};
    UI_obj.def_channel.uitable             = uitable(UI_obj.def_channel.main , "Data", UI_obj.def_channel.fragment_list, "Position",[120 225 230 250]);
    UI_obj.def_channel.uitable.ColumnEditable = [true, true, true];
end

function[hLine] = update_plot(sample_name, M2Q_data_avg)
    
    hold(UI_obj.def_channel.m2q.axes, 'on')
    grid(UI_obj.def_channel.m2q.axes, 'on')
    LineName_title        = ['Sample: ', sample_name, ', averaged'];
    hLine               = plot(UI_obj.def_channel.m2q.axes, M2Q_data_avg.bins, M2Q_data_avg.I);

    xlabel(UI_obj.def_channel.m2q.axes, 'mass to charge [au]')
    ylabel(UI_obj.def_channel.m2q.axes, 'Intensity [arb. u]')
%     title([LineName_title])
end

%Update the channel limits when the figure is zoomed:
function k = update_channel_limits(jRangeSlider,event)
    UI_obj.def_channel.m2q.RangeSlider.LowValue     = jRangeSlider.LowValue;
    UI_obj.def_channel.m2q.RangeSlider.HighValue    = jRangeSlider.HighValue;
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    Pos_rect = UI_obj.def_channel.m2q.rectangle.Position;
    Lo      = min(jRangeSlider.LowValue, jRangeSlider.HighValue);
    Hi      = max(jRangeSlider.LowValue, jRangeSlider.HighValue);
    Max     = jRangeSlider.Maximum;
    Min     = jRangeSlider.Minimum;
    UI_obj.def_channel.m2q.rectangle.Position = [XLim(1) + (Lo-Min)/(Max-Min)*diff(XLim), ...
                                                Pos_rect(2), ...
                                                (Hi-Lo+0.001)/(Max-Min)*diff(XLim), ...
                                                Pos_rect(4)]; % Added 0.001 to prevent zero-sized rectangle dimensions
    % Update the live scan plotter:
    mass_limits = [Pos_rect(1), Pos_rect(1)+Pos_rect(3)];
    update_scan_plot(exp_data, sample_name, mass_limits);
end

function update_slider_limits(ax)
% The user has moved (zoomed, panned, resized) the m2q axes, so we need to
% update the limits accordingly:
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    Pos_rect = UI_obj.def_channel.m2q.rectangle.Position;
    Lo      = min(UI_obj.def_channel.m2q.jRangeSlider.LowValue, UI_obj.def_channel.m2q.jRangeSlider.HighValue);
    Hi      = max(UI_obj.def_channel.m2q.jRangeSlider.LowValue, UI_obj.def_channel.m2q.jRangeSlider.HighValue);
    Max     = UI_obj.def_channel.m2q.jRangeSlider.Maximum;
    Min     = UI_obj.def_channel.m2q.jRangeSlider.Minimum;
    UI_obj.def_channel.m2q.jRangeSlider.LowValue = 0;
    UI_obj.def_channel.m2q.jRangeSlider.HighValue = 100;
    new_slider_Lo = max(Min, (Pos_rect(1) - XLim(1))/diff(XLim) * (Max - Min));
    new_slider_Hi = min(Max, (Pos_rect(1) + Pos_rect(3) - XLim(1))/diff(XLim) * (Max - Min));
    UI_obj.def_channel.m2q.jRangeSlider.LowValue = new_slider_Lo;
    UI_obj.def_channel.m2q.jRangeSlider.HighValue = new_slider_Hi;
    % Update the live scan plotter:
    mass_limits = [Pos_rect(1), Pos_rect(1)+Pos_rect(3)];
    update_scan_plot(exp_data, sample_name, mass_limits);
end

function[hLine] = update_scan_plot(exps, sample_name, mass_limits)
    sample_names    = fieldnames(exps);
    %TODO: implement remember line here:
    ifdo_remember_line = false;
    ifdo_hold_axes_limits = false;
    M2Q_data        = exps.(sample_name).matrix.M2Q.I;
    if ifdo_hold_axes_limits
        xlims = get(UI_obj.def_channel.scan.axes, 'XLim'); 
        ylims = get(UI_obj.def_channel.scan.axes, 'YLim');
    end
    if ifdo_remember_line
        % Remember the current line, re-color it and give it a name:
        nof_remembered_lines = nof_remembered_lines + 1;
        hLine.Color = plot.colormkr(nof_remembered_lines);
    else
        try delete(UI_obj.def_channel.scan.axes.Children(1)); end
    end
    hold(UI_obj.def_channel.scan.axes, 'on')
    grid(UI_obj.def_channel.scan.axes, 'on')
    LineName_leg        = [sample_name];
    
    % Fetch the limit indices from the mass limits given through 
    % nearest neighbor interpolation:
    min_idx = 2*find(min(exps.(sample_name).matrix.M2Q.bins)==exps.(sample_name).matrix.M2Q.bins, 1, 'last');
    bins            = double(exps.(sample_name).matrix.M2Q.bins);
    % Get the unique masses and corresponding indices:
    [bins_u, idx_u] = unique(bins);
    % Make sure the mass limits are not outside range:
    mass_limits(1)  = max(min(bins), mass_limits(1));
    % Make sure the mass limits are not outside range:
    mass_limits(2)  = min(max(bins), mass_limits(2));
    
    mass_indices = interp1(bins_u, idx_u, mass_limits, 'nearest', 'extrap');
    
    hLine = plot(UI_obj.def_channel.scan.axes, exps.(sample_name).photon.energy, sum(exps.(sample_name).matrix.M2Q.I(mass_indices(1):mass_indices(2),:),1), 'b');

    if ifdo_hold_axes_limits
        xlim(UI_obj.def_channel.scan.axes, xlims);
        ylim(UI_obj.def_channel.scan.axes, ylims);
    end
    xlabel(UI_obj.def_channel.scan.axes, 'Photon energy [eV]')
    ylabel(UI_obj.def_channel.scan.axes, 'Intensity [arb. u]')
end

end