function get_rt_plot(data_converted, data_stats, mdata)
%% electron filter
ion.C1= macro.filter.write_coincidence_condition(1, 'det2');
ion.type	        = 'discrete';
ion.data_pointer	= 'h.det2.m2q_l';
ion.translate_condition = 'AND';
ion.value		=  mdata.conv.det2.m2q_label.labels;%

% ion.C2			= macro.filter.write_coincidence_condition(2, 'det2');
% ion.hit1.type				= 'discrete';
% ion.hit1.data_pointer		= 'h.det2.m2q_l';
% ion.hit1.value				= [12*2+5];
% ion.hit1.translate_condition = 'hit1';
% 
% ion.hit2.type					= 'discrete';
% ion.hit2.data_pointer			= 'h.det2.m2q_l';
% ion.hit2.value				= [12*8+11];
% ion.hit2.translate_condition	= 'hit2';


e_TRG.e.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
e_TRG.e.type	        = 'continuous';
e_TRG.e.data_pointer	= 'h.det1.R';
e_TRG.e.translate_condition = 'AND';
e_TRG.e.value		= data_stats.e_R_range;
e_TRG.ion = ion;

[e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
hit_filter_et = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    e_TRG, data_converted);
tof= data_converted.h.det2.TOF(hit_filter_et.det2.filt); 
radius= data_converted.h.det2.R(hit_filter_et.det2.filt); 

Binsize_tof = 10; Binedges_tof = 3000: Binsize_tof: 9500;
Bincenters_tof = Binedges_tof(1:end-1) + diff(Binedges_tof) / 2; %tof values

Binsize_r = 0.4; Binedges_r = 0: Binsize_r: 25;
Bincenters_r = Binedges_r(1:end-1) + diff(Binedges_r) / 2; %tof values

[et_R_tof,~,~] = histcounts2(tof,radius,Binedges_tof,Binedges_r);
figure
subplot(1,3,1)
histogram2('XBinEdges',Binedges_tof,'YBinEdges',Binedges_r,'BinCounts',et_R_tof,'DisplayStyle','tile','ShowEmptyBins','on')
% colorbar
axis square
% xlim([3400 3650])
title('etII(R, tof)')
xlabel('TOF (ns)')
ylabel('Radius (mm)')
%% rnd filter

rnd_TRG.e.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
rnd_TRG.e.type	        = 'continuous';
rnd_TRG.e.data_pointer	= 'h.det1.R';
rnd_TRG.e.translate_condition = 'AND';
rnd_TRG.e.value		= data_stats.e_R_range;
rnd_TRG.ion = ion;

[e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted,rnd_TRG);
hit_filter_rt = filter.events_2_hits(e_filter_rt, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    rnd_TRG, data_converted);
tof= data_converted.h.det2.TOF(hit_filter_rt.det2.filt); 
radius= data_converted.h.det2.R(hit_filter_rt.det2.filt); 

[rt_R_tof,~,~] = histcounts2(tof,radius,Binedges_tof,Binedges_r);

subplot(1,3,2)
histogram2('XBinEdges',Binedges_tof,'YBinEdges',Binedges_r,'BinCounts',rt_R_tof,'DisplayStyle','tile','ShowEmptyBins','on')
axis square
% xlim([3400 3650])
% colorbar
title('rtII(R, tof)')
xlabel('TOF (ns)')
ylabel('Radius (mm)')
%% filtering
R_tof = et_R_tof - data_stats.SC.*rt_R_tof;
%% plotting

subplot(1,3,3)

histogram2('XBinEdges',Binedges_tof,'YBinEdges',Binedges_r,'BinCounts',R_tof,'DisplayStyle','tile','ShowEmptyBins','on')
% colorbar
title('TetII(R, tof)')
xlabel('TOF (ns)')
ylabel('Radius (mm)')
axis square
% xlim([3400 3650])
% ylim([2000 10000])
% caxis([0 10])

figure
surface(Bincenters_tof, Bincenters_r, R_tof'); shading interp
title('Surf TetII(R, tof)')


end