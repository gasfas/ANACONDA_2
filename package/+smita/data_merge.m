%% this code merges multiple experiments into one
S=data_list(); %struct containing all the experiments
%% Make the new struct of data you need
exp = [1:5]; %which exp you need

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
macro.plot(data_converted, mdata)
%% Alternative manual input

% new_struct.exp1 = IO.import_raw(S(1).dir_CO2)
% new_struct.exp2 = IO.import_raw(S(2).dir_CO2)
% new_struct.exp3 = IO.import_raw(S(3).dir_CO2)
% new_struct.exp4 = IO.import_raw(S(4).dir_CO2)
% 
% merge_data = IO.merge_exp(new_struct)
