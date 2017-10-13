function  [data_out] = m2q_2_m2q_label_Ci(data_in, metadata_in, det_name)
% This macro labels based on combinations of different hits in one event.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    % parameters:
    detname                 = detnames{i}; 
    nof_hits                = size(data_out.h.(detname).TOF,1);
    search_radius_m2q       = metadata_in.conv.(detname).m2q_label_Ci.search_radius;
	% signals:
	detnr					= IO.det_nr_from_fieldname(detname);
    e_raw					= data_out.e.raw(:,detnr);
	
	m2q		= fetch_signal(data_in, ['h.' detname '.m2q']);

	switch metadata_in.conv.(detname).m2q_label_Ci.method
        case 'circle'
			m2q_l	= fetch_signal(data_in, ['h.' detname '.m2q_l']);
			f_e_r	= circle(e_raw, m2q, m2q_l, search_radius_m2q);
		case 'line'
			if ~general.struct.issubfield(data_in, ['h.' detname '.m2q_l'])
				% This means that the m2q is not yet labeled, we calculate an intermediate label:
				m2q_l = prelabel(m2q, metadata_in.conv.(detname).m2q_labels, metadata_in.conv.(detname).m2q_label_Ci.length)
				data_in = general.struct.setsubfield(data_in, ['h.' detname '.m2q_l']);% placing it in the experiment metadata
			else
				m2q_l	= fetch_signal(data_in, ['h.' detname '.m2q_l']);
			end
			m2q_l_sum	= fetch_signal(data_in, ['e.' detname '.m2q_l_sum']);
			TOF_sum	= fetch_signal(data_in, ['e.' detname '.TOF_sum']);
			f_e_r = line(e_raw, m2q_l, m2q_l_sum, TOF_sum, search_radius_m2q, metadata_in.conv.(detname).TOF_2_m2q);
	end
	% We discard the labels from events that are outside the specified 
	% radius or not recognized, 
	f_e_discard = (~f_e_r & filter.events.multiplicity(e_raw, 2, Inf, nof_hits));
	% translate to the hits in the events:
	f_h_discard = filter.events_2_hits_det(f_e_discard, e_raw, nof_hits);
	% remove the labels
	data_out.h.(detname).m2q_l(f_h_discard) = NaN;
	% Also remove the m2qs:
% 	data_out.h.(detname).m2q(f_h_discard) = NaN;
end
    disp(['Log: m2q Ci labeling performed on ' detname]);
end

% Local subfunctions

%% Circle
function [f_e_r] = circle(e_raw, m2q, m2q_l, search_radius_m2q)
	% calculate the total m2q-squared of all events:
	m2q_squared		= convert.event_sum((m2q-m2q_l).^2, e_raw);
	% This number is compared to the specified search radius squared:
	f_e_r = (m2q_squared <= search_radius_m2q.^2);
end

%% Line
function [f_e_r] = line(e_raw, m2q_l, m2q_l_sum, TOF_sum, search_radius_m2q, TOF_2_m2q)
	
% Fetch the conversion data:
fact	= TOF_2_m2q.factor;
t0		= TOF_2_m2q.t0;

% Convert the m2q_l_sums to TOF_l_sums:
TOF_l			= convert.m2q_2_TOF(m2q_l, fact, t0);
TOF_l_sum		= convert.event_sum(TOF_l, e_raw);

delta_TOF		= fact*(sqrt(m2q_l_sum + search_radius_m2q) - sqrt(m2q_l_sum));
% These numbers are compared to the label m2q value sums:
f_e_r = abs(TOF_sum-TOF_l_sum) < delta_TOF;
end

%% Prelabel (if no m2q_l exists yet)
function m2q_l = prelabel(m2q, m2q_labels, length)
error('TODO')
end

%% Fetch signal
function signal = fetch_signal (exp, name)
% This function fetches a signal, if it exists:
if general.struct.issubfield(exp, name)
	signal = general.struct.probe_field(exp, name);
	 % If it does not exist, and it is an event sum property, we can create it from the hit data:
elseif IO.data_pointer.is_event_signal(name) && strcmp(name(end-3:end), '_sum') && general.struct.issubfield(exp, ['h.' name(3:end-4)])
	hit_signal = general.struct.probe_field(exp, ['h.' name(3:end-4)]);
	e_raw = exp.e.raw(:,IO.det_nr_from_fieldname(name));
	signal	= convert.event_sum(hit_signal, e_raw);
else
	signal = [];
	warning('signal could not be found or created')
end
end