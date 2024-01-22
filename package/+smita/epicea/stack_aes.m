clear
addpath('E:\PhD\Adamantane_data\data')
addpath('E:\PhD\Anaconda2\ANACONDA_2\package\+smita\epicea')
addpath('E:\PhD\meetings_n_conf\2022\wk 14\Colormaps\Colormaps (5)\Colormaps')

S =data_list_adamantane;
for f = 3%1: length(S)
    raw_data = IO.import_raw(S(f).dir_ada);
    mdata = IO.import_metadata(S(f).dir_ada);
    data            = macro.filter(raw_data, mdata); %define the multiplicity of events
    data_corrected = macro.correct(data, mdata);
    data_converted(f) = macro.convert(data_corrected, mdata);
    [data_stats(f)] =get_data_stats(data_converted(f));
    hv(f) = (S(f).photon);
end
figure
hold on
%%
c1 = 2;  h1 =5; c2= 8; h2=11;
m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
filename= sprintf('c%ih%i_c%ih%i',c1,h1,c2,h2);
% filename= sprintf('c%i_c%i',c1,c2);

roi_path='E:\PhD\Adamantane_data\data\ascii_conv_data\Ada_PEPICO_hv350eV_ke260_0003_ascii\roi_final\';%_carbons_new\new_folder';
load([roi_path,filename,'.mat'],'roi')
mdata = IO.import_metadata(S(3).dir_ada);
% mdata.plot.det2.TOF_hit1_hit2.cond.C2H5.value=m2q_1;
% mdata.plot.det2.TOF_hit1_hit2.cond.C8H11.value=m2q_2;
% macro.plot(data_converted(3),mdata);
% drawellipse('Color','r', 'Center',roi.Center,'SemiAxes',roi.SemiAxes,'FaceAlpha',0,'InteractionsAllowed','none','RotationAngle',roi.RotationAngle);

tof_1 =[roi.Center(1)-500 ; roi.Center(1)+500];
tof_2 =[roi.Center(2)-500 ; roi.Center(2)+500];
disp = 90;
[TES2IIpair_x, Xcenters] = plot_ES_ion_pair_c2(data_converted(3), data_stats(3),roi,tof_1,tof_2, disp);
%%
c1 = 2;  h1 =5; c2= 7; h2=7;
m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
filename= sprintf('c%ih%i_c%ih%i',c1,h1,c2,h2);
% filename= sprintf('c%i_c%i',c1,c2);

roi_path='E:\PhD\Adamantane_data\data\ascii_conv_data\Ada_PEPICO_hv350eV_ke260_0003_ascii\roi_final\';%_carbons_new\new_folder';
load([roi_path,filename,'.mat'],'roi')
mdata = IO.import_metadata(S(3).dir_ada);
% mdata.plot.det2.TOF_hit1_hit2.cond.C2H5.value=m2q_1;
% mdata.plot.det2.TOF_hit1_hit2.cond.C8H11.value=m2q_2;
% macro.plot(data_converted(3),mdata);
% drawellipse('Color','r', 'Center',roi.Center,'SemiAxes',roi.SemiAxes,'FaceAlpha',0,'InteractionsAllowed','none','RotationAngle',roi.RotationAngle);

tof_1 =[roi.Center(1)-500 ; roi.Center(1)+500];
tof_2 =[roi.Center(2)-500 ; roi.Center(2)+500];
disp = 60;
[TES2IIpair_x, Xcenters] = plot_ES_ion_pair_c2(data_converted(3), data_stats(3),roi,tof_1,tof_2, disp);

c1 = 2;  h1 =5; c2= 6; h2=7;
m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
filename= sprintf('c%ih%i_c%ih%i',c1,h1,c2,h2);
% filename= sprintf('c%i_c%i',c1,c2);

roi_path='E:\PhD\Adamantane_data\data\ascii_conv_data\Ada_PEPICO_hv350eV_ke260_0003_ascii\roi_final\';%_carbons_new\new_folder';
load([roi_path,filename,'.mat'],'roi')
mdata = IO.import_metadata(S(3).dir_ada);
% mdata.plot.det2.TOF_hit1_hit2.cond.C2H5.value=m2q_1;
% mdata.plot.det2.TOF_hit1_hit2.cond.C8H11.value=m2q_2;
% macro.plot(data_converted(3),mdata);
% drawellipse('Color','r', 'Center',roi.Center,'SemiAxes',roi.SemiAxes,'FaceAlpha',0,'InteractionsAllowed','none','RotationAngle',roi.RotationAngle);

tof_1 =[roi.Center(1)-500 ; roi.Center(1)+500];
tof_2 =[roi.Center(2)-500 ; roi.Center(2)+500];
disp = 30;
[TES2IIpair_x, Xcenters] = plot_ES_ion_pair_c2(data_converted(3), data_stats(3),roi,tof_1,tof_2, disp);

c1 = 2;  h1 =5; c2= 6; h2=5;
m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
filename= sprintf('c%ih%i_c%ih%i',c1,h1,c2,h2);
% filename= sprintf('c%i_c%i',c1,c2);

roi_path='E:\PhD\Adamantane_data\data\ascii_conv_data\Ada_PEPICO_hv350eV_ke260_0003_ascii\roi_final\';%_carbons_new\new_folder';
load([roi_path,filename,'.mat'],'roi')
mdata = IO.import_metadata(S(3).dir_ada);
% mdata.plot.det2.TOF_hit1_hit2.cond.C2H5.value=m2q_1;
% mdata.plot.det2.TOF_hit1_hit2.cond.C8H11.value=m2q_2;
% macro.plot(data_converted(3),mdata);
% drawellipse('Color','r', 'Center',roi.Center,'SemiAxes',roi.SemiAxes,'FaceAlpha',0,'InteractionsAllowed','none','RotationAngle',roi.RotationAngle);

tof_1 =[roi.Center(1)-500 ; roi.Center(1)+500];
tof_2 =[roi.Center(2)-500 ; roi.Center(2)+500];
disp = 0;
[TES2IIpair_x, Xcenters] = plot_ES_ion_pair_c2(data_converted(3), data_stats(3),roi,tof_1,tof_2, disp);
%%
es_range1 = [250.25;254.5]; %cH2 [250.5;254.4]; %cH2
es_range2 = [255.2;260.7]; %CH[258.6;260.7]; %CH
[centres, electron_KE] = get_AES(data_converted(3), data_stats(3));

yl= ylim;
patch([es_range1(1),es_range1(1),es_range1(2),es_range1(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.2,'FaceColor',[0.4940 0.1840 0.5560])
patch([es_range2(1),es_range2(1),es_range2(2),es_range2(2)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.2,'FaceColor',[0.9290 0.6940 0.1250])

%% give name
e_KE_mean = sum(TES2IIpair_x.*Xcenters)/sum(TES2IIpair_x)