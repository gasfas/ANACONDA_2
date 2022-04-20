clear
addpath('E:\PhD\Adamantane_data\data')
addpath('E:\PhD\Anaconda2\ANACONDA_2\package\+smita\epicea')
S =data_list_adamantane;

%% import the data if already converted to ANA
% for f = 3 %1: length(S)
    raw_data = IO.import_raw(S(3).dir_ada);
    mdata = IO.import_metadata(S(3).dir_ada);
    data            = macro.filter(raw_data, mdata); %define the multiplicity of events
    data_corrected = macro.correct(data, mdata);
    data_converted = macro.convert(data_corrected, mdata);
    [data_stats] =get_data_stats(data_converted);
    hv = (S(3).photon);
% end
% %% Get ROI
% c1 = 3;  h1 =3; c2= 6; h2=5;
% m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
% Center(1) = convert.m2q_2_TOF(m2q_1,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
% Center(2) = convert.m2q_2_TOF(m2q_2,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
% 
% [roi] = get_roi_pipico(data_converted, data_stats,Center);%%
% 
% %% save roi
% % 
% filename= sprintf('c%ih%i_c%ih%i',c1,h1,c2,h2);
% path='E:\PhD\Adamantane_data\data\ascii_conv_data\Ada_PEPICO_hv350eV_ke260_0003_ascii\roi\';
% roi_name =filename ;
% save([path,roi_name],'roi')
%% Get ROI
% for n =3:6
% c1 = 2;  h1 =3; c2= 4; h2=3;
% m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
% Center(1) = convert.m2q_2_TOF(m2q_1,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
% Center(2) = convert.m2q_2_TOF(m2q_2,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
% 
% [roi] = get_roi_pipico(data_converted, data_stats,Center);%%
%%
mdata = IO.import_metadata(S(3).dir_ada);
[h_figure, h_axes, h_GraphObj, exp, histogram] =macro.plot(data_converted,mdata);
%%
hold on
c1 = 1;  h1 =3; c2= 5; h2=7;
m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
Center(1) = convert.m2q_2_TOF(m2q_1,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
Center(2) = convert.m2q_2_TOF(m2q_2,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0);
roi = drawellipse('Color','r', 'Center',Center,'SemiAxes',[50,50],'FaceAlpha',0,'InteractionsAllowed','reshape');%'translate');%,'RotationAngle',135);%,'

%% save roi
% 
filename= sprintf('c%ih%i_c%ih%i',c1,h1,c2,h2);%'c%i_c%i',c1,c2);
path='E:\PhD\Adamantane_data\data\ascii_conv_data\Ada_PEPICO_hv350eV_ke260_0003_ascii\roi_carbons_new\new_folder';
roi_name =filename ;
save([path,roi_name],'roi')
% close all
% clc
% end
