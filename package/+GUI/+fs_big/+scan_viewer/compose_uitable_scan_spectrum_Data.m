    function [uitable_data, UI_obj] = compose_uitable_scan_spectrum_Data(uitable_type, UI_obj, exp_data)

        % Fill the current data into a matrix ready to be fed to the table.
        switch uitable_type
            case 'scans' % The user wants the scan table to be updated:
                % Data_column_fieldnames : {'Scan name', '#', 'Emin', 'Emax', 'Color'};
                % The amount of scans defined:
                scan_names          = fieldnames(exp_data.scans);
                nof_scans           = numel(scan_names);
                uitable_data = cell(nof_scans, 5); % Initialize empty cell
                for i = 1:nof_scans
                    current_scan_name = scan_names{i};
                    uitable_data{i,1} = exp_data.scans.(current_scan_name).Name;
                    uitable_data{i,2} = length(exp_data.scans.(current_scan_name).Data.photon.energy);
                    uitable_data{i,3} = min(exp_data.scans.(current_scan_name).Data.photon.energy);
                    uitable_data{i,4} = max(exp_data.scans.(current_scan_name).Data.photon.energy);
                    uitable_data{i,5} = regexprep(num2str(round(exp_data.scans.(current_scan_name).Color,1)),'\s+',',');
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', exp_data.scans.(current_scan_name).Color);
                    addStyle(UI_obj.main.scans.uitable, s, 'cell', [i,5]);
                end
            case 'spectra'
                % Data_column_fieldnames : {'Spectrum name', 'Color'};
                spectra_intnames    = fieldnames(exp_data.spectra);
                nof_spectra         = numel(spectra_intnames);
                uitable_data        = cell(nof_spectra, 2); % Initialize empty cell
                for i = 1:nof_spectra
                    current_spectrum_name = spectra_intnames{i};
                    uitable_data{i,1} = exp_data.spectra.(current_spectrum_name).Name;
                    uitable_data{i,2} = regexprep(num2str(round(exp_data.spectra.(current_spectrum_name).Color,1)),'\s+',',');
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', exp_data.spectra.(current_spectrum_name).Color);
                    addStyle(UI_obj.main.spectra.uitable, s, 'cell', [i,2]);
                end
        end
    end