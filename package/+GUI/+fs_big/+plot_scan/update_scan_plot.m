function [GUI_settings, UI_obj] = update_scan_plot(exp_data, GUI_settings, UI_obj)
    % Update the plot in the energy spectrum. 

    % First check if the handle currently exists:
    if ishandle(UI_obj.def_channel.scan.axes)
        % Remember the X,Y limits if the user wants it to be fixed:
        if UI_obj.def_channel.scan.if_hold_XY
            xlims = get(UI_obj.def_channel.scan.axes, 'XLim'); 
            ylims = get(UI_obj.def_channel.scan.axes, 'YLim');
        else
            hold(UI_obj.def_channel.scan.axes, 'off')
        end
        % Remove the current lines if present:
        delete(UI_obj.def_channel.scan.axes.Children)
        % Plot the current (slider) selection if the user wishes:
        scannames = fieldnames(exp_data.scans);
        if ~isfield(GUI_settings.channels, 'list')
            nof_channels = 0;
        else 
            nof_channels = numel(fieldnames(GUI_settings.channels.list));
        end
        plotnames   = cell(times(nof_channels+1, length(fieldnames(exp_data.scans))));
        mass_limits = UI_obj.def_channel.m2q.axes.XLim;
        % Hack
        Pos_rect    = UI_obj.def_channel.m2q.rectangle.Position;
        % Define the current mass limits of the box:
        mass_limits = [Pos_rect(1), Pos_rect(1) + Pos_rect(3)];
        i           = 1;
        if GUI_settings.channels.show_box
            % Firstly, we plot the scan defined by the channel of the current rectangle:
            for scanname_cur_cell = scannames'
                scanname_cur    = scanname_cur_cell{:};
                color_cur       = exp_data.scans.(scanname_cur).Color;
                M2Q_data        = exp_data.scans.(scanname_cur).matrix.M2Q.I;
                bins            = double(exp_data.scans.(scanname_cur).matrix.M2Q.bins);
                photon_energy   = exp_data.scans.(scanname_cur).Data.photon.energy;
                plotname        = [general.char.replace_symbol_in_char(exp_data.scans.(scanname_cur).Name, '_', ' '), ' box'];
                plotnames{i}    = plotname;
                i               = i + 1;
                [hLine]         = GUI.fs_big.plot_scan.plot_scan_sub(UI_obj.def_channel.scan.axes, M2Q_data, bins, mass_limits, photon_energy, 1, 0, plotname, color_cur, 'none', '-');
                UI_obj.def_channel.lines.box    = hLine;
            end
        end
    
        % Then we plot the already defined channels:
        [UI_obj, plotnames] = GUI.fs_big.plot_scan.plot_scan_channels(exp_data, GUI_settings, UI_obj, i);
    
        % Set the original X,Y limits if user wants it to be fixed:
        if UI_obj.def_channel.scan.if_hold_XY
            xlim(UI_obj.def_channel.scan.axes, xlims);
            ylim(UI_obj.def_channel.scan.axes, ylims);
        else
            axis(UI_obj.def_channel.scan.axes, 'tight')
        end
    legend(UI_obj.def_channel.scan.axes);
    
    
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj)
    end
end