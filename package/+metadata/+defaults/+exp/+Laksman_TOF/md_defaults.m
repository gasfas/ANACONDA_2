%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPERIMENT % METADATA %  EXPERIMENT % METADATA % EXPERIMENT % METADATA %
% This m-file defines the default metadata.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sample info:
exp_md = metadata.defaults.Laksman_TOF.sample( exp_md );

%% Photon beam information:
exp_md = metadata.defaults.Laksman_TOF.photon( exp_md );

%% Spectrometer info:
exp_md = metadata.defaults.Laksman_TOF.spec( exp_md );

%% Detector info:
exp_md = metadata.defaults.Laksman_TOF.det( exp_md );

%% Correction parameters:
exp_md = metadata.defaults.Laksman_TOF.corr( exp_md );

%% Calibration parameters:
exp_md = metadata.defaults.Laksman_TOF.calib( exp_md );

%% Fitting parameters:
exp_md = metadata.defaults.Laksman_TOF.fit( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = metadata.defaults.Laksman_TOF.conv( exp_md );

%% Condition parameters:
exp_md = metadata.defaults.Laksman_TOF.cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = metadata.defaults.Laksman_TOF.plot(exp_md);
