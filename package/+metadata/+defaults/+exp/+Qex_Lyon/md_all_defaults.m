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
exp_md = metadata.defaults.exp.Qex_Lyon.sample( exp_md );

%% Photon beam information:
exp_md = metadata.defaults.exp.Qex_Lyon.photon( exp_md );

%% Spectrometer info:
exp_md = metadata.defaults.exp.Qex_Lyon.spec( exp_md );

%% Detector info:
exp_md = metadata.defaults.exp.Qex_Lyon.det( exp_md );

%% Correction parameters:
exp_md = metadata.defaults.exp.Qex_Lyon.corr( exp_md );

%% Calibration parameters:
exp_md = metadata.defaults.exp.Qex_Lyon.calib( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = metadata.defaults.exp.Qex_Lyon.conv( exp_md );

% %% Condition parameters:
exp_md = metadata.defaults.exp.Qex_Lyon.cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = metadata.defaults.exp.Qex_Lyon.plot(exp_md);

%% Fitting parameters:
exp_md = metadata.defaults.exp.Qex_Lyon.fit( exp_md );