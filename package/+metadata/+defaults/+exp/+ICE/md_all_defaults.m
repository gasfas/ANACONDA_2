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
exp_md = ICE_sample( exp_md );

%% Photon beam information:
exp_md = ICE_photon( exp_md );

%% Spectrometer info:
exp_md = ICE_spec( exp_md );

%% Detector info:
exp_md = ICE_det( exp_md );

%% Correction parameters:
exp_md = ICE_corr( exp_md );

%% Calibration parameters:
exp_md = ICE_calib( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = ICE_conv( exp_md );

% %% Condition parameters:
exp_md = ICE_cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = ICE_plot(exp_md);

%% Fitting parameters:
exp_md = ICE_fit( exp_md );