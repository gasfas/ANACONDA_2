function [TetEI_x_m2q,Xcenters,Ycenters] = get_pepico_m2q(data_converted, data_stats,m2q_range);
%% define etEI_x_m2q
pepico.elec.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
pepico.elec.type	        = 'continuous';
pepico.elec.data_pointer	= 'h.det1.R';
pepico.elec.translate_condition = 'AND';
pepico.elec.value		= data_stats.e_R_range;

pepico.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
pepico.ions.m2q.type             = 'continuous';
pepico.ions.m2q.data_pointer     = 'h.det2.m2q  ';
pepico.ions.m2q.value            = m2q_range;
pepico.ions.m2q.translate_condition = 'AND';
pepico.ions.m2q.invert_filter     = false;

[e_filter_pepico, ~]	= macro.filter.conditions_2_filter(data_converted,pepico);
hit_filter_elec = filter.events_2_hits_det(e_filter_pepico, data_converted.e.raw(:,1), length(data_converted.h.det1.R),...
    pepico, data_converted); 
hit_filter_ion = filter.events_2_hits_det(e_filter_pepico, data_converted.e.raw(:,2), length(data_converted.h.det2.m2q),...
    pepico, data_converted); 

e_KER_new = data_converted.h.det1.KER(hit_filter_elec);
i_m2q_new = data_converted.h.det2.m2q(hit_filter_ion);

Xedges = [230:0.5:280];
Yedges = [pepico.ions.m2q.value(1):0.2:pepico.ions.m2q.value(2)];

[etEI_x_m2q,Xedges,Yedges] =histcounts2(e_KER_new,i_m2q_new,Xedges,Yedges);


%% define ES_0 
es0_cond =pepico;
es0_cond.ions= macro.filter.write_coincidence_condition(0, 'det2');
[e_filter_ion0, ~]	= macro.filter.conditions_2_filter(data_converted,es0_cond);
hit_filter_c0 = filter.events_2_hits_det(e_filter_ion0, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
    es0_cond, data_converted); 
ES_zero_ion = data_converted.h.det1.KER(hit_filter_c0); %%pa
[ES_0,~] = histcounts(ES_zero_ion,Xedges);
%% define rtI(m2q)
rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
rtN.ions.m2q.type             = 'continuous';
rtN.ions.m2q.data_pointer     = 'h.det2.m2q  ';
rtN.ions.m2q.value            = m2q_range;
rtN.ions.m2q.translate_condition = 'AND';
rtN.ions.m2q.invert_filter     = false;

[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);
hit_filter_ion = filter.events_2_hits_det(e_filter_rtN, data_converted.e.raw(:,2), length(data_converted.h.det2.m2q),...
    rtN, data_converted); 
i_m2q_new = data_converted.h.det2.m2q(hit_filter_ion);
[rtI_m2q,~] = histcounts(i_m2q_new,Yedges);
%% background BetEI_x_m2q
BetEI_x_m2q = kron((ES_0./data_stats.rtP_0)',(rtI_m2q./data_stats.N_RND));
% BetEI_x_m2q = kron((rtI_m2q./data_stats.N_RND)',(ES_0./data_stats.rtP_0));


%% True pepicco
TetEI_x_m2q=etEI_x_m2q - BetEI_x_m2q;
Xcenters = Xedges(1:end-1) + (diff(Xedges)/2);
Ycenters = Yedges(1:end-1) + (diff(Yedges)/2);
end
