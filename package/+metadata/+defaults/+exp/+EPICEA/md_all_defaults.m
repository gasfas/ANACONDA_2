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
exp_md = metadata.defaults.Laksman_TOF.sample( exp_md );

%% Photon beam information:
exp_md = metadata.defaults.Laksman_TOF.photon( exp_md );

%% Spectrometer info:
exp_md = metadata.defaults.EPICEA.spec( exp_md );

%% Detector info:
metadata.defaults.EPICEA.det( exp_md );

%% Correction parameters:
metadata.defaults.EPICEA.corr( exp_md );

%% Calibration parameters:
exp_md = metadata.defaults.EPICEA.calib( exp_md );

%% Fitting parameters:
exp_md = metadata.defaults.Laksman_TOF.fit( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = metadata.defaults.Laksman_TOF.conv( exp_md );

%% Condition parameters:
metadata.defaults.EPICEA.cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = metadata.defaults.EPICEA.plot(exp_md);
end