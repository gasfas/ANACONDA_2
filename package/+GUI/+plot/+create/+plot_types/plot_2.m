function  [ ] = plot_2(exp, metadata, graphtype_X, experiment_name, dimensions, md_GUI)
% This macro produces a bunch of plots, based on the corrected and converted signals.
% Input:
% exp           The experimental data, already converted
% metadata      The corresponding metadata 
% SEE ALSO macro.correct, macro.convert
% macro.fit
% [ nof_hits ] = general.count_nof_hits(exp.h);

% First we fetch the detector names:
detnames            = fieldnames(metadata.det);
nof_hits_all_det    = general.count_nof_hits(exp.h);
graphtype_X = char(graphtype_X);
for i = 1:length(detnames)
    detname =   detnames{i};
    nof_hits =  nof_hits_all_det(i);
    % Plot TOF:
    clear tf
    tf = strcmp(graphtype_X, 'TOF');
    if tf == 1
        % No conditions?
        if dimensions == 1
            figure, Ax.TOF = gca;
            plot.hist(gca, exp.h.(detname).TOF_corr, metadata.plot.(detname).TOF);
            title(experiment_name)
        end
    end
    % Plot m2q:
    clear tf
    tf = strncmp(graphtype_X, 'm2q',3);
    if tf == 1
    % No conditions?
    figure, Ax.m2q = gca;
    m2q = exp.h.(detname).m2q;
    f_e = filter.events.multiplicity(exp.e.raw(:,i), 1, 5, length(m2q));
    f_h = filter.events_2_hits_det(f_e, exp.e.raw(:,i), length(m2q));
    plot.hist(gca, m2q(f_h), metadata.plot.(detname).m2q);
    %plot.hist(gca, m2q(~isnan(exp.h.(detname).m2q_l) & f_h), metadata.plot.(detname).m2q, 'LineStyle', '--');
    title(experiment_name)
    end
	% Plot PEPIPICO:
	tf = strcmp(graphtype_X, 'PEPIPICO');
    if tf == 1
    figure, Ax.PEPIPICO = gca;
    % filter out the double coincidences:
    events          = exp.e.raw(:,i);
    e_f_m = filter.events.multiplicity(events, 2, 2, nof_hits);
    idx_1           = events(e_f_m);
    plot.hist(gca, [exp.h.(detname).TOF_corr(idx_1) exp.h.(detname).TOF_corr(idx_1+1)], metadata.plot.(detname).PEPIPICO);
    title(experiment_name)
    end
    % Plot PEPIPICO_M2Q:
    tf = strcmp(graphtype_X, 'PEPIPICO_m2q');
    if tf == 1
    %md_GUI.exp_md.plot.(detector).PEPIPICO_m2q.cond = struct;
    figure, Ax.PEPIPICO_m2q = gca;
    macro.plot.PEPIPICO_m2q(Ax.PEPIPICO_m2q, exp, metadata, detname);
    title(experiment_name)
    end
	%end
    % Plot branching ratio's:
	clear tf
    tf = strcmp(graphtype_X, 'BR');
    if tf == 1
        figure, Ax.BR	= gca;
    	hAx3            = gca;
        expected_labels = metadata.conv.(detname).M2Q_labels;
        label_hist      = exp.h.(detname).label_hist;
        bar(hAx3, expected_labels, label_hist);
        plot.makeup(hAx3, metadata.plot.(detname).BR);
        title(experiment_name)
    end
    % Plot 2D branching ratio's:
    clear tf
    tf = strcmp(graphtype_X, 'BR_2D');
    if tf == 1
    figure, hold on, Ax.BR_2D = gca;
    color           = metadata.plot.(detname).BR_2D.BubbleColor;
    dotsize         = metadata.plot.(detname).BR_2D.dotsize;
    labels          = metadata.conv.(detname).M2Q_labels;
    x_range         = metadata.plot.(detname).BR_2D.x_range;
    y_range         = metadata.plot.(detname).BR_2D.y_range;
    within_x        = labels > x_range(1) & labels < x_range(end);
    within_y        = labels > y_range(1) & labels < y_range(end);
    labels_x        = labels(within_x); 
    labels_y        = labels(within_y);
    BR_hist         = exp.h.(detname).double_label_hist(within_x, within_y);
    plot.hist.H_2D_dots(gca, BR_hist', labels_x, labels_y, color, dotsize)
    set(hAx6, 'Color',[0.9 0.9 0.9]);
    plot.makeup(hAx6, metadata.plot.(detname).BR_2D);
    title(experiment_name)
    hold off
    end
    
	clear tf
	tf = strcmp(graphtype_X, 'det_image');
    if tf == 1
		if isfield(metadata.plot.(detname).det_image, 'cond') % apply conditions:
            filt = macro.filter.conditions_2_filter(exp, metadata.plot.(detname).det_image.cond);
        else
            filt = true(size(exp.e.raw));
        end
        % Plot detector image:
        figure, Ax.det_image       = gca;
        plot.hist(gca, [exp.h.(detname).X_corr(filt) exp.h.(detname).Y_corr(filt)], metadata.plot.(detname).det_image);
        title(experiment_name)
    end
    clear tf
    tf = strcmp(graphtype_X, 'theta_R');
    if tf == 1        % Plot detector image:
        figure, Ax.theta_R       = gca;
        plot.hist(gca, [exp.h.(detname).theta exp.h.(detname).R], metadata.plot.(detname).theta_R);
        title(experiment_name)
	end
    clear tf
    tf = strcmp(graphtype_X, 'TOF_R');
    if tf == 1
        % Plot R vs TOF:
        figure, Ax.TOF_R       = gca;
        % Filter out real events:
        events          = exp.e.raw(:,i);
        idx_1           = events(~isnan(events));
        plot.hist(gca, [exp.h.(detname).TOF_corr(idx_1) exp.h.(detname).R(idx_1)], metadata.plot.(detname).TOF_R);
        title(experiment_name)
    end
    clear tf
    tf = strcmp(graphtype_X, 'TOF_X');
    if tf == 1
        % Plot X vs TOF:
        figure, Ax.TOF_X       = gca;
        % Filter out real events:
        events          = exp.e.raw(:,i);
        idx_1           = events(~isnan(events));
        plot.hist(gca, [exp.h.(detname).TOF_corr(idx_1) exp.h.(detname).X_corr(idx_1)], metadata.plot.(detname).TOF_X);
        title(experiment_name)
	end
    
    clear tf
	tf = strcmp(graphtype_X, 'p2D');
	if tf == 1
    %     Plot 2D momentum image:
        figure, Ax.p2D       = gca;
            [Ax.p2D] = macro.plot.p2D(Ax.p2D, exp, metadata, detname);
            title(experiment_name)
    end
    
    clear tf
	tf = strcmp(graphtype_X, 'p3D');
	if tf == 1
        % Plot 3D momentum image:
        figure, Ax.p3D       = gca;
        plot.hist(gca, [exp.h.(detname).dp, exp.h.(detname).dp, exp.h.(detname).dp], metadata.plot.(detname).p3D);
        title(experiment_name)
    end
    
    clear tf
    tf = strcmp(graphtype_X, 'KER');
    if tf == 1
        % Plot Kinetic energy release:
        figure, Ax.KER       = gca;
        plot.hist(gca, exp.h.(detname).KER, metadata.plot.(detname).KER);
        title(experiment_name)
    end  

	clear tf
    tf = strcmp(graphtype_X, 'KER_sum');
    if tf == 1
        % Plot the total Kinetic energy release:
        figure, Ax.KER_sum   = gca;
        if isfield(metadata.plot.(detname).KER_sum, 'cond') % apply conditions:
            filt = macro.filter.conditions_2_filter(exp, metadata.plot.(detname).KER_sum.cond);
        else
            filt = true(size(exp.e.raw));
        end
        plot.hist(gca, exp.e.(detname).KER_sum(filt), metadata.plot.(detname).KER_sum);
        title(experiment_name)
	end
	
	for C_nr = 2:4
            % Plot mutual angles:
        clear tf
        tf = strcmp(graphtype_X, ['angle_p_corr_C', num2str(C_nr)]);
        if tf == 1
            ax_fn = (['angle_p_corr_C' num2str(C_nr)]);
            figure, Ax.(ax_fn) = polaraxes;
            [Ax.(ax_fn)] = macro.plot.angle_p_corr_Ci(Ax.(ax_fn), exp, metadata, C_nr, detname);
            title(experiment_name)
        end
	end
	
	for C_nr = 2:4
    % Plot momentum norm correlations, for triple coincidence:
        clear tf
        tf = strcmp(graphtype_X, ['KER_angle_p_corr_C' num2str(C_nr)]);
        if tf == 1
            ax_fn = (['KER_angle_p_corr_C' num2str(C_nr)]);
			figure, Ax.(ax_fn) = gca;
			[Ax.(ax_fn)] = macro.plot.KER_angle_p_corr_Ci(Ax.(ax_fn), exp, metadata, C_nr, detname);
            title(experiment_name)
		end  	
    end
    
    % apply the conditions:
    clear tf
    tf = strcmp(graphtype_X, 'norm_p_corr_C2');
    if tf == 1
		filt			= macro.filter.conditions_2_filter(exp, metadata.plot.(detname).norm_p_corr_C2.cond);
		idx1			= exp.e.raw(filt,i); idx2 = idx1 + 1;
		p1_norm			= general.norm_vectorarray(exp.h.(detname).dp(idx1,:),2);
		p2_norm			= general.norm_vectorarray(exp.h.(detname).dp(idx2,:),2);
		
        % Plot momentum norm correlations, for double coincidence:
        figure, Ax.norm_p_corr_C2 = gca;
        plot.hist(Ax.norm_p_corr_C2, [p1_norm, p2_norm], metadata.plot.(detname).norm_p_corr_C2);
        title(experiment_name)

    end
	clear tf
	tf = strcmp(graphtype_X, 'norm_p_corr_C2_ternary');
	if tf == 1
        % Plot momentum norm correlations, for double coincidence:
        figure, Ax.norm_p_corr_C2_ternary = gca;
        [Ax.norm_p_corr] = macro.plot.norm_p_corr_C2_ternary(Ax.norm_p_corr_C2_ternary, exp, metadata, detname);
        title(experiment_name)
	end 
	
	clear tf
    tf = strcmp(graphtype_X, 'norm_p_corr_C3_ternary');
	if tf == 1
        % Plot momentum norm correlations, for triple coincidence:
        figure, Ax.norm_p_corr_C3_ternary = gca;
        [Ax.norm_p_corr] = macro.plot.norm_p_corr_C3_ternary(Ax.norm_p_corr_C3_ternary, exp, metadata, detname);
        title(experiment_name)
	end  
end
%% Event-based histograms
% These are the cross-correlated plots, that take data from different
% detectors, from the same event.

clear tf
tf = strcmp(graphtype_X, 'KER_sum');
if tf == 1
	% Plot momentum norm correlations, for triple coincidence:
	figure, Ax.M2Q_2_KER = gca;
	[Ax.M2Q_2_KER] = macro.plot.M2Q_2_KER( Ax.M2Q_2_KER, exp, metadata);
    title(experiment_name)
end
end