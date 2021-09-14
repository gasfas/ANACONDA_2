function [TetEI_x_tof,Xedges,Yedges] = plot_pepico(data_converted, data_stats,tof_range);
%% define etEI_x_tof
pepico.elec.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
pepico.elec.type	        = 'continuous';
pepico.elec.data_pointer	= 'h.det1.R';
pepico.elec.translate_condition = 'AND';
pepico.elec.value		= data_stats.e_R_range;

pepico.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
pepico.ions.tof.type             = 'continuous';
pepico.ions.tof.data_pointer     = 'h.det2.TOF  ';
pepico.ions.tof.value            = tof_range;
pepico.ions.tof.translate_condition = 'AND';
pepico.ions.tof.invert_filter     = false;

[e_filter_pepico, ~]	= macro.filter.conditions_2_filter(data_converted,pepico);
hit_filter_elec = filter.events_2_hits_det(e_filter_pepico, data_converted.e.raw(:,1), length(data_converted.h.det1.R),...
    pepico, data_converted); 
hit_filter_ion = filter.events_2_hits_det(e_filter_pepico, data_converted.e.raw(:,2), length(data_converted.h.det2.TOF),...
    pepico, data_converted); 

e_KER_new = data_converted.h.det1.KER(hit_filter_elec);
i_TOF_new = data_converted.h.det2.TOF(hit_filter_ion);

Xedges = [230:2:280];
Yedges = [pepico.ions.tof.value(1):1:pepico.ions.tof.value(2)];

[etEI_x_tof,Xedges,Yedges] =histcounts2(e_KER_new,i_TOF_new,Xedges,Yedges);
figure
imagesc(Xedges,Yedges,etEI_x_tof')
% caxis([0 100])
colorbar
xlabel('Electron kinetic energy (eV)')
ylabel('Ion TOF (ns)')
set(gca,'YDir','normal')
title('etEI(x,tof)')

%% define ES_0 
es0_cond =pepico;
es0_cond.ions= macro.filter.write_coincidence_condition(0, 'det2');
[e_filter_ion0, ~]	= macro.filter.conditions_2_filter(data_converted,es0_cond);
hit_filter_c0 = filter.events_2_hits_det(e_filter_ion0, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
    es0_cond, data_converted); 
ES_zero_ion = data_converted.h.det1.KER(hit_filter_c0); %%pa
[ES_0,~] = histcounts(ES_zero_ion,Xedges);
%% define rtI(tof)
rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
rtN.ions.tof.type             = 'continuous';
rtN.ions.tof.data_pointer     = 'h.det2.TOF  ';
rtN.ions.tof.value            = tof_range;
rtN.ions.tof.translate_condition = 'AND';
rtN.ions.tof.invert_filter     = false;

[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);
hit_filter_ion = filter.events_2_hits_det(e_filter_rtN, data_converted.e.raw(:,2), length(data_converted.h.det2.TOF),...
    rtN, data_converted); 
i_TOF_new = data_converted.h.det2.TOF(hit_filter_ion);
[rtI_tof,~] = histcounts(i_TOF_new,Yedges);
%% background BetEI_x_tof
BetEI_x_tof = kron((ES_0./data_stats.rtP_0)',(rtI_tof./data_stats.N_RND));
% BetEI_x_tof = kron((rtI_tof./data_stats.N_RND)',(ES_0./data_stats.rtP_0));

figure
imagesc(Xedges,Yedges,BetEI_x_tof')
colorbar
% caxis([0 100])
xlabel('Electron kinetic energy (eV)')
ylabel('Ion TOF (ns)')
set(gca,'YDir','normal')
title('BetEI(x,tof)')

%% True pepicco
TetEI_x_tof=etEI_x_tof - BetEI_x_tof;
figure
imagesc(Xedges,Yedges,TetEI_x_tof')
colorbar
xlabel('Electron kinetic energy (eV)')
ylabel('Ion TOF (ns)')
% caxis([0 100])
set(gca,'YDir','normal')
title('TetEI(x,tof)')
%%
figure
Xcenters = Xedges(1:end-1) + (diff(Xedges)/2);
plot(Xcenters,sum(etEI_x_tof,2),'DisplayName','etEI(x)')
hold on
% figure
plot(Xcenters,sum(BetEI_x_tof,2),'DisplayName','BetEI(x)')
plot(Xcenters,sum(TetEI_x_tof,2),'DisplayName','TetEI(x)')
legend
end
