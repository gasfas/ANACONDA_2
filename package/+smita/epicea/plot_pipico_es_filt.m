function [Tet_tof2,Bincenters] = plot_pipico_es_filt(data_converted, mdata, data_stats, e_KER_range);
SC = data_stats.SC;
TP_0 =data_stats.TP_0;

%% Create TOF distribution
Binsize = 15; Binedges = 2000: Binsize: 11e3;
% Binsize = 0.1; Binedges = 10: Binsize: 140;
Bincenters = Binedges(1:end-1) + diff(Binedges) / 2; %tof values

%% Define etII(tof1, tof2)
etN.e_TRG.C1 = macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
etN.e_TRG.type	        = 'continuous';
etN.e_TRG.data_pointer	= 'h.det1.KER';
etN.e_TRG.translate_condition = 'AND';
etN.e_TRG.value		= e_KER_range;

etN.ions= macro.filter.write_coincidence_condition(2, 'det2');
[e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);

hit_filter_et_c2 = filter.events_2_hits(e_filter_etN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    etN, data_converted);

et_tof_c2= data_converted.h.det2.TOF(hit_filter_et_c2.det2.filt); 
% et_tof_c2= data_converted.h.det2.m2q(hit_filter_et_c2.det2.filt); 

%%% the odd index values of et_tof_c2 are tof1%%%
% odd index values
et_c2_tof1 = et_tof_c2(1:2:end) ;
%%% the even index values of et_tof_c2 are tof2%%%
% even index values
et_c2_tof2 = et_tof_c2(2:2:end) ;


[et_tof2,~,~] = histcounts2(et_c2_tof1,et_c2_tof2,Binedges,Binedges);
% figure
% subplot(1,3,1)
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',et_tof2,'DisplayStyle','tile','ShowEmptyBins','on')
% % colorbar
% title('etII(tof1, tof2)')
% xlabel('TOF_1 (ns)')
% ylabel('TOF_2 (ns)')
% axis equal
% xlim([2000 10000])
% ylim([2000 10000])
% caxis([0 5])
% xlim([4006 9670])
% ylim([4888 10553])

%% Projections : Ion TOF for C2 
tof1_hist = sum(et_tof2,2);
tof2_hist = sum(et_tof2,1);

% figure
% hold on
% plot(Bincenters, tof1_hist,'LineWidth',1,'DisplayName','etII(tof1)');
% plot(Bincenters, tof2_hist,'LineWidth',1,'DisplayName','etII(tof2)');
% title('etII(tof1, tof2) projections')
% legend

proj_et_tof2 = tof1_hist +tof2_hist';
% plot(Bincenters, proj_et_tof2,'LineWidth',1,'DisplayName','etII(tof1)+etII(tof2)');


%% Define rtII(tof1, tof2)
rtN.e_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %rnd trigger
rtN.ions= macro.filter.write_coincidence_condition(2, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);

hit_filter_rt_c2 = filter.events_2_hits(e_filter_rtN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    rtN, data_converted);
rt_tof_c2= data_converted.h.det2.TOF(hit_filter_rt_c2.det2.filt); 
% rt_tof_c2= data_converted.h.det2.m2q(hit_filter_rt_c2.det2.filt); 

%%% the odd index values of et_tof_c2 are tof1%%%
% odd index values
rt_c2_tof1 = rt_tof_c2(1:2:end) ;
%%% the even index values of et_tof_c2 are tof2%%%
% even index values
rt_c2_tof2 = rt_tof_c2(2:2:end) ;
[rt_tof2,~,~] = histcounts2(rt_c2_tof1,rt_c2_tof2,Binedges,Binedges);
% figure
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',rt_tof2,'DisplayStyle','tile','ShowEmptyBins','on')
% colorbar
% title('rtII(tof1, tof2)')
% xlabel('TOF_1 (ns)')
% ylabel('TOF_2 (ns)')
% axis equal

%% Define etI(tof)
etN.e_TRG.C1 = macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
etN.e_TRG.type	        = 'continuous';
etN.e_TRG.data_pointer	= 'h.det1.KER';
etN.e_TRG.translate_condition = 'AND';
etN.e_TRG.value		= data_stats.e_KER_range;

etN.ions= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);

hit_filter_et_c1 = filter.events_2_hits(e_filter_etN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    etN, data_converted);

et_tof_c1= data_converted.h.det2.TOF(hit_filter_et_c1.det2.filt);
% et_tof_c1= data_converted.h.det2.m2q(hit_filter_et_c1.det2.filt);

et_tof1= histcounts(et_tof_c1, Binedges);%,'Normalization','probability');


%% Define rtI(tof)
rtN.e_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %rnd trigger
rtN.ions= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);

hit_filter_rt_c1 = filter.events_2_hits(e_filter_rtN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    rtN, data_converted);

rt_tof_c1= data_converted.h.det2.TOF(hit_filter_rt_c1.det2.filt);
% rt_tof_c1= data_converted.h.det2.m2q(hit_filter_rt_c1.det2.filt);

rt_tof1= histcounts(rt_tof_c1, Binedges);%,'Normalization','probability');


%% BetI(tof) & TetI(tof) 
Bet_tof1 = SC.* TP_0 .*rt_tof1;
Tet_tof1 = et_tof1 - Bet_tof1;
% figure
% hold on
% plot(Bincenters, et_tof1,'LineWidth',1,'DisplayName','etI(tof)'); 
% plot(Bincenters, Bet_tof1,'LineWidth',1,'DisplayName','BetI(tof)'); 
% plot(Bincenters, Tet_tof1,'LineWidth',1,'DisplayName','TetI(tof)'); 
% title('TetI(tof)')
% legend
% ylim([-100 2500])

%% Calculate the Background BetII(tof1,tof2)
Bet_tof2= zeros(length(Bincenters));
for ii= 1:length(Bincenters)
    for jj = 1:length(Bincenters)
        if Bincenters(ii) < Bincenters (jj)
            a = (et_tof1(ii)*rt_tof1(jj) + et_tof1(jj)*rt_tof1(ii))/(data_stats.rtP_0*data_stats.N_RND);
            b = (2* SC * TP_0 *rt_tof1(ii)*rt_tof1(jj))/(data_stats.rtP_0*data_stats.N_RND);
            Bet_tof2(ii,jj) = SC .* TP_0.* rt_tof2(ii,jj) + a - b;
        else 
            Bet_tof2(ii,jj) = 0;
        end
    end
end
Bet_tof2=max(Bet_tof2,0);
% figure
% subplot(1,3,2)
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',Bet_tof2,'DisplayStyle','tile','ShowEmptyBins','on')
% % colorbar
% title('BetII(tof1, tof2)')
% xlabel('TOF_1 (ns)')
% ylabel('TOF_2 (ns)')
% axis equal
% xlim([2000 10000])
% ylim([2000 10000])
% caxis([0 5])

%% Final filter True 2D map
Tet_tof2 = et_tof2 - Bet_tof2;
Tet_tof2 = max(Tet_tof2,0);
% figure
% set(gcf,'Visible','on')
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',Tet_tof2,'DisplayStyle','tile','ShowEmptyBins','on')
% colorbar
% title('TetII(tof1, tof2)')
% xlabel('TOF_1 (ns)')
% ylabel('TOF_2 (ns)')
% axis equal
% caxis([0 5])

% figure
% subplot(1,3,3)
% set(gcf,'Visible','on')
% histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',Tet_tof2,'DisplayStyle','tile','ShowEmptyBins','on')
% caxis([0 5])
Tet_tof2_new = imresize(Tet_tof2,0.5);
Bincenters_new = imresize(Bincenters,0.5);
surface(Bincenters_new, Bincenters_new, Tet_tof2_new'); shading interp
% colorbar
caxis([0 2])
title('TetII(tof1, tof2)')
xlabel('TOF_1 (ns)')
ylabel('TOF_2 (ns)')
axis equal tight

xlim([3200 6000]) %4200
ylim([3200 9000])

x1 =convert.m2q_2_TOF(12*2+3,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
x2 =convert.m2q_2_TOF(12*2+5,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
x3 =convert.m2q_2_TOF(12*3+3,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
x4 =convert.m2q_2_TOF(12*3+5,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
x5 =convert.m2q_2_TOF(12*1+3,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
xline(x1, '--w');xline(x2,'--w');xline(x3,'--w');xline(x4,'--w');xline(x5,'--w');

y1 =convert.m2q_2_TOF(12*3+3,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y2 =convert.m2q_2_TOF(12*3+5,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y3 =convert.m2q_2_TOF(12*4+3,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y4 =convert.m2q_2_TOF(12*4+5,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y5 =convert.m2q_2_TOF(12*5+3,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y6 =convert.m2q_2_TOF(12*5+5,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y7 =convert.m2q_2_TOF(12*6+5,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y8 =convert.m2q_2_TOF(12*6+7,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y9 =convert.m2q_2_TOF(12*7+7,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y10 =convert.m2q_2_TOF(12*4+7,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y11 =convert.m2q_2_TOF(12*5+7,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y12 =convert.m2q_2_TOF(12*8+11,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y13 =convert.m2q_2_TOF(12*2+3,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
y14 =convert.m2q_2_TOF(12*2+5,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);

yline(y1, '--w');yline(y2,'--w');yline(y3,'--w');yline(y4,'--w');
yline(y5, '--w');yline(y6,'--w');yline(y7,'--w');yline(y8,'--w');
yline(y9, '--w');yline(y10,'--w');yline(y11,'--w');yline(y12,'--w');yline(y13,'--w');
yline(y14,'--w');


% xlim([3000 10000])
% ylim([3000 10000])
% caxis([0 4])
% xlim([4388 6221])
% ylim([7543 9376])

%% Projections : Ion TOF for C2 
tof1_hist = sum(Tet_tof2,2);
tof2_hist = sum(Tet_tof2,1);

% figure
% hold on
% plot(Bincenters, tof1_hist,'LineWidth',1,'DisplayName','TetII(tof1)');
% plot(Bincenters, tof2_hist,'LineWidth',1,'DisplayName','TetII(tof2)');
% title('TetII(tof1, tof2) projections')
% legend

proj_Tet_tof2 = smooth(tof1_hist +tof2_hist');

% plot(Bincenters, (proj_Tet_tof2./max(proj_Tet_tof2)),'LineWidth',2,'DisplayName','TetII(tof1)+TetII(tof2)');
% figure 
% hold on
% plot(Bincenters, proj_et_tof2,'LineWidth',1,'DisplayName','etII(tof1)+etII(tof2)');
% plot(Bincenters, proj_Tet_tof2,'LineWidth',1,'DisplayName','TetII(tof1)+TetII(tof2)');
% legend
end
