function [] = plot_ES_ion_pair(data_converted, data_stats,pair_m2q_l)

%% define TetEI_x_m2q1 and TetEI_x_m2q2
[TetEI_x_tof1,~,~] = plot_pepico_m2q2tof(data_converted, data_stats,pair_m2q_l.hit1);
[TetEI_x_tof2,Xedges,Yedges] = plot_pepico_m2q2tof(data_converted, data_stats,pair_m2q_l.hit2);
Ycenters = Yedges(1:end-1) + (diff(Yedges)/2);

%% define rtI(m2q1) and rtI(m2q2)
rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
rtN.ions.m2q.type             = 'discrete';
rtN.ions.m2q.data_pointer     = 'h.det2.m2q_l';
rtN.ions.m2q.value            = pair_m2q_l.hit1;
rtN.ions.m2q.translate_condition = 'hit1';
% rtN.ions.m2q.invert_filter     = false;

[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);
hit_filter_ion = filter.events_2_hits_det(e_filter_rtN, data_converted.e.raw(:,2), length(data_converted.h.det2.m2q),...
    rtN, data_converted); 
i_tof_new = data_converted.h.det2.TOF(hit_filter_ion);
[rtI_tof1,~] = histcounts(i_tof_new,Yedges);

rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.ions.C1= macro.filter.write_coincidence_condition(1, 'det2');
rtN.ions.m2q.type             = 'discrete';
rtN.ions.m2q.data_pointer     = 'h.det2.m2q_l';
rtN.ions.m2q.value            = pair_m2q_l.hit2;
rtN.ions.m2q.translate_condition = 'hit1';
% rtN.ions.m2q.invert_filter     = false;

[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);
hit_filter_ion = filter.events_2_hits_det(e_filter_rtN, data_converted.e.raw(:,2), length(data_converted.h.det2.m2q),...
    rtN, data_converted); 
i_tof_new = data_converted.h.det2.TOF(hit_filter_ion);
[rtI_tof2,~] = histcounts(i_tof_new,Yedges);
%% define rtII(m2q1, m2q2)
rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.C2= macro.filter.write_coincidence_condition(2, 'det2');

rtN.ions.m2q.type             = 'discrete';
rtN.ions.m2q.data_pointer     = 'h.det2.m2q_l';
rtN.ions.m2q.value            = pair_m2q_l.hit1;
rtN.ions.m2q.translate_condition = 'hit1';

rtN.ions2.m2q.type             = 'discrete';
rtN.ions2.m2q.data_pointer     = 'h.det2.m2q_l';
rtN.ions2.m2q.value            = pair_m2q_l.hit2;
rtN.ions2.m2q.translate_condition = 'hit2';

[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);

hit_filter_rt_c2 = filter.events_2_hits(e_filter_rtN, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    rtN, data_converted);
rt_tof_c2= data_converted.h.det2.TOF(hit_filter_rt_c2.det2.filt); 

%%% the odd index values of et_m2q_c2 are m2q1%%%
% odd index values
rt_c2_tof1 = rt_tof_c2(1:2:end) ;
%%% the even index values of et_m2q_c2 are m2q2%%%
% even index values
rt_c2_tof2 = rt_tof_c2(2:2:end) ;
[rtII_tof1_tof2,~,~] = histcounts2(rt_c2_tof1,rt_c2_tof2,Yedges,Yedges);

%% define ES_0 
es0_cond.elec= macro.filter.write_coincidence_condition(1, 'det1'); %RND trigger
es0_cond.ions= macro.filter.write_coincidence_condition(0, 'det2');
[e_filter_ion0, ~]	= macro.filter.conditions_2_filter(data_converted,es0_cond);
hit_filter_c0 = filter.events_2_hits_det(e_filter_ion0, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
    es0_cond, data_converted); 
ES_zero_ion = data_converted.h.det1.KER(hit_filter_c0); %%pa
[ES_0,~] = histcounts(ES_zero_ion,Xedges);

%% summation in region J
BES1 = TetEI_x_tof1(ii).*rtI_tof2(jj) + TetEI_x_tof2(jj).*rtI_tof1(ii);
BES2(ii,jj) = rtII_tof1_tof2(ii,jj);
    
%% background BetEI_x_m2q
BES2IIpair_x_j = BES2(:).*ES_0;
% BetEI_x_m2q = kron((rtI_m2q./data_stats.N_RND)',(ES_0./data_stats.rtP_0));

% figure
% imagesc(Xedges,Yedges,BetEI_x_m2q')
% colorbar
% caxis([0 800])
% xlabel('Electron kinetic energy (eV)')
% ylabel('m2q (a.u.)')
% set(gca,'YDir','normal')
% title('BetEI(x,m2q)')

%% True pepicco
TetEI_x_m2q=TetEI_x_tof1 - BetEI_x_m2q;
% figure
% imagesc(Xedges,Yedges,TetEI_x_m2q')
% colorbar
% caxis([0 800])
% xlabel('Electron kinetic energy (eV)')
% ylabel('m2q (a.u.)')
% set(gca,'YDir','normal')
% title('TetEI(x,m2q)')
%%
figure
Xcenters = ESedges(1:end-1) + (diff(ESedges)/2);
plot(Xcenters,sum(TetEI_x_tof1,2),'DisplayName','etEI(x)')
hold on
% figure
plot(Xcenters,sum(BetEI_x_m2q,2),'DisplayName','BetEI(x)')
plot(Xcenters,sum(TetEI_x_m2q,2),'DisplayName','TetEI(x)')
legend
end