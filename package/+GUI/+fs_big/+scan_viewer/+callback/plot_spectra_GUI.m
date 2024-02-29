function plot_spectra_GUI(~, ~, GUI_settings)

[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    % This function feeds the selected to the m2q plot function
    if isempty(fieldnames(exp_data.scans)) && isempty(fieldnames(exp_data.spectra))
        UI_obj.main.plot_m2q.empty_data_plot_msgbox = msgbox('Cannot plot mass spectra, since neither scans nor spectra are loaded yet. Nice try.');
    else
        % If there is some data to plot, start the mass spectrum:
        GUI.fs_big.plot_mass_spectrum.start_plot_mass_spectrum(exp_data, GUI_settings, UI_obj);
    end

end