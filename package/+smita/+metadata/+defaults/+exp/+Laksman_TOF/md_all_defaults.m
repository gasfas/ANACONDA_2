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
exp_md = metadata.defaults.exp.Laksman_TOF.sample( exp_md );
% delete - exp_md = my_md.Laksman_TOF_clusters.sample( exp_md );

%% Photon beam information:
exp_md = metadata.defaults.exp.Laksman_TOF.photon( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.photon( exp_md );

%% Spectrometer info:
exp_md = metadata.defaults.exp.Laksman_TOF.spec( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.spec( exp_md );

%% Detector info:
exp_md = metadata.defaults.exp.Laksman_TOF.det( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.det( exp_md );

%% Correction parameters:
exp_md = metadata.defaults.exp.Laksman_TOF.corr( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.corr( exp_md );

%% Calibration parameters:
exp_md = metadata.defaults.exp.Laksman_TOF.calib( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.calib( exp_md );

%% Fitting parameters:
exp_md = metadata.defaults.exp.Laksman_TOF.fit( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.fit( exp_md );

%% Conversion factors:
% Which conversions should be performed on the data:
exp_md = metadata.defaults.exp.Laksman_TOF.conv( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.conv( exp_md );

%% Condition parameters:
exp_md = metadata.defaults.exp.Laksman_TOF.cond( exp_md );
%exp_md = my_md.Laksman_TOF_clusters.cond(exp_md);
                                                    
%% Plot Styles are defined in this file.
exp_md = metadata.defaults.exp.Laksman_TOF.plot(exp_md);
%exp_md = my_md.Laksman_TOF_clusters.plot(exp_md);
end