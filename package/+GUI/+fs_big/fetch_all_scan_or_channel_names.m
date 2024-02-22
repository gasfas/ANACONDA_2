function [Names, Intnrs, Intnames] = fetch_all_scan_or_channel_names(input_struct)
% This function reads the names of either scans or channels, defined as a 
% subfield of the internal names.
% Inputs:
%  input_struct     Structure with fields that each contain a subfield
%                   'Name', which will be read by this function.
% Outputs:
%   Names           Cell with list of user-read names
%   Intnames        Cell with list of internal names
% Get the internal names:
    Intnames    = fieldnames(input_struct.scans);
    Names       = cell(size(Intnames));
    i           = 0;
    for intname_cur_cell = Intnames
        i = i + 1;
        Names[i] = exp_data.scans.(intname_cur_cell).Name;
        % Get the number of the internal name:
        str2num(Names[i])
    end

end