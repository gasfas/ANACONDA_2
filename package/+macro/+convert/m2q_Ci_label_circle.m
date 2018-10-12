function [f_e_r] = m2q_label_Ci_circle (exp, conv_md, detname)
% This macro convert the mass-to-charge signal to a mass-to-charge label
% signal, in the case of multi-coincidence events, and a line-shape is
% chosen as a filter shape around the nominal mass-to-charge value.

%% Fetching
nof_hits                = size(exp.h.(detname).TOF,1);
detnr					= IO.det_nr_from_fieldname(detname);

e_raw					= exp.e.raw(:,detnr);

% fetch the total m2q of each event:
if ~general.struct.issubfield(exp.e, [detname '.m2q_sum'])
	m2q_sum			= convert.event_sum(exp.h.(detname).m2q, e_raw);
else
	m2q_sum			= exp.e.(detname).m2q_sum;
end
% fetch the total TOF of each event:
if ~general.struct.issubfield(exp.e, [detname '.TOF_sum'])
	TOF_sum			= convert.event_sum(exp.h.(detname).TOF, e_raw);
else
	TOF_sum			= exp.e.(detname).TOF_sum;
end
% TOF_sum		= convert.TOF(m2q_sum, conv_md.(detname).TOF_2_m2q.factor, conv_md.(detname).TOF_2_m2q.t0);
% Fetch the search radius:
SR_m2q       = conv_md.(detname).m2q_label_Ci.search_radius;
% Fetch the conversion data:
TOF_2_M2Q_fact	= conv_md.(detname).TOF_2_m2q.factor;
TOF_2_M2Q_t0	= conv_md.(detname).TOF_2_m2q.t0;

%% Converting
try		m2q_l			= data_out.h.(detname).m2q_l;
catch
	m2q_l			= NaN*ones(size(data_out.h.(detname).m2q));
end
% calculate the total m2q-squared of all events:
m2q_squared		= convert.event_sum((m2q-m2q_l).^2, e_raw);
% This number is compared to the specified search radius squared:
f_e_r = (m2q_squared <= search_radius_m2q.^2);

end