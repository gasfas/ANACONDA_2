function output_name = make_valid_name(input_name, pretext)
% Make sure the given name is a valid MATLAB (field)name:
% Input:
%   - input_name: char (single name) or cell of chars (multiple names) to
%   be checked for validity
%   - pretext: (char, optional): text to write at start of name when the
%           first character is a number. Default: 'n'
% Output:
%   - output_name: The possibly modified input name, now valid as variable
%   name, in the same format as the input_name.
% The following changes are made by default: 
% - Spaces are replaced with underscores
% - Dots are replaced with underscores
% - If the first character is a number, pretext is placed in front
% - Too long names are cut to max length at the end

if ~exist("pretext", 'var')
    pretext = 'n';
end

if ischar(input_name) %assumed only one name given.
    % replace spaces by underscore:
    output_name = general.char.replace_symbol_in_char(input_name, ' ', '_');
    % replace dots by underscore:
    output_name = general.char.replace_symbol_in_char(output_name, '.', '_');
    % replace scores by underscore:
    output_name = general.char.replace_symbol_in_char(output_name, '-', '_');
    % Add first letter in case the name starts with a number:
    if ~isnan(str2double(output_name(1))), output_name = insertBefore(output_name, output_name, pretext); end
    % Make sure the name isnt too long:
    output_name = output_name(1:min(length(output_name), namelengthmax-1));
elseif iscell(input_name)
    output_name = cell(length(input_name),1);
    for i = 1:length(input_name) % run this function recursively for this name:
        output_name{i} = general.make_valid_name(input_name{i});
    end
end
end
