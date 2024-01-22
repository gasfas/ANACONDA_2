function char_out = replace_symbol_in_char(char_in, char_to_replace, char_replacement)
% This function replaces a symbol (char_to_replace) within a longer given
% character (char_in), by a given other symbol (char_replacement).

if iscell(char_in)
    for i = 1:length(char_in)
        char_out{i} = general.char.replace_symbol_in_char(char_in{i}, char_to_replace, char_replacement);
    end
else
    % Split char_in:
    C           = strsplit(char_in, char_to_replace);
    % join them again with the backslash added as elements:
    char_out    = strjoin(C, char_replacement);
end
end

