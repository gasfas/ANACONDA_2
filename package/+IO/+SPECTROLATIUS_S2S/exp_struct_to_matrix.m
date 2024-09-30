function [exp_data] = exp_struct_to_matrix(exp_data)
% Build an intensity matrix (only for scans)
for sample_name_cell = fieldnames(exp_data.scans)'
    sample_name_cur     = sample_name_cell{:};
    if ~isfield(exp_data.scans.(sample_name_cur), 'matrix')
        exp_sample = exp_data.scans.(sample_name_cur);
    
        spectr_names    = fieldnames(exp_sample.Data.hist);
        % Make sure all the bins are the same:
        m_bins       = exp_sample.Data.hist.(spectr_names{1}).M2Q.bins;
        for i = 1:length(spectr_names)
            spectr_name_cur     = spectr_names{i};
            % Compare the M2Q spectra, if they are close enough within
            % tolerance:
            tol = 1e-3; % Tolerance in [Da]
            isapproximatelyequal = @(x1,x2,tol) all(abs(real(x1(:)-x2(:)))<tol) & all(abs(imag(x1(:)-x2(:)))<tol);

            if ~isapproximatelyequal(m_bins, exp_sample.Data.hist.(spectr_name_cur).M2Q.bins, tol)
                % The bins are not the same, TODO: this means we need to
                % re-shape the M2Q spectra to the largest overlapping
                % region, using interpolation:
                error('bins are not the same, cannot merge to matrix')
            end
        end
        % Build the intensity matrix:
        m_I = zeros(length(m_bins), length(spectr_names));
        for i = 1:length(spectr_names)
            spectr_name_cur     = spectr_names{i};
            m_I(:,i)            = exp_sample.Data.hist.(spectr_name_cur).M2Q.I;
        end
        
        % Write the current experiment data into export struct:
        exp_data.scans.(sample_name_cur).matrix.M2Q.bins  = m_bins;
        exp_data.scans.(sample_name_cur).matrix.M2Q.I     = m_I;
    end
end