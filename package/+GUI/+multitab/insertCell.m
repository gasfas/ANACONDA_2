% Description: Inserts a cell at position 1 of oldCellStruct.
%   - inputs:   oldCellStruct, cell_to_be_inserted
%   - outputs:  newCellStruct
% Date of creation: 2017-08-01.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% Insert this into code & uncomment.
%% Message to log_box - cell_to_be_inserted:
% cell_to_be_inserted = ['Folder loaded: ', foldername];
% [ md_GUI.UI.log_box_string ] = GUI.multitab.insertCell ( md_GUI.UI.log_box_string, cell_to_be_inserted );
% md_GUI.UI.UImultitab.log_box.String = md_GUI.UI.log_box_string;
% End of new message to log_box function.
%%
function [ newCellStruct ] = insertCell ( oldCellStruct, cell_to_be_inserted )
[H,M] = hms(datetime('now'));
newCellStruct(1) = {[num2str(H), ':', num2str(M), ': ', cell_to_be_inserted]};
for lx = 1:length(oldCellStruct) 
    newCellStruct(lx+1) = oldCellStruct(lx);
end
end