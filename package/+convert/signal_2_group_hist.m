function [ hist_group ] = signal_2_group_hist(signal, boundaries, correction_method, bgr_1, bgr_2)
% This function converts the signal to a histogram. The containers of the
% histogram are defined by 'boundaries'. The boundaries do not need to
% coincide, but cannot overlap.
% Input:
% signal        The data hits. [n,1]
% boundaries    The histogram edges minimum and maximum [m, 2]
% correction_method The stage at which the background correction should be 
%               applied: either 'hits' or 'Intensity'
% 'Intensity'
% bgr_signal    The hits from a background signal
% bgr_factor    The factor by which the background histogram should be
%               multiplied before subtracted from the data.
% hist_group    The histogram, showing the amount of hits (minus
%               background) in each specified histogram container

%% Data:
% binning:
edge1                   = reshape(boundaries', [1, numel(boundaries)]);
[raw_hist_all]          = hist.histcn(signal, edge1);
% we only need the odd element in this array:
raw_hist_group          = raw_hist_all(1:2:end);
%% Background subtraction:
if strcmpi(correction_method, 'hits')
    % bgr_1 are the hits, bgr_2 is the subtraction factor
    % binning:
    [bgr_hist_all]          = hist.histcn(bgr_1, edge1);
    bgr_hist_group          = bgr_hist_all(1:2:end);
    % Subtracting background from data:
    hist_group              = raw_hist_group - bgr_2*bgr_hist_group;
elseif strcmpi(correction_method, 'Intensity')
    if length(bgr_1) ==1
        % a correction of one value-for-all is applied:
        hist_group              = raw_hist_group - bgr_1;
    else
        %     we apply the correction to the intensity directly:
        % bgr_1 are the y-values
        % bgr_2 are the x-axes of integration
        hist_group              = raw_hist_group - mean(bgr_1, 2).*diff(bgr_2,1,2);
    end
end
end
