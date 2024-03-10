    function [uitable_data, UI_obj, exp_data] = compose_uitable_scan_spectrum_Data(uitable_type, UI_obj, exp_data)

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
                    uitable_data{i,1} = exp_data.scans.(current_scan_name).Name;                        % Name
                    uitable_data{i,2} = length(exp_data.scans.(current_scan_name).Data.photon.energy);  % Number of spectra
                    uitable_data{i,3} = min(exp_data.scans.(current_scan_name).Data.photon.energy);     % minimum photon energy
                    uitable_data{i,4} = max(exp_data.scans.(current_scan_name).Data.photon.energy);     % Maximum photon energy 
                    uitable_data{i,5} = regexprep(num2str(round(exp_data.scans.(current_scan_name).Color,1)),'\s+',','); % Color
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', exp_data.scans.(current_scan_name).Color);
                    addStyle(UI_obj.main.scans.uitable, s, 'cell', [i,5]);
                end
            case 'spectra'
                % Data_column_fieldnames : {'Spectrum name', 'Color', 'dY', 'Scale'};
                spectra_intnames    = fieldnames(exp_data.spectra);
                nof_spectra         = numel(spectra_intnames);
                uitable_data        = cell(nof_spectra, 2); % Initialize empty cell
                for i = 1:nof_spectra
                    current_spectrum_name = spectra_intnames{i};
                    uitable_data{i,1} = exp_data.spectra.(current_spectrum_name).Name;                 % Name
                    uitable_data{i,2} = regexprep(num2str(round(exp_data.spectra.(current_spectrum_name).Color,1)),'\s+',','); % Color
                    uitable_data{i,3} = exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.dY; % Color
                    uitable_data{i,4} = exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.Scale; % Color
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', exp_data.spectra.(current_spectrum_name).Color);
                    addStyle(UI_obj.main.spectra.uitable, s, 'cell', [i,2]);
                end
            case 'spectra_m2q_spectrum'
                % Data_column_fieldnames : 'Name', 'dY', 'Scale', 'Color';
                % The amount of scans defined:
                spectra_intnames    = fieldnames(exp_data.spectra);
                nof_spectra         = numel(spectra_intnames);
                uitable_data = cell(nof_spectra, 4); % Initialize empty cell
                for i = 1:nof_spectra
                    current_spectrum_name = spectra_intnames{i};
                    if ~isfield(exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001, 'dY')
                        exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.dY = 0;
                    end
                    if ~isfield(exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001, 'Scale')
                        exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.Scale = 1;
                    end
                    uitable_data{i,1} = exp_data.spectra.(current_spectrum_name).Name;                        % Name
                    uitable_data{i,2} = exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.dY;                          % dY
                    uitable_data{i,3} = exp_data.spectra.(current_spectrum_name).Data.hist.spectr_001.Scale;                       % Scale
                    uitable_data{i,4} = regexprep(num2str(round(exp_data.spectra.(current_spectrum_name).Color,1)),'\s+',','); % Color
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', exp_data.spectra.(current_spectrum_name).Color);
                    addStyle(UI_obj.plot.m2q.spectra.uitable, s, 'cell', [i,4]);
                end
        end

    end