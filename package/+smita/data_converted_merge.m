S=data_list(); %struct containing all the experiments
%% Make the new struct of data you need
exp = 18:20; %which exp you need

%% Creating a struct with separate experiments
for i=exp
    tmp = sprintf('exp%d',i);
    new_struct.(tmp).raw_data = IO.import_raw(S(i).dir_CO2);
    mdata = IO.import_metadata(S(i).dir_CO2); 
    new_struct.(tmp).data = macro.filter(new_struct.(tmp).raw_data, mdata);
    new_struct.(tmp).data_corrected = macro.correct(new_struct.(tmp).data, mdata);
    new_struct.(tmp).data_converted = macro.convert(new_struct.(tmp).data_corrected, mdata);
end
%% Merging data
merge_data = IO.merge_exp(new_struct);
%% Conitnue with teh
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
data            = macro.filter(merge_data, mdata);
data_corrected = macro.correct(data, mdata);
data_converted = macro.convert(data_corrected, mdata);

%% 
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
macro.calibrate.momentum(data_converted, 1, mdata)
% macro.calibrate.Molecular_Beam(data_converted, 1, mdata.calib.det1.MB)
%% plotting
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
macro.plot(data_converted, mdata)
%% Alternative manual input

% new_struct.exp1 = IO.import_raw(S(1).dir_CO2)
% new_struct.exp2 = IO.import_raw(S(2).dir_CO2)
% new_struct.exp3 = IO.import_raw(S(3).dir_CO2)
% new_struct.exp4 = IO.import_raw(S(4).dir_CO2)
% 
% merge_data = IO.merge_exp(new_struct)
