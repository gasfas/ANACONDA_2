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
exp_md = metadata.defaults.exp.MAXLAB_REMI.sample( exp_md );

%% Photon beam information:
exp_md = metadata.defaults.exp.MAXLAB_REMI.photon( exp_md );

%% Spectrometer info:
exp_md = metadata.defaults.exp.MAXLAB_REMI.spec( exp_md );

%% Detector info:
exp_md = metadata.defaults.exp.MAXLAB_REMI.det( exp_md );

%% Correction parameters:
exp_md = metadata.defaults.exp.MAXLAB_REMI.corr( exp_md );

%% Calibration parameters:
exp_md = metadata.defaults.exp.MAXLAB_REMI.calib( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = metadata.defaults.exp.MAXLAB_REMI.conv( exp_md );

% %% Condition parameters:
exp_md = metadata.defaults.exp.MAXLAB_REMI.cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = metadata.defaults.exp.MAXLAB_REMI.plot(exp_md);

%% Fitting parameters:
exp_md = metadata.defaults.exp.MAXLAB_REMI.fit( exp_md );
