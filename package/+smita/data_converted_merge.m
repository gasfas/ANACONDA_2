S=data_list(); %struct containing all the experiments
%% Make the new struct of data you need
exp = [1,32]; %which exp you need

%% Creating a struct with separate experiments
for i=exp
    tmp = sprintf('exp%d',i);
    new_struct.raw_data.(tmp) = IO.import_raw(S(i).dir_CO2);
    mdata = IO.import_metadata(S(i).dir_CO2); 
    new_struct.data.(tmp) = macro.filter(new_struct.raw_data.(tmp), mdata);
    new_struct.data_corrected.(tmp) = macro.correct(new_struct.data.(tmp), mdata);
    new_struct.data_converted.(tmp) = macro.convert(new_struct.data_corrected.(tmp), mdata);
end
%% Merging data
merge_data = smita.merge_data_converted(new_struct.data_converted);

%% 
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
macro.calibrate.momentum(merge_data, 1, mdata)
% macro.calibrate.Molecular_Beam(merge_data, 1, mdata.calib.det1.MB)
%% plotting
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
macro.plot(merge_data, mdata)
%% Alternative manual input

% new_struct.exp1 = IO.import_raw(S(1).dir_CO2)
% new_struct.exp2 = IO.import_raw(S(2).dir_CO2)
% new_struct.exp3 = IO.import_raw(S(3).dir_CO2)
% new_struct.exp4 = IO.import_raw(S(4).dir_CO2)
% 
% merge_data = IO.merge_exp(new_struct)
