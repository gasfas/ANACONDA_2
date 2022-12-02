clear
addpath('E:\PhD\Adamantane_data\data')
addpath('E:\PhD\Anaconda2\ANACONDA_2\package\+smita\epicea')
addpath('E:\PhD\meetings_n_conf\2022\wk 14\Colormaps\Colormaps (5)\Colormaps')

S =data_list_adamantane;

for f = 3%1: length(S)
    raw_data = IO.import_raw(S(f).dir_ada);
    mdata = IO.import_metadata(S(f).dir_ada);
    data            = macro.filter(raw_data, mdata); %define the multiplicity of events
    data_corrected = macro.correct(data, mdata);
    data_converted = macro.convert(data_corrected, mdata);
    [data_stats] =get_data_stats(data_converted);
    hv = (S(f).photon);
end

%%
figure; hold on
for i=3;%1:length(S)
%     subplot(1,3,i)
    [Tet_tof2] = plot_pipico(data_converted, data_stats);
% %     [Tet_tof2] = plot_p_norm_p_norm(data_converted(i), data_stats(i),roi,m2q_1,m2q_2);
    
end
cm_magma=magma(20);
colormap(cm_magma);%caxis([0 1])
hold on
ylim([7500, 9600])
xlim([3000, 6000])
axis square
caxis([0 2])
%%
m2q_1 = 12*3+3; m2q_2 = 12*6+7; 

Center(1) = convert.m2q_2_TOF(m2q_1,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
Center(2) = convert.m2q_2_TOF(m2q_2,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
plot(Center(1), Center(2),'ko')
x= Center(1)-100:10:Center(1)+100;
% point = [4811,9385];
m = -tan(45*pi/180);%(point(1) -Center(1))/ (point(2) -Center(2));
y = m*(x-Center(1))+ Center(2);

plot(x,y,'k--')
axis tight
ylim([7500, 9600])
xlim([3000, 6000])
%%
% e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
% e_TRG.e.type	        = 'continuous';
% e_TRG.e.data_pointer	= 'h.det1.R';
% e_TRG.e.translate_condition = 'AND';
% e_TRG.e.value		= data_stats.e_R_range;
% 
% e_TRG.ion.C2			= macro.filter.write_coincidence_condition(2, 'det2');
% e_TRG.ion.hit1.type				= 'discrete';
% e_TRG.ion.hit1.data_pointer		= 'h.det2.m2q_l';
% e_TRG.ion.hit1.value				= m2q_1;%[12*2+5];
% e_TRG.ion.hit1.translate_condition = 'hit1';
% e_TRG.ion.hit2.type					= 'discrete';
% e_TRG.ion.hit2.data_pointer			= 'h.det2.m2q_l';
% e_TRG.ion.hit2.value					= m2q_2;%12*8+11;
% e_TRG.ion.hit2.translate_condition	= 'hit2';
% 
% [e_filter_e_TRG, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
% hit_filter_et = filter.events_2_hits(e_filter_e_TRG, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
%     e_TRG, data_converted);
% hit_signal_et = data_converted.h.det2.TOF(hit_filter_et.det2.filt);
% tof1 =hit_signal_et(1:2:end);
% tof2= hit_signal_et(2:2:end);
% figure
% plot(tof1,tof2,'.')
% hold on