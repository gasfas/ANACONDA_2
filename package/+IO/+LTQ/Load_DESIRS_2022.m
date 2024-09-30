function [exps] = Load_DESIRS_2022(data_dir_base, sample_names, energy_range_char, Flux_calibration_directory)
% Function to read LTQ data (from DESIRS) in txt format.
% Importing and visualizing the DESIRS data
%% Load data
% fullfilename = fullfile(datadir, expname);
exps            = struct();
photon_energy_stepsize_default = 0.1; % If not given in metadata.
delta_m_corr_default = 0.0; % If not given in metadata

if strcmpi(energy_range_char, 'full') % The user wants to fetch the full range of energy of the given samples:
    exps_to_merge = struct();
    for energy_range_char_cur = {'5-7', '7-14'}
        energy_range_fieldname_cur = ['hv_range_' general.char.replace_symbol_in_char(energy_range_char_cur{:}, '-', '_')];
        exps_to_merge.(energy_range_fieldname_cur) = IO.LTQ.load_metadata_files(data_dir_base, sample_names, energy_range_char_cur{:}, photon_energy_stepsize_default, Flux_calibration_directory);
        exps_to_merge.(energy_range_fieldname_cur) = IO.LTQ.load_data_files(exps_to_merge.(energy_range_fieldname_cur), data_dir_base, sample_names, energy_range_char_cur{:}, Flux_calibration_directory);
    end
    % Merge the different energy ranges:
    for i = 1:numel(sample_names)
        sample_name_cur     = sample_names{i}; % current sample name.
        % Count the number of spectra present for the low energy range:
        spectr_nrs_low_en = get_spectr_numbers_from_struct(exps_to_merge.hv_range_5_7.(sample_name_cur).hist);
        if isempty(spectr_nrs_low_en) % No spectra found in this sample, continue to next sample.
            continue
        end
        last_spectrum_nr = spectr_nrs_low_en(end);
        % Make sure the M2Q ranges are overlapping:
        spectr_names_high_en    = fieldnames(exps_to_merge.hv_range_7_14.(sample_name_cur).hist);
        spectr_names_low_en     = fieldnames(exps_to_merge.hv_range_5_7.(sample_name_cur).hist);
        if length(exps_to_merge.hv_range_5_7.(sample_name_cur).hist.(spectr_names_low_en{1}).M2Q.bins) ~= length(exps_to_merge.hv_range_7_14.(sample_name_cur).hist.(spectr_names_high_en{1}).M2Q.bins)
            % We assume the M2Q range does not change within a (low or high energy) Find the overlapping M2Q range:
            M2Q_bins_low        = exps_to_merge.hv_range_5_7.(sample_name_cur).hist.(spectr_names_low_en{1}).M2Q.bins;
            M2Q_bins_high       = exps_to_merge.hv_range_7_14.(sample_name_cur).hist.(spectr_names_high_en{1}).M2Q.bins;
            Li_low              = ismembertol(M2Q_bins_low, M2Q_bins_high, 1e-6); % Relative tolerance of 1e-6.
            Li_high             = ismembertol(M2Q_bins_high, M2Q_bins_low, 1e-6); % Relative tolerance of 1e-6.
            M2Q_to_replace      = exps_to_merge.hv_range_5_7.(sample_name_cur).hist.(spectr_names_low_en{1}).M2Q.bins(Li_low);
            % Now we loop through all spectra (high and low) to only leave
            % the overlapping numbers:
            spectra_names_low   = fieldnames(exps_to_merge.hv_range_5_7.(sample_name_cur).hist);
            spectra_names_high  = fieldnames(exps_to_merge.hv_range_7_14.(sample_name_cur).hist);
            for spectrum_name = spectra_names_low' % Skim off the outliers on the low side:
                exps_to_merge.hv_range_5_7.(sample_name_cur).hist.(spectrum_name{:}).M2Q.I      = exps_to_merge.hv_range_5_7.(sample_name_cur).hist.(spectrum_name{:}).M2Q.I(Li_low);
                exps_to_merge.hv_range_5_7.(sample_name_cur).hist.(spectrum_name{:}).M2Q.bins   = M2Q_to_replace;
            end
            for spectrum_name = spectra_names_high' % And the outliers on the high side:
                exps_to_merge.hv_range_7_14.(sample_name_cur).hist.(spectrum_name{:}).M2Q.I     = exps_to_merge.hv_range_7_14.(sample_name_cur).hist.(spectrum_name{:}).M2Q.I(Li_high);
                exps_to_merge.hv_range_7_14.(sample_name_cur).hist.(spectrum_name{:}).M2Q.bins  = M2Q_to_replace;
            end
        end
        % Merging:
        % First fill in the low energy range:
        exps.Data = exps_to_merge.hv_range_5_7.(sample_name_cur);
        % Then add the high energy part of the spectra (by adding to the existing number of spectra):
        % spectr_nrs_high_en = get_spectr_numbers_from_struct(exps_to_merge.hv_range_7_14.Data.hist);
        nof_low_en_spectr       = length(fieldnames(exps_to_merge.hv_range_5_7.(sample_name_cur).hist));
        nof_high_en_spectr      = length(fieldnames(exps_to_merge.hv_range_7_14.(sample_name_cur).hist));
        for j = 1:nof_high_en_spectr
            new_spectr_nr   = last_spectrum_nr + j;
            exps.Data.hist.(['spectr_' sprintf('%03.f', new_spectr_nr)]) = exps_to_merge.hv_range_7_14.(sample_name_cur).hist.(spectr_names_high_en{j});
        end
        % Merge the photon energy arrays:
        exps.Data.photon.energy    = [exps_to_merge.hv_range_5_7.(sample_name_cur).photon.energy, exps_to_merge.hv_range_7_14.(sample_name_cur).photon.energy];
        % Calculate the photon wavelength as well:
        exps.Data.photon.wavelength = convert.eV_to_nm(exps.Data.photon.energy);
        % Merge the photon flux arrays:
        exps.Data.photon.flux      = [exps_to_merge.hv_range_5_7.(sample_name_cur).photon.flux, exps_to_merge.hv_range_7_14.(sample_name_cur).photon.flux];
        % Store the acquisition time values:
        exps.Data.meta.acq_time_msec = [ones(nof_low_en_spectr,1)*exps_to_merge.hv_range_5_7.(sample_name_cur).meta.acq_time_msec; ones(nof_high_en_spectr,1)*exps_to_merge.hv_range_7_14.(sample_name_cur).meta.acq_time_msec];
        % The import values:
        exps.Data.meta.import.hv_range_5_7    = exps_to_merge.hv_range_5_7.(sample_name_cur).meta.import;
        exps.Data.meta.import.hv_range_7_14   = exps_to_merge.hv_range_7_14.(sample_name_cur).meta.import;
        % Initialize the YScale and dY:
        for spectrum_name_cur = fieldnames(exps.Data.hist)'
            exps.Data.hist.(spectrum_name_cur{:}).Scale  = 1;
            exps.Data.hist.(spectrum_name_cur{:}).dY     = 0;
        end
    end
else
    energy_range_fieldname_cur = ['hv_range_' general.char.replace_symbol_in_char(energy_range_char, '-', '_')];
    exp_mds.(sample_names{1}).(energy_range_fieldname_cur) = load_metadata_files(data_dir_base, sample_names, energy_range_char, photon_energy_stepsize_default, Flux_calibration_directory);
    exps = load_data_files(exp_mds.(sample_names{1}).(energy_range_fieldname_cur), data_dir_base, sample_names, energy_range_char, Flux_calibration_directory);
    for i = 1:numel(sample_names)
        sample_name_cur     = sample_names{i}; % current sample name.
        % Calculate photon wavelength:
        exps.Data.photon.wavelength = convert.eV_to_nm(exps.Data.photon.energy);
        sample_name_cur                         = sample_names{i}; % current sample name.
        nof_spectr                              = length(fieldnames(exps.Data.hist));
        % Store acquisition time:
        exps.Data.meta.acq_time_msec = ones(nof_spectr,1)*exps.Data.meta.acq_time_msec(1);
    end
end

end

function spectr_nrs = get_spectr_numbers_from_struct(spectra_struct)
    spectr_nrs         = str2num(char(erase(fieldnames(spectra_struct), 'spectr_')));
end