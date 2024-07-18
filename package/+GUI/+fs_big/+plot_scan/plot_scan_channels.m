function [UI_obj, plotnames] = plot_scan_channels(exp_data, GUI_settings, UI_obj, i)
plotnames               = {};
scannames               = fieldnames(exp_data.scans);
% Read through all channel groups and plot a line for each scan, if
    % they are indicated to be visible:
    if general.struct.issubfield(GUI_settings, 'channels.list')
        channelgroupnames = fieldnames(GUI_settings.channels.list);
        % Plot the existing channels:
        for chgroupname_cur_cell = channelgroupnames'
                chgroupname_cur = chgroupname_cur_cell{:};
            if GUI_settings.channels.list.(chgroupname_cur).Visible
                % Get the current mass limits:
                mass_limits_cur = [GUI_settings.channels.list.(chgroupname_cur).minMtoQ GUI_settings.channels.list.(chgroupname_cur).maxMtoQ];
                Yscale          = GUI_settings.channels.list.(chgroupname_cur).Yscale; % Scale in Y direction
                dY              = GUI_settings.channels.list.(chgroupname_cur).dY; % Vertical offset
                for scanname_cur_cell = scannames'
                    scanname_cur    = scanname_cur_cell{:};
                    if GUI_settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).Visible % If the user wants to see this plot:
                        [hLine, plotname] = GUI.fs_big.plot_scan.plot_scan_channel(UI_obj.def_channel.scan.axes, ...
                            exp_data, GUI_settings, scanname_cur, chgroupname_cur, mass_limits_cur, Yscale, dY);
                        UI_obj.def_channel.lines.channels.list.(chgroupname_cur).scanlist.(scanname_cur) = hLine;
                        plotnames{i}    = plotname;
                        i               = i + 1;
                    end
                end
            end
        end
    end