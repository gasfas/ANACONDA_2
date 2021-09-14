function [Tet_m2q2] = plot_pipico_m2q(data_converted, data_stats,mdata);
SC = data_stats.SC;
TP_0 =data_stats.TP_0;

%% Create m2q distribution
Binsize = 0.1; Binedges = 0: Binsize: 140;
Bincenters = Binedges(1:end-1) + diff(Binedges) / 2; %m2q values

%% Define etII(m2q1, m2q2)
etN.e_TRG.C1 = macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
etN.e_TRG.type	        = 'continuous';
etN.e_TRG.data_pointer	= 'h.det1.R';
etN.e_TRG.translate_condition = 'AND';
etN.e_TRG.value		= data_stats.e_R_range;

etN.ions= macro.filter.write_coincidence_condition(2, 'det2');
[e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);

hit_filter_et_c2 = filter.events_2_hits(e_filter_etN, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    etN, data_converted);

et_m2q_c2= data_converted.h.det2.m2q(hit_filter_et_c2.det2.filt); 

%%% the odd index values of et_m2q_c2 are m2q1%%%
% odd index values
et_c2_m2q1 = et_m2q_c2(1:2:end) ;
%%% the even index values of et_m2q_c2 are m2q2%%%
% even index values
et_c2_m2q2 = et_m2q_c2(2:2:end) ;


[et_m2q2,~,~] = histcounts2(et_c2_m2q1,et_c2_m2q2,Binedges,Binedges);
% figure
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',et_m2q2,'DisplayStyle','tile','ShowEmptyBins','on')
% colorbar
% title('etII(m2q1, m2q2)')
% xlabel('m2q_1 (a.u.)')
% ylabel('m2q_2 (a.u.)')
% axis equal
% caxis([0 10])
% xlim([4006 9670])
% ylim([4888 10553])

%% Projections : Ion m2q for C2 
m2q1_hist = sum(et_m2q2,2);
m2q2_hist = sum(et_m2q2,1);

% figure
% hold on
% plot(Bincenters, m2q1_hist,'LineWidth',1,'DisplayName','etII(m2q1)');
% plot(Bincenters, m2q2_hist,'LineWidth',1,'DisplayName','etII(m2q2)');
% title('etII(m2q1, m2q2) projections')
% legend

proj_et_m2q2 = m2q1_hist +m2q2_hist';
% plot(Bincenters, proj_et_m2q2,'LineWidth',1,'DisplayName','etII(m2q1)+etII(m2q2)');


%% Define rtII(m2q1, m2q2)
rtN.e_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %rnd trigger
rtN.ions= macro.filter.write_coincidence_condition(2, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);

hit_filter_rt_c2 = filter.events_2_hits(e_filter_rtN, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    rtN, data_converted);
rt_m2q_c2= data_converted.h.det2.m2q(hit_filter_rt_c2.det2.filt); 

%%% the odd index values of et_m2q_c2 are m2q1%%%
% odd index values
rt_c2_m2q1 = rt_m2q_c2(1:2:end) ;
%%% the even index values of et_m2q_c2 are m2q2%%%
% even index values
rt_c2_m2q2 = rt_m2q_c2(2:2:end) ;
[rt_m2q2,~,~] = histcounts2(rt_c2_m2q1,rt_c2_m2q2,Binedges,Binedges);
% figure
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',rt_m2q2,'DisplayStyle','tile','ShowEmptyBins','on')
% colorbar
% title('rtII(m2q1, m2q2)')
% xlabel('m2q_1 (a.u.)')
% ylabel('m2q_2 (a.u.)')
% axis equal

%% Define etI(m2q)
etN.e_TRG.C1 = macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
etN.e_TRG.type	        = 'continuous';
etN.e_TRG.data_pointer	= 'h.det1.R';
etN.e_TRG.translate_condition = 'AND';
etN.e_TRG.value		= data_stats.e_R_range;

etN.ions= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);

hit_filter_et_c1 = filter.events_2_hits(e_filter_etN, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    etN, data_converted);

et_m2q_c1= data_converted.h.det2.m2q(hit_filter_et_c1.det2.filt);

et_m2q1= histcounts(et_m2q_c1, Binedges);%,'Normalization','probability');


%% Define rtI(m2q)
rtN.e_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %rnd trigger
rtN.ions= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);

hit_filter_rt_c1 = filter.events_2_hits(e_filter_rtN, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    rtN, data_converted);

rt_m2q_c1= data_converted.h.det2.m2q(hit_filter_rt_c1.det2.filt);

rt_m2q1= histcounts(rt_m2q_c1, Binedges);%,'Normalization','probability');


%% BetI(m2q) & TetI(m2q) 
Bet_m2q1 = SC.* TP_0 .*rt_m2q1;
Tet_m2q1 = et_m2q1 - Bet_m2q1;
% figure
% hold on
% plot(Bincenters, et_m2q1,'LineWidth',1,'DisplayName','etI(m2q)'); 
% plot(Bincenters, Bet_m2q1,'LineWidth',1,'DisplayName','BetI(m2q)'); 
% plot(Bincenters, Tet_m2q1,'LineWidth',1,'DisplayName','TetI(m2q)'); 
% title('TetI(m2q)')
% legend
% ylim([-100 2500])

%% Calculate the Background BetII(m2q1,m2q2)
Bet_m2q2= zeros(length(Bincenters));
for ii= 1:length(Bincenters)
    for jj = 1:length(Bincenters)
        if Bincenters(ii) < Bincenters (jj)
            a = (et_m2q1(ii)*rt_m2q1(jj) + et_m2q1(jj)*rt_m2q1(ii))/(data_stats.rtP_0*data_stats.N_RND);
            b = (2* SC * TP_0 *rt_m2q1(ii)*rt_m2q1(jj))/(data_stats.rtP_0*data_stats.N_RND);
            Bet_m2q2(ii,jj) = SC .* TP_0.* rt_m2q2(ii,jj) + a - b;
        else 
            Bet_m2q2(ii,jj) = 0;
        end
    end
end
Bet_m2q2=max(Bet_m2q2,0);
% figure
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',Bet_m2q2,'DisplayStyle','tile','ShowEmptyBins','on')
% colorbar
% title('BetII(m2q1, m2q2)')
% xlabel('m2q_1 (a.u.)')
% ylabel('m2q_2 (a.u.)')
% axis equal
% caxis([0 10])

%% Final filter True 2D map
Tet_m2q2 = et_m2q2 - Bet_m2q2;
Tet_m2q2 = max(Tet_m2q2,0);
figure
histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',Tet_m2q2,'DisplayStyle','tile','ShowEmptyBins','on')
colorbar
title('TetII(m2q1, m2q2)')
xlabel('m2q_1 (a.u.)')
ylabel('m2q_2 (a.u.)')
xticks([mdata.conv.det2.m2q_label.labels])
yticks([mdata.conv.det2.m2q_label.labels])
axis equal
% caxis([0 10])

% xlim([4006 9670])
% ylim([4888 10553])
% caxis([0 4])
% xlim([4388 6221])
% ylim([7543 9376])

%% Projections : Ion m2q for C2 
m2q1_hist = sum(Tet_m2q2,2);
m2q2_hist = sum(Tet_m2q2,1);

% figure
% hold on
% plot(Bincenters, m2q1_hist,'LineWidth',1,'DisplayName','TetII(m2q1)');
% plot(Bincenters, m2q2_hist,'LineWidth',1,'DisplayName','TetII(m2q2)');
% title('TetII(m2q1, m2q2) projections')
% xticks([mdata.conv.det2.m2q_label.labels])
% legend

proj_Tet_m2q2 = m2q1_hist +m2q2_hist';

% plot(Bincenters, proj_Tet_m2q2,'LineWidth',1,'DisplayName','TetII(m2q1)+TetII(m2q2)');
% figure 
% hold on
% plot(Bincenters, proj_et_m2q2,'LineWidth',1,'DisplayName','etII(m2q1)+etII(m2q2)');
% plot(Bincenters, proj_Tet_m2q2,'LineWidth',1,'DisplayName','TetII(m2q1)+TetII(m2q2)');
% legend
end
