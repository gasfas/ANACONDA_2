function [h_axes, h_figure, h_GraphObj] = Abel_inversion(data_in, metadata_in, det_name)
% This macro inverts an Abel projection.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% im_inv		The inverted image(s)

data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};
	detnr	= IO.det_nr_from_fieldname(detname);
	
%% Fetch
	fit_md = metadata_in.fit.(detname).Abel_inversion;
	plot_md = fit_md.plot;
	
	% Make sure the image is symmetric around the origin:
	extremes = abs(mean([plot_md.hist.Range(:,1), -plot_md.hist.Range(:,2)], 2));
	plot_md.hist.Range = [-extremes, extremes];

%% Select the type of Abel inversion
	switch fit_md.Type
		case {'CpBasex', 'cpbasex'}
			histogram = cpbasex(data_in, fit_md, plot_md);
		case {'FOM', 'iterative', 'Iterative'}
			histogram = FOM(data_in, fit_md, plot_md);
		case {'MBI', 'mbi'}
			histogram = mbi(data_in, fit_md, plot_md);
	end

%% Plot		

% Create a new figure:
h_figure	= macro.plot.create.fig(plot_md.figure);
% Then create the new axes:
h_axes		= macro.plot.create.ax(h_figure, plot_md.axes);
% And plot the Graphical Object in it:
h_GraphObj	= macro.hist.create.GraphObj(h_axes, histogram, plot_md.GraphObj);


end
end

%% Local functions
% CpBASEX:
function histogram = cpbasex(data_in, fit_md, plot_md)

	% Make sure the output image has the right size (1023x1023):
	plot_md.hist.binsize = diff(plot_md.hist.Range, 1, 2)/1023;
	
	% load gData struct:
	CpBas_loc = fileparts(which('fit.Abel_inversion.CpBasex.pbasex'));
	gData_512 = fit.Abel_inversion.CpBasex.loadG(fullfile(CpBas_loc, 'gData', 'G_r512_k64_l4.h5'),1);
	r = 512;
	%% Raw Histogram:
	histogram = raw_hist(plot_md, data_in);
	
	fold = fit.Abel_inversion.CpBasex.resizeFolded(fit.Abel_inversion.CpBasex.foldQuadrant(histogram.Count,r,r,[1,1,1,1]),r);
	
	%% Fit
	out = fit.Abel_inversion.CpBasex.pbasex(fold,gData_512,1);

	%% Inverted image histogram:

	fold_inv = fit.Abel_inversion.CpBasex.resizeFolded(fit.Abel_inversion.CpBasex.foldQuadrant(out.inv,r,r,[1,1,1,1]),r);
	fold_inv = fold_inv - min(fold_inv(:));
	fold_inv = fold_inv*max(fold(:))./max(fold_inv(:));

	% Replace half of the circle with the original data, half with the
	% inverted, with matching intensities:
	histogram.Count(1:512,1:1024) = [rot90(fold,2) flip(fold,1)];
	histogram.Count(513:1024,1:1024) = [flip(fold_inv,2) fold_inv];
end

% Iterative computation from FOM:
function histogram = FOM(data_in, fit_md, plot_md)

	% Make sure the binsize results in the right size:
	plot_md.hist.binsize = diff(plot_md.hist.Range, 1, 2)./(fit_md.ImageSize-1);

	% Write the input configuration file:
	fit.Abel_inversion.FOM.create_configuration_file(fit_md);
	
	%% Calculate the raw image Histogram:
	histogram = raw_hist(plot_md, data_in);
	% Write it into the input datafile:
	data = histogram.Count;
	input_data_fn = ['images000' num2str(fit_md.filenumber) '.dat'];
	save(fullfile(fileparts(which('fit.Abel_inversion.FOM.execute_IterativeInversion')), input_data_fn), 'data', '-ascii')
	
	%% Fit
	% Execute the inversion:
	fit.Abel_inversion.FOM.execute_IterativeInversion

	%% Inverted image histogram:
	% Fetch it:
	
	
fold_inv = fit.Abel_inversion.CpBasex.resizeFolded(fit.Abel_inversion.CpBasex.foldQuadrant(out.inv,r,r,[1,1,1,1]),r);
fold_inv = fold_inv - min(fold_inv(:));
fold_inv = fold_inv*max(fold(:))./max(fold_inv(:));

% Replace half of the circle with the original data, half with the
% inverted, with matching intensities:
histogram.Count(1:512,1:1024) = [rot90(fold,2) flip(fold,1)];
histogram.Count(513:1024,1:1024) = [flip(fold_inv,2) fold_inv];

end

function histogram = raw_hist(plot_md, data_in)

% Raw histogram collecting:
if isfield(plot_md, 'cond')
		% Calculate the filter from a condition:
		[e_filter, data_in]	= macro.filter.conditions_2_filter(data_in, plot_md.cond);
		% Calculate the histogram with the filter:
		histogram	= macro.hist.create.hist(data_in, plot_md.hist, e_filter);
	else
		% Calculate the histogram:
		histogram	= macro.hist.create.hist(data_in, plot_md.hist);
end
end
