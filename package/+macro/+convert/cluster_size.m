function  [data_out] = cluster_size(data_in, metadata_in, det_name)
% This macro converts the m2q value to a 'cluster size' signal, which is a
% number that represents the number a constituent is represented in the
% cluster. If the fragment m2q cannot be reconstructed from the give
% constituent masses, NaN is returned.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

% fetch the known constituent masses:
const_masses       = metadata_in.sample.constituent.masses;
% fetch the corresponding sizes:
const_sizes       = metadata_in.sample.fragment.sizes;
if size(const_sizes,2) ~= length(const_masses)
    const_sizes = const_sizes*ones(1, length(const_masses));
end

% Does the cluster protonate after ionization?
if isfield(metadata_in.sample.fragment, 'protonation') 
    protonation = metadata_in.sample.fragment.protonation;
else
    protonation = 0;
end

for i = 1:length(detnames)
    detname = detnames{i};
	detnr	= general.data.pointer.detname_2_detnr(detname);
    m2q_l               = data_in.h.(detname).m2q_l;
    
    % Construct the possible masses and their corresponding number of
    % occurences of every constituent from the given expected constituents:
    [masses_exp_no_proton, nof_occ_exp] = general.fragment_masses(const_masses', max(const_sizes, [], 1)', min(const_sizes, [], 1)');
    % Add the proton mass to the constituent masses:
    masses_exp                          = masses_exp_no_proton + protonation;
    % If there are duplicate masses, we cannot unambiguously connect one
    % combination to a mass label. Therefore, a random pick of the first in
    % the list is chosen:
    if length(unique(masses_exp)) < length(masses_exp)
        disp('warning: several constituent combinations can lead to the same total mass. The first given is chosen, all other combinations are ignored.')
        % Filter away all the duplicates:
        [~, I_ori] = unique(masses_exp, 'rows', 'stable');
        masses_exp = masses_exp(I_ori);
        nof_occ_exp = nof_occ_exp(I_ori, :);
    end
    % We treat m2q_l = NaN as a registration of no cluster, so cluster
    % sizes of all constituents is zero:
    masses_exp(end+1,:)     = NaN*zeros(1,size(masses_exp, 2));
    nof_occ_exp(end+1, :)   = zeros(1,size(nof_occ_exp, 2));
    
    
    % Now relate these labels to the m2q label:
    data_out.h.(detname).cluster_size = convert.label_2_label(m2q_l, masses_exp, nof_occ_exp, 0);
    % Write out a 'total' cluster size, of all samples combined:
    data_out.h.(detname).cluster_size_total = sum(data_out.h.(detname).cluster_size, 2);
    
    % Write it as an event sum property as well:
	
    data_out.e.(detname).cluster_size_sum = convert.event_sum(data_out.h.(detname).cluster_size, data_in.e.raw(:,detnr));
    data_out.e.(detname).cluster_size_total = sum(data_out.e.(detname).cluster_size_sum, 2);

    disp('Log: cluster size labeling performed')
end
end
