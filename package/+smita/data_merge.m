%% this code merges multiple experiments into one
S=data_list(); %struct containing all the experiments
%% Make the new struct of data you need
% exp = [18]; %:32]; %which exp you need
exp = [];
j = 1;
% x =150;
for i = 1:size(S,2)
    if  S(i).pressure == 0.2 && S(i).photon == 320
        exp(j) = i;
        j = j+1;
    end
end
%% Creating a struct with separate experiments
for i=exp
    tmp = sprintf('exp%d',i);
    new_struct.(tmp) = IO.import_raw(S(i).dir_CO2);
end
%% Merging data
merge_data = IO.merge_exp(new_struct);
%% Continue the normal analysis
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
data            = macro.filter(merge_data, mdata);
data_corrected = macro.correct(data, mdata);
data_converted = macro.convert(data_corrected, mdata);

%% plotting
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
% macro.calibrate.momentum(data_converted, 1, mdata)
% macro.calibrate.Molecular_Beam(data_converted, 1, mdata.calib.det1.MB)
macro.plot(data_converted, mdata)
%% define p_ratio
% [e_filter_c2, ~]	= macro.filter.conditions_2_filter(data_converted,mdata.cond.def.X_X);
% hit_filter_c2 = filter.events_2_hits(e_filter_c2, data_converted.e.raw, length(data_converted.h.det1.TOF),...
%     mdata.cond.def.X_X, data_converted);
% dp_c2= data_converted.h.det1.dp_norm(hit_filter_c2.det1.filt); 
% 
% %%% the odd index values of et_tof_c2 are tof1%%%
% % odd index values
% dp_c2_hit1 = dp_c2(1:2:end) ;
% %%% the even index values of et_tof_c2 are tof2%%%
% % even index values
% dp_c2_hit2 = dp_c2(2:2:end) ;
% % [rt_tof2,~,~] = histcounts2(rt_c2_tof1,rt_c2_tof2,Binedges,Binedges);
% dp_ratio = dp_c2_hit1./dp_c2_hit2;
% data_converted.e.det1.p_ratio = zeros(length(e_filter_c2),1);
% ii = find(e_filter_c2>0);
% data_converted.e.det1.p_ratio(ii) = dp_ratio(:);
%% plot exp angle c2
% [e_filter_cond1, ~]	= macro.filter.conditions_2_filter(data_converted, mdata.cond.def.X_X);
% exp_angle = data_converted.e.det1.angle_p_corr_C2(e_filter_cond1,:); 
% Binsize = 0.2; Binedges = -pi-0.5: Binsize: pi+0.5;
% Bincenters = Binedges(1:end-1) + diff(Binedges) / 2;
% exp_angle_hist= histcounts(exp_angle, Binedges);%,'Normalization','probability');
% % figure
% % hold on
% % plot(Bincenters, exp_angle_hist ,'DisplayName','exp data')
% 
% figure
% polarplot(Bincenters, exp_angle_hist ,'DisplayName','exp data')
%% Beta fitting

% mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
% [x, y] = dataextract(data_converted, mdata);
% fit.beta_function(x,y)

% [N,edges] = histcounts(data_converted.h.det1.theta); 
% centers = (edges(1:end-1) + edges(2:end))./2; %histcounts gives the bin edges, but we want to plot the bin centers 
% fit.beta_function(centers,N) %%this gives the value of the beta  

%% CALCULATING PEAK AREAS
% mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
% [peak_area]=peakarea(data_converted,mdata,132,0.5,2,'trapz_approx')%'trg_approx')%
% 
% 
 %% FITTING
% mdata = IO.import_metadata(S(exp(1)).dir_CO2);
% fit_data = macro.fit.angle_p_corr_C2(data_converted, mdata, 'det1');
% fits = (fit_data.mu.value).*180./pi
% % macro.fit.angle_p_corr_C3(data_converted, mdata, 'det1')
%% Alternative manual input

% new_struct.exp1 = IO.import_raw(S(1).dir_CO2)
% new_struct.exp2 = IO.import_raw(S(2).dir_CO2)
% new_struct.exp3 = IO.import_raw(S(3).dir_CO2)
% new_struct.exp4 = IO.import_raw(S(4).dir_CO2)
% 
% merge_data = IO.merge_exp(new_struct)
