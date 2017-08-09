function [f_e_r] = m2q_2_m2q_label_Ci_line (exp, conv_md, detname)
% This macro convert the mass-to-charge signal to a mass-to-charge label
% signal, in the case of multi-coincidence events, and a line-shape is
% chosen as a filter shape around the nominal mass-to-charge value.

%% Fetching
nof_hits                = size(exp.h.(detname).TOF,1);
detnr					= IO.det_nr_from_fieldname(detname);

e_raw					= exp.e.raw(:,detnr);

% fetch the total m2q of all events:
if ~general.struct.issubfield(exp.e, [detname '.m2q_sum'])
	m2q_sum			= convert.event_sum(exp.h.(detname).m2q, e_raw);
else
	m2q_sum			= exp.e.(detname).m2q_sum;
end
% fetch the total TOF of all events:
if ~general.struct.issubfield(exp.e, [detname '.TOF_sum'])
	TOF_sum			= convert.event_sum(exp.h.(detname).TOF, e_raw);
else
	TOF_sum			= exp.e.(detname).TOF_sum;
end
% TOF_sum		= convert.m2q_2_TOF(m2q_sum, conv_md.(detname).TOF_2_m2q.factor, conv_md.(detname).TOF_2_m2q.t0);
% Fetch the search radius:
SR_m2q       = conv_md.(detname).m2q_label_Ci.search_radius;
% Fetch the conversion data:
TOF_2_M2Q_fact	= conv_md.(detname).TOF_2_m2q.factor;
TOF_2_M2Q_t0	= conv_md.(detname).TOF_2_m2q.t0;

%% Converting

if ~general.struct.issubfield(exp.h, [detname '.m2q_l'])
	% If the mass-to-charge labels are not defined, we need a length from the nominal point. 
	m2q_length = conv_md.(detname).m2q_label_Ci.length;
	% We check each multiplicity individually:
	try C_nrs				= conv_md.(detname).m2q_label_Ci.C_nr;
	catch; 	C_nrs = 2:5;
	end
	m2q_sum_l	= NaN * ones(size(exp.e.raw, 1), 1);
	f_e_r		= false(size(exp.e.raw, 1), 1);
	for C_nr = C_nrs
		% Find the mass-to-charge combinations that can be approved:
		m2q_l_comb		= nchoosek(repmat(conv_md.(detname).m2q_labels, C_nr, 1), C_nr);
		m2q_l_sum_norm	= sum(m2q_l_comb, 2);
% 		% Translate this to an m2q minimum and maximum for each label:
% 		TOF_sum_min		= convert.m2q_2_TOF(m2q_l_sum_norm - search_radius_m2q, conv_md.(detname).TOF_2_m2q.factor, conv_md.(detname).TOF_2_m2q.t0);
% 		TOF_sum_max		= convert.m2q_2_TOF(m2q_l_sum_norm + search_radius_m2q, conv_md.(detname).TOF_2_m2q.factor, conv_md.(detname).TOF_2_m2q.t0);
		% Find double coincidence events:
		e_f_C_nr		= filter.events.multiplicity(exp.e.raw(:,detnr), C_nr, C_nr, nof_hits);
		% Perform a labeling on the m2q sum:
		m2q_sum_l(e_f_C_nr) = convert.signal_2_label(m2q_sum(e_f_C_nr), m2q_l_sum_norm, SR_m2q);
		% Perform a labeling on the m2q difference:
		if C_nr == 2
% 			m2q_diff	= convert.event_sum;
			TODO
		end
	end
	% See whether the found events can be approved:
	f_e_r(e_f_C_nr) = ~isnan(m2q_sum_l);
else % The mass-to-charge label is already defined, so we can use it:
	m2q_l			= exp.h.(detname).m2q_l;
	% Fetch the mass-to-charge label sum, if it exists:
	if ~general.struct.issubfield(exp.e, [detname '.m2q_l_sum'])
		m2q_l_sum		= convert.event_sum(m2q_l, e_raw);
	else
		m2q_l_sum		= exp.e.(detname).m2q_l_sum;
	end
	% Fetch the TOF label sum, if it exists:
	if ~general.struct.issubfield(exp.e, [detname '.TOF_l_sum'])
		% Convert the m2q_l_sums to TOF_l_sums:
		TOF_l			= convert.m2q_2_TOF(m2q_l, TOF_2_M2Q_fact, TOF_2_M2Q_t0);
		TOF_l_sum		= convert.event_sum(TOF_l, e_raw);
	else
		TOF_l_sum		= exp.e.(detname).TOF_l_sum;
	end
	delta_TOF		= TOF_2_M2Q_fact*(sqrt(m2q_l_sum + SR_m2q) - sqrt(m2q_l_sum));
	% These numbers are compared to the label m2q value sums:
	f_e_r = abs(TOF_sum-TOF_l_sum) < delta_TOF;
end


end