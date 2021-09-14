function [Tet_tof,Tet_tof_error] = plot_ion_tof(data_converted, data_stats)
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
et_tof= data_converted.h.det2.TOF(hit_filter_et.det2.filt); 

hit_filter_rt = filter.events_2_hits(e_filter_rt, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    RND_TRG, data_converted);
rt_tof= data_converted.h.det2.TOF(hit_filter_rt.det2.filt);

%% make histogram

Binsize = 10; Binedges = 0: Binsize: 11e3;
Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
et_tof_hist= histcounts(et_tof, Binedges);%,'Normalization','probability');
rt_tof_hist= histcounts(rt_tof, Binedges);%,'Normalization','probability');
% figure
% plot(Bincenters, et_tof_hist,'LineWidth',1,'DisplayName','etAI(tof)')
% hold on
% plot(Bincenters, rt_tof_hist,'LineWidth',1,'DisplayName','rtAI(tof)' )
% legend
%% Filter Ion TOF
figure
Tet_tof = et_tof_hist - data_stats.SC.* rt_tof_hist;
% Tet_tof = max(Tet_tof,0);
Tet_tof_error = sqrt(et_tof_hist + (data_stats.SC.^2).* rt_tof_hist);
plot(Bincenters, Tet_tof ,'LineWidth',1,'DisplayName','TetAI(tof)')
xlabel('Ion TOF (ns)')
legend

% figure
% errorbar(Bincenters,Tet_tof ,Tet_tof_error, 'LineWidth',1,'DisplayName','TetAI(tof)')
end