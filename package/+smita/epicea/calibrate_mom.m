%% Load data
clear
% close all

addpath('E:\PhD\Adamantane_data\data')
addpath('E:\PhD\Anaconda2\ANACONDA_2\package\+smita\epicea')
addpath('E:\PhD\meetings_n_conf\2022\wk 14\Colormaps\Colormaps (5)\Colormaps')

S =data_list_adamantane;
%%
dir= S(2).dir_ada;
mdata = IO.import_metadata(dir);
% mdata.spec.Efield = mdata.spec.Efield.*0.67;
% mdata.spec.Efield = mdata.spec.Efield.*0.9;

raw_data = IO.import_raw(dir);
data            = macro.filter(raw_data, mdata); %define the multiplicity of events
data_corrected = macro.correct(data, mdata);
data_converted = macro.convert(data_corrected, mdata);
% data_stats = get_data_stats(data_converted);
%% RT plot
% get_rt_plot(data_converted, data_stats, mdata);
% convert.m2q_2_TOF(29,mdata.conv.det2.m2q.factor,mdata.conv.det2.m2q.t0)
%% Calibrate momentum
% [v_MB, v_MBx, v_MBy, v_MBz]	= macro.convert.momentum.fetch_v_MB(mdata.sample);

% data_converted.h.det2.X = (data_converted.h.det2.X - v_MBx  * data_converted.h.det2.TOF*1e-6);
% data_converted.h.det2.Y = (data_converted.h.det2.Y - v_MBy  * data_converted.h.det2.TOF*1e-6);
%%
% ellipse(roi.SemiAxes(1),roi.SemiAxes(2),roi.RotationAngle*pi/180-pi/2,roi.Center(1),roi.Center(2))
% mdata = IO.import_metadata(dir);
% [e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,mdata.cond.C2H5_C8H11);
% sum(e_filter_etN)
%%
mdata = IO.import_metadata(dir);
[h_figure, h_axes, h_GraphObj, exp, histogram] =macro.plot(data_converted,mdata);
% mdata.plot.det2.m2q.cond = mdata.calib.det2.momentum.cond;
% [h_figure, h_axes, h_GraphObj, exp, histogram] =macro.plot(data_converted,mdata);
% % macro.calibrate.Molecular_Beam(data_converted,2,mdata.calib.det2.MB)
% disp(mdata.spec.Efield)
% macro.calibrate.momentum(data_converted,2,mdata);
%% KER_AES
% roi_path='E:\PhD\Adamantane_data\data\ascii_conv_data\Ada_PEPICO_hv350eV_ke260_0003_ascii\roi_final_filt\';%_carbons_new\new_folder';
% plot_AES_KER(roi_path,data_corrected)
%%
% exp_angle = data_converted.e.det2.angle_p_corr_C2(e_filter);
% figure
% Binsize_a = 0.15; Binedges_a = 0-0.5: Binsize_a: pi+0.2;
% Bincenters_a = Binedges_a(1:end-1) + diff(Binedges_a) / 2;
% exp_angle_hist = histcounts(exp_angle, Binedges_a);
% figure
% polarplot( Bincenters_a,exp_angle_hist./max(exp_angle_hist),'LineWidth',2)
%% Dalitz
% plot_dalitz_from_roi(data_converted, roi,data_stats)