function subtract_callback(~, ~, GUI_settings)
% Start the subtraction GUI window

[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    % This function feeds the selected to the m2q plot function
    if isempty(fieldnames(exp_data.scans)) && isempty(fieldnames(exp_data.spectra))
        UI_obj.main.plot_m2q.empty_data_plot_msgbox = msgbox('Cannot normalize data, since no data is loaded yet. Nice try.');
    else
        % If there is some data to plot, start the mass spectrum:
        GUI.fs_big.subtract_scan.start_subtract(GUI_settings);
    end


end