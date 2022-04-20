function [m2q_l,b_r] = get_br(data_converted, data_stats, mdata)
data_converted_copy = data_converted;
m2q_l = mdata.conv.det2.m2q_label.labels(1:17);
counts = zeros(length(m2q_l),1);
for ii = 1: length(m2q_l)
    %% ion filters
    ion.C1= macro.filter.write_coincidence_condition(1, 'det2'); % electron trigger
        %%define the ion filter
    ion.type	        = 'discrete';
    ion.data_pointer	= 'h.det2.m2q_l';
    ion.translate_condition = 'OR';
    ion.value		= m2q_l(ii);

    [e_filter, ~]	= macro.filter.conditions_2_filter(data_converted,ion);

    hit_filter = filter.events_2_hits(e_filter, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    ion, data_converted);

%     data_converted.h.det2.m2q(~hit_filter.det2.filt) = NaN;

    [Tet_m2q,Tet_m2q_error] = plot_ion_m2q(data_converted, data_stats);
    counts(ii) = sum(Tet_m2q);
    data_converted = data_converted_copy;
end

b_r = 100.*counts./sum(counts);

end