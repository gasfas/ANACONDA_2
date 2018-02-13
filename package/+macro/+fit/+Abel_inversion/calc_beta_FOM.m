function [beta] = calc_beta_FOM(fit_md)
% Function to calculate the beta values from a previously calculated FOM inversion:
% Fetch R, theta coordinates:
im_pol			= load(fullfile(fileparts(which('fit.Abel_inversion.FOM.execute_IterativeInversion')), 'it_3dpol0001.dat'));
% Select the requested radius range: (assuming momentum plot)
nof_p_regions	= size(fit_md.calc_beta.p_range,1);
beta			= NaN*zeros(nof_p_regions,1);
% fetch the right theta:
theta_im_pol = linspace(-pi/2, 3*pi/2, size(im_pol,2));
p_norm			= linspace(0, fit_md.plot.hist.Range(1,2), size(im_pol, 1))';
for i = 1:nof_p_regions
	% fetch the current p range:
	p_range_cur	= fit_md.calc_beta.p_range(i,:);
	% See which part is inside the specified range:
	is_in		= p_norm > p_range_cur(1) & p_norm < p_range_cur(2);
	% Integrate along R inside the given region:
	Intensity	= sum(im_pol(is_in, :), 1);
	% calculate beta from fit:
	beta(i)		= fit.beta_function(theta_im_pol, Intensity);
end
