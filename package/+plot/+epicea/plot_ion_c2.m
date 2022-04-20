function [Tet_ev_mean,Tet_ev_std,Tet_ev_mode] = plot_ion_c2(data_converted, data_stats,e_filter_roi,plot_signal,m2q_1,m2q_2)
%%This function plots the filtered Ion Kinetic energy of the events in for 
%events in the roi selected in pipico (TOF-TOF) plot. 

% Input:
% data_converted:       The converted data struct
% data_stats: Data statistics containing the Scaling factor for filtering
% roi :                 Region of interest selected in PIPICO TOF TOF plot

% Output:
%kinetic energy plots
% Written by Smita Ganguly, 2021, Lund university: smita.ganguly(at)sljus.lu.se
%% get event filter from roi & define e_trig and rnd_trig event filters
%%%%%% electron trigger%%%%%%%%%%%
e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
e_TRG.e.type	        = 'continuous';
e_TRG.e.data_pointer	= 'h.det1.R';
e_TRG.e.translate_condition = 'AND';
e_TRG.e.value		= data_stats.e_R_range;

e_TRG.ion.C2			= macro.filter.write_coincidence_condition(2, 'det2');
e_TRG.ion.hit1.type				= 'discrete';
e_TRG.ion.hit1.data_pointer		= 'h.det2.m2q_l';
e_TRG.ion.hit1.value				= m2q_1;%[12*2+5];
e_TRG.ion.hit1.translate_condition = 'hit1';
e_TRG.ion.hit2.type					= 'discrete';
e_TRG.ion.hit2.data_pointer			= 'h.det2.m2q_l';
e_TRG.ion.hit2.value					= m2q_2;%12*8+11;
e_TRG.ion.hit2.translate_condition	= 'hit2';

[e_filter_e_TRG, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);

%%%%%% RND trigger%%%%%%%%%%%
RND_TRG.e= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger
RND_TRG.ion =e_TRG.ion;

[e_filter_RND_TRG, ~]	= macro.filter.conditions_2_filter(data_converted,RND_TRG);
%%%% final event filters
e_filter_et = and(e_filter_roi , e_filter_e_TRG);
e_filter_rt = and(e_filter_roi , e_filter_RND_TRG);
% e_filter_et = and(e_filter_roi , ~or(e_filter_et,e_filter_rt));
% 
% hit_filter_e_c2 = filter.events_2_hits_det(e_filter_et, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
%     RND_TRG, data_converted); 
% ES_2_ion = data_converted.h.det1.KER(hit_filter_e_c2);
%% get hit filters from event filters
hit_filter_et = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    e_TRG, data_converted);
hit_filter_rt = filter.events_2_hits(e_filter_rt, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    RND_TRG, data_converted);
%% bins
Binedges = plot_signal.Range(1): plot_signal.Binsize: plot_signal.Range(2);
Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
%% plot hit property?
if isfield(plot_signal,'hit')
    %% define hit signals
    hit_signal =eval(plot_signal.hit.data_pointer); 
    %% filter the signals
    hit_signal_et= hit_signal(hit_filter_et.det2.filt); 
    hit_signal_rt= hit_signal(hit_filter_rt.det2.filt); 

    %% create the hit property plots
    %%%%%hit1%%%%%%%%% %odd values
    et_hit1_hist= histcounts(hit_signal_et(1:2:end), Binedges);%,'Normalization','probability');
    rt_hit1_hist= histcounts(hit_signal_rt(1:2:end), Binedges);%,'Normalization','probability');

%     Tet_hit1 = et_hit1_hist - data_stats.SC.* rt_hit1_hist;
    Tet_hit1 = et_hit1_hist - data_stats.SC.* data_stats.TP_0.* rt_hit1_hist;

    Tet_hit1_error = sqrt(et_hit1_hist + (data_stats.SC.^2.* data_stats.TP_0.^2).* rt_hit1_hist);
    %%%%%%plotting%%%%%%%%%%
%     figure
%     subplot(2,1,1)
%     plot(Bincenters, et_hit1_hist,'LineWidth',1,'DisplayName','etAI(x)')
    hold on
%     plot(Bincenters, data_stats.SC.* data_stats.TP_0.* rt_hit1_hist,'LineWidth',1,'DisplayName','SC*rtAI(x)' )
    plot(Bincenters,Tet_hit1./sum(Tet_hit1), 'LineWidth',2, 'DisplayName','hit 1','LineStyle',':')
%     errorbar(Bincenters,Tet_hit1./sum(Tet_hit1) ,Tet_hit1_error./sum(Tet_hit1), 'LineWidth',1, 'DisplayName','hit 1')
%     xlabel(plot_signal.hit.label)
    
    %%%%%hit2%%%%%%%%% %even values
    et_hit2_hist= histcounts(hit_signal_et(2:2:end), Binedges);%,'Normalization','probability');
    rt_hit2_hist= histcounts(hit_signal_et(2:2:end), Binedges);%,'Normalization','probability');

    Tet_hit2 = et_hit2_hist - data_stats.SC.* data_stats.TP_0.* rt_hit2_hist;
    Tet_hit2_error = sqrt(et_hit2_hist + (data_stats.SC.^2.* data_stats.TP_0.^2).* rt_hit2_hist);
    %%%%%%plotting%%%%%%%%%%
%     subplot(2,1,2)
%     plot(Bincenters, et_hit2_hist,'LineWidth',1,'DisplayName','etAI(x)')
    hold on
%     plot(Bincenters, data_stats.SC.* data_stats.TP_0.*rt_hit2_hist,'LineWidth',1,'DisplayName','SC*rtAI(x)' )
    plot(Bincenters,Tet_hit2./sum(Tet_hit2), 'LineWidth',2, 'DisplayName','hit 2','LineStyle',':')
%     errorbar(Bincenters,Tet_hit2./sum(Tet_hit2) ,Tet_hit2_error./sum(Tet_hit2), 'LineWidth',1, 'DisplayName','hit 2')
%     xlabel(plot_signal.hit.label)
%         legend(['hit 1';'hit 2'])
%     fprintf('The number of true events in ROI are %0.0f\n',sum(Tet_hit2))

%     title('hit 2')
end
if isfield(plot_signal,'event')
    event_signal =eval(plot_signal.event.data_pointer); 
    
    event_signal_et = event_signal(e_filter_et);
    event_signal_rt = event_signal(e_filter_rt);

    %% create the event property plots
    et_ev_hist= histcounts(event_signal_et, Binedges);%,'Normalization','probability');
    rt_ev_hist= histcounts(event_signal_rt, Binedges);%,'Normalization','probability');

    Tet_ev = et_ev_hist - data_stats.SC.* data_stats.TP_0.* rt_ev_hist;
    Tet_ev_error = sqrt(et_ev_hist + (data_stats.SC.^2 .* data_stats.TP_0.^2).* rt_ev_hist);
    %%%%%%plotting%%%%%%%%%%
%         subplot(2,1,2)
    Tet_ev =max(Tet_ev,0);
    Tet_ev(Tet_ev < max(Tet_ev)/10)=0;
%     Tet_ev((Tet_ev-Tet_ev_error)<0)=0;

%     plot(Bincenters, et_ev_hist,'LineWidth',2,'DisplayName','etAI(x)')
%     hold on
%     plot(Bincenters, data_stats.SC.* data_stats.TP_0.* rt_ev_hist,'LineWidth',2,'DisplayName','SC*rtAI(x)' )
%     errorbar(Bincenters,Tet_ev./sum(Tet_ev),Tet_ev_error./sum(Tet_ev), '-k','LineWidth',2, 'DisplayName','Total KER')
%     xlabel(plot_signal.event.label)
%     legend
%     xpdf = repelem(Bincenters,round(Tet_ev));
%     [dip, p_value, xlow, xup] = HartigansDipSignifTest(xpdf, 200); 

    Tet_ev_mean = sum(Tet_ev.*Bincenters)/sum(Tet_ev);
    Tet_ev_mode = max(Bincenters(Tet_ev == max(Tet_ev)));
    Tet_ev_std = sqrt(sum(Tet_ev.*((Bincenters - Tet_ev_mean).^2))./(sum(Tet_ev).*((nnz(Tet_ev)-1)/nnz(Tet_ev))));
    
    errorbar(Bincenters,Tet_ev./sum(Tet_ev),Tet_ev_error./sum(Tet_ev), '-k','LineWidth',2, 'DisplayName','Total KER')
    xline(Tet_ev_mean)
% %     xline(Tet_ev_mode)
    yl= ylim;
    patch([Tet_ev_mean-Tet_ev_std,Tet_ev_mean-Tet_ev_std,Tet_ev_mean+Tet_ev_std,Tet_ev_mean+Tet_ev_std],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.2)
%     fprintf('Mean KER is %0.2f\n',Tet_ev_mean)

%     
%     xlabel(plot_signal.event.label)
%     legend
%     title('Event')
end
end