function [isvalid, isemptyname, isduplicate_spectrum, isduplicate_scan] = check_validity_name(exp_data, NewName)
% Simple function to check user names and verify that t user-requested new
% Name is indeed not in use yet:

%Check if name is not empty:
isemptyname = isempty(NewName);

% Check if the name is not already in use (either for a spectrum or scan): 
% Fetch user names scans and spectra:
spectra_usernames       = GUI.fs_big.get_user_names(exp_data.spectra);
scan_usernames          = GUI.fs_big.get_user_names(exp_data.scans);

% Compare to those names, and see if it already exists
isduplicate_spectrum        = any(ismember(spectra_usernames, NewName));
isduplicate_scan            = any(ismember(scan_usernames, NewName));
isvalid                     = ~isemptyname && ~isduplicate_spectrum && ~isduplicate_scan;
end