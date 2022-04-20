function [xvalues, c, d] = get_ker_in_roi(path,data_corrected)
xvalues = {'C1H3','C2H3','C2H4','C2H5','C3H3','C3H5','C4H3','C4H5','C4H6','C4H7','C5H3','C5H5','C5H7','C6H4','C6H5','C6H7','C7H7','C8H11'};
yvalues =xvalues;
c = NaN(length(xvalues),length(xvalues));
d = NaN(length(xvalues),length(xvalues));
%% load all rois in path
rois = dir(fullfile(path,'*.mat'));
for k = 1:numel(rois)
    filename = dir(fullfile(path,rois(k).name));
    roi = load([path,filename.name],'roi'); % much better than EVAL and LOAD.s
    
    name = upper(filename.name); name = split(name,'.');
    name = split(name(1),'_');
    ii = split(name(1),'H'); jj = split(name(2),'H');
    
    c1 = regexp(ii{1},'[0-9]','match');  c2= regexp(jj{1},'[0-9]','match');
    c1 =str2double(c1{1}); c2= str2double(c2{1});
    h1 = str2double(ii{2});  h2=str2double(jj{2});
    m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
%    if c1== 4 && h1 == 3 && c2== 6 && h2 == 7
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
    data_stats = get_data_stats(data_converted);

    [e_filter_roi, ~] = find_events_in_roi(data_converted,roi.roi);

%%
    plot_signal=struct();
    plot_signal.Binsize =0.4; plot_signal.Range =[0, 20]; 
    plot_signal.event.data_pointer = 'data_converted.e.det2.KER_sum';
    plot_signal.event.label = 'Total KER (eV)';%p_{1z} + p_{2z}
    [Tet_ev_mean,Tet_ev_std,Tet_ev_mode] =plot.epicea.plot_ion_c2(data_converted, data_stats,e_filter_roi,plot_signal,m2q_1,m2q_2);

    name = upper(filename.name); name = split(name,'.');
    name = split(name(1),'_');
    kk = find(strcmp(name{1},xvalues)==1); pp = find(strcmp(name{2},yvalues)==1);
    c(pp,kk) = Tet_ev_mean;
    d(pp,kk) = Tet_ev_std;
%    end
end

end