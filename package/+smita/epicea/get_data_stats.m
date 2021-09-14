function [data_stats] =get_data_stats(data_converted)
data_stats.e_R_range = [0; 40.0];%[0; 19.0];
e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
e_TRG.type	        = 'continuous';
e_TRG.data_pointer	= 'h.det1.R';
e_TRG.translate_condition = 'AND';
e_TRG.value		= data_stats.e_R_range;
RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger

[e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
data_stats.N_e = sum(e_filter_et);
[e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted, RND_TRG);
data_stats.N_RND = sum(e_filter_rt);
%%% the scaling factor%%%
data_stats.SC = data_stats.N_e / data_stats.N_RND;

%probability to detect j ions after electron trigger
for j =0:4
    etN =struct();
    etN.e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
    etN.e_TRG.type	        = 'continuous';
    etN.e_TRG.data_pointer	= 'h.det1.R';
    etN.e_TRG.translate_condition = 'AND';
    etN.e_TRG.value		= data_stats.e_R_range;
    etN.ions= macro.filter.write_coincidence_condition(j, 'det2');
    [e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);
    strg = ['etP_',num2str(j)];
    data_stats.(strg) = sum(e_filter_etN)/data_stats.N_e;
end

%probability to detect j ions after RND trigger
for j =0:4
    rtN =struct();
    rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
    rtN.ions= macro.filter.write_coincidence_condition(j, 'det2');
    [e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);
    strg = ['rtP_',num2str(j)];
    data_stats.(strg) = sum(e_filter_rtN)/data_stats.N_RND;
    
end

%% TP
data_stats.TP_0 = max(data_stats.etP_0 / data_stats.rtP_0,0) ;
% data_stats.TP_0 = min(data_stats.TP_0,1) ;
data_stats.TP_1 = max((data_stats.etP_1 - data_stats.rtP_1*data_stats.TP_0) / data_stats.rtP_0,0);
data_stats.TP_2 = max((data_stats.etP_2 - data_stats.rtP_2*data_stats.TP_0 - data_stats.rtP_1*data_stats.TP_1) / data_stats.rtP_0,0);
data_stats.TP_3 = max((data_stats.etP_3 - data_stats.rtP_3*data_stats.TP_0 - data_stats.rtP_2*data_stats.TP_1 - data_stats.rtP_1*data_stats.TP_2) ...
        / data_stats.rtP_0,0);
data_stats.TP_4 = max((data_stats.etP_4 - data_stats.rtP_4*data_stats.TP_0 - data_stats.rtP_3*data_stats.TP_1 - data_stats.rtP_2*data_stats.TP_2 ...
        - data_stats.rtP_1*data_stats.TP_3)/ data_stats.rtP_0,0);
x =   data_stats.TP_0 + data_stats.TP_1 + data_stats.TP_2+ data_stats.TP_3+data_stats.TP_4;
for j =0:4
    strg = ['TP_',num2str(j)];
    data_stats.(strg) = data_stats.(strg)/x;
end

%% Pj
PD = 0.1; PD_bar = 1-PD;
data_stats.P4 = max(data_stats.TP_4 / PD^4,0);
data_stats.P3 = max((data_stats.TP_3 - 4*data_stats.P4*PD_bar*PD^3)/PD^3,0);
data_stats.P2 = max((data_stats.TP_2 - 3*data_stats.P3*PD_bar*PD^2 - 6*data_stats.P4*PD_bar^2*PD^2)/PD^2,0);
data_stats.P1 = max((data_stats.TP_1 - 2*data_stats.P2*PD_bar*PD - 3*data_stats.P3*PD_bar^2*PD - 4*data_stats.P4*PD_bar^3*PD)/PD,0);
data_stats.P0 = max((data_stats.TP_0 - data_stats.P1*PD_bar - data_stats.P2*PD_bar^2 - data_stats.P3*PD_bar^3 - data_stats.P4*PD_bar^4),0);
%% Baseline corrected SC
% data_stats.SC = 0.42;
display(['The Scaling factor is ', num2str(data_stats.SC)])
end