function [p, p_0] = momentum_3D_EField(TOF, X, Y, m2q_l, m_l, labels, labels_mass, labels_TOF_no_p, E_ER, sample_md, name)
% The function converts TOF, X, Y to momentum, in the case of only E-field.
% Only hits that are recognized to belong to a certain m/q are considered.
% Input:
% TOF           [n, 1] array, the (corrected) TOF hits [mm]
% X             [n, 1] array, the (corrected) X coordinates [ns]
% Y             [n, 1] array, the (corrected) Y coordinates [ns]
% m2q_l         [n, 1] array, hits identified to belong to expected mass over charge values.
% m_l           [n, 1] array, hits identified to belong to expected mass values [a.m.u].
% labels        [m, 1] m2q hit labels that should be converted.
% labels_mass   [m, 1] m2q hit label masses that should be converted.
% Output:
% p             [n, 3] the final momentum [atomic momentum unit]
% p_0           [n, 3] the time-zero momentum [atomic momentum unit]


m           = length(labels); % number of labels
% n         = length(TOF); % number of hits
% q         = number of hits that are recognized to belong to a label of interest

% Initialize the empty p vectors:
p           = NaN*ones(size(TOF,1),3); % [n, 1]
p_0         = NaN*ones(size(TOF,1),3); % [n, 1]

% Then define the hits that are identified by the m2q labels, that
% participate in this conversion:
[part_label_filt, label_loc] = filter.hits.labeled_hits(m2q_l, labels); % [n, 1]
% Filter these out from our signals:
X_f     = X(part_label_filt); % [q, 1]
Y_f     = Y(part_label_filt); % [q, 1]
TOF_f   = TOF(part_label_filt); %[q, 1]

switch name
    case 'ion' 
            
            % And remove the empty label indices:
            m2q_l_f = m2q_l(part_label_filt); % [q, 1]
            m_l_f   = m_l(part_label_filt); % [q, 1]
            ch_l_f  = m_l_f./m2q_l_f; % elementary charge [q, 1]%same as m2q_l_f, m_l_f

            % % Find the label masses and charges [m,1]:
            labels_charge   = labels_mass./labels;

            % the label numbers in the filtered hit array:
            label_nr_f      = (label_loc(find(label_loc)));
            %% The p_0 reference values:
            % The zero-time momentum p_0 (particles are believed to contain that
            % momentum before photon (or whatever) interaction) is determined from the deviation 
            % of the average from the zero-momentum reference points.
    case 'electron' 
            % And remove the empty label indices:
            m2q_l_f = m2q_l(part_label_filt); % [q, 1]
            m_l_f   = m2q_l_f; % [q, 1]
            ch_l_f  = m2q_l_f; % elementary charge [q, 1]%same as m2q_l_f, m_l_f

            % % Find the label masses and charges [m,1]:
            labels_charge   = labels;

            % the label numbers in the filtered hit array:
            label_nr_f      = (label_loc(find(label_loc)));
end

    % the expected zero-momentum position (detection centre):
    X_no_p      = zeros(m,1); %(this should be zero if correction is done well)
    Y_no_p      = X_no_p;
    % the expected zero-momentum TOF (defined in the labels)
    TOF_no_dp    = labels_TOF_no_p;  % [m, 1]

    try
        [X_0, Y_0, T_0] = convert.zero_dp_splat_position(TOF_no_dp, labels_mass, labels_charge, E_ER, sample_md);
    catch % If some values are not given, we don't perform the MB correction:
        warning('Molecular beam momentum correction not performed')
            % The most probable velocities are calculated for all the labels:
        v_p                 = 0;
        % The radii where the these velocity/mass particles will splat:
        X_0                 = zeros(m,1);
        Y_0                 = zeros(m,1);
        T_0                 = TOF_no_dp;
    end

    % p_0 is determined from the difference between these two:
    p_0_X = labels_mass.*general.constants({'amu'}).* (X_0./T_0 - X_no_p./TOF_no_dp)*1e6; % [kg*m/s] [m,1]
    p_0_Y = labels_mass.*general.constants({'amu'}).* (Y_0./T_0 - Y_no_p./TOF_no_dp)*1e6; % [kg*m/s] [m,1]
    p_0_Z = labels_charge.*general.constants({'q'}).* E_ER.* (T_0 - TOF_no_dp)*1e-9; % [kg*m/s] [m,1]

    % fill this into the momentum (hit array, [n, 1]):
    p_0(find(label_loc),:) = [p_0_X(label_nr_f), p_0_Y(label_nr_f), p_0_Z(label_nr_f)];

    %% p values
    % The final momentum is different for each hit (the zero-time momentum is
    % different for each label). So we need to fit some label arrays to
    % filtered labeled hits.
    X_no_p_f      = X_no_p(label_nr_f); % [q, 1]
    Y_no_p_f      = Y_no_p(label_nr_f); % [q, 1]
    TOF_no_p_f    = TOF_no_dp(label_nr_f); % [q, 1]

 

    % The final momentum p in X and Y direction wil be determined by the
    % distance of the splat position to the detection centre
    p_X = m_l_f  .*general.constants({'amu'}) .* (X_f./TOF_f - X_no_p_f./TOF_no_p_f).*1e6; % [kg*m/s] [q,1]
    p_Y = m_l_f  .*general.constants({'amu'}) .* (Y_f./TOF_f - Y_no_p_f./TOF_no_p_f).*1e6; % [kg*m/s] [q,1]
    % The momentum p in Z-direction will be determined from the difference in
    % expected and actual Time Of Flight:
    p_Z = ch_l_f .*general.constants({'q'})   .* E_ER.* (TOF_f - TOF_no_p_f)*1e-9; %        [kg*m/s] [q,1]

    % fill this into the momentum (hit array, [n, 1]):
    p(find(label_loc),:) = [p_X p_Y p_Z];

    % Convert to atomic units: 
    p = p ./ general.constants('momentum_au');
    p_0= p_0./ general.constants('momentum_au');
    

end
