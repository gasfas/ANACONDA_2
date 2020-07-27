%% Kinematics of dissociation
% assume a pathway :
%  step 1 : M ---> X + A
% step 2      ---> Y + B + A
% you detect ions A and B where A is produced in first step
function [observables] = kinematics_7(ker_com, mass_y, pa, ma, mb)
% mdata = IO.import_metadata(S(exp(1)).dir_CO2); %%% select the mdata to use
% macro.plot(data_converted, mdata)
%% Masses
ma = ma * general.constants('amu');
mb = mb * general.constants('amu');
my = mass_y * general.constants('amu'); %variable mass

%% KER CM
ker_cm = ker_com.* general.constants('eVtoJ'); %variable ker released after second breakup in center of mass frame
 
 %% 
observables.p_b_norm = [];
observables.p_norm_sum = [];
observables.ker = [];
observables.psi = [];


%% Momentum of B in center of mass frame
p_b_cm.r = abs(sqrt((2 * ker_cm * mb .*my) ./ (mb + my)));

%% we vary p_b_cm in all possible angles in center of mass frame
theta = (-90:5:90).* pi/180 ; %%angke between p1 and p2 radians elevation
phi = (-180:5:180).* pi/180 ; %%angke between p1 and p2 radians azimuthal
%% Momentum of A 

[p_a.phi,p_a.theta,p_a.r] = cart2sph(pa(:,1),pa(:,2),pa(:,3));
[p_x.phi,p_x.theta,p_x.r] = cart2sph(-pa(:,1),-pa(:,2),-pa(:,3));

p_a.r = p_a.r .* general.constants('momentum_au'); %a.u. norm
%% factor for calculation of pb in lab frame
p_x.r = (mb / (mb + my)) .* p_x.r .* general.constants('momentum_au'); %a.u. norm
            
for ii = 1:length(theta)
%     tic
    for jj = 1:length(phi)
            p_b.phi=[]; p_b.r=[]; p_b.theta=[]; p_sum_struct.phi =[];p_sum_struct.theta =[];p_sum_struct.r =[];
            p_b_cm.theta = theta(ii);
            p_b_cm.phi = phi(jj);
            
            p_b = vector_add_3d( p_b_cm, p_x);
            observables.p_b_norm = [observables.p_b_norm; p_b.r];
            observables.ker =[observables.ker; (( p_a.r.^2 ./ (2 * ma) ) + (p_b.r.^2 ./ (2 * mb ) )) .* general.constants('JtoeV')] ;
            p_sum_struct = vector_add_3d( p_a, p_b);
            observables.p_norm_sum =[observables.p_norm_sum; p_sum_struct.r];
            observables.psi= [observables.psi; vector_angle( p_a, p_b)];
         
    end
%     toc
end

%% convert momentum to au

observables.p_b_norm = observables.p_b_norm./general.constants('momentum_au');
observables.p_norm_sum = observables.p_norm_sum./general.constants('momentum_au');
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

 