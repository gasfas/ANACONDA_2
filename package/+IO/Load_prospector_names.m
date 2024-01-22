function [Prospector_M2Q,Prospector_names, Prospector_formulas] = Load_prospector_names(Filename_html, settings)
%Loads the prospector (expected fragments and masses) from a pre-downloaded
%html file.
% Inputs:
% Filename_html         full filename to the html file where the table with
% fragment masses should be written in. This should have been downloaded
% beforehand.
% fragment_type         
% Outputs:
% Prospector_masses     [n,1], double: List of fragment masses as specified
% in Prospector
% Prospector_names      {n,1} cell with the corresponding fragment names.
% Prospector_formulas   {n,1} The chemical formulas

if ~exist('settings', 'var')
    settings = struct();
end
% Default settings
if ~isfield(settings, 'ifdo_show_evaporated')
    settings.ifdo_show_evaporated  = true;
end
if ~isfield(settings, 'ifdo_show_hydrated')
    settings.ifdo_show_hydrated  = true;
end
if ~isfield(settings, 'ifdo_show_doubly_charged_parent')
    settings.ifdo_show_doubly_charged_parent  = true;
end
if ~isfield(settings, 'ifdo_include_internal_fragments')
    settings.ifdo_include_internal_fragments  = false;
end

table.idTableBy.plaintextPreceedingTable = 'Theoretical Peak Table';
Prospector_cell     = htmlTableToCell(Filename_html,table);
% order the cell into three columns:
Prospector_cell_ordered = reshape(Prospector_cell', 3, [])';
% Skim the last elements if they were left empty (number of fragments ~= in multiplication tables:
nof_rows_2_remove = 0;
while isempty(Prospector_cell_ordered{end-nof_rows_2_remove,1})
    nof_rows_2_remove = nof_rows_2_remove + 1;
end
Prospector_M2Q          = cellfun( @str2num, Prospector_cell_ordered(1:end-nof_rows_2_remove,1) );
Prospector_names        = Prospector_cell_ordered(1:end-nof_rows_2_remove,2);
Prospector_formulas     = Prospector_cell_ordered(1:end-nof_rows_2_remove,3);

%% Include the internal fragments if the user has requested:
if settings.ifdo_include_internal_fragments
    table.idTableBy.plaintextPreceedingTable = 'Internal Ions';
    % Load the prospector HTML file into a cell:
    Prospector_cell_int     = htmlTableToCell(Filename_html,table);
    nof_rows_2_remove = 0;
    % Split and merge the table for 'b' and 'a' fragments:
    Prospector_cell_intnames_a      = cellfun(@(c)[c '_a'],Prospector_cell_int(2:end,[1]),'uni',false); % add the postscript 'a'
    Prospector_cell_intnames_b      = cellfun(@(c)[c '_b'],Prospector_cell_int(2:end,[1]),'uni',false); % add the postscript 'b'
    
    Prospector_names    = [Prospector_names;    Prospector_cell_intnames_a; Prospector_cell_intnames_b];
    Prospector_M2Q      = [Prospector_M2Q;      cellfun( @str2num, [Prospector_cell_int(2:end,[3]); Prospector_cell_int(2:end,[2])])];
    Prospector_formulas = [Prospector_formulas; cellstr(repmat('.', 2*size(Prospector_cell_int,1)-2,1))];
end

%% User settings
if settings.ifdo_show_doubly_charged_parent % add Doubly_charged parent if requested
    Singly_charged_parent_filter = strcmp(Prospector_names, 'MH');
    % make a new entry for the doubly charged parent:
    Prospector_names    = [Prospector_names; 'MH2'];
    Prospector_M2Q      = [Prospector_M2Q; (Prospector_M2Q(Singly_charged_parent_filter)+1)/2];
    Prospector_formulas = Prospector_formulas([1:length(Prospector_formulas), find(Singly_charged_parent_filter)]);
end

if isfield(settings, 'fragment_names_to_remove')
    remove_fragment_filter = zeros(size(Prospector_M2Q));
    for Fragment_name_cur = settings.fragment_names_to_remove
        remove_fragment_filter = or(remove_fragment_filter, strcmp(Prospector_names, Fragment_name_cur));
    end
    Prospector_names    = Prospector_names(~remove_fragment_filter);
    Prospector_M2Q      = Prospector_M2Q(~remove_fragment_filter);
    Prospector_formulas = Prospector_formulas(~remove_fragment_filter);
end

if ~settings.ifdo_show_evaporated % Evaporation
    evaporated_filter    = cellfun(@isempty, regexp(Prospector_names, '-'));
else
    evaporated_filter    = ones(size(Prospector_names));
end

% See if hydrated fragments should (not) be included
if ~settings.ifdo_show_evaporated % Hydration
    hydrated_filter    = cellfun(@isempty, regexp(Prospector_names, '+ H2O'));
else
    hydrated_filter    = ones(size(Prospector_names));
end

% Apply the filter:
full_filter = and(evaporated_filter, hydrated_filter);
Prospector_M2Q          = Prospector_M2Q(full_filter);
Prospector_names        = Prospector_names(full_filter);
Prospector_formulas     = Prospector_formulas(full_filter);

% See if the user wants to add their own fragments:
if isfield(settings, 'fragment_names_to_add')
    if size(settings.fragment_names_to_add, 2) > 1 % transpose if necessary for merging
        settings.fragment_names_to_add      = transpose(settings.fragment_names_to_add);
    end
    if size(settings.fragment_masses_to_add, 2) > 1 % transpose if necessary for merging
        settings.fragment_masses_to_add   = transpose(settings.fragment_masses_to_add);
    end
    if size(settings.fragment_formulas_to_add, 2) > 1 % transpose if necessary for merging
        settings.fragment_formulas_to_add   = transpose(settings.fragment_formulas_to_add);
    end
    Prospector_names    = [Prospector_names; settings.fragment_names_to_add];
    Prospector_M2Q      = [Prospector_M2Q; settings.fragment_masses_to_add];
    Prospector_formulas = [Prospector_formulas; settings.fragment_formulas_to_add];
end
%% Sorting output
% Make sure the fragments are well ordered:
[Prospector_M2Q, idx, ~] = unique(Prospector_M2Q);
Prospector_names        = Prospector_names(idx);
Prospector_formulas     = Prospector_formulas(idx);

end

