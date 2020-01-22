%% this code helps you analyse multiple experiments faster
%% 
S=data_list(); %struct containing all the experiments
%% Make the new struct of data you need
exp = [1:5]; %which exp you need

%% Creating a struct with separate experiments
for i=exp
    tmp = sprintf('exp%d',i);
    data_struct.(tmp) = IO.import_raw(S(i).dir_CO2);
    mdata_struct.(tmp) = IO.import_metadata(S(i).dir_CO2);
end
%% Data analysis
data_converted = macro.all_n(data_struct,mdata_struct); %struct with different experiment data as fields, now after the 
%		procedures have been applied. procedures can be specified

%% plotting all the experiments
for ii = exp %select experiment to plot
    f = sprintf('exp%d',ii);
    mdata = IO.import_metadata(S(ii).dir_CO2); %%% select the mdata to use
    macro.plot(data_converted.(f), mdata)
    title(f)
end
