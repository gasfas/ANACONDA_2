function  [ ] = plot_2_n(exp, metadata, exp_names, graphtype_X, dimensions, md_GUI)
% This macro produces a bunch of plots, based on the corrected and converted signals.
% It plots all selected experiments into the very same plot.
% Input:
% exp           The experimental data, already converted
% metadata      The corresponding metadata 
% SEE ALSO macro.correct, macro.convert
% macro.fit
% [ nof_hits ] = general.count_nof_hits(exp.h);

graphtype_X = char(graphtype_X);
linecolors = ['k'; 'b'; 'g'; 'r'; 'c'; 'm'; 'y'];

figure, hold on

for j = 1:length(exp_names)
% First we fetch the detector names:
metadataz = metadata.([char(exp_names(j))]);
expz = exp.([char(exp_names(j))]);
detnames            = fieldnames(metadataz.det);
nof_hits_all_det    = general.count_nof_hits(expz.h);
linecolor = linecolors(j);
for i = 1:length(detnames)
    detname =   detnames{i};
    nof_hits =  nof_hits_all_det(i);
    clear tf
    tf = strcmp(graphtype_X, 'TOF');
    if tf == 1
    disp('true')
    Ax.TOF = gca;
    plot.hist_n(linecolor, gca, expz.h.(detname).TOF_corr, metadataz.plot.(detname).TOF, exp_names(j));
    end
    clear tf
    tf = strcmp(graphtype_X, 'm2q');
    if tf == 1
    Ax.m2q = gca;
    m2q = expz.h.(detname).m2q;
    f_e = filter.events.multiplicity(expz.e.raw(:,i), 1, 5, length(m2q));
    f_h = filter.events_2_hits_det(f_e, expz.e.raw(:,i), length(m2q));
    exp_name = exp_names(j);
    plot.hist_n(linecolor, gca, m2q(f_h), metadataz.plot.(detname).m2q, exp_name);
    legend(exp_names)
    end
    % Plot PEPIPICO:
    clear tf
    tf = strcmp(graphtype_X, 'PEPIPICO');
    if tf == 1
    Ax.PEPIPICO = gca;
    % filter out the double coincidences:
    events          = expz.e.raw(:,i);
    e_f_m = filter.events.multiplicity(events, 2, 2, nof_hits);
    idx_1           = events(e_f_m);
    plot.hist_n(linecolor, gca, [expz.h.(detname).TOF_corr(idx_1) expz.h.(detname).TOF_corr(idx_1+1)], metadataz.plot.(detname).PEPIPICO);
    end
    % Plot PEPIPICO_M2Q:
    clear tf
    tf = strcmp(graphtype_X, 'PEPIPICO_m2q');
    if tf == 1
    Ax.PEPIPICO_m2q = gca;
    macro.plot.PEPIPICO_m2q(Ax.PEPIPICO_m2q, expz, metadataz, detname);
    end
    % Plot branching ratio's:
    clear tf
    tf = strcmp(graphtype_X, 'BR');
    if tf == 1
    Ax.BR	= gca;
    hAx3            = gca;
    expected_labels = metadataz.conv.(detname).M2Q_labels;
    label_hist      = expz.h.(detname).label_hist;
    bar(hAx3, expected_labels, label_hist);
    plot.makeup(hAx3, metadataz.plot.(detname).BR);
    end
    % Plot 2D branching ratio's:
    clear tf
    tf = strcmp(graphtype_X, 'BR_2D');
    if tf == 1
    Ax.BR_2D = gca;
    color           = metadataz.plot.(detname).BR_2D.BubbleColor;
    dotsize         = metadataz.plot.(detname).BR_2D.dotsize;
    labels          = metadataz.conv.(detname).M2Q_labels;
    x_range         = metadataz.plot.(detname).BR_2D.x_range;
    y_range         = metadataz.plot.(detname).BR_2D.y_range;
    within_x        = labels > x_range(1) & labels < x_range(end);
    within_y        = labels > y_range(1) & labels < y_range(end);
    labels_x        = labels(within_x); 
    labels_y        = labels(within_y);
    BR_hist         = expz.h.(detname).double_label_hist(within_x, within_y);
    plot.hist.H_2D_dots(gca, BR_hist', labels_x, labels_y, color, dotsize)
    set(hAx6, 'Color',[0.9 0.9 0.9]);
    plot.makeup(hAx6, metadataz.plot.(detname).BR_2D);
    end
    clear tf
	tf = strcmp(graphtype_X, 'det_image');
    if tf == 1
        if isfield(metadataz.plot.(detname).det_image, 'cond') % apply conditions:
            filt = macro.filter.conditions_2_filter(expz, metadataz.plot.(detname).det_image.cond);
        else
            filt = true(size(expz.e.raw));
        end
        % Plot detector image:
        Ax.det_image       = gca;
        plot.hist_n(linecolor, gca, [expz.h.(detname).X_corr(filt) expz.h.(detname).Y_corr(filt)], metadataz.plot.(detname).det_image);
    end
    % Plot detector image:
    clear tf
    tf = strcmp(graphtype_X, 'theta_R');
    if tf == 1
    Ax.theta_R       = gca;
    plot.hist_n(linecolor, gca, [expz.h.(detname).theta expz.h.(detname).R], metadataz.plot.(detname).theta_R);
    end
    % Plot R vs TOF:
    clear tf
    tf = strcmp(graphtype_X, 'TOF_R');
    if tf == 1
    Ax.TOF_R       = gca;
    % Filter out real events:
    events          = expz.e.raw(:,i);
    idx_1           = events(~isnan(events));
    plot.hist_n(linecolor, gca, [expz.h.(detname).TOF_corr(idx_1) expz.h.(detname).R(idx_1)], metadataz.plot.(detname).TOF_R);
    end
    % Plot X vs TOF:
    clear tf
    tf = strcmp(graphtype_X, 'TOF_X');
    if tf == 1
    Ax.TOF_X       = gca;
    % Filter out real events:
    events          = expz.e.raw(:,i);
    idx_1           = events(~isnan(events));
    plot.hist_n(linecolor, gca, [expz.h.(detname).TOF_corr(idx_1) expz.h.(detname).X_corr(idx_1)], metadataz.plot.(detname).TOF_X);
    end
    % Plot 2D momentum image:
    clear tf
	tf = strcmp(graphtype_X, 'p2D');
	if tf == 1
        Ax.p2D       = gca;
            [Ax.p2D] = macro.plot.p2D(Ax.p2D, expz, metadataz, detname);
    end
    clear tf
    % Plot 3D momentum image:
    tf = strcmp(graphtype_X, 'p3D');
    if tf == 1
    Ax.p3D       = gca;
    plot.hist_n(linecolor, gca, [expz.h.(detname).dp, expz.h.(detname).dp, expz.h.(detname).dp], metadataz.plot.(detname).p3D);
    end
	% Plot Kinetic energy release:
    clear tf
    tf = strcmp(graphtype_X, 'KER');
    if tf == 1
    Ax.KER       = gca;
    plot.hist_n(linecolor, gca, expz.h.(detname).KER, metadataz.plot.(detname).KER);
    end
    clear tf
    tf = strcmp(graphtype_X, 'KER_sum');
    if tf == 1
    % Plot the total Kinetic energy release:
    Ax.KER_sum   = gca;
    if isfield(metadataz.plot.(detname).KER_sum, 'cond') % apply conditions:
        filt = macro.filter.conditions_2_filter(expz, metadataz.plot.(detname).KER_sum.cond);
    else
        filt = true(size(expz.e.raw));
    end
    plot.hist_n(linecolor, gca, expz.e.(detname).KER_sum(filt), metadataz.plot.(detname).KER_sum);
    end
for C_nr = 2:4
    % Plot mutual angles:
    clear tf
    tf = strcmp(graphtype_X, ['angle_p_corr_C', num2str(C_nr)]);
    if tf == 1
    ax_fn = (['angle_p_corr_C' num2str(C_nr)]);
    Ax.(ax_fn) = polaraxes;
    [Ax.(ax_fn)] = macro.plot.angle_p_corr_Ci(Ax.(ax_fn), expz, metadataz, C_nr, detname);
    end
end
for C_nr = 2:4
    % Plot momentum norm correlations, for triple coincidence:
    clear tf
    tf = strcmp(graphtype_X, ['KER_angle_p_corr_C' num2str(C_nr)]);
    if tf == 1
    ax_fn = (['KER_angle_p_corr_C' num2str(C_nr)]);
    Ax.(ax_fn) = gca;
    [Ax.(ax_fn)] = macro.plot.KER_angle_p_corr_Ci(Ax.(ax_fn), expz, metadataz, C_nr, detname);
    end  	
end
% apply the conditions:
clear tf
tf = strcmp(graphtype_X, 'norm_p_corr_C2');
if tf == 1
filt			= macro.filter.conditions_2_filter(exp, metadataz.plot.(detname).norm_p_corr_C2.cond);
idx1			= exp.e.raw(filt,i); idx2 = idx1 + 1;
p1_norm			= general.norm_vectorarray(exp.h.(detname).dp(idx1,:),2);
p2_norm			= general.norm_vectorarray(exp.h.(detname).dp(idx2,:),2);
% Plot momentum norm correlations, for double coincidence:
Ax.norm_p_corr_C2 = gca;
plot.hist_n(linecolor, Ax.norm_p_corr_C2, [p1_norm, p2_norm], metadataz.plot.(detname).norm_p_corr_C2);
end
clear tf
tf = strcmp(graphtype_X, 'norm_p_corr_C2_ternary');
if tf == 1
Ax.norm_p_corr_C2_ternary = gca;
[Ax.norm_p_corr] = macro.plot.norm_p_corr_C2_ternary(Ax.norm_p_corr_C2_ternary, exp, metadataz, detname);
end
clear tf
tf = strcmp(graphtype_X, 'norm_p_corr_C3_ternary');
if tf == 1
Ax.norm_p_corr_C3_ternary = gca;
[Ax.norm_p_corr] = macro.plot.norm_p_corr_C3_ternary(Ax.norm_p_corr_C3_ternary, exp, metadataz, detname);
end
end
%% Event-based histograms
% These are the cross-correlated plots, that take data from different
% detectors, from the same event.
clear tf
tf = strcmp(graphtype_X, 'KER_sum');
if tf == 1
Ax.M2Q_2_KER = gca;
[Ax.M2Q_2_KER] = macro.plot.M2Q_2_KER( Ax.M2Q_2_KER, exp, metadataz);
end
end
hold off
end