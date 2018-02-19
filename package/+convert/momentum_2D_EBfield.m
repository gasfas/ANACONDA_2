function [p, p_0] = momentum_2D_EBfield(TOF, X, Y, m2q_l, m_l, labels, labels_mass, labels_TOF_no_p, E_ER, Bfield, sample_md) 
% The function converts TOF, X, Y to momentum, in the case of both E- and B-field.
% Only hits that are recognized to belong to a certain m/q are considered (labels).
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
% E_ER          [V\m]  electric field strength

%constants
omega = general.constants('q')*Bfield./labels_mass;

%Initialize all variables
m           = length(labels); % number of m2qlabels
p           = NaN*ones(size(TOF,1),3); % [n, 1]
p_0         = NaN*ones(size(TOF,1),3); % [n, 1]

%filter out hits with a certain label
[part_label_filt, label_loc] = general.matrix.ismemberNaN(m2q_l, labels);
% part_label_filt: array [n,1] with 1 and 0, 1 corresponding to a filtered
% value with the label that we are interested in and 0 to unlabeled values
X_f     = X(part_label_filt); % [q, 1]
Y_f     = Y(part_label_filt); % [q, 1]
TOF_f   = TOF(part_label_filt); %[q, 1]
%calculate no_K variables, _f stands for filtered
m2q_l_f = m2q_l(part_label_filt); % [q, 1]
m_l_f   = m_l(part_label_filt); % [q, 1]
q_l_f  = m_l_f./m2q_l_f; % elementary charge [q, 1]

% the expected zero-momentum position (detection centre):
X_no_p      = zeros(m,1); %(this should be zero if correction is done well)
Y_no_p      = zeros(m,1);
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
p_X_0 = 0.5*general.constants({'q'}).*Bfield.*((sin(omega.*TOF_0)./(1-cos(omega.*TOF_0)))*X_0 - (sin(omega.*TOF_no_dp)./(1-cos(omega.*TOF_no_dp))).*X_no_p - (Y_0 - Y_no_p));
p_Y_0 = 0.5*general.constants({'q'}).*Bfield.*(X_0 - X_no_p -(sin(omega*TOF_0)/(1-cos(omega*TOF_0)))*Y_0 - (sin(omega*TOF_no_dp)/(1-cos(omega*TOF_no_dp)))*Y_no_dp)*1e6;
p_Z_0 = labels_charge.*general.constants({'q'}).* E_ER.* (T_0 - TOF_no_dp)*1e-9; % [kg*m/s] [m,1]
p_Z = q*E*(TOF_0 - TOF_no_p);
 % [kg*m/s] [m,1] %substraction is done to rescale p_0_X to the same size as 



% fill this into the momentum (hit array, [n, 1]):
p_0(find(label_loc),:) = [p_X_0(label_nr_f), p_Y_0(label_nr_f), p_Z_0(label_nr_f)];

%% p values
% The final momentum is different for each hit (the zero-time momentum is
% different for each label). So we need to fit some label arrays to
% filtered labeled hits.
X_no_p_f      = X_no_p(label_nr_f); % [q, 1]
Y_no_p_f      = Y_no_p(label_nr_f); % [q, 1]
TOF_no_p_f    = TOF_no_dp(label_nr_f); % [q, 1]

%step2: calculate p_x0, p_y0
% 3D
p_X = 0.5*general.constants({'q'})*Bfield*((sin(omega*TOF_f)/(1-cos(omega*TOF_f)))*X_f - Y_f - (sin(omega*TOF_no_p_f)/(1-cos(omega*TOF_no_p_f)))*X_no_p_f - Y_no_p_f)*1e6; % [kg*m/s] [q,1];
p_Y = 0.5*general.constants({'q'})*Bfield*(X_f-(sin(omega*TOF_f)/(1-cos(omega*TOF_f)))*Y_f - X_no_p_f-(sin(omega*TOF_no_p_f)/(1-cos(omega*TOF_no_p_f)))*Y_no_p_f)*1e6; % [kg*m/s] [q,1];
p_Z = q*E*(TOF_f - TOF_no_p_f)*1e-9; %        [kg*m/s] [q,1]; % same as the Efield one, write small function
%to call here


% fill this into the momentum (hit array, [n, 1]):
p(find(label_loc),:) = [p_X p_Y p_Z];

% Convert to atomic units: 
p = p ./ general.constants('momentum_au');
p_0= p_0./ general.constants('momentum_au');

end


         
            
