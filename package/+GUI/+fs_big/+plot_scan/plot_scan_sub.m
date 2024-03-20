function [hLine] = plot_scan_sub(haxes, M2Q_data, bins, mass_limits_cur, photon_energy, Yscale, dY, plotname, LineColor, Marker, LineStyle)
    % Plot the energy scan subplot.
    hold(haxes, 'on')
    mass_limits_cur(1)  = max(min(bins), mass_limits_cur(1));
    mass_limits_cur(2)  = min(max(bins), mass_limits_cur(2));
    % Get the unique masses and corresponding indices:
    [bins_u, idx_u] = unique(bins);
    % Find the indices of the closest mass points in the data:
    mass_indices = interp1(bins_u, idx_u, mass_limits_cur, 'nearest', 'extrap');
    if islogical(LineStyle) || isempty(LineStyle);    LineStyle = '-'; end
    if islogical(Marker)    || isempty(Marker);         Marker = 'none'; end
    hLine = plot(haxes, ...
        photon_energy, Yscale*trapz(bins(mass_indices(1):mass_indices(2),:), M2Q_data(mass_indices(1):mass_indices(2),:),1) + dY, 'b', 'DisplayName', plotname, ...
        'Color', LineColor, 'LineStyle', LineStyle, 'Marker', Marker);
end