%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPERIMENT % METADATA %  EXPERIMENT % METADATA % EXPERIMENT % METADATA %
% This m-file defines the default metadata.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exp_md = md_all_defaults()
if ~exist('exp_md', 'var')
    exp_md = struct();
end

%% Sample info:
exp_md = metadata.defaults.Laksman_TOF_e_XY.sample( exp_md );

%% Photon beam information:
exp_md = metadata.defaults.Laksman_TOF_e_XY.photon( exp_md );

%% Spectrometer info:
exp_md = metadata.defaults.Laksman_TOF_e_XY.spec( exp_md );

%% Detector info:
exp_md = metadata.defaults.Laksman_TOF_e_XY.det( exp_md );

%% Correction parameters:
exp_md = metadata.defaults.Laksman_TOF_e_XY.corr( exp_md );

%% Calibration parameters:
exp_md = metadata.defaults.Laksman_TOF_e_XY.calib( exp_md );

%% Fitting parameters:
exp_md = metadata.defaults.Laksman_TOF_e_XY.fit( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = metadata.defaults.Laksman_TOF_e_XY.conv( exp_md );

%% Condition parameters:
exp_md = metadata.defaults.Laksman_TOF_e_XY.cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = metadata.defaults.Laksman_TOF_e_XY.plot(exp_md);
end