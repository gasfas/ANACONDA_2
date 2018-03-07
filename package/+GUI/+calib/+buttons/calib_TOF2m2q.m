

function calib_TOF2m2q()
%all data is stored in the md_GUI
md_GUI = evalin('base', 'md_GUI');



% Get the data depending on whether its electrons or ions, there should be
% a switch

% More experiments might have been saved, thus we iterate over the
% exp_names

for xn = 1: length(md_GUI.load.exp_names)
    exp_data    = md_GUI.data_n.(['exp' int2str(xn)]);
    exp_md      = md.GUI.mdata_n.(['exp' int2str(xn)]);


    [factor, t0] = macro.calibrate.TOF_2_m2q(exp_data.h.det1, exp_md.calib.det1)







end
        