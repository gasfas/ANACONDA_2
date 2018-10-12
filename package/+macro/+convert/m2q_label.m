function  [data_out] = m2q_label(data_in, metadata_in, det_name)
% This macro converts the m2q signal to m2q-label signal. The conversion
% from a mass-to-charge value to a label can be done in several ways:
% simply by assigning a label to a hit that is within the search radius of
% a certain expected label (C_nr = 1), and/or by considering a correlation
% between the hits in one event, for example in their respective TOF
% values (C_nr > 1).
% a label
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.

data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};
	detnr = IO.det_nr_from_fieldname(detname);
	m2q_l_md				= metadata_in.conv.(detname).m2q_label;
	
	% By default, the labeling is done on single hits. However, events with
	% multiple hits and their correlation can be used to come to a better
	% definition of labels. The coincidence number (C_nr) is 1 by default:
	if isfield(m2q_l_md, 'C_nr')
		C_nr = m2q_l_md.C_nr;
	else
		C_nr = 1;
	end
	
	%% Fetching parameters
	% the expected mass-to-charge labels:
	exp_m2q_labels		= m2q_l_md.labels;
    % the expected mass labels:
	exp_m_labels		= m2q_l_md.mass;

	% The mass-2-charge data:
	m2q					= data_out.h.(detname).m2q;
	events				= data_out.e.raw(:,detnr);
	
	
	%% Single hit labeling:
	if find(C_nr==1)
			% see if a labeling signal is defined ('TOF' or 'm2q')
		switch general.struct.probe_field(m2q_l_md, 'signal')
			case 'TOF'
			% The labeling is done based on the TOF signal (hit based),
			% and therefore the search radius depends on the m2q value:
			search_radius = TOF_based_search_radius(exp_m2q_labels, m2q_l_md.search_radius, metadata_in.conv.(detname));
			otherwise % we assume it is based on 'm2q' signal, and change nothing
					% The width around a label nominal value that still assignes the label
					% to that hit:
					search_radius       = m2q_l_md.search_radius;
		end

		% grouping the hits in labels:
		m2q_l  = convert.signal_2_label(m2q, exp_m2q_labels, search_radius);
	else
		% Initiate an empty mass-2-charge signal:
		m2q_l	= NaN*ones(size(data_out.h.(detname).m2q));	
	end
	
	%% Double coincidence labeling
	if find(C_nr==2)
		% The double coincidence mass-2-charge labeling overwrites the
		% double coincidences m2q_labels.

		m2q_l = label_Ci(m2q_l, events, m2q, m2q_l_md.search_radius, metadata_in.conv.(detname), 2);
	end
	
	%% Triple coincidence labeling:
		if find(C_nr==3)
		% The triple coincidence mass-2-charge labeling overwrites the
		% triple coincidences m2q_labels:
		m2q_l = label_Ci(m2q_l, events, m2q, m2q_l_md.search_radius, metadata_in.conv.(detname), 3);
	end
	
	%% Writing into data struct:
	% Write the mass to charge label signal:
	data_out.h.(detname).m2q_l		= m2q_l;
	% create the mass labels as well:
	[data_out.h.(detname).m_l]     = convert.label_2_label(m2q_l, exp_m2q_labels, exp_m_labels, NaN);
	% Write the event-summed m2q (if possible):
	try data_out.e.(detname).m2q_l_sum	= convert.event_sum(m2q_l, events); catch; end
			
    disp(['Log: mass-to-charge (m2q) labeling performed on ' detname])
end
end

%% Local functions:
function [search_radius_m2q] = TOF_based_search_radius(m2q_labels, search_radius, conv_md)
% The labeling is done based on the TOF signal (hit based)
factor = conv_md.m2q.factor;
t0 = conv_md.m2q.t0;
TOF_labels = convert.m2q_2_TOF(m2q_labels, conv_md.m2q.factor, conv_md.m2q.t0);
% Convert the given TOF search radii to m2q search radii:
search_radius_m2q = abs(m2q_labels - convert.TOF_2_m2q(TOF_labels-search_radius, factor, t0));
end

function [m2q_l] = label_Ci(m2q_l, events, m2q, search_radii_m2q, conv_md, C_nr)
% warning: triple coincidence not tested due to limited memory
m2q_l_md			= conv_md.m2q_label;
mult				= convert.event_multiplicity (events, length(m2q));
expected_m2q_labels = m2q_l_md.labels;	

events_isCi = (mult == C_nr);

switch general.struct.probe_field(m2q_l_md, 'signal')
	case 'TOF'	% We base the labeling on the TOF channel and have to convert to TOF signals:
		signal = convert.m2q_2_TOF(m2q, conv_md.m2q.factor, conv_md.m2q.t0);
		% we convert the mass-2-charge labels, search radius and possibly length to
		% TOF-based search radii:
		expected_labels = convert.m2q_2_TOF(expected_m2q_labels, conv_md.m2q.factor, conv_md.m2q.t0);
		search_radii	= convert.m2q_2_TOF(expected_m2q_labels, conv_md.m2q.factor, conv_md.m2q.t0) - ...
			convert.m2q_2_TOF(expected_m2q_labels - search_radii_m2q, conv_md.m2q.factor, conv_md.m2q.t0);		
		if isfield(m2q_l_md, 'length') && strcmpi(m2q_l_md.method, 'line')
			m2q_l_md.length		= convert.m2q_2_TOF(m2q_l_md.length, conv_md.m2q.factor, conv_md.m2q.t0)- ...
				convert.m2q_2_TOF(m2q_l_md.length - search_radii_m2q, conv_md.m2q.factor, conv_md.m2q.t0);
		end
	otherwise % we assume it is based on 'm2q' signal, and change nothing:
		signal = m2q;
		% The different expected labels:
		expected_labels = expected_m2q_labels;
		search_radii	= search_radii_m2q;
end

% the different combinations of labels:
expected_l_comb = combnk(expected_labels, C_nr);
expected_m2q_l_comb = combnk(expected_m2q_labels, C_nr);
if size(search_radii) == size(expected_labels)
	% the different combinations of search radii (we take the average of the 
	% different fragments in the pair:
	search_radii_avg = mean(combnk(search_radii, C_nr), 2);
	search_radii_avg = repmat(search_radii_avg', sum(events_isCi), 1);
else 
	search_radii_avg = search_radii;
end

signal_all_hits = NaN*zeros(sum(events_isCi), C_nr);
for i = 1:C_nr % find the first, second, etc hit m2q values:
	signal_all_hits(:,i) = signal(events(events_isCi)+i-1,:);
end

switch general.struct.probe_field(m2q_l_md, 'method')
	case 'line'
		% The user wants a rectangular region around the nominal label
		% to be approved as a hit pair.
		if ~isfield(m2q_l_md, 'length')
			% we assume the length to equal the search radius if it is not defined:
			length_avg = search_radii_avg;
		else
			if size(m2q_l_md.length) == size(expected_labels)
				% length is different for each different m2q label:
				% The different combinations of line lengths (we take the average of the 
				% different fragments in the pair):
				length_avg = mean(combnk(m2q_l_md.length, C_nr), 2);
				length_avg = repmat(length_avg', size(signal_all_hits, 1), 1);
			else
				length_avg = m2q_l_md.length(1);
			end	
		end
		
		% calculate the difference and sum (hits and labels):
		m2q_c	= abs(diff(signal_all_hits, 1, 2));
		m2q_d	= sum(signal_all_hits, 2);
		
		% the c and d maps: (c for the vertical distance, d for the
		% horizontal one)
		signal_l_c	= abs(diff(expected_l_comb, 1, 2));
		signal_l_d	= sum(expected_l_comb, 2);
		if general.struct.probe_field(m2q_l_md, 'line_slope') && (C_nr ==2)
			error('TODO: implement the option to change line slope')
		end
		% see which events are within the search area:
		% calculate the euclidean distance of all signal hits to the nearest label point:
		C = pdist2(m2q_c, signal_l_c, 'euclidean');
		[~, c_l_pair] = min(C, [], 2);
		% see if the distances are within acceptable boundaries:
		c_appr = C < length_avg;
		clear C length_avg;

		% calculate the euclidean distance of all signal hits to the nearest label point:
		D = pdist2(m2q_d,signal_l_d,'euclidean');
		[~, d_l_pair] = min(D, [], 2);
		% see if the distances are within acceptable boundaries:
		d_appr = D < search_radii_avg;
		clear D search_radii_avg;

		% find events where both search radius and lenght are approved:
		E_appr		= c_appr & d_appr;
	otherwise
		% We assume that the user wants a circular (C2) or spherical (C3) region
		% around the nominal label values to be approved as a hit pair:
		R = compute_radial_distance(signal_all_hits, expected_l_comb);
		% see whether it is within the specified radius:
		E_appr		= R < search_radii_avg;
	end
	% if there is overlap in the regions, choose the closest:
	E_appr_array	= sum(E_appr, 2)>0;
	is_overlap		= sum(E_appr, 2)>1;
			
	if any(is_overlap)
		disp('Ambiguous (overlapping) labeling areas: smallest label pair chosen');
	end
	% Find which pairs are approved:
	[sel, c_l_pair_nrs] = max(E_appr, [], 2 ); c_l_pair_nrs(sel==0) = [];
	
	[~, appr_pair] = max(E_appr, [], 2);	
	
	events_appr		= false(size(events));
	events_appr(events_isCi) = E_appr_array;
	% find to which m2q labels the hits correspond and fill them into data:
	for i = 1:C_nr
		m2q_l_hit_i						= NaN*zeros(size(signal, 1), 1);
		m2q_l_hit_i(E_appr_array)		= expected_m2q_l_comb(c_l_pair_nrs, i);
		m2q_l(events(events_appr)+i-1,:)	= m2q_l_hit_i(~isnan(m2q_l_hit_i));
	end

end

function R = compute_radial_distance(hits, labels)
% mathematical function to calculate the absolute distance between all 
% possible hit combinations and a set of possible nominal points(labels)
hits_mat	= repmat(hits, 1, 1, size(labels, 1));
labels_mat	= repmat(labels, 1, 1, size(hits, 1));
hits_mat	= permute(hits_mat, [1 3 2]);
labels_mat	= permute(labels_mat, [3 1 2]);
R = (sum((hits_mat-labels_mat).^2, 3)).^(0.5);
end
