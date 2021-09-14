function [TetEI_x_tof,Xedges,Yedges] = plot_pepico_m2q2tof(data_converted, data_stats,m2q_l);
% takes m2q labels but returns the matrix in tof
%% define etEI_x_tof
pepico.elec.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
pepico.elec.type	        = 'continuous';
pepico.elec.data_pointer	= 'h.det1.R';
pepico.elec.translate_condition = 'AND';
pepico.elec.value		= data_stats.e_R_range;

pepico.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
pepico.ions.m2q.type             = 'discrete';
pepico.ions.m2q.data_pointer     = 'h.det2.m2q_l  ';
pepico.ions.m2q.value            = m2q_l;
pepico.ions.m2q.translate_condition = 'hit1';

[e_filter_pepico, ~]	= macro.filter.conditions_2_filter(data_converted,pepico);
hit_filter_elec = filter.events_2_hits_det(e_filter_pepico, data_converted.e.raw(:,1), length(data_converted.h.det1.R),...
    pepico, data_converted); 
hit_filter_ion = filter.events_2_hits_det(e_filter_pepico, data_converted.e.raw(:,2), length(data_converted.h.det2.TOF),...
    pepico, data_converted); 

e_KER_new = data_converted.h.det1.KER(hit_filter_elec);
i_TOF_new = data_converted.h.det2.TOF(hit_filter_ion);

Xedges = [230:0.5:280];
Yedges = 2000:10:11000;

[etEI_x_TOF,Xedges,Yedges] =histcounts2(e_KER_new,i_TOF_new,Xedges,Yedges);


%% define ES_0 
es0_cond =pepico;
es0_cond.ions= macro.filter.write_coincidence_condition(0, 'det2');
[e_filter_ion0, ~]	= macro.filter.conditions_2_filter(data_converted,es0_cond);
hit_filter_c0 = filter.events_2_hits_det(e_filter_ion0, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
    es0_cond, data_converted); 
ES_zero_ion = data_converted.h.det1.KER(hit_filter_c0); %%pa
[ES_0,~] = histcounts(ES_zero_ion,Xedges);
%% define rtI(TOF)
rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
rtN.ions.m2q.type             = 'discrete';
rtN.ions.m2q.data_pointer     = 'h.det2.m2q_l  ';
rtN.ions.m2q.value            = m2q_l;
rtN.ions.m2q.translate_condition = 'hit1';
% rtN.ions.m2q.invert_filter     = false;

[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);
hit_filter_ion = filter.events_2_hits_det(e_filter_rtN, data_converted.e.raw(:,2), length(data_converted.h.det2.TOF),...
    rtN, data_converted); 
i_TOF_new = data_converted.h.det2.TOF(hit_filter_ion);
[rtI_TOF,~] = histcounts(i_TOF_new,Yedges);
%% background BetEI_x_TOF
BetEI_x_TOF = kron((ES_0./data_stats.rtP_0)',(rtI_TOF./data_stats.N_RND));
% BetEI_x_TOF = kron((rtI_TOF./data_stats.N_RND)',(ES_0./data_stats.rtP_0));

% figure
% imagesc(Xedges,Yedges,BetEI_x_TOF')
% colorbar
% caxis([0 800])
% xlabel('Electron kinetic energy (eV)')
% ylabel('TOF (a.u.)')
% set(gca,'YDir','normal')
% title('BetEI(x,TOF)')

%% True pepicco
TetEI_x_tof=etEI_x_TOF - BetEI_x_TOF;
% figure
% imagesc(Xedges,Yedges,TetEI_x_TOF')
% colorbar
% caxis([0 800])
% xlabel('Electron kinetic energy (eV)')
% ylabel('TOF (a.u.)')
% set(gca,'YDir','normal')
% title('TetEI(x,TOF)')
%%
% figure
% Xcenters = Xedges(1:end-1) + (diff(Xedges)/2);
% plot(Xcenters,sum(etEI_x_TOF,2),'DisplayName','etEI(x)')
% hold on
% % figure
% plot(Xcenters,sum(BetEI_x_TOF,2),'DisplayName','BetEI(x)')
% plot(Xcenters,sum(TetEI_x_tof,2),'DisplayName','TetEI(x)')
% legend
end
