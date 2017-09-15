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
exp_md = metadata.defaults.exp.EPICEA.sample( exp_md );

%% Photon beam information:
exp_md = metadata.defaults.exp.EPICEA.photon( exp_md );

%% Spectrometer info:
exp_md = metadata.defaults.exp.EPICEA.spec( exp_md );

%% Detector info:
exp_md = metadata.defaults.exp.EPICEA.det( exp_md );

%% Correction parameters:
exp_md = metadata.defaults.exp.EPICEA.corr( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = metadata.defaults.exp.EPICEA.conv( exp_md );

%% Condition parameters:
exp_md = metadata.defaults.exp.EPICEA.cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = metadata.defaults.exp.EPICEA.plot(exp_md);

%% Fitting parameters:
exp_md = metadata.defaults.exp.EPICEA.fit( exp_md );

%% Calibration parameters:
exp_md = metadata.defaults.exp.EPICEA.calib( exp_md );

end