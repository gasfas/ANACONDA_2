function exps = load_data_files(exp_md, data_dir_base, sample_names, energy_range_char, delta_m_corr_default)
    short_sample_names  = {'RYGGM', 'RYMGG', 'RFGGM', 'RFMGG', 'RWGGM', 'RWMGG'};
    long_sample_names   = {'RWMG7', 'RWG2MG5', 'RWG4MG3', 'RWG6MG'};

    for i = 1:numel(sample_names)
        sample_name = sample_names{i}; % Determine whether we are looking at a 5- or 10-unit peptide.    
    switch sample_name
            case short_sample_names % 'short' peptide
                datadir         = fullfile(data_dir_base, '5-unit');
                expname         = [sample_name, '\\', sample_name, '_', energy_range_char, 'eV\\'];    
            case long_sample_names % 'long' peptide
                datadir         = fullfile(data_dir_base, '10-unit');
                expname         = [sample_name, '\\', sample_name, '_', energy_range_char, 'eV\\'];
            case 'photon_only'
                datadir         = fullfile(data_dir_base, 'photon_only');
                expname         = [''];
    end
    exp_md_cur = exp_md.(sample_name);
    % Generate the full filename:
    data_filedir_gen = fullfile(datadir, expname);
    % Load txt files:
        if exist(fullfile(data_filedir_gen, 'txt'), 'dir') % we assume the files are saved in the 'txt' folder:
            % Find all the files in the txt directory:
            hist_files = dir(fullfile(data_filedir_gen, 'txt','*.txt')); % list all txt files in the directory.
            hist_files = hist_files(~ismember({hist_files.name},{'.','..'})); % remove non-files
            clear hist % empty the variable from the previous run, if exisiting.
            for histnr = 1:length(hist_files)
                % Import for first time (txt)
                hist_single = IO.Qex_Lyon.txt_hist(fullfile(hist_files(histnr).folder, hist_files(histnr).name));
                % Apply the mass correction:
                if isfield(exp_md_cur.meta.import, 'delta_m_corr') % If the user has specified the mass shift in the metadata file:
                    hist_single.M2Q.bins                = hist_single.M2Q.bins - exp_md_cur.meta.import.delta_m_corr;
                else
                    warning('no corrective delta_m given in metadata, default value used.')
                    hist_single.M2Q.bins                = hist_single.M2Q.bins - delta_m_corr_default(i);
                end
                % Apply the linear mass correction:
                if isfield(exp_md_cur.meta.import, 'delta_m_corr_linear_m0') % If the user has specified the linear mass correction in the metadata file:
                    hist_single.M2Q.bins        = hist_single.M2Q.bins + (hist_single.M2Q.bins-exp_md_cur.meta.import.delta_m_corr_linear_m0)*exp_md_cur.meta.import.delta_m_corr_linear_dm;
                else
                    warning('no corrective linear mass shift values given in metadata, no correction performed.')
                end
                
                % Remove the NaN's:
                NaN_idx                             = ~isnan(hist_single.M2Q.bins) & ~isnan(hist_single.M2Q.I); % NaN in either the bins or intensities will be removed.
                hist_single.M2Q.bins                = hist_single.M2Q.bins(NaN_idx); % Remove NaN entries from bins
                hist_single.M2Q.I                   = hist_single.M2Q.I(NaN_idx); % Remove NaN entries from Intensity
                % Calculate integrated signal:
                Int_sign_cur = trapz(hist_single.M2Q.bins, hist_single.M2Q.I);
                % Normalize spectrum:
                hist_single.M2Q.I      = hist_single.M2Q.I/Int_sign_cur*1e3; % Multiply by 1000 to avoid fitting tolerance problems later.

                [~, bare_spectrum_name]             = fileparts(hist_files(histnr).name);
                hist.(['spectr_', sprintf('%03.f', str2num(bare_spectrum_name(end-1:end)))]) = hist_single;
            end
            if isfield(exp_md_cur.meta.import, 'spectra_to_use') % The user has specified which spectra ought to be used and which shouldn't (ordered alphabetically in spectr name)
                spectra_names_cur           = fieldnames(hist);
                spectra_names_to_remove     = spectra_names_cur(~boolean(exp_md_cur.meta.import.spectra_to_use));
                hist                        = rmfield(hist, spectra_names_to_remove);
                % Remove these entries of the photon flux and energy as well:
                exps.(sample_name).photon.flux      = exp_md.(sample_name).photon.flux(boolean(exp_md_cur.meta.import.spectra_to_use));
                exps.(sample_name).photon.energy    = exp_md.(sample_name).photon.energy(boolean(exp_md_cur.meta.import.spectra_to_use));
            end
        end
        exps.(sample_name).hist = hist;
        exps.(sample_name) = general.struct.catstruct(exp_md_cur, exps.(sample_name));
    end
end