function View_flux(hObj, event, GUI_settings, sourcetype)

[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

if ~isempty(UI_obj.normalize.dropdown_dataselection.Value) % In case a file is selected at all: 
    % In case a spectrum is selected, we show the flux number:
    if UI_obj.normalize.radioswitch_spectrum.Value
        intname = GUI.fs_big.get_intname_from_username(exp_data.spectra, UI_obj.normalize.dropdown_dataselection.Value);
        photon_energy   = exp_data.spectra.(intname).Data.photon.energy;
        switch sourcetype
            case 'flux'
                photon_flux     = exp_data.spectra.(intname).Data.photon.flux;
                msgbox({['Photon flux: ', num2str(photon_flux)]; ['Photon energy: ', num2str(photon_energy)]})
            case 'PD'
                PD_current     = exp_data.spectra.(intname).Data.photon.Photodiode_current;
                msgbox({['Photodiode current: ', num2str(PD_current)]; ['Photon energy: ', num2str(photon_energy)]})
        end
    elseif UI_obj.normalize.radioswitch_scan.Value
        % In case a scan is selected, plot the flux:
        intname = GUI.fs_big.get_intname_from_username(exp_data.scans, UI_obj.normalize.dropdown_dataselection.Value);
        switch sourcetype
            case 'flux'
                h_flux                      = figure;
                UI_obj.normalize.flux_axes  = axes(h_flux);
                UI_obj.normalize.flux_line  = plot(UI_obj.normalize.flux_axes, exp_data.scans.(intname).Data.photon.energy, exp_data.scans.(intname).Data.photon.flux);
                xlabel('Photon energy [eV]')
                ylabel('Photon flux [photons/sec]')
            case 'PD'
                h_PD                        = figure;
                UI_obj.normalize.PD_axes    = axes(h_PD);
                UI_obj.normalize.PD_line    = plot(UI_obj.normalize.PD_axes, exp_data.scans.(intname).Data.photon.energy, exp_data.scans.(intname).Data.photon.Photodiode_current);
                xlabel('Photon energy [eV]')
                ylabel('Photodiode current [microAmpere]')
                
    end
end

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end