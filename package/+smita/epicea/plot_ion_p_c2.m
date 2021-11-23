function [] = plot_ion_p_c2(data_converted, data_stats, mdata,m2q_1,m2q_2)
%%This function plots the filtered Ion Kinetic energy
%% define the event of ion condition
    
ion.C2			= macro.filter.write_coincidence_condition(2, 'det2');
ion.hit1.type				= 'discrete';
ion.hit1.data_pointer		= 'h.det2.m2q_l';
ion.hit1.value				= m2q_1;
ion.hit1.translate_condition = 'hit1';

ion.hit2.type					= 'discrete';
ion.hit2.data_pointer			= 'h.det2.m2q_l';
ion.hit2.value				= m2q_2;
ion.hit2.translate_condition	= 'hit2';

% ion.hit1.type				= 'continuous';
% ion.hit1.data_pointer		= 'h.det2.m2q';
% ion.hit1.value				= [27.9;30.1];
% ion.hit1.translate_condition = 'hit1';
% 
% ion.hit2.type					= 'continuous';
% ion.hit2.data_pointer			= 'h.det2.m2q';
% ion.hit2.value				= [104.8;109];
% ion.hit2.translate_condition	= 'hit2';

%% get the event filters
%electron triggered events
    e_TRG.e.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
    e_TRG.e.type	        = 'continuous';
    e_TRG.e.data_pointer	= 'h.det1.R';
    e_TRG.e.translate_condition = 'AND';
    e_TRG.e.value		= data_stats.e_R_range;
    e_TRG.ion = ion;
    [e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
%rnd trigerred events
    RND_TRG.e= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger
    RND_TRG.ion = ion;
    [e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted,RND_TRG);
    
%% visualise the pipico
mdata.plot.det2.ifdo =[];
mdata.plot.det2.ifdo.m2q_hit1_hit2 = 1;
mdata.plot.det2.m2q_hit1_hit2.cond = ion;
macro.plot(data_converted,mdata);

%% calculate the event property : dp_sum
et_dp_sum = data_converted.e.det2.dp_sum_norm(e_filter_et);
rt_dp_sum = data_converted.e.det2.dp_sum_norm(e_filter_rt);
%get the histograms
Binsize = 5; Binedges = -0.01: Binsize: 200;
Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;

et_dp_sum_hist= histcounts(et_dp_sum, Binedges);%,'Normalization','probability');
rt_dp_sum_hist= histcounts(rt_dp_sum, Binedges);%,'Normalization','probability');

Tet_dp_sum = et_dp_sum_hist - data_stats.SC.* rt_dp_sum_hist;
Tet_dp_sum_error = sqrt(et_dp_sum_hist + (data_stats.SC.^2).* rt_dp_sum_hist);

figure
% subplot(3,1,1)
plot(Bincenters, et_dp_sum_hist,'LineWidth',1,'DisplayName','etAI(p_{sum})')
hold on
plot(Bincenters, data_stats.SC.*rt_dp_sum_hist,'LineWidth',1,'DisplayName','SC*rtAI(p_{sum})' )
errorbar(Bincenters,Tet_dp_sum ,Tet_dp_sum_error, 'LineWidth',1, 'DisplayName','TetAI(p_{sum})')
xlabel('|p_1 + p_2| (a.u.)')
legend
title('Total momentum')
figure
%% hit1 momentum

e_TRG.hit_to_show.det = 'det2';
e_TRG.hit_to_show.value = ion.hit1.value;

et_hit1 = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    e_TRG, data_converted);
et_hit1_p= data_converted.h.det2.dp_norm(et_hit1.det2.filt); 

RND_TRG.hit_to_show.det = 'det2';
RND_TRG.hit_to_show.value = ion.hit1.value;

rt_hit1 = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    RND_TRG, data_converted);
rt_hit1_p= data_converted.h.det2.dp_norm(rt_hit1.det2.filt); 

%make histogram
et_hit1_p_hist= histcounts(et_hit1_p, Binedges);%,'Normalization','probability');
rt_hit1_p_hist= histcounts(rt_hit1_p, Binedges);%,'Normalization','probability');

Tet_hit1_p = et_hit1_p_hist - data_stats.SC.* rt_hit1_p_hist;
Tet_hit1_p_error = sqrt(et_hit1_p_hist + (data_stats.SC.^2).* rt_hit1_p_hist);


subplot(3,1,2)
plot(Bincenters, et_hit1_p_hist,'LineWidth',1,'DisplayName','etAI(p)')
hold on
plot(Bincenters, data_stats.SC.*rt_hit1_p_hist,'LineWidth',1,'DisplayName','SC*rtAI(p)' )
errorbar(Bincenters,Tet_hit1_p ,Tet_hit1_p_error, 'LineWidth',1, 'DisplayName','TetAI(p)')
xlabel('|p_1| (a.u.)')
legend
title('hit1 momentum')
%% hit2 momentum

e_TRG.hit_to_show.det = 'det2';
e_TRG.hit_to_show.value = ion.hit2.value;

et_hit2 = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    e_TRG, data_converted);
et_hit2_p= data_converted.h.det2.dp_norm(et_hit2.det2.filt); 

RND_TRG.hit_to_show.det = 'det2';
RND_TRG.hit_to_show.value = ion.hit2.value;

rt_hit2 = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    RND_TRG, data_converted);
rt_hit2_p= data_converted.h.det2.dp_norm(rt_hit2.det2.filt); 

%make histogram
et_hit2_p_hist= histcounts(et_hit2_p, Binedges);%,'Normalization','probability');
rt_hit2_p_hist= histcounts(rt_hit2_p, Binedges);%,'Normalization','probability');

Tet_hit2_p = et_hit2_p_hist - data_stats.SC.* rt_hit2_p_hist;
Tet_hit2_p_error = sqrt(et_hit2_p_hist + (data_stats.SC.^2).* rt_hit2_p_hist);

subplot(3,1,3)
plot(Bincenters, et_hit2_p_hist,'LineWidth',1,'DisplayName','etAI(p)')
hold on
plot(Bincenters, data_stats.SC.*rt_hit2_p_hist,'LineWidth',1,'DisplayName','SC*rtAI(p)' )
errorbar(Bincenters,Tet_hit2_p ,Tet_hit2_p_error, 'LineWidth',1, 'DisplayName','TetAI(p)')
xlabel('|p_2| (a.u.)')
legend
title('hit2 momentum')

end