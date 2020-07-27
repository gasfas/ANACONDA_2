%% %% 
%% Masses to be studied
masses.ma = 44; %%must be in amu
masses.mb = 32; %%must be in amu
%% collect the experimental data
%define cond
cond = struct();
cond.X_X.C2			= macro.filter.write_coincidence_condition(2, 'det1');

cond.X_X.O.type					= 'discrete';
cond.X_X.O.data_pointer			= 'h.det1.m2q_l';
cond.X_X.O.value				    = [32] ;
cond.X_X.O.translate_condition	= 'hit1';
cond.X_X.O.invert_filter         = false;
%   
cond.X_X.CO2.type				= 'discrete';
cond.X_X.CO2.data_pointer		= 'h.det1.m2q_l';
cond.X_X.CO2.value				= 44; %
cond.X_X.CO2.translate_condition = 'hit2';
cond.X_X.CO2.invert_filter         = false;

cond.X_X.dp_sum.type             = 'continuous';
cond.X_X.dp_sum.data_pointer     = 'e.det1.dp_sum_norm'; %%filter dalitz using this?
cond.X_X.dp_sum.value            = [0 ; 300];%[200 ; 300] ;%[150 ; 200]; % 
cond.X_X.dp_sum.translate_condition = 'AND';
cond.X_X.dp_sum.invert_filter     = false;

% Momentum filter for hit1
cond.X_X.dp_norm1.data_pointer	= 'h.det1.dp_norm';
cond.X_X.dp_norm1.type			= 'continuous';
cond.X_X.dp_norm1.value			= [0; 30];
cond.X_X.dp_norm1.translate_condition = 'hit1';
cond.X_X.dp_norm1.invert_filter     = false;     
% % % % % % % % 
% % %Momentum filter for hit2
cond.X_X.dp_norm2.data_pointer	= 'h.det1.dp_norm';
cond.X_X.dp_norm2.type			= 'continuous';
cond.X_X.dp_norm2.value			= [0; 300]; %[100; 300];%
cond.X_X.dp_norm2.translate_condition = 'hit2';
cond.X_X.dp_norm2.invert_filter     = false;

%% e_filter
[e_filter, ~]	= macro.filter.conditions_2_filter(data_converted, cond.X_X);
%% pa_exp
cond.X_X.hit_to_show  = masses.ma;
hit_filter = filter.events_2_hits_det(e_filter, data_converted.e.raw(:,1), length(data_converted.h.det1.dp_norm),...
    cond.X_X, data_converted); 
% pa.exp_data = data_converted.h.det1.dp_norm(hit_filter); %%pa
pa.exp_data = data_converted.h.det1.dp(hit_filter,:); %%pa
pa.Binsize = 4; pa.Binedges = 0: pa.Binsize : 500;

%% pb_norm_exp
cond.X_X.hit_to_show  = masses.mb;
hit_filter = filter.events_2_hits_det(e_filter, data_converted.e.raw(:,1), length(data_converted.h.det1.dp_norm),...
    cond.X_X, data_converted); 
pb_norm.Binsize = 4; pb_norm.Binedges = 0: pb_norm.Binsize : 500;
pb_norm.exp_data = data_converted.h.det1.dp_norm(hit_filter); %%pb
pb_norm.hist.exp_data = histcounts(pb_norm.exp_data, pb_norm.Binedges,'Normalization','probability');
pb_norm.Bincenters = pb_norm.Binedges(1:end-1) + diff(pb_norm.Binedges) / 2;

%% ker_sum
ker_sum.exp_data = data_converted.e.det1.KER_sum(e_filter);
ker_sum.Binsize = 0.1; ker_sum.Binedges = 0: ker_sum.Binsize : 20;
ker_sum.hist.exp_data = histcounts(ker_sum.exp_data, ker_sum.Binedges,'Normalization','probability');
ker_sum.Bincenters = ker_sum.Binedges(1:end-1) + diff(ker_sum.Binedges) / 2;


%% p_sum
p_sum_norm.exp_data = data_converted.e.det1.dp_sum_norm (e_filter);
p_sum_norm.Binsize = 5; p_sum_norm.Binedges = 0: p_sum_norm.Binsize : 500;
p_sum_norm.hist.exp_data = histcounts(p_sum_norm.exp_data, p_sum_norm.Binedges,'Normalization','probability');
p_sum_norm.Bincenters = p_sum_norm.Binedges(1:end-1) + diff(p_sum_norm.Binedges) / 2;

%% psi
psi.exp_data = data_converted.e.det1.angle_p_corr_C2(e_filter);
psi.Binsize = 5.0*pi/180; psi.Binedges = 0: psi.Binsize : pi;
psi.hist.exp_data = histcounts(psi.exp_data, psi.Binedges,'Normalization','probability');
psi.Bincenters = psi.Binedges(1:end-1) + diff(psi.Binedges) / 2;
%% 
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
mdata.plot.det1.Dalitz_C2.cond  = cond.X_X;
macro.plot(data_converted, mdata);
%% 
masses.mc = 750;%[0:50:700]; %;%[530:2:560]; % % [195:1:255]; %;%
ker_com =  0.15; %[0.0:0.05:0.25]; %0.2;%
% [my, ker2_com] = meshgrid(mass_y,ker_com);
for ii = 1:length(masses.mc)
    for jj = 1:length(ker_com)
        tic
            [data_simulated] = kinematics_7plot(ker_com, pa.exp_data(1:100,:), masses );
            
        toc
    end
end
%%
cond.dalitz.C2			= macro.filter.write_coincidence_condition(3, 'det1');

cond.dalitz.hit1.type					= 'discrete';
cond.dalitz.hit1.data_pointer			= 'h.det1.m2q_l';
cond.dalitz.hit1.value				    = [32] ;
cond.dalitz.hit1.translate_condition	= 'hit1';
cond.dalitz.hit1.invert_filter         = false;
%   
cond.dalitz.hit2.type				= 'discrete';
cond.dalitz.hit2.data_pointer		= 'h.det1.m2q_l';
cond.dalitz.hit2.value				= 44; %
cond.dalitz.hit2.translate_condition = 'hit2';
cond.dalitz.hit2.invert_filter         = false;
%   
cond.dalitz.hit3.type				= 'discrete';
cond.dalitz.hit3.data_pointer		= 'h.det1.m2q_l';
cond.dalitz.hit3.value				= masses.mc; %
cond.dalitz.hit3.translate_condition = 'hit3';
cond.dalitz.hit3.invert_filter         = false;
%%
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
mdata.plot.det1.Dalitz_C2.cond  = cond.dalitz;
mdata.plot.det1.Dalitz_C2					= metadata.create.plot.signal_2_plot({mdata.plot.signal.dp_norm_squared, mdata.plot.signal.dp_norm_squared, mdata.plot.signal.dp_norm_squared}, mdata.plot.det1.Dalitz_C2);
mdata.plot.det1.Dalitz_C2.hist.hitselect		= [1, 2, 3]; %[1, 2, NaN]hitselect can be used to select onl
macro.plot(data_simulated, mdata);
%% save
save('data_simulated.mat','-struct','data_simulated');

%