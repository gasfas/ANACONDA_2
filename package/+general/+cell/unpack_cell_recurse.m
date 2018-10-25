function [ C_unpacked ] = unpack_cell_recurse( C_packed )
% This function checks whether a cell is 'packed in' another cell, and
% checks it recursively.
% Inputs:
% C_packed The (possibly packed) input cell
% Outputs:
% C_unpacked The output cell, unpacked if possible

try % see if the cell is packed:
	iscell(C_packed{:});
	C_unpacked = general.cell.unpack_cell_recurse(C_packed{:});
catch % if not, just return the original cell:
	C_unpacked = C_packed;
end

