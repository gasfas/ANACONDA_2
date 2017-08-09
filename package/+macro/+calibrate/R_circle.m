function [ R_maxs, R_avg, theta ] = R_circle(det_data, calib_md)
%This function performs an angle-dependent energy calibration of the
%electron energy. Note that this procedure focuses on the RELATIVE
%calibration, not on the ABSOLUTE energy value.
% The procedure assumes that the Regions of Intersest (ROI) contain only
% ONE peak. The points are interpolated between the origin (R=0) and the
% recognized peak values.
% Inputs:
% - det_data		The detector data
% - calib_md		the calibration metadata of the e_KE routine.
% Outputs:
% - r_sf			The radial scaling factor [-].
% - theta			The corresponding theta values [rad].
plot_md = calib_md.plot;

if calib_md.isplotted
	% Plot (for the visual minds):
	plot_md.plottype = 'Default';
	figure; ax = gca; 
	plot.quickhist(ax, [det_data.theta, det_data.R], 'plot_md', plot_md);
end

%% Region of interest:
% Fetch and visualize the field of interest
% There can be multiple separate radial ROI's defined:
ROI_th	= plot_md.hist.Range(1,:);
ROI_R	= sort(calib_md.ROI,1);
if calib_md.isplotted
	% Visualize the Region of interest:
	for i = 1:size(ROI_R, 1)
		hold on;
		th	= ROI_th([1 2 2 1]);
		R	= ROI_R(i, [1 1 2 2]);
		hpatch = patch(ax, th,R, plot.colormkr(i));
		set(hpatch, 'FaceAlpha', '0.2')
	end
end

% To prevent extrapolation problems, we add R=0 point:
th_bins	= hist.bins(plot_md.hist.Range(1,:), plot_md.hist.binsize(1));
R_maxs = zeros(length(th_bins)-1, size(ROI_R, 1)+2); R_avg = zeros(size(ROI_R, 1)+2,1);
%% Calculate histogram of field of interest:
for i = 1:size(ROI_R, 1)
	% Construct/Plot a 2-D histogram:
	R_bins	= hist.bins(ROI_R(i,:), plot_md.hist.binsize(2));
	[Count_ROI, theta, R] = hist.H_2D(det_data.theta, det_data.R, th_bins, R_bins);

	%% Peak finding
	% Calculate the average value in the histogram, to force all the radial
	% peak points to line up with:
	[~,R_avg(i+1)] = findpeaks(sum(Count_ROI, 1), R, 'NPeaks',1, 'SortStr', 'descend');

	% apply a median filter:
	R_filter_width = floor(calib_md.filter_width./plot_md.hist.binsize(2));
	Count_ROI_f = medfilt2(Count_ROI, [1, R_filter_width]);

	% Now we perform a two-dimensional peak finding (maximum) to find the correction
	% factor for different theta values:
	[~, idx]		= max(Count_ROI_f, [], 2);
	R_maxs(:,i+1)	= R_bins(idx);
end

% To prevent extrapolation problems, we add R = 2*max(R_avg) point:
R_avg(end)		= 2*max(R_avg);
R_maxs(:,end)	= R_avg(end) /R_avg(i+1) * R_maxs(:,i+1);

if calib_md.isplotted
	hold on;
	plot(theta, R_maxs, 'k+')
end
colormap(plot.custom_RGB_colormap); grid on
xlabel('Theta [rad]'); ylabel('R [mm]')

%% validation of the correction:

if calib_md.isplotted
	R_corr = correct.R_circle(det_data.R, det_data.theta, R_maxs, R_avg, theta);
	plot_md.plottype = 'Default';
	figure; ax = gca; 
	plot.quickhist(ax, [det_data.theta, R_corr], 'plot_md', plot_md);
end
colormap(plot.custom_RGB_colormap); grid on; 
xlabel('Theta [rad]'); ylabel('R [mm]')

end

