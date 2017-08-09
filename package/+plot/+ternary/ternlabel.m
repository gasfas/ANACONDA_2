% TERNLABEL label ternary phase diagram
%   TERNLABEL('ALABEL', 'BLABEL', 'CLABEL') labels a ternary phase diagram created using TERNPLOT
%   
%   H = TERNLABEL('ALABEL', 'BLABEL', 'CLABEL') returns handles to the text objects created.
%   with the labels provided.  TeX escape codes are accepted.
%
%   See also TERNPLOT

% Author: Carl Sandrock 20020827

% To Do

% Modifications

% Modifiers

function h = ternlabel(A, B, C)
rel_pos = 0.5; dist = 0.17;
r(1) = text(0.5, -dist, A, 'horizontalalignment', 'center', 'verticalalignment', 'bottom', 'FontSize', 20);
r(2) = text(1-rel_pos*sin(deg2rad(30))+dist*cos(deg2rad(30)), rel_pos*cos(deg2rad(30)) + dist*sin(degtorad(30)), B, 'rotation', -60, 'horizontalalignment', 'center', 'FontSize', 20);
r(3) = text(rel_pos*sin(deg2rad(30))-dist*cos(deg2rad(30)), rel_pos*cos(deg2rad(30)) + dist*sin(degtorad(30)), C, 'rotation', 60, 'horizontalalignment', 'center', 'FontSize', 20);

if nargout > 0
    h = r;
end;