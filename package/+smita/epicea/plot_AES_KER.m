function plot_AES_KER(roi_path,data_corrected)

%% load all rois in path
rois = dir(fullfile(roi_path,'*.mat'));
for k = 1:numel(rois)
    filename = dir(fullfile(roi_path,rois(k).name));
    roi = load([roi_path,filename.name],'roi'); % much better than EVAL and LOAD.s
    
    name = upper(filename.name); name = split(name,'.');
    name = split(name(1),'_');
    ii = split(name(1),'H'); jj = split(name(2),'H');
    
    c1 = regexp(ii{1},'[0-9]','match');  c2= regexp(jj{1},'[0-9]','match');
    c1 =str2double(c1{1}); c2= str2double(c2{1});
    h1 = str2double(ii{2});  h2=str2double(jj{2});
    m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
    if c1== 2 && h1 == 3 && c2== 3 && h2 == 3
%%
    addpath('E:\PhD\Adamantane_data\data')
    addpath('E:\PhD\Anaconda2\ANACONDA_2\package\+smita\epicea')
    addpath('E:\PhD\meetings_n_conf\2022\wk 14\Colormaps\Colormaps (5)\Colormaps')

    S =data_list_adamantane;
    dire= S(3).dir_ada;
    mdata = IO.import_metadata(dire);
    mdata.conv.det2.m2q_label.labels 			= [ m2q_1;m2q_2];
    mdata.conv.det2.m2q_label.search_radius = [ 5.0];
    mdata.conv.det2.m2q_label.mass 			= mdata.conv.det2.m2q_label.labels ;
    mdata.cond.C2H5_C8H11.C2H5.value				= m2q_1;%[12*2+5];
    mdata.cond.C2H5_C8H11.C8H11.value				= m2q_2;%12*8+11;
    data_converted = macro.convert(data_corrected, mdata);
    %%
    [e_filter_roi, ~] = find_events_in_roi(data_converted,roi.roi);
    [e_filter_m2q, ~]	= macro.filter.conditions_2_filter(data_converted,mdata.cond.C2H5_C8H11);
    e_filter = and(e_filter_roi,e_filter_m2q);
    ker_sum = data_converted.e.det2.KER_sum(e_filter);
    hit_filter_e= filter.events_2_hits_det(e_filter, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
        e_filter, data_converted); 
    e_ke = data_converted.h.det1.KER(hit_filter_e);

    hit_filter_i = filter.events_2_hits(e_filter, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
        e_filter, data_converted);
    hit_signal_et =data_converted.h.det2.KER(hit_filter_i.det2.filt); 
    hit1 = hit_signal_et(1:2:end);
    hit2 =hit_signal_et(2:2:end);
    %% 
    Xedges = [230:1:280];%      Xedges = [230:2:280];
    Xcenters = Xedges(1:end-1) + diff(Xedges) / 2; %tof values
    Yedges = [-1:0.5:22];    % Yedges = [-1:0.5:22];
    Ycenters = Yedges(1:end-1) + diff(Yedges) / 2; %tof values

    figure1 = figure ;
    axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.41 0.51 0.50]);
    hold(axes1,'on');   box on 
    [etEI_x_tof,Xedges,Yedges] =histcounts2(e_ke,ker_sum,Xedges,Yedges);
    surface(Xcenters, Ycenters, etEI_x_tof'); shading interp
    ylabel('Total KER (eV)')
    cm_magma=magma(50);
    colormap(cm_magma)
    xlim(axes1,[240 275]);
    ylim(axes1,[0 15]);
%%
%     colorbar
%     subplot(3,1,2)
%     [etEI_x_tof,Xedges,Yedges] =histcounts2(e_ke,hit1,Xedges,Yedges);
%     surface(Xcenters, Ycenters, etEI_x_tof'); shading interp
%     xlabel('Electron kinetic energy (eV)')
%     ylabel('Hit 1 Kinetic energy (eV)')
% 
%     subplot(3,1,3)
%     [etEI_x_tof,Xedges,Yedges] =histcounts2(e_ke,hit2,Xedges,Yedges);
%     surface(Xcenters, Ycenters, etEI_x_tof'); shading interp
%     xlabel('Electron kinetic energy (eV)')
%     ylabel('Hit 2 Kinetic energy (eV)')
%     subplot(2,2,4)
    axes2 = axes('Parent',figure1,...
    'Position',[0.13 0.11 0.51 0.225103244837758]);
    hold(axes2,'on'); box on

    data_stats = get_data_stats(data_converted);
    tof_1 =[roi.roi.Center(1)-500 ; roi.roi.Center(1)+500];
    tof_2 =[roi.roi.Center(2)-500 ; roi.roi.Center(2)+500];
    [TES2IIpair_x, Xcenters] = plot_ES_ion_pair_c2(data_converted, data_stats,roi.roi,tof_1,tof_2);
        xlim(axes2,[240 275]);
    xlabel('Electron kinetic energy (eV)')

    axes3 = axes('Parent',figure1,...
    'Position',[0.677750158220692 0.41 0.227249841779303 0.50]);
    hold(axes3,'on');  
    view(axes3,[90 -90]); box on
    legend1 = legend(axes3,'show');
    set(legend1,'Location','northeast');
    plot_signal=struct();
    plot_signal.hit.data_pointer = 'data_converted.h.det2.KER';
    plot_signal.hit.label = 'Ion kinetic energy (eV)';%dp_{norm}
    plot_signal.Binsize =0.4; plot_signal.Range =[0, 20]; 

    plot_signal.event.data_pointer = 'data_converted.e.det2.KER_sum';
    plot_signal.event.label = 'Total KER (eV)';%p_{1z} + p_{2z}
    [~,~] =plot.epicea.plot_ion_c2(data_converted, data_stats,e_filter_roi,plot_signal,m2q_1,m2q_2);
    xlim(axes3,[0 15]);
    legend('hit1','hit2','Total KER')
% legend(filename)
     
%     x0=500;
%     y0=100;
%     width=550;
%     height=800;
%     set(gcf,'position',[x0,y0,width,height])

    fig_name =sprintf('C_%iH_%i^+ / C_%iH_{%i}^+',c1,h1,c2,h2);
    sgtitle(fig_name)
    fname = 'E:\PhD\meetings_n_conf\2022\wk 16\mean_with_std_threshold_errorbar';
    saveas(figure1,fullfile(fname, sprintf('C%iH%i_C%iH%i',c1,h1,c2,h2)),'png')
    close all
    

   end
end
end