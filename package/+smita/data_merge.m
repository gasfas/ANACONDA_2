%% this code merges multiple experiments into one
S=data_list(); %struct containing all the experiments
%% Make the new struct of data you need
exp = [28]; %:32]; %which exp you need

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
macro.calibrate.Molecular_Beam(data_converted, 1, mdata.calib.det1.MB)
% macro.plot(data_converted, mdata)

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
