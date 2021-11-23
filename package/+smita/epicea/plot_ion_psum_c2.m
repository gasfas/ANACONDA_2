function [Tet_dp_norm,Tet_dp_norm_error] = plot_ion_psum_c2(data_converted, data_stats,roi)
%%This function plots the filtered sum of momemtum of events in roi
%% from roi
tof_1 =[roi.Center(1)-500 ; roi.Center(1)+500];
tof_2 =[roi.Center(2)-500 ; roi.Center(2)+500];
ion.C2			= macro.filter.write_coincidence_condition(2, 'det2');
ion.hit1.type				= 'continuous';
ion.hit1.data_pointer		= 'h.det2.TOF';
ion.hit1.value				= tof_1;
ion.hit1.translate_condition = 'hit1';

ion.hit2.type					= 'continuous';
ion.hit2.data_pointer			= 'h.det2.TOF';
ion.hit2.value				= tof_2;
ion.hit2.translate_condition	= 'hit2';
% 
% hit_to_show.det = 'det2';
% hit_to_show.value = ion.hit2.value;
%%
    e_TRG.e.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
    e_TRG.e.type	        = 'continuous';
    e_TRG.e.data_pointer	= 'h.det1.R';
    e_TRG.e.translate_condition = 'AND';
    e_TRG.e.value		= data_stats.e_R_range;
    e_TRG.ion = ion;
%     e_TRG.hit_to_show = hit_to_show;
[e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
hit_filter_pair_c2 = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    e_TRG, data_converted);
et_tof_c2= data_converted.h.det2.TOF(hit_filter_pair_c2.det2.filt);
et_ker_c2= data_converted.h.det2.KER(hit_filter_pair_c2.det2.filt); 

%%% the odd index values of et_m2q_c2 are m2q1%%%
% odd index values
et_c2_tof1 = et_tof_c2(1:2:end) ;
et_ker1 = et_ker_c2(1:2:end) ;
%%% the even index values of et_m2q_c2 are m2q2%%%
% even index values
et_c2_tof2 = et_tof_c2(2:2:end) ;
et_ker2 = et_ker_c2(2:2:end) ;

et_filter_roi = inROI(roi,double(et_c2_tof1),double(et_c2_tof2));
et_ker1 = et_ker1(et_filter_roi);
et_ker2 = et_ker2(et_filter_roi);

et_total_ker = et_ker1 + et_ker2;
% [e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
% [e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted, RND_TRG);
%%
RND_TRG.e= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger
RND_TRG.ion = ion;
%     RND_TRG.hit_to_show =hit_to_show;

[e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted,RND_TRG);
hit_filter_pair_c2 = filter.events_2_hits(e_filter_rt, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    RND_TRG, data_converted);
rt_tof_c2= data_converted.h.det2.TOF(hit_filter_pair_c2.det2.filt); 
rt_ker_c2 =data_converted.h.det2.KER(hit_filter_pair_c2.det2.filt); 

%%% the odd index values of et_m2q_c2 are m2q1%%%
% odd index values
rt_c2_tof1 = rt_tof_c2(1:2:end) ;
rt_ker1 = rt_ker_c2(1:2:end) ;
%%% the even index values of et_m2q_c2 are m2q2%%%
% even index values
rt_c2_tof2 = rt_tof_c2(2:2:end) ;
rt_ker2 = rt_ker_c2(2:2:end) ;

rt_filter_roi = inROI(roi,double(rt_c2_tof1),double(rt_c2_tof2));
rt_ker1 = rt_ker1(rt_filter_roi);
rt_ker2 = rt_ker2(rt_filter_roi);

rt_total_ker = rt_ker1 + rt_ker2;

%% Define total ker
% Binsize = 10; Binedges = -0.01: Binsize: 200;
Binsize = 0.2; Binedges = -0.01: Binsize: 5;

Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
et_ker_hist1= histcounts(et_total_ker, Binedges);%,'Normalization','probability');
rt_ker_hist1= histcounts(rt_total_ker, Binedges);%,'Normalization','probability');
%% Filter 
Tet_ker1 = et_ker_hist1 - data_stats.SC.* rt_ker_hist1;
Tet_ker_error1 = sqrt(et_ker_hist1 + (data_stats.SC.^2).* rt_ker_hist1);
%% plotting
figure
subplot(3,1,1)
plot(Bincenters, et_ker_hist1,'LineWidth',1,'DisplayName','etAI(ker)')
hold on
plot(Bincenters, data_stats.SC.*rt_ker_hist1,'LineWidth',1,'DisplayName','SC*rtAI(ker)' )
errorbar(Bincenters,Tet_ker1 ,Tet_ker_error1, 'LineWidth',1, 'DisplayName','TetAI(ker)')
xlabel('ker (a.u.)')
legend
title('Total ker')
%% hit1 make histogram1

% Binsize = 10; Binedges = -0.01: Binsize: 200;
% Binsize = 0.1; Binedges = -0.01: Binsize: 3;

Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
et_ker_hist1= histcounts(et_ker1, Binedges);%,'Normalization','probability');
rt_ker_hist1= histcounts(rt_ker1, Binedges);%,'Normalization','probability');
%% Filter 
Tet_ker1 = et_ker_hist1 - data_stats.SC.* rt_ker_hist1;
Tet_ker_error1 = sqrt(et_ker_hist1 + (data_stats.SC.^2).* rt_ker_hist1);
%% plotting

subplot(3,1,2)
plot(Bincenters, et_ker_hist1,'LineWidth',1,'DisplayName','etAI(ker)')
hold on
plot(Bincenters, data_stats.SC.*rt_ker_hist1,'LineWidth',1,'DisplayName','SC*rtAI(ker)' )
errorbar(Bincenters,Tet_ker1 ,Tet_ker_error1, 'LineWidth',1, 'DisplayName','TetAI(ker)')
xlabel('ker (a.u.)')
legend
title('hit1')

%% hit2 make histogram2
% Binsize = 10; Binedges = -0.01: Binsize: 200;
% Binsize = 0.1; Binedges = -0.01: Binsize: 3;
% Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
et_ker_hist2= histcounts(et_ker2, Binedges);%,'Normalization','probability');
rt_ker_hist2= histcounts(rt_ker2, Binedges);%,'Normalization','probability');

Tet_ker2 = et_ker_hist2 - data_stats.SC.* rt_ker_hist2;
Tet_ker_error2 = sqrt(et_ker_hist2 + (data_stats.SC.^2).* rt_ker_hist2);
%% plotting
subplot(3,1,3)
plot(Bincenters, et_ker_hist2,'LineWidth',1,'DisplayName','etAI(ker)')
hold on
plot(Bincenters, data_stats.SC.*rt_ker_hist2,'LineWidth',1,'DisplayName','SC*rtAI(ker)' )
errorbar(Bincenters,Tet_ker2 ,Tet_ker_error2, 'LineWidth',1,'DisplayName','TetAI(ker)')
xlabel('ker (a.u.)')
legend
title('hit2')

end