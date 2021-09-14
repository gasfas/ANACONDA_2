function [Tet_m2q,Tet_m2q_error] = plot_ion_m2q(data_converted, data_stats)
e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
e_TRG.type	        = 'continuous';
e_TRG.data_pointer	= 'h.det1.R';
e_TRG.translate_condition = 'AND';
e_TRG.value		= data_stats.e_R_range;

RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger

[e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
[e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted, RND_TRG);

%% Define etAI and rtAI
hit_filter_et = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    e_TRG, data_converted);
et_m2q= data_converted.h.det2.m2q(hit_filter_et.det2.filt); 

hit_filter_rt = filter.events_2_hits(e_filter_rt, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    RND_TRG, data_converted);
rt_m2q= data_converted.h.det2.m2q(hit_filter_rt.det2.filt);

%% make histogram

Binsize = 0.1; Binedges = 0: Binsize: 150;
Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
et_m2q_hist= histcounts(et_m2q, Binedges);%,'Normalization','probability');
rt_m2q_hist= histcounts(rt_m2q, Binedges);%,'Normalization','probability');
% figure
% plot(Bincenters, et_m2q_hist,'LineWidth',1,'DisplayName','etAI(m2q)')
% hold on
% plot(Bincenters, rt_m2q_hist,'LineWidth',1,'DisplayName','rtAI(m2q)' )
% legend

%% Filter Ion TOF
figure
Tet_m2q = et_m2q_hist - data_stats.SC.* rt_m2q_hist;
% Tet_tof = max(Tet_tof,0);
Tet_m2q_error = sqrt(et_m2q_hist + (data_stats.SC.^2).* rt_m2q_hist);
plot(Bincenters, Tet_m2q ,'LineWidth',1,'DisplayName','TetAI(m2q)')
xlabel('m2q (a.u.)')
legend
% for kk =1:10
%     xline(12*(kk));
% end
xticks(0:12:150)
% figure
% errorbar(Bincenters,Tet_m2q ,Tet_m2q_error, 'LineWidth',1,'DisplayName','TetAI(m2q)')

end