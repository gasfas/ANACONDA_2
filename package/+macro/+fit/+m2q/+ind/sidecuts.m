function [IG, LB, UB] = sidecuts(fit_md, IG, LB, UB, m2q_cut_center)
% This function makes sure that the peak centres the user wishes to cut out
% do not show up in the fit.

%  Recognize which centres are cut out:
%IG:
centers         = linspace(IG(end-6), IG(end-5), round((IG(end-5)-IG(end-6)+IG(end-4))./IG(end-4)));
q               = size(centers,2) - 1; % q is the number of dice throws
IG_rph			= IG(1:q+1);% relative peak heights
UB_rph			= UB(1:q+1);
LB_rph			= LB(1:q+1);

min_center = (m2q_cut_center - fit_md.sidecuts.m2q_width);
max_center = (m2q_cut_center + fit_md.sidecuts.m2q_width);

% Take all centres that are outside the scope:
centers_to_remove = (centers < min_center | centers > max_center);

IG_rph(centers_to_remove) = 0;

UB(1:q+1) = IG_rph;

LB(1:q+1) = IG_rph;

end