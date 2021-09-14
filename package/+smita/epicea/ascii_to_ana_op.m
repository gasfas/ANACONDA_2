% electrons_path = 'E:\PhD\Adamantane_data\data\Ada_PEPICO_hv350eV_ke260_0003_ascii\ascii\electrons';
% ions_path = 'E:\PhD\Adamantane_data\data\Ada_PEPICO_hv350eV_ke260_0003_ascii\ascii\ions';
% IO.EPICEA.ASCII_2_mat(electrons_path, ions_path)
% d_ion = load('ions.mat');
% d_elec = load('electrons.mat');
%% 
dir = 'E:\PhD\Adamantane_data\data\Ada_PEPICO_hv350eV_ke260_0003_ascii';
filename_base = 'ascii';
ascii_data = IO.EPICEA.convert_2_ANA2(dir, filename_base);
%%
addpath('E:\PhD\Adamantane_data\mdata')
mdata = md_all();
data            = macro.filter(ascii_data, mdata); %define the multiplicity of events
data_corrected = macro.correct(data, mdata);
data_frm_ascii = macro.convert(data_corrected, mdata);
% C1(1) = sum(data_frm_ascii.e.det2.filt.C1  );
% C2(1) = sum(data_frm_ascii.e.det2.filt.C2  );
[data_stats_ASCII] =get_data_stats_new(data_frm_ascii);
%% import the data if already converted to ANA
dir= 'E:\PhD\Adamantane_data\data\Ada_PEPICO_hv350eV_ke260_0003\Ada_PEPICO_hv350eV_ke260_0003_ana';
raw_data = IO.import_raw(dir);
addpath('E:\PhD\Adamantane_data\mdata')
mdata = md_all();
data   = macro.filter(raw_data, mdata); %define the multiplicity of events
data_corrected = macro.correct(data, mdata);
data_frm_python = macro.convert(data_corrected, mdata);
[data_stats_PYTHON] =get_data_stats_new(data_frm_python);

% C1(2) = sum(data_frm_python.e.det2.filt.C1  );
% C2(2) =sum(data_frm_python.e.det2.filt.C2  );
%% 
% Analysis = {'data_frm_ascii'; 'data_frm_python'};
% T = table(Analysis,C1',C2');%,'C1','C2','Rnd','Electron'});
