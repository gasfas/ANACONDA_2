%% this code is for filtering the data with random trigger
%% import the data if already converted to ANA
dir= 'E:\PhD\Adamantane_data\data\Ada_PEPICO_hv350eV_ke260_0003\Ada_PEPICO_hv350eV_ke260_0003_ana';
raw_data = IO.import_raw(dir);
mdata = md_all();
data            = macro.filter(raw_data, mdata); %define the multiplicity of events
%% step 1 filtering for 
 
