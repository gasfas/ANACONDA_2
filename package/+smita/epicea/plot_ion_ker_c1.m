function [Tet_dp_norm,Tet_dp_norm_error] = plot_ion_ker_c1(data_converted, data_stats,mode,m2q_range)
%%This function plots the filtered Ion Kinetic energy
%% ion filters
    ion.C1= macro.filter.write_coincidence_condition(1, 'det2'); % electron trigger
if strcmp(mode, 'direct_input')
    if length(m2q_range)== 1 %use labels
        %%define the ion filter
        ion.type	        = 'discrete';
        ion.data_pointer	= 'h.det2.m2q_l';
        ion.translate_condition = 'AND';
        ion.value		= m2q_range;
    else %use m2q range
        %%define the ion filter 
        ion.type	        = 'continuous';
        ion.data_pointer	= 'h.det2.m2q';
        ion.translate_condition = 'AND';
        ion.value		= m2q_range;
    end
elseif  strcmp(mode, 'manual_selection')
    m2q_range = get_m2q_range(data_converted, data_stats);
    %%define the ion filter
    ion.type	        = 'continuous';
    ion.data_pointer	= 'h.det2.m2q';
    ion.translate_condition = 'AND';
    ion.value		= m2q_range;
    
end

    e_TRG.e.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
    e_TRG.e.type	        = 'continuous';
    e_TRG.e.data_pointer	= 'h.det1.R';
    e_TRG.e.translate_condition = 'AND';
    e_TRG.e.value		= data_stats.e_R_range;
    e_TRG.ion = ion;

    RND_TRG.e= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger
    RND_TRG.ion = ion;

[e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
[e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted, RND_TRG);

%% Define etAI and rtAI
hit_filter_et = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    e_TRG, data_converted);
et_dp_norm= data_converted.h.det2.dp_norm(hit_filter_et.det2.filt); 
et_dp_norm= data_converted.h.det2.KER(hit_filter_et.det2.filt); 

hit_filter_rt = filter.events_2_hits(e_filter_rt, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    RND_TRG, data_converted);
rt_dp_norm= data_converted.h.det2.dp_norm(hit_filter_rt.det2.filt);
rt_dp_norm= data_converted.h.det2.KER(hit_filter_rt.det2.filt);

%% make histogram

Binsize = 10; Binedges = -0.01: Binsize: 200;
Binsize = 0.1; Binedges = -0.4: Binsize: 8;

Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
et_dp_norm_hist= histcounts(et_dp_norm, Binedges);%,'Normalization','probability');
rt_dp_norm_hist= histcounts(rt_dp_norm, Binedges);%,'Normalization','probability');
% figure
plot(Bincenters, et_dp_norm_hist,'LineWidth',1,'DisplayName','Measured data')%etAI(dp_norm)
hold on
plot(Bincenters, data_stats.SC.*rt_dp_norm_hist,'LineWidth',1,'DisplayName','Calc.Background' ) %SC*rtAI(dp_norm)
legend
%% Filter Ion TOF
% figure
Tet_dp_norm = et_dp_norm_hist - data_stats.SC.* rt_dp_norm_hist;
% Tet_dp_norm = max(Tet_dp_norm,0);
Tet_dp_norm_error = sqrt(et_dp_norm_hist + (data_stats.SC.^2).* rt_dp_norm_hist);
% plot(Bincenters, Tet_dp_norm ,'LineWidth',1,'DisplayName','TetAI(dp_norm)')
xlabel('Ion Kinetic energy (eV)')%dp_norm (a.u.)
legend

% figure
% errorbar(Bincenters,Tet_dp_norm./max(Tet_dp_norm) ,Tet_dp_norm_error./max(Tet_dp_norm), 'LineWidth',2,'DisplayName',sprintf('%.2f (a.u.) - %.2f (a.u.)', m2q_range(1),m2q_range(2)))
try 
    errorbar(Bincenters,Tet_dp_norm ,Tet_dp_norm_error, 'LineWidth',1,'DisplayName',sprintf('%.2f (a.u.) - %.2f (a.u.)', m2q_range(1),m2q_range(2)))
catch
    errorbar(Bincenters,Tet_dp_norm ,Tet_dp_norm_error, 'LineWidth',1,'DisplayName','Corrected data')%sprintf('%.2f (a.u.) ', m2q_range(1)))
end
%%
end