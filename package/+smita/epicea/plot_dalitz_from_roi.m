function plot_dalitz_from_roi(data_converted, roi,data_stats)
%% filter in roi
[e_filter_roi, ~] = find_events_in_roi(data_converted,roi);
e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
e_TRG.e.type	        = 'continuous';
e_TRG.e.data_pointer	= 'h.det1.R';
e_TRG.e.translate_condition = 'AND';
e_TRG.e.value		= data_stats.e_R_range;

e_TRG.ion = macro.filter.write_coincidence_condition(2, 'det2'); % rnd trigger
[e_filter_e_TRG, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
e_filter_et = and(e_filter_roi , e_filter_e_TRG);

hit_filter_et = filter.events_2_hits(e_filter_et, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    e_TRG, data_converted);
hit_signal_et =data_converted.h.det2.dp_norm(hit_filter_et.det2.filt); 
hit1 = hit_signal_et(1:2:end);
hit2 =hit_signal_et(2:2:end);

hit_sum = data_converted.e.det2.dp_sum_norm(e_filter_et);

%% make histogram
hist_data = [hit1.^2 ,hit2.^2, hit_sum.^2];   

norm_factor = sum(hist_data, 2);
hist_data_n = hist_data./norm_factor;
%    [hist_data(:,1), hist_data(:,2)] = plot.ternary.terncoords(hist_data_n(:,1), hist_data_n(:,2), hist_data_n(:,3));
[hist_data(:,1), hist_data(:,2)] = plot.ternary.terncoords(hist_data_n(:,1), hist_data_n(:,2));
hist_data(:,3) = [];
midpoints = hist.bins([0 1; 0 1], [0.03,0.03]);
[dalitz_hist, histd.midpoints] = hist.H_nD(hist_data, midpoints);
 histd.Count = dalitz_hist;
 
 h_figure = figure;
load('E:\PhD\meetings_n_conf\2021\wk 33\plot_md_dalitz.mat'); %% exp data
h_axes		= macro.plot.create.ax(h_figure, plot_md.axes);
plot_md.GraphObj.Type = 'ternary';
h_GraphObj	= macro.hist.create.GraphObj(h_axes, histd,plot_md.GraphObj );
 %% make rnd bckgrd
 %%%%%% RND trigger%%%%%%%%%%%
RND_TRG.e= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger
RND_TRG.ion= macro.filter.write_coincidence_condition(2, 'det2'); % rnd trigger

[e_filter_RND_TRG, ~]	= macro.filter.conditions_2_filter(data_converted,RND_TRG);

e_filter_rt =e_filter_RND_TRG;%and(e_filter_roi , e_filter_RND_TRG); % 

hit_filter_rt = filter.events_2_hits(e_filter_rt, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    e_TRG, data_converted);
hit_signal_rt =data_converted.h.det2.dp_norm(hit_filter_rt.det2.filt); 
hit1 = hit_signal_rt(1:2:end);
hit2 =hit_signal_rt(2:2:end);

hit_sum = data_converted.e.det2.dp_sum_norm(e_filter_rt);

%% make histogram
hist_data = [hit1.^2 ,hit2.^2, hit_sum.^2];   

norm_factor = sum(hist_data, 2);
hist_data_n = hist_data./norm_factor;
%    [hist_data(:,1), hist_data(:,2)] = plot.ternary.terncoords(hist_data_n(:,1), hist_data_n(:,2), hist_data_n(:,3));
[hist_data(:,1), hist_data(:,2)] = plot.ternary.terncoords(hist_data_n(:,1), hist_data_n(:,2));
hist_data(:,3) = [];
[rnd_hist, ~] = hist.H_nD(hist_data, midpoints);
%% substract bckgrd
% SC = sum(e_filter_et)./sum(e_filter_rt);
histd.Count = max(histd.Count - data_stats.SC.*data_stats.TP_0.*rnd_hist,0);
%% plot
h_figure = figure;
load('E:\PhD\meetings_n_conf\2021\wk 33\plot_md_dalitz.mat'); %% exp data
h_axes		= macro.plot.create.ax(h_figure, plot_md.axes);
plot_md.GraphObj.Type = 'ternary';
h_GraphObj	= macro.hist.create.GraphObj(h_axes, histd,plot_md.GraphObj );
end