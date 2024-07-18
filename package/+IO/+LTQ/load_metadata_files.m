function exps = load_metadata_files(data_dir_base, sample_names, energy_range_char, photon_energy_stepsize_default, Flux_calibration_directory)
    short_sample_names  = {'RYGGM', 'RYMGG', 'RFGGM', 'RFMGG', 'RWGGM', 'RWMGG'};
    long_sample_names   = {'RWMG7', 'RWG2MG5', 'RWG4MG3', 'RWG6MG'};

    for i = 1:numel(sample_names)
                
        sample_name = sample_names{i}; % Determine whether we are looking at a 5- or 10-unit peptide.
        if any(strcmpi(sample_name, short_sample_names)) || any(strcmpi(sample_name, long_sample_names)) || any(strcmpi(sample_name, 'photon_only')) % We recognize the specified sample
            switch sample_name
                case short_sample_names % 'short' peptide
                    datadir         = fullfile(data_dir_base, '5-unit');
                    expname         = [sample_name, '\\', sample_name, '_', energy_range_char, 'eV\\'];    
                case long_sample_names % 'long' peptide
                    datadir         = fullfile(data_dir_base, '10-unit');
                    expname         = [sample_name, '\\', sample_name, '_', energy_range_char, 'eV\\'];
                case 'photon_only'
                    datadir         = fullfile(data_dir_base, 'photon_only');
                    expname         = ['\\'];
            end
            % Generate the full filename:
            data_filedir_gen = fullfile(datadir, expname);
            
            % Load the default metadata:
            run([data_dir_base '/md_defaults.m'])
            % Fetch metadata info on this measurement run.  Will overwrite
            % defaults if they are double defined:
            if any(any(strcmpi(sample_name, short_sample_names))) || any(strcmpi(sample_name, long_sample_names))
                run([data_filedir_gen 'md_' sample_name '_' general.char.replace_symbol_in_char(energy_range_char, '-', '_') 'eV.m'])
            else
                run([data_filedir_gen 'md_' sample_name '.m'])
            end
            
        elseif any(strcmpi(sample_name, 'photon_only'))
            datadir         = fullfile(data_dir_base, 'photon_only');
            expname         = [''];
            % Generate the full filename:
            data_filedir_gen = fullfile(datadir, expname);
            % Fetch metadata info on this measurement run:
            run([data_filedir_gen '\md_' sample_name '.m'])
        end
        
        % If photon energy is specified in the metadata of this run, print it along in the data
        if exist('photon_energy', 'var') % copy from metadata if given:
            exps.(sample_name).photon.energy = photon_energy;
        else    % Make a guess of the photon energy points from the limits and amount of spectra:
            % Get the photon energy limits:
            photon_energy_limits    = str2num(char(strsplit(energy_range_char, '-')));
            exps.(sample_name).photon.energy = photon_energy_limits(1):photon_energy_stepsize_default:(photon_energy_limits(1)+photon_energy_stepsize_default*(length(photon_energy)-1));
        end
        if exist('parent_mass', 'var') % Write the parent mass to the struct, if it is given in the metadata:
            exps.(sample_name).sample.parent_mass = parent_mass;
        end
            
        % Scale the Intensities in accordance with the given photon flux:
        % Load the file
        flux_calib                          = IO.Qex_Lyon.txt2mat(fullfile(Flux_calibration_directory, ['flux_desirs_2022_' energy_range_char 'eV.txt']), 'InfoLevel', 0);

        % Interpolate the photon flux at the measured photon energies and store the photon flux in the exps struct:
        exps.(sample_name).photon.flux      = interp1(flux_calib(:,1), flux_calib(:,2), exps.(sample_name).photon.energy);
        % Store the acquisition time in the data struct:
        exps.(sample_name).meta.acq_time_msec = acq_time_msec;
        
        try exps.(sample_name).meta.import.delta_m_corr_linear_dm = delta_m_corr_linear_dm; end
        try exps.(sample_name).meta.import.delta_m_corr = delta_m_corr; end
        try exps.(sample_name).meta.import.delta_m_corr_linear_m0 = delta_m_corr_linear_m0; end
        try exps.(sample_name).meta.import.spectra_to_use = spectra_to_use; end
        try exps.(sample_name).meta.m_fit = m_fit;  end % Add fit metadata if it exists
        try exps.(sample_name).meta.PIY_fragments = PIY_fragments; end % Add masslist for PIY spectra if exists.

    end
end