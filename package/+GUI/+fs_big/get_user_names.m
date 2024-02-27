function scan_usernames = get_user_names(scans)
% Fetch the user-visible names of the scans:

% The amount of scans defined:
scan_names          = fieldnames(scans);
nof_scans           = numel(scan_names);
scan_usernames      = cell(nof_scans, 1);
 for i = 1:nof_scans
     scan_usernames{i} = scans.(scan_names{i}).Name;
 end
end