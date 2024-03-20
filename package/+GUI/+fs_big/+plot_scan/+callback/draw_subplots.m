function draw_subplots(~,~, GUI_settings)
% Fetch the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    channel_intnames        = fieldnames(GUI_settings.channels.list)';
    num_visible_channels    = 0;
    visible_channel_names   = cell([]);
    % Find how many channels are visible:
    for channel_visible_cur_cell   = channel_intnames
        channel_visible_cur        = channel_visible_cur_cell{:};
        % Check which scan is visible for this channel:
        if GUI_settings.channels.list.(channel_visible_cur).Visible
            num_visible_channels = num_visible_channels + 1;
            visible_channel_names{end+1} = channel_visible_cur;
        end
    end

    % Start a subplot, depending on the amount of channels:
    num_channels    = numel(visible_channel_names);
    num_row         = min(4, num_channels);
    num_col         = ceil(num_channels/num_row);
UI_obj.plot_scan.subplot.fig = figure();
i = 0;
% Plot the channel:
for channel_visible_cur_cell     = visible_channel_names
    channel_visible_cur            = channel_visible_cur_cell{:};
    % Check which scan is visible for this channel:
       i = i + 1;
       % Plot it in the right subplot: 
       haxes = subplot(num_row, num_col, i);
       scannames = fieldnames(GUI_settings.channels.list.(channel_visible_cur).scanlist);
       legendtext = {};
       for j = 1:numel(scannames)
           scanname_cur  = scannames{j};
           % Plot it in the right style:
            if GUI_settings.channels.list.(channel_visible_cur).scanlist.(scanname_cur).Visible
                  Yscale         = GUI_settings.channels.list.(channel_visible_cur).Yscale; % Scale in Y direction
                  dY             = GUI_settings.channels.list.(channel_visible_cur).dY; % Vertical offset
                  mass_limits_cur= [GUI_settings.channels.list.(channel_visible_cur).minMtoQ GUI_settings.channels.list.(channel_visible_cur).maxMtoQ];
                  Marker_cur    = GUI_settings.channels.list.(channel_visible_cur).scanlist.(scanname_cur).Marker;
                  LineStyle_cur = GUI_settings.channels.list.(channel_visible_cur).scanlist.(scanname_cur).LineStyle;
                  Color_cur     = GUI_settings.channels.list.(channel_visible_cur).scanlist.(scanname_cur).Color;
                  % hLine         = plot_scan_sub(haxes, M2Q_data, bins, mass_limits_cur, photon_energy, Yscale, dY, plotname, LineColor, Marker, LineStyle);
                  [hLine, plotname] =  GUI.fs_big.plot_scan.plot_scan_channel(haxes, exp_data, GUI_settings, scanname_cur, channel_visible_cur, mass_limits_cur, Yscale, dY);
                  UI_obj.plot_scan.subplot.axes.(scanname_cur) = hLine;
                  haxes.XLabel.String   = 'Photon energy [eV]';
                  haxes.YLabel.String   = 'Intensity [arb. u.]';
                  legendtext{end+1}         = plotname;
            end
       end
       legend(haxes, legendtext)
end

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
end