function [e_KE_mean,e_KE_std,e_KE_mode] = plot_ES_ion_pair_c2(data_converted, data_stats,roi,tof1,tof2,disp)
 tof_range =[2000 ; 11000];
%  tof1 = roi(:,1);  tof2 = roi(:,2);

%% define TetEI_x_tof 
[TetEI_x_tof,Xedges,Yedges] = get_pepico(data_converted, data_stats,tof_range);
Xcenters = Xedges(1:end-1) + (diff(Xedges)/2);
Ycenters = Yedges(1:end-1) + (diff(Yedges)/2);
%% define rtI
rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.C1= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);
hit_filter_ion = filter.events_2_hits_det(e_filter_rtN, data_converted.e.raw(:,2), length(data_converted.h.det2.m2q),...
    rtN, data_converted); 
i_tof_new = data_converted.h.det2.TOF(hit_filter_ion);
[rtI,~] = histcounts(i_tof_new,Yedges);

%% define rtII(tof1, tof2)
rtN =struct();
rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
rtN.C2= macro.filter.write_coincidence_condition(2, 'det2');

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
[rtII,~,~] = histcounts2(rt_c2_tof1,rt_c2_tof2,Yedges,Yedges);

%% define ES_0 
es0_cond.e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); %RND trigger
es0_cond.e_TRG.type	        = 'continuous';
es0_cond.e_TRG.data_pointer	= 'h.det1.R';
es0_cond.e_TRG.translate_condition = 'AND';
es0_cond.e_TRG.value		= data_stats.e_R_range;

es0_cond.ions= macro.filter.write_coincidence_condition(0, 'det2');
[e_filter_ion0, ~]	= macro.filter.conditions_2_filter(data_converted,es0_cond);
hit_filter_c0 = filter.events_2_hits_det(e_filter_ion0, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
    es0_cond, data_converted); 
ES_zero_ion = data_converted.h.det1.KER(hit_filter_c0); %%pa
[ES_0,~] = histcounts(ES_zero_ion,Xedges);

%% summation in region J background BetEI_x_J
tof1_index = find(Ycenters>tof1(1) & Ycenters<tof1(2));
tof2_index = find(Ycenters>tof2(1) & Ycenters<tof2(2));
% BES1 = NaN(length(tof1_index),length(tof2_index));
% BES2 = NaN(length(tof1_index),length(tof2_index));
BES2IIpair_x_j =NaN(length(tof1_index)*length(tof2_index),size(TetEI_x_tof,1));
kk =1;
for ii =1:length(tof1_index)
    for jj = 1:length(tof2_index)
        if inROI(roi,Ycenters(tof1_index(ii)),Ycenters(tof2_index(jj))) && Ycenters(tof1_index(ii)) < Ycenters(tof2_index(jj))
            t1 = tof1_index(ii); t2 = tof2_index(jj); 
            BES1 = (TetEI_x_tof(:,t1).*rtI(t2) + TetEI_x_tof(:,t2).*rtI(t1))./(data_stats.rtP_0*data_stats.N_RND);
            BES2 = rtII(t1,t2).*(data_stats.SC./data_stats.rtP_0);
        else
            BES1= 0; BES2=0;
        end
       BES2IIpair_x_j(kk,:) =  BES1' + (ES_0.*BES2)./data_stats.N_e;
       kk =kk+1;
    end
end
BES2IIpair_x = sum(BES2IIpair_x_j,1);
%% ES2IIpair_x_j
ES2IIpair.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
ES2IIpair.C2			= macro.filter.write_coincidence_condition(2, 'det2');

ES2IIpair.ion1.type				= 'continuous';
ES2IIpair.ion1.data_pointer		= 'h.det2.TOF';
ES2IIpair.ion1.value				= tof1;
ES2IIpair.ion1.translate_condition = 'hit1';

ES2IIpair.ion2.type					= 'continuous';
ES2IIpair.ion2.data_pointer			= 'h.det2.TOF';
ES2IIpair.ion2.value				= tof2;
ES2IIpair.ion2.translate_condition	= 'hit2';

[e_filter_ES2IIpair1, ~]	= macro.filter.conditions_2_filter(data_converted,ES2IIpair);
hit_filter_pair_c2 = filter.events_2_hits(e_filter_ES2IIpair1, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    ES2IIpair, data_converted);
et_tof_c2= data_converted.h.det2.TOF(hit_filter_pair_c2.det2.filt); 
%%% the odd index values of et_m2q_c2 are m2q1%%%
% odd index values
et_c2_tof1 = et_tof_c2(1:2:end) ;
%%% the even index values of et_m2q_c2 are m2q2%%%
% even index values
et_c2_tof2 = et_tof_c2(2:2:end) ;

hit_filter_e_c2 = filter.events_2_hits_det(e_filter_ES2IIpair1, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
    ES2IIpair, data_converted); 
ES_2_ion = data_converted.h.det1.KER(hit_filter_e_c2);

ES_2_ion = ES_2_ion(inROI(roi,double(et_c2_tof1),double(et_c2_tof2)));

[ES2IIpair_x,~] = histcounts(ES_2_ion,Xedges);

%% True ES
TES2IIpair_x = ES2IIpair_x -BES2IIpair_x;
TES2IIpair_x_error = sqrt(ES2IIpair_x + BES2IIpair_x);
%% filtering
TES2IIpair_x =max(TES2IIpair_x,0);
TES2IIpair_x(TES2IIpair_x < max(TES2IIpair_x)/5)=0;

TES2IIpair_x = TES2IIpair_x+disp;
e_KE_mean = sum(TES2IIpair_x.*Xcenters)/sum(TES2IIpair_x);
e_KE_mode = max(Xcenters(TES2IIpair_x == max(TES2IIpair_x)));
e_KE_std = sqrt(sum(TES2IIpair_x.*((Xcenters - e_KE_mean).^2))./(sum(TES2IIpair_x).*((nnz(TES2IIpair_x)-1)/nnz(TES2IIpair_x))));
% figure
% hold on
% plot(Xcenters,ES2IIpair_x,'LineWidth',1,'DisplayName','ES2IIpair_x_j(x)')
% plot(Xcenters,BES2IIpair_x,'LineWidth',1,'DisplayName','BES2IIpair_x_j(x)')% colorbar
% plot(Xcenters,TES2IIpair_x,'DisplayName','TES2IIpair_x_j(x)')% colorbar
% figure./sum(TES2IIpair_x)
%%
errorbar(Xcenters,TES2IIpair_x./max(TES2IIpair_x),TES2IIpair_x_error./max(TES2IIpair_x),'LineWidth',2,'DisplayName','TES2IIpair_x_j(x)','Color',[0 0 0])% 
hold on
xline(e_KE_mean)
yl= ylim;
patch([e_KE_mean-e_KE_std,e_KE_mean-e_KE_std,e_KE_mean+e_KE_std,e_KE_mean+e_KE_std],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.2)

% legend
% % caxis([0 800])
% xlabel('Electron kinetic energy (eV)')
% ylabel('m2q (a.u.)')
% set(gca,'YDir','normal')
% title('BetEI(x,m2q)')
%     fprintf('The number of true events in ROI are %0.0f\n',sum(TES2IIpair_x))


end