function PD_reading = fetch_photodiode_current(csv_filename)
% This function reads the photon flux, if it is read by Spectrolatius:
% Read the comments:

% Open the file:
fid = fopen(csv_filename);
% Read the first (comment) line:
comment_line = fgetl(fid);
% Close the file again:
fclose(fid);

% First get rid of all blank spaces at the end:
comment_line    = strtrim(comment_line);

% Fetch the photon flux from it:
% We see if the photon flux reading is stored at all:
if strcmpi(comment_line(end-1:end), 'uA')
    % find the last underscore and read the number from there:
    PD_reading = str2num(comment_line(find(comment_line=='_',1,'last')+1:end-2));
else % if not, we fill in 'not a number':
    PD_reading = NaN;
end

end