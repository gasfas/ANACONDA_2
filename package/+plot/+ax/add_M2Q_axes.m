function M2Q_axes = add_M2Q_axes(TOF_axes, conv_md, M2QTicks, M2QTickLabel, coor, ori_plottype)
% Function to add an extra axes to existing TOF spectra.
    M2Q_axes = TOF_axes; % Copy all axes information, and change the Tick related details.
    if ~exist('ori_plottype', 'var')
        ori_plottype = 'TOF'; % If not defined, we assume the original plot is of TOF type.
    end
    
    if strcmpi(ori_plottype, 'TOF')
        % Convert mass to charge:
        M2Q_axes.([coor 'Tick']) = convert.m2q_2_TOF(M2QTicks, conv_md.factor, conv_md.t0);
    elseif strcmpi(ori_plottype, 'M2Q') % No conversion needed:
        M2Q_axes.([coor 'Tick']) = M2QTicks;
    switch coor
        case 'Y'
            M2Q_axes.YAxisLocation = 'right';
        case 'X'
            M2Q_axes.XAxisLocation = 'top';
    end
    M2Q_axes.([coor 'TickLabel']) = M2QTickLabel;
end
