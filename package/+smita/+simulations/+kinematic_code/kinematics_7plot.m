%% Kinematics of dissociation - Dalitz plot
% assume a pathway :
%  step 1 : M ---> X + A
% step 2      ---> Y + B + A
% you detect ions A and B where A is produced in first step
function [data_simulated] = kinematics_7plot(ker_com, pa, masses )
% mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
% macro.plot(data_converted, mdata)
% %% filter events and hits experimental data
% [e_filter, ~]	= macro.filter.conditions_2_filter(data_converted, cond_plot);
% hit_filter = filter.events_2_hits_det(e_filter, data_converted.e.raw(:,1), length(data_converted.h.det1.dp_norm),...
%     cond_plot, data_converted); 
% %% filter the event experimental data
% fn = fieldnames(data_converted.e.det1);
% for k=1:numel(fn)
%     if( isnumeric(data_converted.e.det1.(fn{k})) )
%         data_converted.e.det1.(fn{k}) = data_converted.e.det1.(fn{k})(e_filter);
%     end
% end
%% Masses
ma = masses.ma * general.constants('amu');
mb = masses.mb * general.constants('amu');
mc = masses.mc * general.constants('amu'); %variable mass

%% KER CM
ker_cm = ker_com.* general.constants('eVtoJ'); %variable ker released after second breakup in center of mass frame

%% Momentum of B in center of mass frame
p_b_cm.r = abs(sqrt((2 * ker_cm * mb .*mc) ./ (mb + mc)));

%% we vary p_b_cm in all possible angles in center of mass frame
theta = (-90:5:90).* pi/180 ; %%angke between p1 and p2 radians elevation
phi = (-180:5:180).* pi/180 ; %%angke between p1 and p2 radians azimuthal
%% Momentum of A and X
p_a.vector = pa .* general.constants('momentum_au'); %convert to SI

[p_a.phi,p_a.theta,p_a.r] = cart2sph(p_a.vector(:,1),p_a.vector(:,2),p_a.vector(:,3));
[p_x.phi,p_x.theta,p_x.r] = cart2sph(-p_a.vector(:,1),-p_a.vector(:,2),-p_a.vector(:,3));

p_a.vector = pa .* general.constants('momentum_au'); %convert to SI
p_x.vector = - p_a.vector;
%% intitialize output
data_simulated.h.det1.dp_norm =[]; data_simulated.h.det1.m2q_l=[]; data_simulated.e.det1.filt.C3=[]; 
data_simulated.e.det1.mult = []; data_simulated.e.det1.dp_sum_norm=[];
data_simulated.e.raw  = 1;
struct_names = {'p_a', 'p_b','p_c'};
%% factor for calculation of pb and py in lab frame
for ii = 1:length(theta)
    tic
    for jj = 1:length(phi)
            p_b_cm.theta = theta(ii);
            p_b_cm.phi = phi(jj);
            % calculate pb in lab frame
            p_b = vector_add_3d( p_b_cm, (mb / (mb + mc)) .* p_x.vector);
            % calculate py in lab frame
            p_c = vector_add_3d( p_x.vector, -p_b.vector);
            %% add simulated hit data and event data
            p_a.m =masses.ma; p_b.m =masses.mb; p_c.m =masses.mc;
            [~, sort_order] = sort([p_a.m, p_b.m,p_c.m]);

            for hit_no = 1: length(p_a.r)
                for kk = sort_order
                field_name = sprintf('%s.r(%i)', struct_names{kk}, hit_no);
                data_simulated.h.det1.dp_norm = [data_simulated.h.det1.dp_norm; eval(field_name)];
                data_simulated.h.det1.m2q_l   = [data_simulated.h.det1.m2q_l; eval(sprintf('%s.m', struct_names{kk}))];
                end
                data_simulated.e.raw  =[data_simulated.e.raw  ; (data_simulated.e.raw(end) +3)];
                p_sum_measured = vector_add_3d( p_a.vector(hit_no,:), p_b.vector(hit_no,:));
                p_sum_total = vector_add_3d( p_c.vector(hit_no,:), p_sum_measured);
                data_simulated.e.det1.dp_sum_norm  = [data_simulated.e.det1.dp_sum_norm; p_sum_total.r];
                data_simulated.e.det1.filt.C3  = [data_simulated.e.det1.filt.C3; 1];
                data_simulated.e.det1.mult  = [ data_simulated.e.det1.mult; 3];
            end
            
         
    end
    toc
end
data_simulated.e.raw(end) =[]; %%last element doesnt exist in event data
%% convert momentum to au
data_simulated.e.det1.dp_sum_norm = data_simulated.e.det1.dp_sum_norm./general.constants('momentum_au'); %convert to au
data_simulated.h.det1.dp_norm = data_simulated.h.det1.dp_norm./general.constants('momentum_au'); %convert to au
%             p_c.r = p_c.r./general.constants('momentum_au'); %convert to au
% % observables.p_b_norm = observables.p_b_norm./general.constants('momentum_au');
% observables.p_norm_sum = observables.p_norm_sum./general.constants('momentum_au');
end
% legend()

% figure
% plot(observables.p_norm_sum./general.constants('momentum_au'), observables.ker,'-','DisplayName',... 
%     num2str(my ./ general.constants('amu'))) %(ker_cm))%
% hold on
% figure
% polarplot(psi_measurable ,ker_measurable,'o','DisplayName',... 
%     num2str(my ./ general.constants('amu')))
% 
% figure
% polarplot(psi_measurable ,p_norm_sum_measurable./general.constants('momentum_au'),'r')

 