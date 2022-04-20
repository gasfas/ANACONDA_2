function [ R_maxs, R_avg, theta ] = R_circle(exp, calib_md)
%This function performs an angle-dependent energy calibration of the
%electron energy. Note that this procedure focuses on the RELATIVE
%calibration, not on the ABSOLUTE energy value.
% The procedure assumes that the Regions of Intersest (ROI) contain only
% ONE peak. The points are interpolated between the origin (R=0) and the
% recognized peak values.
% Inputs:
% - det_data		The experiment data
% - calib_md		the calibration metadata of the e_KE routine.
% Outputs:
% - r_sf			The radial scaling factor [-].
% - theta			The corresponding theta values [rad].
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

plot_md = calib_md.plot;
plot_md_bck = plot_md;

if general.struct.probe_field(calib_md, 'ifdo.plot')
	% Plot (for the visual minds):
	[h_fig, h_ax] = macro.plot.create.plot(exp, calib_md.plot);
end


%% Region of interest:
% Fetch and visualize the field of interest
% There can be multiple separate radial ROI's defined:
ROI_th	= plot_md.hist.Range(1,:);
ROI_R	= sort(calib_md.ROI,1);

% Check if the peak type is specified:
if ~general.struct.issubfield(calib_md, 'PeakType')
	calib_md.PeakType		= cell(1, size(ROI_R, 1));
	calib_md.PeakType(:)	= {'Peak'};
elseif length(calib_md.PeakType) < size(ROI_R, 1) % Not enough peaktypes given:
	calib_md.PeakType(end+1:size(ROI_R, 1)) = {'Peak'};
end

if general.struct.probe_field(calib_md, 'ifdo.plot') && general.struct.probe_field(calib_md, 'ifdo.show_patch')
	% Visualize the Region of interest:
	for j = 1:size(ROI_R, 1)
		hold on;
		th	= ROI_th([1 2 2 1]);
		R	= ROI_R(j, [1 1 2 2]);
		hpatch = patch(h_ax, th, R, plot.colormkr(j,1));
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
	plot_md.hist.Range(2,:) = ROI_R(i,:);
	[histogram] = macro.hist.create.hist(exp, plot_md.hist);
	
	[Count_ROI, theta, R] = deal(histogram.Count, histogram.midpoints.dim1, ...
	histogram.midpoints.dim2);
% 	.Counthist.H_2D(exp .theta, exp.R, th_bins, R_bins);

	% median filter (if requested):
	if isfield(calib_md, 'medfilt_theta') && isfield(calib_md, 'medfilt_R')
		try 
			Count_ROI_f = medfilt2(Count_ROI, [calib_md.medfilt_theta(i), calib_md.medfilt_R(i)]);
		catch
			Count_ROI_f = medfilt2(Count_ROI, [calib_md.medfilt_theta, calib_md.medfilt_R]);
		end
	end
	%% Peak finding

	switch calib_md.PeakType{i}
		case {'Peak', 'peak'}
			% Now we perform a two-dimensional peak finding (maximum) to find the correction
			% factor for different theta values:
			max(Count_ROI_f, [], 2)./mean(Count_ROI_f, 2);
			[~, idx]		= max(Count_ROI_f, [], 2);
			R_maxs(:,i+1)	= R_bins(idx+1);
			% Calculate the average value in the histogram, to force all the radial
			% peak points to line up with:
			[~,R_avg(i+1)]	= findpeaks(sum(Count_ROI, 1), R, 'NPeaks',1, 'SortStr', 'descend');
		case {'Edge', 'edge'}
			Diff_ROI_f		= diff(Count_ROI_f, 1, 2);
			[~, idx]		= max(abs(Diff_ROI_f), [], 2);
			R_maxs(:,i+1)	= R_bins(idx+1);
			R_avg(i+1)		= mean(R_maxs(:,i+1));
	end
end

% To prevent extrapolation problems, we add R = 2*max(R_avg) point:
R_avg(end)		= 2*max(R_avg);
R_maxs(:,end)	= R_avg(end) /R_avg(i+1) * R_maxs(:,i+1);

if general.struct.probe_field(calib_md, 'ifdo.plot')
	hold on;
	plot(theta, R_maxs, 'k.')
end

%% validation of the correction:

if general.struct.probe_field(calib_md, 'ifdo.plot') && general.struct.probe_field(calib_md, 'ifdo.show_result')
	theta_data		= general.data.pointer.read(plot_md.hist.pointer{1}, exp);
	R_data			= general.data.pointer.read(plot_md.hist.pointer{2}, exp);
	R_corr			= correct.R_circle(R_data, theta_data, R_maxs, R_avg, theta);
	h_ax.Position	= [0.2 0.3 0.3 0.6];
	h_ax.Title.String= 'Uncorrected';
	plot_md			= plot_md_bck;
	plot_md.axes.Position = [0.53 0.3 0.3 0.6];
	plot_md.axes.Title.String = 'Corrected';
	plot_md.axes.colormap	=plot.jet;% plot.custom_RGB_colormap('w', 'r', 0, 1);
	[h_fig, h_ax_corr] = plot.quickhist(h_fig, [theta_data, R_corr], 'plot_md', plot_md);
	h_ax_corr.YAxis.Visible = 'off';
end

end

