function [intname] = get_intname_from_username(input_struct, username_input)
% This function fetches the internal name of a struct, by reading the
% user-given names in the 'Name' subfield.
% Inputs:
%  input_struct     Structure with fields that each contain a subfield
%                   'Name', which will be read by this function.
% Outputs:
%   Names           Cell with list of user-read names
%   Intnames        Cell with list of internal names
% Get the internal names:
Intnames    = fieldnames(input_struct);
% Get the corresponding user names:
usernames = GUI.fs_big.get_user_scannames(input_struct);
% Find the internal name:
[idx] = find(ismember(usernames, username_input));
% Make sure no duplicate names:
if numel(idx) > 1
    warning('Duplicate user name found')
end
intname = Intnames(idx(1));
end