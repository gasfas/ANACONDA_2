function [ TOF_peaks ] = find_TOF_peaks (TOF_hist, TOF_peaks_est, search_radius)
%Automation of finding the TOF peak points, based on a few TOF's and their
%corresponding mass-to-charge values.
% Input:
% TOF_hist:       The input histogram, unconverted struct with fields:
% 					TOF_hist.midpoints: the bin containers.
% 					TOF_hist.Count: the actual count.
% TOF_peaks_est:    TOF estimates that show a close peak in the histogram
%                   [n, 1]
% search_radius:	the search radius around the given TOF_peak values.
% Output:
% TOF_peaks:        The TOF where the peak is at its maximum.
%
% See also: CALIBRATE.TOF_2_m2q CONVERT.TOF_2_MASS2CHARGE
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% filter out the TOF hits that are within searchradius around TOF_points:
TOF_labels = convert.signal_2_label(TOF_hist.midpoints, TOF_peaks_est, search_radius);
% remove the TOF hits that are out of range:
% TOF_signal = TOF_signal(find(TOF_labels));
%
% Written by Bart Oostenrijk, Lund university: Bart.oostenrijk(at)sljus.lu.se

TOF_peaks = TOF_peaks_est;

for i = 1:length(TOF_peaks)
    TOF_peak = TOF_peaks(i);
    Count_cur		= TOF_hist.Count(TOF_labels == TOF_peak);
	midpoints_cur	= TOF_hist.midpoints(TOF_labels == TOF_peak);
    % TODO: make a Gaussian fit here, to correctly fit blunt TOF peaks.
    % find the precise TOF of the TOF points and fill it in the TOF_peaks:
	try     [~, TOF_peaks(i)] = findpeaks(Count_cur, midpoints_cur, 'NPeaks', 1, 'SortStr', 'descend');
	catch	[~, idx] = max(Count_cur);  TOF_peaks(i) = midpoints_cur(idx);
	end
end
    
end

