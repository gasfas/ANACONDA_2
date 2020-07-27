%% %% %% Masses to be studied
ma = 44; %%must be in amu
mb = 32; %%must be in amu
% mc = 340;
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
cond.X_X.dp_sum.value            = [100 ; 300];%[200 ; 300] ;%[150 ; 200]; % 
cond.X_X.dp_sum.translate_condition = 'AND';
cond.X_X.dp_sum.invert_filter     = false;

% Momentum filter for hit1
cond.X_X.dp_norm1.data_pointer	= 'h.det1.dp_norm';
cond.X_X.dp_norm1.type			= 'continuous';
cond.X_X.dp_norm1.value			= [0; 60];
cond.X_X.dp_norm1.translate_condition = 'hit1';
cond.X_X.dp_norm1.invert_filter     = false;     
% % % % % % % % % 
% % % %Momentum filter for hit2
cond.X_X.dp_norm2.data_pointer	= 'h.det1.dp_norm';
cond.X_X.dp_norm2.type			= 'continuous';
cond.X_X.dp_norm2.value			= [0; 300]; %[100; 300];%
cond.X_X.dp_norm2.translate_condition = 'hit2';
cond.X_X.dp_norm2.invert_filter     = false;
% 
% cond.X_X.angle_corr_C2.type             = 'continuous';
% cond.X_X.angle_corr_C2.data_pointer     = 'e.det1.angle_p_corr_C2 ';
% cond.X_X.angle_corr_C2.value            = [(120)*pi/180 ; (125)*pi/180];%[200 ; 300] ;%[150 ; 200]; % 
% cond.X_X.angle_corr_C2.translate_condition = 'AND';
% cond.X_X.angle_corr_C2.invert_filter     = false;

%% e_filter
[e_filter, ~]	= macro.filter.conditions_2_filter(data_converted, cond.X_X);
%% pa_exp
cond.X_X.hit_to_show  = ma;
hit_filter = filter.events_2_hits_det(e_filter, data_converted.e.raw(:,1), length(data_converted.h.det1.dp_norm),...
    cond.X_X, data_converted); 
% pa.exp_data = data_converted.h.det1.dp_norm(hit_filter); %%pa
pa.exp_data = data_converted.h.det1.dp(hit_filter,:); %%pa
pa.Binsize = 4; pa.Binedges = 0: pa.Binsize : 500;

%% pb_norm_exp
cond.X_X.hit_to_show  = mb;
hit_filter = filter.events_2_hits_det(e_filter, data_converted.e.raw(:,1), length(data_converted.h.det1.dp_norm),...
    cond.X_X, data_converted); 
pb_norm.Binsize = 4; pb_norm.Binedges = 0: pb_norm.Binsize : 500;
pb_norm.exp_data = data_converted.h.det1.dp_norm(hit_filter); %%pb
pb_norm.hist.exp_data = histcounts(pb_norm.exp_data, pb_norm.Binedges,'Normalization','probability');
pb_norm.Bincenters = pb_norm.Binedges(1:end-1) + diff(pb_norm.Binedges) / 2;

%% ker_sum
ker_sum.exp_data = data_converted.e.det1.KER_sum(e_filter);
ker_sum.Binsize = 0.2; ker_sum.Binedges = 0: ker_sum.Binsize : 20;
ker_sum.hist.exp_data = histcounts(ker_sum.exp_data, ker_sum.Binedges,'Normalization','probability');
ker_sum.Bincenters = ker_sum.Binedges(1:end-1) + diff(ker_sum.Binedges) / 2;


%% p_sum
p_sum_norm.exp_data = data_converted.e.det1.dp_sum_norm (e_filter);
p_sum_norm.Binsize = 5; p_sum_norm.Binedges = 0: p_sum_norm.Binsize : 500;
p_sum_norm.hist.exp_data = histcounts(p_sum_norm.exp_data, p_sum_norm.Binedges,'Normalization','probability');
p_sum_norm.Bincenters = p_sum_norm.Binedges(1:end-1) + diff(p_sum_norm.Binedges) / 2;

%% psi
psi.exp_data = data_converted.e.det1.angle_p_corr_C2(e_filter);
psi.Binsize = 15.0*pi/180; psi.Binedges = 0: psi.Binsize : pi;
psi.hist.exp_data = histcounts(psi.exp_data, psi.Binedges,'Normalization','probability');
psi.Bincenters = psi.Binedges(1:end-1) + diff(psi.Binedges) / 2;
%% 
mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
mdata.plot.det1.Dalitz_C2.cond  = cond.X_X;
macro.plot(data_converted, mdata);
%%
gca = figure;
h = subplot(2,2,1);
plot(pb_norm.Bincenters, pb_norm.hist.exp_data,'DisplayName','exp data')
xlabel('Norm of Momentum of B')
ylabel('Intensity')
set(h,'Tag','top left');


h = subplot(2,2,2);
plot(ker_sum.Bincenters, ker_sum.hist.exp_data,'DisplayName','exp data')
xlabel('Total KER of event')
ylabel('Intensity')
set(h,'Tag','top right');

h = subplot(2,2,3);
plot(psi.Bincenters, psi.hist.exp_data,'DisplayName','exp data')
xlabel('The angle between A and B')
ylabel('Intensity')
set(h,'Tag','bottom left');


h = subplot(2,2,4);
plot(p_sum_norm.Bincenters, p_sum_norm.hist.exp_data,'DisplayName','exp data')
xlabel('The total momentum of event')
ylabel('Intensity')
set(h,'Tag','bottom right');

%% 
mass_y = 550;[0:50:700]; %;%[530:2:560]; % % [195:1:255]; %;%
ker_com =  0.1; %[0.0:0.05:0.25]; %0.2;%
% [my, ker2_com] = meshgrid(mass_y,ker_com);
for ii = 1:length(mass_y)
    for jj = 1:length(ker_com)
        tic
            obs = kinematics_7(ker_com(jj), mass_y(ii), pa.exp_data(1:1000,:), ma, mb);
            pb_norm.sim_data = obs.p_b_norm;  
            
            ker_sum.sim_data = obs.ker;
            psi.sim_data = obs.psi;
            p_sum_norm.sim_data = obs.p_norm_sum;
            
            pb_norm.hist.sim_data = histcounts(obs.p_b_norm, pb_norm.Binedges,'Normalization','probability');
            ker_sum.hist.sim_data = histcounts(obs.ker, ker_sum.Binedges,'Normalization','probability');
            psi.hist.sim_data = histcounts(obs.psi, psi.Binedges,'Normalization','probability');
            p_sum_norm.hist.sim_data = histcounts(obs.p_norm_sum, p_sum_norm.Binedges,'Normalization','probability');
            
            
            [pb_norm.KSstat(ii,jj)] = Kolmogorov_Smirnov_test(pb_norm);
            [ker_sum.KSstat(ii,jj)] = Kolmogorov_Smirnov_test(ker_sum);
            [psi.KSstat(ii,jj)] = Kolmogorov_Smirnov_test(psi);
            [p_sum_norm.KSstat(ii,jj)] = Kolmogorov_Smirnov_test(p_sum_norm);
            
            %%%%plotting%%%%
            label = join(['Mass of y = ', num2str(mass_y(ii)), ', KER_{com} =', num2str(ker_com(jj))]);
            
            h = findobj(gca,'Tag','top left'); % get handle to object tagged as 'left'
            set(h,'NextPlot','add'); % set 'NextPlot' property to 'add'
            plot(h, pb_norm.Bincenters, pb_norm.hist.sim_data,'DisplayName',label)
            legend(h)
       
            h = findobj(gca,'Tag','top right'); % get handle to object tagged as 'left'
            set(h,'NextPlot','add'); % set 'NextPlot' property to 'add'
            plot(h, ker_sum.Bincenters, ker_sum.hist.sim_data,'DisplayName',label)
            legend(h)
            
            h = findobj(gca,'Tag','bottom left'); % get handle to object tagged as 'left'
            set(h,'NextPlot','add'); % set 'NextPlot' property to 'add'
            plot(h, psi.Bincenters, psi.hist.sim_data,'DisplayName',label)
            legend(h)
            
            h = findobj(gca,'Tag','bottom right'); % get handle to object tagged as 'left'
            set(h,'NextPlot','add'); % set 'NextPlot' property to 'add'
            plot(h, p_sum_norm.Bincenters, p_sum_norm.hist.sim_data,'DisplayName',label)
            legend(h)
        toc
    end
end

%% save
save('pb_norm.mat','-struct','pb_norm');
save('psi.mat','-struct','psi');
save('ker_sum.mat','-struct','ker_sum');
save('p_sum_norm.mat','-struct','p_sum_norm');
save('mass_y.mat','mass_y');
save('ker_com.mat','ker_com');

%% plot ks_stat

figure

subplot(2,2,1)
imagesc(pb_norm.KSstat,'XData',ker_com,'YData',mass_y)
title('pb_{norm}.KSstat')
xlabel('ker_{com}')
ylabel('mass_y')
colorbar

subplot(2,2,2)
imagesc(ker_sum.KSstat,'XData',ker_com,'YData',mass_y )
axis square;
title('ker_{sum}.KSstat')
xlabel('ker_{com}')
ylabel('mass_y')
colorbar

subplot(2,2,3)
imagesc(psi.KSstat,'XData',ker_com,'YData',mass_y)
title('psi.KSstat')
xlabel('ker_{com}')
ylabel('mass_y')
colorbar

subplot(2,2,4)
imagesc(p_sum_norm.KSstat,'XData',ker_com,'YData',mass_y)
axis square;
title('psum_{norm}.KSstat')
xlabel('ker_{com}')
ylabel('mass_y')
colorbar

sgtitle('KSstat of comparision between Simulated and experimental data')


%% add KSstat  values
figure
total.KSstat = ker_sum.KSstat +psi.KSstat + p_sum_norm.KSstat + pb_norm.KSstat;
imagesc(total.KSstat,'XData',ker_com,'YData',mass_y)
title('total.KSstat')
xlabel('ker_{com}')
ylabel('mass_y')
colorbar

[x,y]=find(total.KSstat==min(min(total.KSstat)));
disp([' The minimum KSstat is for KER in C.M. = ',num2str(ker_com(y(1))),' eV'])
disp([' The minimum KSstat is for mass of Y = ',num2str(mass_y(x(1))), ' a.u.'])
% disp([' The p-value for KER simulated is = ',num2str(ker_sum.p_value(x(1),y(1)))])
% disp([' The p-value for sum of momentum simulated is = ',num2str(p_sum_norm.p_value(x(1),y(1)))])

