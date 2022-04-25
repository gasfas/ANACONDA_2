function M2Q_axes = add_M2Q_axes(TOF_axes, conv_md, M2QTicks, M2QTickLabel, coor)
% Function to add an extra axes to existing TOF spectra.
    M2Q_axes = TOF_axes; % Copy all axes information, and change the Tick related details.
    M2Q_axes.([coor 'Tick']) = convert.m2q_2_TOF(M2QTicks, conv_md.factor, conv_md.t0);
    switch coor
        case 'Y'
            M2Q_axes.YAxisLocation = 'right';
        case 'X'
            M2Q_axes.XAxisLocation = 'top';
    end
    M2Q_axes.([coor 'TickLabel']) = M2QTickLabel;
end
