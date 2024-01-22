function [fit_peak_strength, fit_peak_mass, fit_peak_FWHM] = Gauss_fit_mass_peaks(m_bins, I, m_fit)
% Gaussian fits of mass peaks. Inputs:
% m_bins                    = mass bin centres [Da]
% I                         = Intensities at the given mass centres.
% peak_mass_center_guess    = [n_peaks, 1] First guess of the peak centre, expressed in mass [Da]
% peak_width_guess          = First guess of the peak width, expressed in mass [Da]. Size: either scalar, or [n_peaks, 1] array. if scalar, used for all peaks.
% peak_mass_search_radius   = The total allowed distance from the initial peak centre guess to travel [Da]. Size: either scalar, or [n_peaks, 1] array. if scalar, used for all peaks.
% peak_width_search_radius  = The allowed change in peak width as part of the solution space. [Da]
% fit_mass_width            = The width over the region over which the fit
% is made. [Da]
% Outputs:
% fit_peak_strength         = The fitted peak intensity
% fit_peak_mass             = The fitted peak mass [Da]
% fit_peak_FWHM             = The fitted peak width [Da]

peak_mass_center_guess      = m_fit.peak_mass_center_guess;
peak_FWHM_guess             = m_fit.peak_FWHM_guess;
peak_mass_search_radius     = m_fit.peak_mass_search_radius;
peak_FWHM_search_radius     = m_fit.peak_FWHM_search_radius;
fit_mass_full_width         = m_fit.fit_mass_full_width;
Normalization_method        = m_fit.Normalization_method;
min_rel_peak2peak           = m_fit.min_rel_peak2peak;
main_peak_mass_search_radius= m_fit.main_peak_mass_search_radius;
RESNORM_max                 = m_fit.RESNORM_max;

if length(peak_mass_center_guess) > 1 && length(peak_FWHM_guess) == 1
    % make peak_width_guess just as long as value_nominal, if only one
    % value is given:
    peak_FWHM_guess = ones(size(peak_mass_center_guess))*peak_FWHM_guess;
end
if length(peak_mass_center_guess) > 1 && length(peak_mass_search_radius) == 1
    % make peak_mass_search_radius just as long as value_nominal, if only one
    % value is given:
    peak_mass_search_radius = ones(size(peak_mass_center_guess))*peak_mass_search_radius;
end
if length(peak_mass_center_guess) > 1 && length(peak_FWHM_search_radius) == 1
    % make peak_width_search_radius just as long as value_nominal, if only one
    % value is given:
    peak_FWHM_search_radius = ones(size(peak_mass_center_guess))*peak_FWHM_search_radius;
end

% Normalize if requested:
if exist('Normalization_method', 'var')
    switch Normalization_method
        case 'parent' % Hack:
            I = I./max(I);
            Normalization_mass              = m_fit.Normalization_mass;
            %calculate the parent intensity through fitting and normalize with that in the end:
            peak_mass_center_guess          = [peak_mass_center_guess, Normalization_mass];
            peak_FWHM_guess(end+1)          = peak_FWHM_guess(end);
            peak_mass_search_radius(end+1)  = peak_mass_search_radius(end);
            peak_FWHM_search_radius(end+1)  = peak_FWHM_search_radius(end);
        otherwise
            Normalization_method = 'none';
end
end

% peak2peak if requested:
if ~exist('min_rel_peak2peak', 'var')
    % default minimum relative peak height:
    min_rel_peak2peak = 0.1;
end

fit_peak_strength   = zeros(size(peak_mass_center_guess));
fit_peak_mass       = zeros(size(peak_mass_center_guess));
fit_peak_FWHM       = zeros(size(peak_mass_center_guess));
fit_options         = optimset('Display','on', 'TolFun', 1e-12);

% Loop over all centres:
peaknr = 0;
for peak_cent_cur = peak_mass_center_guess
    peaknr = peaknr + 1;
    % Select a certain bin range over which to fit, around the estimated peak centre:
    mass_range_cur              = [peak_cent_cur - fit_mass_full_width/2; peak_cent_cur + fit_mass_full_width/2]; % current mass range
    main_peak_mass_range_cur    = [peak_cent_cur - main_peak_mass_search_radius; peak_cent_cur + main_peak_mass_search_radius]; % current mass range
    m_bins_idx_cur              = (m_bins > mass_range_cur(1) & m_bins < mass_range_cur(2)); % current mass bin index range
    main_peak_m_bins_idx_cur    = (m_bins > main_peak_mass_range_cur(1) & m_bins < main_peak_mass_range_cur(2)); % current mass bin index range
    m_bins_cur                  = m_bins(m_bins_idx_cur); % current mass bins
    main_peak_m_bins_cur        = m_bins(main_peak_m_bins_idx_cur); % current mass bins
    I_cur                       = I(m_bins_idx_cur); % current intensity
    main_peak_I_cur             = I(main_peak_m_bins_idx_cur); % current intensity
%     plot(m_bins_cur, I_cur)
    peak_FWHM_cur              = peak_FWHM_guess(peaknr);
    peak_mass_search_radius_cur = peak_mass_search_radius(peaknr);
    peak_FWHM_search_radius_cur= peak_FWHM_search_radius(peaknr);
    
    if isempty(m_bins_cur) % No mass bins found in the interval, so we assume that no peak exists in the given interval:
        fit_peak_strength(peaknr)   = 0;
        fit_peak_mass(peaknr)       = peak_cent_cur;
        fit_peak_FWHM(peaknr)       = 0;
        % skip the rest of instructions and continue to the next peak:
        continue
    end
    m_stepsize = mean(diff(m_bins_cur));
    % Find all peaks in the data area given:
    [PeakFinderValues_UV1, PeakFinderCent_UV1] = findpeaks([0; I_cur; 0], [m_bins_cur(1)-m_stepsize; m_bins_cur; m_bins_cur(end)+m_stepsize], 'MinPeakProminence', peak2peak(min_rel_peak2peak*I_cur));
    % Find all peaks within which the main peak is expected:
    
    [main_peak_PeakFinderValues_UV1, main_peak_PeakFinderCent_UV1] = findpeaks([0; main_peak_I_cur; 0], [main_peak_m_bins_cur(1)-m_stepsize; main_peak_m_bins_cur; main_peak_m_bins_cur(end)+m_stepsize], 'MinPeakProminence', peak2peak(min_rel_peak2peak*I_cur));
    
    if isempty(main_peak_PeakFinderValues_UV1) % No peak found in the interval, assuming there is zero intensity:
        fit_peak_strength(peaknr)   = 0;
        fit_peak_mass(peaknr)       = peak_cent_cur;
        fit_peak_FWHM(peaknr)       = 0;
        disp('no peak found')
        % skip the rest of instructions and continue to the next peak:
        continue
    end
    
    if all(abs(peak_cent_cur - PeakFinderCent_UV1) > m_fit.min_peak2peak_dm) % The main peak is not found by the general findpeaks algorithm (due to low relative intensity), so added manually here:
        PeakFinderValues_UV1    = [PeakFinderValues_UV1; main_peak_PeakFinderValues_UV1];
        PeakFinderCent_UV1      = [PeakFinderCent_UV1; main_peak_PeakFinderCent_UV1];
    end
    
    [max_I, max_I_pos] = max(I_cur);
    if any(max_I > max(PeakFinderValues_UV1)) % A higher intensity has been found in the spectrum (possibly at edge of data)
        PeakFinderValues_UV1(end+1) = max_I;
        PeakFinderCent_UV1(end+1)   = m_bins_cur(max_I_pos);
    end % TODO: allow higher intensity on both ends of the data.
        
    if length(PeakFinderValues_UV1) <= 1 % only one or less peaks found within the search region:
        % Give initial guess for the peak strength (multiply with normalized gaussian):
        [max_value, max_idx]        = max(I_cur);
        peak_strength_guess_cur     = PeakFinderValues_UV1;
        
        peak_cent_cur               = m_bins_cur(interp1(m_bins_cur, 1:length(m_bins_cur), PeakFinderCent_UV1, 'nearest', 'extrap'));
        % Define upper and lower boundary:
        ub = [peak_cent_cur + peak_mass_search_radius_cur, peak_FWHM_cur + peak_FWHM_search_radius_cur, max(0.1, 6*peak_strength_guess_cur)];
        lb = [max(0, peak_cent_cur-peak_mass_search_radius_cur), max(0, peak_FWHM_cur - peak_FWHM_search_radius_cur), 0];
        fun = @(x,m_bins) x(3)*x(2)*sqrt(pi)/(2*sqrt(log(2)))*normpdf(m_bins, x(1), x(2)/(2*sqrt(2*log(2))));
        % Define initial guess:
        x0 = [peak_cent_cur, peak_FWHM_cur, peak_strength_guess_cur];
        % Run the optimization for a single peak:
        [x,RESNORM,RESIDUAL,EXITFLAG] = lsqcurvefit(fun,x0,m_bins_cur,I_cur, lb, ub, fit_options);

    else % Multiple peaks have been detected in the mass range:
        % If multiple peaks are found, this means multiple peaks need to be
        % fitted. Assumed here that only 1 extra peak needs to be fitted:
        % Main peak:
        % Choose the one closest to the given expected peak centre:
        [~, main_peak_idx] = min(abs(PeakFinderCent_UV1 - peak_cent_cur));
        % Give initial guess for the peak strength (multiply with normalized gaussian):
        peak_strength_guess_cur    = PeakFinderValues_UV1(main_peak_idx);
        
        if length(PeakFinderValues_UV1) == 2
            % Second peak:
            % We only take into account the peak that is the biggest (after the closest peak that was chosen above)
            PeakFinderValues_UV1_c = PeakFinderValues_UV1; % Make copy
            PeakFinderValues_UV1_c(main_peak_idx) = 0;
            [~, second_peak_idx] = max(PeakFinderValues_UV1_c);
            second_peak_strength_guess_cur = PeakFinderValues_UV1(second_peak_idx);

            % Define upper and lower boundary:
            % format x0 = [main_peak_centre, main_peak_FWHM, main_peak_strength, second_peak_centre, second_peak_FWHM, second_peak_strength];
            ub = [peak_cent_cur + peak_mass_search_radius_cur, peak_FWHM_cur + peak_FWHM_search_radius_cur, max(0.1, 6*peak_strength_guess_cur), ...
                  PeakFinderCent_UV1(second_peak_idx)+peak2peak(m_bins_cur),  peak_FWHM_cur+5*peak_FWHM_search_radius_cur, max(0.1, 6*second_peak_strength_guess_cur)]; % We define the maximum of the second peak a bit wider, also outside the data range.
            lb = [max(0, peak_cent_cur-peak_mass_search_radius_cur), max(0, peak_FWHM_cur - peak_FWHM_search_radius_cur), 0, ...
                  PeakFinderCent_UV1(second_peak_idx)-peak2peak(m_bins_cur),  max(0, peak_FWHM_cur-5*peak_FWHM_search_radius_cur), 0]; % We define the maximum of the second peak a bit wider, also outside the data range.
    %         fun = @(x,m_bins) x(3)*normpdf(m_bins, x(1), x(2)/(2*sqrt(2*log(2)))) + x(6)*normpdf(m_bins, x(4), x(5)/(2*sqrt(2*log(2))));
            fun = @(x,m_bins) x(3)*x(2)*sqrt(pi)/(2*sqrt(log(2)))*normpdf(m_bins, x(1), x(2)/(2*sqrt(2*log(2)))) + x(6)*x(5)*sqrt(pi)/(2*sqrt(log(2)))*normpdf(m_bins, x(4), x(5)/(2*sqrt(2*log(2))));
            % Define initial guess:
            x0 = [peak_cent_cur, peak_FWHM_cur, peak_strength_guess_cur, ...
                PeakFinderCent_UV1(second_peak_idx), peak_FWHM_cur, second_peak_strength_guess_cur];
            % Run the optimization:
            [x,RESNORM,RESIDUAL,EXITFLAG] = lsqcurvefit(fun,x0,m_bins_cur,I_cur, lb, ub, fit_options);

            if RESNORM > RESNORM_max % Residue is larger than user wants. We add a third 'wildcard' peak in an attempt to increase fit quality:
                % Subtract the fitted data and see if a peak can be found in
                % the tails of bigger peaks:
                I_double_fitted_res = I_cur - fun(x, m_bins_cur);
                % Find the peak in the two-peak residue (for now only one
                % allowed)
                m_stepsize = mean(diff(m_bins_cur));
                [sub_peak_PeakFinderValues_UV1, sub_peak_PeakFinderCent_UV1] = findpeaks([0; I_double_fitted_res; 0], [m_bins_cur(1)-m_stepsize; m_bins_cur; m_bins_cur(end)+m_stepsize], 'NPeaks',1, 'SortStr', 'descend', 'MinPeakProminence', peak2peak(min_rel_peak2peak*I_cur));
                
                % If no peak is found, we abort the search and have to
                % accept the peak fit as-is:
                if length(sub_peak_PeakFinderValues_UV1) == 1 && all(abs(sub_peak_PeakFinderCent_UV1 - PeakFinderCent_UV1) > m_fit.min_peak2peak_dm) % Distance in mass between peaks is large enough
                    % Merge with PeakFinderValues:
                    PeakFinderValues_UV1(end+1)     = sub_peak_PeakFinderValues_UV1;
                    PeakFinderCent_UV1(end+1)       = sub_peak_PeakFinderCent_UV1;
                    % plot(m_bins_cur, I_double_fitted_res, 'k')
                    disp('wildcard peak used')
                    RESNORM_2_peaks = RESNORM; % Save for later.
                    x_2_peaks       = x;
                    fun_2_peaks     = fun;
                else
                    disp('Residue larger than requested, but no extra peak found')
                end
            end
        end
                 
        if length(PeakFinderValues_UV1) >= 3
            
            % Three peaks:
            % We only take into account the two peaks that are the biggest (after the closest peak that was chosen above)
            PeakFinderValues_UV1_c = PeakFinderValues_UV1; % Make copy
            PeakFinderValues_UV1_c(main_peak_idx) = 0;
            [~, second_peak_idx] = max(PeakFinderValues_UV1_c);
            PeakFinderValues_UV1_c(second_peak_idx) = 0;
            [~, third_peak_idx] = max(PeakFinderValues_UV1_c);
            second_peak_strength_guess_cur = PeakFinderValues_UV1(second_peak_idx);
            third_peak_strength_guess_cur = PeakFinderValues_UV1(third_peak_idx);

            % Define upper and lower boundary:
            % format x0 = [main_peak_centre, main_peak_FWHM, main_peak_strength, second_peak_centre, second_peak_FWHM, second_peak_strength];
            ub = [peak_cent_cur + peak_mass_search_radius_cur, peak_FWHM_cur + peak_FWHM_search_radius_cur, max(0.1, 6*peak_strength_guess_cur), ...
                  PeakFinderCent_UV1(second_peak_idx)+peak2peak(m_bins_cur),  peak_FWHM_cur+5*peak_FWHM_search_radius_cur, max(0.1, 6*second_peak_strength_guess_cur), ...
                  PeakFinderCent_UV1(third_peak_idx)+peak2peak(m_bins_cur),  peak_FWHM_cur+5*peak_FWHM_search_radius_cur, max(0.1, 6*third_peak_strength_guess_cur)]; % We define the maximum of the second peak a bit wider, also outside the data range.
            lb = [max(0, peak_cent_cur-peak_mass_search_radius_cur), max(0, peak_FWHM_cur - peak_FWHM_search_radius_cur), 0, ...
                  PeakFinderCent_UV1(second_peak_idx)-peak2peak(m_bins_cur),  max(0, peak_FWHM_cur-5*peak_FWHM_search_radius_cur), 0, ...
                  PeakFinderCent_UV1(third_peak_idx)-peak2peak(m_bins_cur),  max(0, peak_FWHM_cur-5*peak_FWHM_search_radius_cur), 0]; % We define the maximum of the second peak a bit wider, also outside the data range.
    %         fun = @(x,m_bins) x(3)*normpdf(m_bins, x(1), x(2)/(2*sqrt(2*log(2)))) + x(6)*normpdf(m_bins, x(4), x(5)/(2*sqrt(2*log(2))));
            fun = @(x,m_bins) x(3)*x(2)*sqrt(pi)/(2*sqrt(log(2)))*normpdf(m_bins, x(1), x(2)/(2*sqrt(2*log(2)))) + ...
                    x(6)*x(5)*sqrt(pi)/(2*sqrt(log(2)))*normpdf(m_bins, x(4), x(5)/(2*sqrt(2*log(2)))) + ...
                    x(9)*x(8)*sqrt(pi)/(2*sqrt(log(2)))*normpdf(m_bins, x(7), x(8)/(2*sqrt(2*log(2))));
            % Define initial guess:
            x0 = [peak_cent_cur, peak_FWHM_cur, peak_strength_guess_cur, ...
                PeakFinderCent_UV1(second_peak_idx), peak_FWHM_cur, second_peak_strength_guess_cur, ...
                PeakFinderCent_UV1(third_peak_idx), peak_FWHM_cur, third_peak_strength_guess_cur];
            % Run the optimization:
            [x,RESNORM,RESIDUAL,EXITFLAG] = lsqcurvefit(fun,x0,m_bins_cur,I_cur, lb, ub, fit_options);
        end
        if exist('RESNORM_2_peaks', 'var') && length(x) == 9
            if RESNORM > RESNORM_2_peaks || any(diff(sort(x([1, 4, 7]))) <= m_fit.min_peak2peak_dm) % Check if the residual norm has decreased, and the new peak masses are not too close to one another.
                x                   = x_2_peaks; % (the original double peak was actually better).
                fun                 = fun_2_peaks; % reset to original 2-peak fit.
                disp('no improvement by adding a peak to the fit')
                RESNORM_2_peaks     = RESNORM; % Save for later.
            end
        end
    end
    %% Debug plot
%         Plot for debug:
    try close(h_test); end
    if false%m_fit.photon_energy >= 9 %%&& m_fit.photon_energy <= 13.3 && peak_cent_cur < 297.2
        h_test = figure();    
        plot(m_bins_cur, I_cur); hold on % Data in blue.
        plot.vline(peak_cent_cur)
        m_bins_fit = linspace(m_bins_cur(1), m_bins_cur(end), 100);
        plot(m_bins_fit, fun(x0, m_bins_fit), 'g') % initial guess in green
        plot(m_bins_fit, fun(x, m_bins_fit), 'r') % final solution in red
        plot(PeakFinderCent_UV1, PeakFinderValues_UV1, 'b*') % Plot dot
        plot.vline(x(1), 'r')
        plot.vline(x0(1), 'g')
        legend('Data', 'Peak center', 'Initial guess', 'fit solution', 'Peakfinder', 'final main peak mass', 'initial main peak mass')
        xlim([lb(1)-ub(2), ub(1)+ub(2)]);
        title(['hv =', num2str(m_fit.photon_energy), ', PS =', num2str(x(3).*x(2).*sqrt(pi/log(2))./2), ', sample =' , m_fit.sample_name, ', m_IG =' num2str(peak_cent_cur, 4)])
        disp(num2str(length(x)/3))
    end

%% 
    % Extract the peak fitting values for export:
    fit_peak_mass(peaknr)       = x(1);
    fit_peak_FWHM(peaknr)       = x(2);
%     fit_peak_strength(peaknr)   = x(3)./fit_peak_FWHM(peaknr)./sqrt(2);
    fit_peak_strength(peaknr)   = x(3).*fit_peak_FWHM(peaknr).*sqrt(pi/log(2))./2;
    disp('end of fit')
    clear RESNORM_2_peaks
end

% Normalize if requested:
if exist('Normalization_method', 'var')
    switch Normalization_method
        case 'parent' % Hack:
            % The last entry (parent) from the fit result belongs to the parent:
            % And use the last entry (parent) as normalization value
            fit_peak_mass_parent    = fit_peak_mass(end);
            fit_peak_mass           = fit_peak_mass(1:end-1);
            fit_peak_FWHM_parent    = fit_peak_FWHM(end);
            fit_peak_FWHM           = fit_peak_FWHM(1:end-1);
            fit_peak_strength_parent= fit_peak_strength(end);
            fit_peak_strength       = fit_peak_strength(1:end-1)./fit_peak_strength_parent;
        otherwise
            Normalization_method = 'none';
    end
end

end