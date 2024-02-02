function [defaults, settings, UI_obj] = define_channels(defaults, settings, UI_obj, exp_data, scan_name_cur)
% TODO: make valid for multiple samples at once.
defaults.def_channel.scan.if_hold_XY = false; % Do not hold XY from start
UI_obj.def_channel.scan.if_hold_XY  = defaults.def_channel.scan.if_hold_XY;

% If no fragments are defined yet, we initiate an empty array:
if ~isfield(settings, 'channels')
    settings.channels.Name       = {};
    settings.channels.minMtoQ    = {};
    settings.channels.maxMtoQ    = {};
    settings.channels.Visible    = {};
end

% Set up the control window:
UI_obj.def_channel.main         = uifigure('Name', 'Define and plot channels','NumberTitle','off','position',[300 300 550 300]);

% Set up the m2q plot window:
UI_obj.def_channel.data_plot  = figure('Name', 'Channel scan, M/Q', ...
    'NumberTitle','off', 'position', [20 20 800 600]);
set(UI_obj.def_channel.data_plot, 'CloseRequestFcn', @close_both_scan_windows) % Make sure that both windows close when one is closed by user.
set(UI_obj.def_channel.main, 'CloseRequestFcn', @close_both_scan_windows) 

% Plot the first mass spectrum:
UI_obj.def_channel.m2q.axes     = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10);
setpixelposition(UI_obj.def_channel.m2q.axes, [75, 350, 700, 200])
% Calculate the spectrum matrix, to speed up plot updates:

[exp_data] = IO.SPECTROLATIUS_S2S.exp_struct_to_matrix(exp_data);
% Calculate the average m2q spectrum:
[UI_obj.def_channel.m2q_lines, avg_M2Q] = update_plot(exp_data);

hold(UI_obj.def_channel.m2q.axes, 'on')

% Plot the rectangle with the rangeslider values:
UI_obj.def_channel.m2q.rectangle = rectangle(UI_obj.def_channel.m2q.axes, 'FaceColor', [1 0.1 0.1 0.3], ...
    'Position', [UI_obj.def_channel.m2q.axes.XLim(1), UI_obj.def_channel.m2q.axes.YLim(1), diff(UI_obj.def_channel.m2q.axes.XLim), diff(UI_obj.def_channel.m2q.axes.YLim)]);

% Set up the callbacks of the axes:
set(zoom(UI_obj.def_channel.m2q.axes),'ActionPostCallback',@(x,y) update_slider_limits(UI_obj.def_channel.m2q.axes));
set(pan(UI_obj.def_channel.data_plot),'ActionPostCallback',@(x,y) update_slider_limits(UI_obj.def_channel.m2q.axes));

% Set the (improvised) Java range slider:
UI_obj.def_channel.m2q.jRangeSlider = GUI.fs_big.rangeslider(UI_obj.def_channel.data_plot, 0, 100, 0, 100, 'channel limits', [75, 570, 700, 15], 0.1, 0.1, @update_channel_limits);

%Plot the live scan axes in the same figure:
UI_obj.def_channel.scan.axes            = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10);
setpixelposition(UI_obj.def_channel.scan.axes, [75, 100, 700, 200])

mass_limits                             = UI_obj.def_channel.m2q.axes.XLim;
UI_obj.def_channel.m2q.hLine            = update_scan_plot(exp_data, mass_limits, UI_obj, false);

% User defines the channels of a certain scan
defaults.def_channel.tooltips.Add_single_channel      = 'Manually add a channel by clicking the channel limits in the axes of the mass spectrum';
defaults.def_channel.tooltips.Import_scan             = 'Import fragments from another scan in the workspace';
defaults.def_channel.tooltips.Remove_channel          = 'Remove the selected channels';
defaults.def_channel.tooltips.Add_prospector_channels = 'Load channels from Prospector html file.';
defaults.def_channel.tooltips.Import_quickview        = 'Import the fragments from quickviewer';
defaults.def_channel.tooltips.OK                      = 'Save channels and close window';
defaults.def_channel.tooltips.holdchbx                = 'Do not change the X, Y axes limits when changing mass spectrum';

% Initiate the experiment struct:
uitable_create()

% Initialize the interaction buttons (load, delete, view spectra):
UI_obj.def_channel.Add_single_channel       = uibutton(UI_obj.def_channel.main , "Text", "Add channel", "Position",     [10, 250, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually);
UI_obj.def_channel.Add_prospector_channels  = uibutton(UI_obj.def_channel.main , "Text", "Add Prospector", "Position",  [10, 220, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Add_prospector_channels, "ButtonPushedFcn", @load_prospector);
UI_obj.def_channel.Import_quickviewer       = uibutton(UI_obj.def_channel.main , "Text", "Import Quickview", "Position", [10, 190, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Import_quickview, "ButtonPushedFcn", @import_quickviewer);
UI_obj.def_channel.Import_scan              = uibutton(UI_obj.def_channel.main , "Text", "Import from scan", "Position",[10, 160, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Import_scan, "ButtonPushedFcn", @Import_scan);
UI_obj.def_channel.Remove_channel           = uibutton(UI_obj.def_channel.main , "Text", "Remove channel", "Position",  [10, 130, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Remove_channel, "ButtonPushedFcn", @Remove_channel);
UI_obj.def_channel.holdchbx                 = uicheckbox(UI_obj.def_channel.main  , "Text", 'hold XY lim', 'Position', [10, 100, 100, 20], 'Tooltip', defaults.def_channel.tooltips.holdchbx, 'Value', 0, 'ValueChangedFcn', @hold_limits);
UI_obj.def_channel.OK                       = uibutton(UI_obj.def_channel.main , "Text", "OK", "Position",  [10, 10, 100, 20], 'Tooltip', defaults.def_channel.tooltips.OK, "ButtonPushedFcn", @OK_close);

% TODO: when one of the two window is closed, the other one closes as well:

    function Remove_channel(hObj, event)
        % Remove the selected channels from the list.
        if ~isempty(settings.channels.Name) && ~isempty(UI_obj.def_channel.uitable.Selection(:,1))
            rownrs              = unique(UI_obj.def_channel.uitable.Selection(:,1));
            % Remove from the fragment list:
            settings.channels.Name(rownrs)      = [];
            settings.channels.minMtoQ(rownrs)   = [];
            settings.channels.maxMtoQ(rownrs)   = [];
            settings.channels.Visible(rownrs)   = [];
            % Update the uitable:
            uitable_add_fragment();
        else
            msgbox('No fragments to remove. Please select the fragment(s) you want to remove in the table.')
        end
    end

function add_channel_manually(~,~)
    % User wants to manually pick a fragment from the plot window.
    UI_obj.def_channel.Add_single_channel.Visible = 'off';
    UI_obj.def_channel.Done     = uibutton(UI_obj.def_channel.main , "Text", "Done", "Position", ...
        [10, 250, 50, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_done);
    UI_obj.def_channel.Reset     = uibutton(UI_obj.def_channel.main , "Text", "Reset", "Position", ...
        [65, 250, 45, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_reset);
end

function add_channel_manually_done(~,~)
    % Place the current rectangle limits into the list of channels:
    minMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(1);
    maxMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(3) +  UI_obj.def_channel.m2q.rectangle.Position(1);
    Name_cur = num2str(mean([minMtoQ_cur, maxMtoQ_cur]));
    % Add the channel to those defined in the settings:
    settings.channels.Name{end+1}        = Name_cur;
    settings.channels.minMtoQ{end+1}     = minMtoQ_cur;
    settings.channels.maxMtoQ{end+1}     = maxMtoQ_cur;
    settings.channels.Visible{end+1}     = true;
    % Make the 'Done' and 'Reset' button invisble, and show the 'Add single
    % channel' button again:
    UI_obj.def_channel.Done.Visible = 'off';
    UI_obj.def_channel.Reset.Visible = 'off';
    UI_obj.def_channel.Add_single_channel.Visible = 'on';
    % Show the updated table:
    uitable_add_fragment()
    % Make the scan plot keep the current channel plot:
    update_scan_plot(exp_data, mass_limits, UI_obj, true);
end

function add_channel_manually_reset(~,~)
    % Set the range back to full:
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    YLim    = UI_obj.def_channel.m2q.axes.YLim;
    UI_obj.def_channel.m2q.rectangle.Position(1) = XLim(1);
    UI_obj.def_channel.m2q.rectangle.Position(3) = diff(XLim);
    UI_obj.def_channel.m2q.rectangle.Position(2) = YLim(1);
    UI_obj.def_channel.m2q.rectangle.Position(4) = diff(YLim);
    UI_obj.def_channel.m2q.jRangeSlider.HighValue   = UI_obj.def_channel.m2q.jRangeSlider.Maximum;
    UI_obj.def_channel.m2q.jRangeSlider.LowValue    = UI_obj.def_channel.m2q.jRangeSlider.Minimum;
    resetplotview(UI_obj.def_channel.m2q.axes)
end

function OK_close(~,~)
    UI_obj.def_channel.main.Visible                 = 'off';
    UI_obj.def_channel.data_plot.Visible          = 'off';
    % TODO: how to parse the fragments to main.
end

function uitable_create()
    % Create the table that lists the channels.
    UI_obj.def_channel.fragment_list.Properties.VariableNames = {'Name', 'min M/Q', 'max M/Q', 'Show'};
    UI_obj.def_channel.uitable                  = uitable(UI_obj.def_channel.main , "ColumnName", UI_obj.def_channel.fragment_list.Properties.VariableNames, "Position",[120 25 350 250]);
    UI_obj.def_channel.uitable.Data             = [settings.channels.Name, settings.channels.minMtoQ, settings.channels.maxMtoQ, settings.channels.Visible];
    UI_obj.def_channel.uitable.ColumnEditable   = [true true true true];
    UI_obj.def_channel.uitable.ColumnFormat     = {'char', 'numeric', 'numeric', 'logical'};
    UI_obj.def_channel.uitable.CellEditCallback = @uitable_user_edit;
end

    function uitable_user_edit(app, event)
        % This function will be called when the uitable of channels is
        % changed, and needs to be updated in the settings accordingly:
        ifdo_update_plot = false; % by default, no extra plot needed.
        % Find which value has been changed:
        switch event.Indices(1)
            case 1 % The Name has been changed               
                settings.channels.Name{event.Indices(2)} = event.NewData;
            case 2 % The minimum mass-to-charge has been changed:
                settings.channels.minMtoQ{event.Indices(2)} = event.NewData;
                ifdo_update_plot = true;
            case 3 % The minimum mass-to-charge has been changed:
                settings.channels.maxMtoQ{event.Indices(2)} = event.NewData;
                ifdo_update_plot = true;
            case 4 % The Visibility of a channel has been changed:
                settings.channels.Visible{event.Indices(2)} = event.NewData;
                ifdo_update_plot = true;
            case 5 % The scaling of a channel has been changed:
                %TODO
                ifdo_update_plot = true;
                why
            case 6 % The dY value of a channel has been changed:
                ifdo_update_plot = true;
                why
        end
        if ifdo_update_plot
            why
            % TODO
            % [hLine] = update_scan_plot(exp_data, mass_limits, UI_obj, ifdo_remember_line);
        end
    end

function uitable_add_fragment()
    UI_obj.def_channel.uitable.Data = [settings.channels.Name', settings.channels.minMtoQ', settings.channels.maxMtoQ', settings.channels.Visible'];
end

function[hLine, avg_M2Q] = update_plot(exp_data)
    % Plot the mass-to-charge spectra for all scans:
    avg_M2Q.XLim = [0,0];
    hold(UI_obj.def_channel.m2q.axes,"on");
    for scan_name_cell = fieldnames(exp_data.scans)'
        scan_name_cur     = scan_name_cell{:};
        avg_M2Q.(scan_name_cur).I       = mean(exp_data.scans.(scan_name_cur).matrix.M2Q.I, 2);
        avg_M2Q.(scan_name_cur).bins    = exp_data.scans.(scan_name_cur).matrix.M2Q.bins;
        % 
        hold(UI_obj.def_channel.m2q.axes, 'on')
        grid(UI_obj.def_channel.m2q.axes, 'on')
        LineName_leg          = [scan_name_cur, ', averaged'];
        hLine.(scan_name_cur)   = plot(UI_obj.def_channel.m2q.axes, avg_M2Q.(scan_name_cur).bins, avg_M2Q.(scan_name_cur).I, 'DisplayName',scan_name_cur);
        hLine.(scan_name_cur).Color = exp_data.scans.(scan_name_cur).Color;
        avg_M2Q.XLim(1)         = min(min(avg_M2Q.(scan_name_cur).bins), avg_M2Q.XLim(1));
        avg_M2Q.XLim(2)         = max(max(avg_M2Q.(scan_name_cur).bins), avg_M2Q.XLim(2));
    end
    xlabel(UI_obj.def_channel.m2q.axes, 'mass to charge [au]')
    ylabel(UI_obj.def_channel.m2q.axes, 'Intensity [arb. u]')
    legend(UI_obj.def_channel.m2q.axes)
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
    
    UI_obj.def_channel.m2q.hLine = update_scan_plot(exp_data, mass_limits, UI_obj, false);
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

    UI_obj.def_channel.m2q.hLine = update_scan_plot(exp_data.scans, mass_limits, UI_obj, false);
end

    function [hLine] = update_scan_plot(exps, mass_limits, UI_obj, ifdo_remember_line)
        for sample_name_cell = fieldnames(exps.scans)'
            sample_name_cur = sample_name_cell{:};
            % Fetch the intensity data of the current sample:
            M2Q_data        = exps.scans.(sample_name_cur).matrix.M2Q.I;
            % Remember the X,Y limits if the user wants it to be fixed:
            if UI_obj.def_channel.scan.if_hold_XY
                xlims = get(UI_obj.def_channel.scan.axes, 'XLim'); 
                ylims = get(UI_obj.def_channel.scan.axes, 'YLim');
            end
            if ifdo_remember_line
                % Remember the current line, re-color it and give it a name:
                nof_remembered_lines = length(settings.channels.Name);
                hLine.(sample_name_cur).Color = plot.colormkr(nof_remembered_lines);
            else % remove all lines of previous rectangle location:
                try delete(UI_obj.def_channel.m2q.hLine.(sample_name_cur))
                end
            end
            hold(UI_obj.def_channel.scan.axes, 'on')
            grid(UI_obj.def_channel.scan.axes, 'on')
            
            % Fetch the limit indices from the mass limits given through 
            % nearest neighbor interpolation:
            min_idx         = 2*find(min(exps.scans.(sample_name_cur).matrix.M2Q.bins)==exps.scans.(sample_name_cur).matrix.M2Q.bins, 1, 'last');
            bins            = double(exps.scans.(sample_name_cur).matrix.M2Q.bins);
            % Get the unique masses and corresponding indices:
            [bins_u, idx_u] = unique(bins);
            % Make sure the mass limits (min) are not outside range:
            mass_limits(1)  = max(min(bins), mass_limits(1));
            % Make sure the mass limits (max) are not outside range:
            mass_limits(2)  = min(max(bins), mass_limits(2));
            
            mass_indices = interp1(bins_u, idx_u, mass_limits, 'nearest', 'extrap');
            
            hLine.(sample_name_cur)         = plot(UI_obj.def_channel.scan.axes, exps.scans.(sample_name_cur).photon.energy, sum(exps.scans.(sample_name_cur).matrix.M2Q.I(mass_indices(1):mass_indices(2),:),1), 'b', 'DisplayName',sample_name_cur);
            hLine.(sample_name_cur).Color   = exp_data.scans.(sample_name_cur).Color;
        
            if UI_obj.def_channel.scan.if_hold_XY
                xlim(UI_obj.def_channel.scan.axes, xlims);
                ylim(UI_obj.def_channel.scan.axes, ylims);
            end
            xlabel(UI_obj.def_channel.scan.axes, 'Photon energy [eV]')
            ylabel(UI_obj.def_channel.scan.axes, 'Intensity [arb. u]')
        end
        legend(UI_obj.def_channel.scan.axes)
    end

    function hold_limits(objHandle, ~)
        % User wants to change the state of the hold XY window:
        UI_obj.def_channel.scan.if_hold_XY  = objHandle.Value;
    end

    function close_both_scan_windows(~,~)
        delete(UI_obj.def_channel.main)
        delete(UI_obj.def_channel.data_plot)
    end

end