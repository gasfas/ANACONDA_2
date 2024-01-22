function [m_I, m_bins] = exp_struct_to_matrix(exp_sample)

spectr_names    = fieldnames(exp_sample.hist);
% Make sure all the bins are the same:
m_bins       = exp_sample.hist.(spectr_names{1}).M2Q.bins;
for i = 1:length(spectr_names)
    spectr_name_cur     = spectr_names{i};
    
    if ~isequal(m_bins, exp_sample.hist.(spectr_name_cur).M2Q.bins)
        error('bins are not the same, cannot merge to matrix')
    end
end
% Build the intensity matrix:
m_I = zeros(length(m_bins), length(spectr_names));
for i = 1:length(spectr_names)
    spectr_name_cur     = spectr_names{i};
    m_I(:,i)            = exp_sample.hist.(spectr_name_cur).M2Q.I;
end

end

