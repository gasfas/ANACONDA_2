function [data_stats] =get_data_stats_es_filt(data_converted,e_KER_range)

%% define filter for electrons and ions
% electron radius
data_stats.e_KER_range = e_KER_range;%[0; 19.0];
% data_stats.TOF_range = [2000 ; 11000];%[0; 19.0];

radius.type	        = 'continuous';
radius.data_pointer	= 'h.det1.KER';
radius.translate_condition = 'AND';
radius.value		= data_stats.e_KER_range;

% ion tof
% TOF.type	        = 'continuous';
% TOF.data_pointer	= 'h.det2.TOF';
% TOF.translate_condition = 'AND';
% TOF.value		= data_stats.TOF_range ;
%% Events with one electron
e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); % electron trigger
e_TRG.radius = radius;
% not trigger by RND
e_TRG.trigger.type	        = 'discrete';
e_TRG.trigger.data_pointer	= 'e.rnd_trig';
e_TRG.trigger.translate_condition = 'AND';
e_TRG.trigger.value		= 0;

[e_filter_et, ~]	= macro.filter.conditions_2_filter(data_converted,e_TRG);
data_stats.N_e = sum(e_filter_et);
%% Events triggered by RND ions
RND_TRG.trigger= macro.filter.write_coincidence_condition(0, 'det1'); % rnd trigger
% RND_TRG.TOF = TOF;

[e_filter_rt, ~]	= macro.filter.conditions_2_filter(data_converted, RND_TRG);
data_stats.N_RND = sum(e_filter_rt);
%% the scaling factor%%%
data_stats.SC = data_stats.N_e / data_stats.N_RND;

%probability to detect j ions after electron trigger
for j =0:4
    etN =struct();
    etN.e_TRG.C1= macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
    etN.e_TRG.radius = radius;
    
    etN.e_TRG.trigger.type	        = 'discrete';
    etN.e_TRG.trigger.data_pointer	= 'e.rnd_trig';
    etN.e_TRG.trigger.translate_condition = 'AND';
    etN.e_TRG.trigger.value		= 0;
    
    etN.ions.C= macro.filter.write_coincidence_condition(j, 'det2');
%     etN.ions.TOF = TOF;
    [e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);
    strg = ['etP_',num2str(j)];
    data_stats.(strg) = sum(e_filter_etN)/data_stats.N_e;
end

%probability to detect j ions after RND trigger
for j =0:4
    rtN =struct();
    rtN.RND_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %RND trigger
    
    rtN.ions.C= macro.filter.write_coincidence_condition(j, 'det2');
%     rtN.ions.TOF = TOF;
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