function data_out = generate_rnd(data_in, raw_data_in)
%% find the random events with one ion
rtN.e_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %rnd trigger
rtN.ions= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_in,rtN);
%% get the rnd event data
n_of_event = sum(e_filter_rtN);
data_out.e.raw = [NaN(n_of_event,1), [1:n_of_event]'];
% data_out.e.det1.mult = zeros(n_of_event,1);
% data_out.e.det2.mult = ones(n_of_event,1);
hit_filter_rt_c1 = filter.events_2_hits(e_filter_rtN, data_in.e.raw, [2, length(data_in.h.det2.raw)],...
    rtN, data_converted);


end