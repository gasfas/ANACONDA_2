function [ hLine, v ] = no_dp_line(Ax, md, detnr, coor)
%This function plots a line in a TOF-X plot that shows the expected
%position of the hit at that mass. We assume that the molecular beam is
%perpendicular to the detector axis.
% Inputs:
% Ax		The TOF_X axis to plot into (TOF along x-axis assumed)
% TOF		The TOF values at which the position should be shown
% sample_md	The metadata of the sample: This gives information about the
% expected position.
% coor		The coordinate that is plotted on the Y-axis (e.g. 'X', 'Y', 'R')
% Outputs:
% hLine		The handle of the reference line.

TOF = linspace(Ax.XLim(1), Ax.XLim(2), 1e3);
sample_md	= md.sample;
spec_md		= md.spec;
conv_md		= md.conv.(['det' num2str(detnr)]);

labels_mass		= convert.TOF_2_m2q(TOF, conv_md.TOF_2_m2q.factor, conv_md.TOF_2_m2q.t0);
labels_charge	= 1;
E_ER			= theory.TOF.calc_field_strength(spec_md.volt.Ve2s, spec_md.volt.Vs2a, spec_md.dist.s);

[d.X_0, d.Y_0, d.T_0] = convert.zero_dp_splat_position(TOF, labels_mass, labels_charge, E_ER, sample_md);
d.R_0 = sqrt(d.X_0.^2 + d.Y_0.^2);
v = d.R_0./d.T_0*1e6;
if all(diff(v)./v(1:end-1) < 1e-10)
	v = mean(v);
end

% Select the ordinate that is chosen by the user:
ord_name = [coor '_0'];
hold(Ax, 'on')
hLine = plot(Ax, TOF, d.(ord_name), 'Color', 'k', 'LineStyle', '--');

end
