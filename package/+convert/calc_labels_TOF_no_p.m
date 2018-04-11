function labels_TOF_no_p = calc_labels_TOF_no_p(labels, TOF_2_m2q_md)
% This function calculates the nominal TOF, when the particle is assumed to have
% a momentum component of zero magnitude along the TOF direction
	m2qfactor		= TOF_2_m2q_md.factor; 
	t0				= TOF_2_m2q_md.t0;

	labels_TOF_no_p = convert.m2q_2_TOF(labels, m2qfactor, t0);

end