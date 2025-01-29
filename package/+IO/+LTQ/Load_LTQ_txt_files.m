function [hist] = Load_LTQ_txt_files(hist_files, hist_dir, exp_md_cur, delta_m_corr_default)
% Load a given list of TXT files
clear hist % empty the variable from the previous run, if exisiting.
for histnr = 1:length(hist_files)
    % Import for first time (txt)
    hist_single = IO.Qex_Lyon.txt_hist(fullfile(hist_dir, hist_files{histnr}));
    % Apply the mass correction:
    if general.struct.issubfield(exp_md_cur, 'meta.import.delta_m_corr') % If the user has specified the mass shift in the metadata file:
        hist_single.M2Q.bins                = hist_single.M2Q.bins - exp_md_cur.meta.import.delta_m_corr;
    else
        warning('no corrective delta_m given in metadata, default value used.')
        hist_single.M2Q.bins                = hist_single.M2Q.bins - delta_m_corr_default;
    end
    % Apply the linear mass correction:
    if general.struct.issubfield(exp_md_cur, 'meta.import.delta_m_corr_linear_m0') % If the user has specified the linear mass correction in the metadata file:
        hist_single.M2Q.bins        = hist_single.M2Q.bins + (hist_single.M2Q.bins-exp_md_cur.meta.import.delta_m_corr_linear_m0)*exp_md_cur.meta.import.delta_m_corr_linear_dm;
    else
        warning('no corrective linear mass shift values given in metadata, no correction performed.')
    end
    
    % Remove the NaN's:
    NaN_idx                             = ~isnan(hist_single.M2Q.bins) & ~isnan(hist_single.M2Q.I); % NaN in either the bins or intensities will be removed.
    hist_single.M2Q.bins                = hist_single.M2Q.bins(NaN_idx); % Remove NaN entries from bins
    hist_single.M2Q.I                   = hist_single.M2Q.I(NaN_idx); % Remove NaN entries from Intensity
    % Calculate integrated signal:
    Int_sign_cur = trapz(hist_single.M2Q.bins, hist_single.M2Q.I);
    % Normalize spectrum:
    hist_single.M2Q.I      = hist_single.M2Q.I/Int_sign_cur*1e3; % Multiply by 1000 to avoid fitting tolerance problems later.

    [~, bare_spectrum_name]             = fileparts(hist_files{histnr});
    spectrum_nr_cur = str2num(bare_spectrum_name(end-1:end));
    hist.(['spectr_', sprintf('%03.f', spectrum_nr_cur)]) = hist_single;
end