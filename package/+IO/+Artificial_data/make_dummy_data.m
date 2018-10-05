function [dummy, th_md] = make_dummy_data(th_md)
nof_det = length(th_md.n_hits);

for dnr = 1:nof_det
	dnr_name = ['det' num2str(dnr)];
    max_hit_index = th_md.n_hits(dnr);
    det_name = th_md.det.(['det' num2str(dnr)]).name;
    % making dummy events:
    dummy.e.raw(:,dnr) = double(sort(int32((max_hit_index-1)*rand(th_md.n_events, 1)),1)) + 1;
    
    % making the dummy data (hits):
    switch det_name
        case 'Roentdek DLD X,Y,T detector'
            % In case of a 'Roentdek DLD X,Y,T detector', we assume a TOF momentum
            % imaging spectrometer. The particles are randomly distributed,
            % with a set energy and mass.
            m               = th_md.mass(general.stat.randp(1/length(th_md.mass)*(ones(length(th_md.mass),1)), [th_md.n_hits(dnr),1])); %[a.m.u.]
            q               = th_md.charge;% Charge
            KE              = normrnd(th_md.ke*ones(th_md.n_hits(dnr),1), th_md.sigma_ke*ones(th_md.n_hits(dnr),1));% [eV]
            KE(KE<0)        = -KE(KE<0); % making sure no negative energies are given.
            beta            = th_md.beta;
            amomu           = general.constants('momentum_au');
            abs_p           = amomu * convert.KE_2_p(KE, m);
            E_ER            = theory.TOF.calc_field_strength(th_md.volt.Ve2s, th_md.volt.Vs2a, th_md.dist.s); %[V/m]
            % We describe the momentum oriention in space with a beta-distribution:    
            azimuth         = 2*pi*rand(th_md.n_hits(dnr),1);
            % generate random numbers from PDF:
            theta           = linspace(0,pi,1e4)';
            L               = legendre(2, cos(theta));
            PDD = sin(theta) .* (1 + beta * L(1,:)') ./ (2);
            elevation = general.stat.rand_PDD(theta, PDD, [th_md.n_hits(dnr),1]) - pi/2;
            [p_z,p_y,p_x]   = sph2cart(azimuth,elevation,abs_p);
            
            % The TOF can be calculated from the theoretical model:
            TOF             = theory.predict_TOF_Laksman(p_z./amomu, m, q, th_md.volt, th_md.dist);
            % The zero-KE TOF also:
            TOF_no_KE       = theory.predict_TOF_Laksman(0, m, q, th_md.volt, th_md.dist);
%             dTOF            = TOF - TOF_no_KE;
            % Give some artificial momentum in x-direction:
%             p_x             = p_x + mean(p_x);
            
%             Fill it into the raw hit arrays:
            dummy.h.(dnr_name).raw(:,1) = p_x.*TOF./(m*general.constants({'amu'}))*1e-6;
            dummy.h.(dnr_name).raw(:,2) = p_y.*TOF./(m*general.constants({'amu'}))*1e-6;
            dummy.h.(dnr_name).raw(:,3) = TOF;
            %             recalculate scaling factors (for this ideal picture):
            [th_md.conv.det1.TOF_2_m2q.factor, th_md.conv.det1.TOF_2_m2q.t0] = calibrate.TOF_2_m2q([0 TOF_no_KE(1)], [0  m(1)/q(1)]);
            % only one expected mass and mtoq:
            th_md.conv.det1.m2q_labels 		= th_md.mass./th_md.charge; % the expected mass to charge values in this experiment (example from NH3 cluster experiment, 2009).
            th_md.conv.det1.mass_labels 		= th_md.mass ; % the corresponding expected mass
            % no corrections needed:
            th_md.corr.det1.ifdo.dXdY        = false; % Does this data need detector image translation correction?
            th_md.corr.det1.ifdo.dTheta 		= false; % Does this data need detector image rotation correction?
            th_md.corr.det1.ifdo.dTOF  		= false; % Does this data need detector absolute TOF correction?
            th_md.corr.det1.ifdo.detectorabb	= false; % Does this data need detector-induced abberation correction?
            th_md.corr.det1.ifdo.lensabb 		= false; % Does this data need lens abberation correction?
           
        case 'Photodiode'
            min = 0.1;
            max = 2;
            dummy.h.(dnr_name).raw(:,1) = min + (max-min)*rand(th_md.n_hits(dnr),1);
    end
end
dummy.e.raw(1,:) = ones(1,nof_det);% First values needs to be a one
dummy.e.raw = IO.zero_mult_to_NaN(dummy.e.raw, th_md.n_hits); % removing NaN's


end
